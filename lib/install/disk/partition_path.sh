#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Partition Path Helper
# ==============================================================================
#  lib/install/disk/partition_path.sh
#
#  Builds a partition device path for a given disk and partition
#  number, accounting for nvme/mmcblk devices needing a "p" separator
#  (/dev/nvme0n1p1) vs plain sd-style devices (/dev/sda1).
# ==============================================================================

disk_partition_path()
{
    local disk="$1"
    local num="$2"

    case "$disk" in
        *nvme*|*mmcblk*)
            printf "%sp%s" "$disk" "$num"
            ;;
        *)
            printf "%s%s" "$disk" "$num"
            ;;
    esac
}