#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Disk Destruction Confirmation
# ==============================================================================
#  lib/validate/confirm.sh
#
#  Requires the exact target disk path to be typed back, on the same
#  screen as the LUKS passphrase (see validate_luks.sh) — a mistyped
#  "yes" or "WIPE" is not enough to wipe the wrong disk.
#
#  Requires:
#    - AG_P_DISK, AG_P_DISK_WIPE_MODE
#
#  Does NOT:
#    - Clear the screen (caller controls that — see run_validation)
#    - Wipe or touch the disk itself
#
#  Returns:
#    - 0 if confirmed
#    - 1 if the user backed out or mistyped the path
# ==============================================================================

confirm_disk_destruction()
{
    printf "================================================\n"
    printf " ⚠  CONFIRM TARGET DISK\n"
    printf "================================================\n\n"
    printf "  Selected disk : %s\n" "$AG_P_DISK"
    printf "  Wipe mode     : %s\n\n" "${AG_P_DISK_WIPE_MODE:-Not set}"
    printf "  ALL DATA ON %s WILL BE PERMANENTLY LOST.\n\n" "$AG_P_DISK"
    printf "  Type the disk path exactly to confirm, or leave\n"
    printf "  blank to cancel:\n\n"

    local input
    read -rp "  > " input
    printf "\n"

    if [[ -z "$input" ]]; then
        msg "Disk confirmation cancelled."
        return 1
    fi

    if [[ "$input" != "$AG_P_DISK" ]]; then
        printf "  Disk path did not match — aborting.\n\n"
        printf "  A typo here is the last thing standing between you and\n"
        printf "  wiping the wrong disk, so this sends you all the way\n"
        printf "  back to the menu rather than letting you retype it.\n\n"
        sleep 3
        return 1
    fi


    log_silent "VALIDATE: disk destruction confirmed for AG_P_DISK=$AG_P_DISK"
    return 0
}
