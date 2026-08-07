#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Disk Discovery
# ==============================================================================
#  lib/prepare/storage/disk/map.sh
#
#  Builds the map of selectable disks.
#
#  Populates:
#    - DISK_MAP (global associative array)
#
#  Does NOT:
#    - Select disks
#    - Render menus
# ==============================================================================

build_disk_map()
{
    declare -gA DISK_MAP
    DISK_MAP=()

    local letters=( {a..z} )
    local index=0
    local disk

    set +e
    while IFS= read -r disk; do

        if [[ -n "${AG_HW_USB_DEVICE:-}" ]] &&
           [[ "$disk" == "$AG_HW_USB_DEVICE" ]]; then
            continue
        fi

        DISK_MAP["${letters[$index]}"]="$disk"
        ((index+=1))

    done < <(
        lsblk -dn -o NAME,TYPE |
        awk '$2=="disk" {print "/dev/"$1}'
    )
    set -e
}