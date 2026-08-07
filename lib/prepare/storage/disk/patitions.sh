#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Partition Display
# ==============================================================================
#  lib/prepare/storage/disk/partitions.sh
#
#  Renders partitions for a given disk.
#
#  Does NOT:
#    - Discover disks
#    - Select disks or partitions
#    - Modify partitions
# ==============================================================================

display_partitions()
{
    local disk="$1"

    local partitions=()
    local name
    local size
    local type
    local label
    local part
    local total
    local count=0

    while read -r name size type; do

        [[ "$type" == "part" ]] || continue

        label=$(lsblk a-dn -o PARTLABEL "/dev/$name" 2>/dev/null || true)

        partitions+=("$name|$size|$label")

    done < <(
        lsblk -rno NAME,SIZE,TYPE "$disk"
    )

    total="${#partitions[@]}"

    if lsblk -rno MOUNTPOINT "$disk" | grep -q '[^[:space:]]'; then
        printf "       ⚠ Mounted partitions detected\n"
    fi

    for part in "${partitions[@]}"; do

        ((count+=1))

        IFS='|' read -r name size label <<< "$part"

        if (( count == total )); then
            printf "       └── %-15s %-8s %s\n" \
                "/dev/$name" \
                "$size" \
                "$label"
        else
            printf "       ├── %-15s %-8s %s\n" \
                "/dev/$name" \
                "$size" \
                "$label"
        fi

    done
}