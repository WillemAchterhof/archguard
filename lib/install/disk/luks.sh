#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — LUKS Container
# ==============================================================================
#  lib/install/disk/luks.sh
#
#  Requires:
#    - AG_INSTALL_PART_ROOT (from partition.sh)
#    - resolve_luks_passphrase (from lib/prepare/security/luks)
#
#  Populates:
#    - /dev/mapper/cryptroot (opened LUKS device)
# ==============================================================================

install_disk_luks()
{
    resolve_luks_passphrase || fatal "LUKS passphrase not set."

    msg "Creating LUKS container on: $AG_INSTALL_PART_ROOT"

    printf '%s' "$AGS_LUKS_PASSPHRASE" | \
        cryptsetup luksFormat --type luks2 "$AG_INSTALL_PART_ROOT" -d -

    printf '%s' "$AGS_LUKS_PASSPHRASE" | \
        cryptsetup open "$AG_INSTALL_PART_ROOT" cryptroot -d -
}