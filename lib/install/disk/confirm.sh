#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Disk Destruction Confirmation
# ==============================================================================
#  lib/install/disk/confirm.sh
#
#  Last checkpoint before anything destructive happens. Shows the
#  resolved LUKS passphrase (generating/prompting if needed), then
#  requires the user to type the exact disk path and the word WIPE.
#
#  Requires:
#    - AG_P_DISK, AG_P_DISK_WIPE_MODE
#    - resolve_luks_passphrase (from lib/prepare/security/luks)
#
#  Returns:
#    - 0 if confirmed
#    - 1 if the user backed out at any point
# ==============================================================================

confirm_disk_destruction()
{
    if ! resolve_luks_passphrase; then
        printf " LUKS passphrase not set — cannot continue.\n"
        return 1
    fi

    clear
    printf "\
================================================
 ⚠  FINAL CONFIRMATION
================================================

Target disk : %s
Wipe mode   : %s

ALL DATA ON THIS DISK WILL BE PERMANENTLY LOST.

" "$AG_P_DISK" "$AG_P_DISK_WIPE_MODE"

    if [[ "$AG_P_LUKS" == "auto" ]]; then
        printf "LUKS passphrase (auto-generated) — write this down:\n\n"
        printf "   %s\n\n" "$AGS_LUKS_PASSPHRASE"
    else
        printf "LUKS passphrase: set manually — you entered this yourself.\n\n"
    fi

    printf "Type the disk path exactly to confirm: "
    local input
    read -r input
    if [[ "$input" != "$AG_P_DISK" ]]; then
        printf "\n Disk path mismatch — aborting.\n"
        sleep 1
        return 1
    fi

    printf "\nType WIPE to continue: "
    local confirm
    read -r confirm
    if [[ "$confirm" != "WIPE" ]]; then
        printf "\n Not confirmed — aborting.\n"
        sleep 1
        return 1
    fi

    return 0
}