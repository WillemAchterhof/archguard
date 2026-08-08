#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Disk List Display
# ==============================================================================
#  lib/prepare/storage/disk/display.sh
#
#  Renders the list of selectable disks.
#
#  Requires:
#    - DISK_MAP (from map.sh)
#    - display_partitions() (from partitions.sh)
#
#  Does NOT:
#    - Discover disks
#    - Select disks
# ==============================================================================

display_disks()
{
    local index
    local disk
    local size
    local model

    for key in $(printf "%s\n" "${!DISK_MAP[@]}" | sort); do

        disk="${DISK_MAP[$key]}"
        size=$(lsblk -dn -o SIZE "$disk" 2>/dev/null)
        model=$(lsblk -dn -o MODEL "$disk" 2>/dev/null | xargs)

        printf " [%s] %-15s %-10s %s\n" \
            "$key" \
            "$disk" \
            "$size" \
            "${model:--}"

        display_partitions "$disk"

        printf "\n"
    done
}