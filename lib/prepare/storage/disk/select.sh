#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Disk Selection
# ==============================================================================
#  lib/prepare/storage/disk/select.sh
#
#  Validates and commits the chosen disk.
#
#  Requires:
#    - DISK_MAP (from map.sh)
#
#  Does NOT:
#    - Render menus
#    - Discover disks
# ==============================================================================

select_disk()
{
    local choice="$1"
    local selected

    if [[ ! -v "DISK_MAP[$choice]" ]]; then
        printf " Invalid selection.\n"
        # sleep 1
        return 1
    fi

    selected="${DISK_MAP[$choice]}"

    if [[ ! -b "$selected" ]]; then
        printf " Invalid block device.\n"
        # sleep 1
        return 1
    fi

    if [[ -n "${SA_HW_USB_DEVICE:-}" ]] &&
       [[ "$(readlink -f "$selected")" == "$(readlink -f "$SA_HW_USB_DEVICE")" ]]; then

        printf " ⚠ Cannot select installer USB: %s\n" "$selected"
        sleep 2
        return 1
    fi

    SA_P_DISK="$selected"

    msg "Selected disk: $SA_P_DISK"
    log_silent "SETTER: disk — SA_P_DISK=$SA_P_DISK"

    return 0
}