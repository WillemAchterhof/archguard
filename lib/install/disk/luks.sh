#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — LUKS Container
# ==============================================================================
#  lib/install/disk/luks.sh
#
#  Opens a LUKS2 container using the passphrase already resolved by
#  validate (see lib/validate/validate_luks.sh) — does NOT resolve it
#  again here. Re-resolving would generate a fresh passphrase (auto
#  mode) different from the one already shown to the user, silently
#  encrypting the disk with a value nobody ever saw.
#
#  Requires:
#    - AG_INSTALL_PART_ROOT (from partition.sh)
#    - AGS_LUKS_PASSPHRASE (already resolved by validate)
#
#  Populates:
#    - /dev/mapper/cryptroot (opened LUKS device)
# ==============================================================================

install_disk_luks()
{
    [[ -n "${AGS_LUKS_PASSPHRASE:-}" ]] \
        || fatal "LUKS passphrase not resolved — validate stage did not run."

    msg "Creating LUKS container on: $AG_INSTALL_PART_ROOT"
    printf '%s' "$AGS_LUKS_PASSPHRASE" | \
        cryptsetup luksFormat --type luks2 --batch-mode "$AG_INSTALL_PART_ROOT" -d -

    msg "Opening LUKS container"
    printf '%s' "$AGS_LUKS_PASSPHRASE" | \
        cryptsetup open "$AG_INSTALL_PART_ROOT" cryptroot -d -
}
