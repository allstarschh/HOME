#!/usr/bin/env bash
#
# Generate a FIDO/U2F-backed SSH key using a YubiKey (or other security key).
# The type ed25519-sk keeps the secret on the hardware; the file written by
# ssh-keygen is only a handle, and using the key requires a physical touch.
#
# Usage: ./gen_ssh_key.sh <key-name>
#   <key-name> is the -f output path, e.g. "id_yubikey" or "~/.ssh/id_yubikey".
#   Both <key-name> (private handle) and <key-name>.pub (public key) are created.

set -euo pipefail

if [[ $# -ne 1 || -z "${1:-}" ]]; then
	echo "Usage: $0 <key-name>" >&2
	echo "  Generates an ed25519-sk SSH key at <key-name>." >&2
	echo "  Insert your YubiKey; you will be asked to touch it to confirm." >&2
	exit 1
fi

KEY="$1"

if [[ -e "${KEY}" || -e "${KEY}.pub" ]]; then
	echo "Error: '${KEY}' or '${KEY}.pub' already exists; refusing to overwrite." >&2
	exit 1
fi

echo "Insert your YubiKey. You will be asked to touch it to confirm."
ssh-keygen -t ed25519-sk -f "${KEY}"

echo
echo "Created:"
echo "  ${KEY}      (private key handle)"
echo "  ${KEY}.pub  (public key)"
