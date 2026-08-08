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

    printf "\n"
    printf "================================================\n"
    printf " Target Disk Selection\n"
    printf "================================================\n\n"
    printf " Choose the disk to install to. This disk will be\n"
    printf " wiped and partitioned according to your other\n"
    printf " settings (filesystem, LVM, wipe mode) once install\n"
    printf " begins. Nothing is modified until then.\n\n"


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