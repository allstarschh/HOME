#!/usr/bin/env bash
#
# Deploy the PAM files kept in this directory to their system locations
# and regenerate the PAM stack. This replaces the per-file "put this in ..."
# notes that used to live inside the config files themselves.
#
#   yubikey-u2f -> /usr/share/pam-configs/   then run: pam-auth-update
#   kde         -> /etc/pam.d/kde            (KDE KScreenLocker)
#   polkit-1    -> /etc/pam.d/polkit-1       (KDE Discover and other PolicyKit services)
#
# WARNING: a broken PAM config can lock you out of sudo and login. Before
# running this, open a SEPARATE root shell and keep it open until you have
# verified auth still works, e.g. with your YubiKey plugged in:
#
#     sudo -s
#
# Existing destination files are backed up (<file>.bak.<timestamp>) so you
# can restore them from that spare root shell if anything breaks.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ ${EUID} -ne 0 ]]; then
	echo "This script needs root; re-running under sudo..." >&2
	exec sudo "$0" "$@"
fi

# Back up OUTSIDE any scanned directory. A backup left in /usr/share/pam-configs/
# would itself be parsed by pam-auth-update as a duplicate profile.
BACKUP_DIR="/var/backups/pam-install-$(date +%Y%m%d%H%M%S)"

install_file() {
	local src="$1" dest="$2"
	echo "Installing ${src} -> ${dest}"
	if [[ -e "${dest}" ]]; then
		mkdir -p "${BACKUP_DIR}"
		# Flatten the path (/ -> _) so backups never collide.
		local bak="${BACKUP_DIR}/${dest//\//_}"
		cp -a "${dest}" "${bak}"
		echo "  backed up existing file -> ${bak}"
	fi
	install -o root -g root -m 0644 "${SCRIPT_DIR}/${src}" "${dest}"
}

install_file yubikey-u2f /usr/share/pam-configs/yubikey-u2f
install_file kde         /etc/pam.d/kde
install_file polkit-1    /etc/pam.d/polkit-1

echo
echo "Regenerating /etc/pam.d/common-* with pam-auth-update..."
echo "Keep 'YubiKey U2F passwordless auth' enabled in the menu, then confirm."
pam-auth-update

echo
echo "Done. Now TEST in a separate terminal, leaving your root shell open:"
echo "  sudo -k; sudo ls   # YubiKey unplugged -> should prompt for password"
echo "  sudo -k; sudo ls   # YubiKey plugged in -> should authenticate on touch"
