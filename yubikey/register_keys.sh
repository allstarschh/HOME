#!/usr/bin/env bash
#
# Register YubiKeys for login (pam_u2f) on this machine.
#
# Writes ~/.config/Yubico/u2f_keys in the single-line format pam_u2f expects:
#     <user>:<key 1>:<key 2>:...
# then optionally runs ./install.sh to copy it to /etc/Yubico/u2f_keys, which
# is the file PAM actually reads (see yubikey-u2f and install.sh).
#
# Registrations are bound to this machine's hostname (origin pam://<hostname>),
# so run this again on every machine instead of copying the file around.
#
# Usage: ./register_keys.sh          register all keys from scratch
#                                    (the existing file is backed up first)
#        ./register_keys.sh --add    add more keys to the existing file

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KEYS_DIR="${HOME}/.config/Yubico"
KEYS_FILE="${KEYS_DIR}/u2f_keys"

usage() {
	echo "Usage: $0 [--add]" >&2
	echo "  (no option)  register all your keys, replacing ${KEYS_FILE}" >&2
	echo "  --add        add more keys to the existing ${KEYS_FILE}" >&2
	exit 1
}

MODE=replace
case "${1:-}" in
	"") ;;
	--add) MODE=add ;;
	*) usage ;;
esac
[[ $# -le 1 ]] || usage

if [[ ${EUID} -eq 0 ]]; then
	echo "Error: run this as your normal user, not root; the keys belong to" >&2
	echo "  that user. install.sh will ask for sudo when it needs it." >&2
	exit 1
fi

if ! command -v pamu2fcfg >/dev/null; then
	echo "Error: pamu2fcfg not found. Install it with: sudo apt install pamu2fcfg" >&2
	exit 1
fi

# Current registrations, as ":<key>:<key>..." with the "<user>" prefix removed.
line=""
if [[ ${MODE} == add ]]; then
	if [[ ! -s "${KEYS_FILE}" ]]; then
		echo "Error: ${KEYS_FILE} doesn't exist yet; run without --add first." >&2
		exit 1
	fi
	existing="$(grep "^${USER}:" "${KEYS_FILE}" || true)"
	if [[ -z "${existing}" ]]; then
		echo "Error: no line for user '${USER}' in ${KEYS_FILE}." >&2
		exit 1
	fi
	line="${existing#"${USER}"}"
	echo "${KEYS_FILE} has $(tr -cd ':' <<<"${line}" | wc -c) key(s) registered."
fi

echo "Register one key at a time: plug in ONLY the key being registered,"
echo "and touch it when it blinks."
echo

count=0
while true; do
	read -r -p "Plug in a YubiKey and press Enter (or type 'q' and Enter to finish): " answer
	[[ ${answer} == q ]] && break
	# -n: print only ":<key>", without the "<user>" prefix.
	if key="$(pamu2fcfg -n)" && [[ ${key} == :* ]]; then
		line+="${key}"
		count=$((count + 1))
		echo "  Key registered. Unplug it before plugging in the next one."
	else
		echo "  Registration failed (no key found, or not touched in time). Try again." >&2
	fi
done

if [[ ${count} -eq 0 ]]; then
	echo "No keys registered; ${KEYS_FILE} left unchanged."
	exit 0
fi

mkdir -p "${KEYS_DIR}"
if [[ -e "${KEYS_FILE}" ]]; then
	backup="${KEYS_FILE}.bak.$(date +%Y%m%d%H%M%S)"
	cp -a "${KEYS_FILE}" "${backup}"
	echo "Backed up the old file -> ${backup}"
fi
# Write to a temp file and rename it into place, so an interruption can't
# leave a half-written file.
tmp="$(mktemp "${KEYS_DIR}/u2f_keys.XXXXXX")"
printf '%s%s\n' "${USER}" "${line}" >"${tmp}"
chmod 0644 "${tmp}"
mv "${tmp}" "${KEYS_FILE}"

total="$(tr -cd ':' <<<"${line}" | wc -c)"
echo
echo "Registered ${count} new key(s); ${KEYS_FILE} now has ${total} key(s)."
echo "If you registered the same YubiKey twice, that's harmless: both entries work."
echo

read -r -p "Run install.sh now to copy it to /etc/Yubico/u2f_keys (needs sudo)? [y/N] " answer
if [[ ${answer} == [yY]* ]]; then
	"${SCRIPT_DIR}/install.sh"
else
	echo "Remember: PAM reads /etc/Yubico/u2f_keys. Run ${SCRIPT_DIR}/install.sh to update it."
fi
