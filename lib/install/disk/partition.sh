#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Disk Partitioning
# ==============================================================================
#  lib/install/disk/partition.sh
#
#  Requires:
#    - AG_P_DISK, AG_P_EFI_SIZE
#    - disk_partition_path (from partition_path.sh)
#
#  Populates:
#    - AG_INSTALL_PART_EFI, AG_INSTALL_PART_ROOT (partition device paths)
# ==============================================================================

disk_partition()
{
    msg "Partitioning disk: $AG_P_DISK"

    parted -s "$AG_P_DISK" mklabel gpt
    parted -s "$AG_P_DISK" mkpart ESP fat32 1MiB "$AG_P_EFI_SIZE"
    parted -s "$AG_P_DISK" set 1 esp on
    parted -s "$AG_P_DISK" mkpart primary "$AG_P_EFI_SIZE" 100%

    partprobe "$AG_P_DISK"
    sleep 2

    AG_INSTALL_PART_EFI="$(disk_partition_path "$AG_P_DISK" 1)"
    AG_INSTALL_PART_ROOT="$(disk_partition_path "$AG_P_DISK" 2)"

    [[ -b "$AG_INSTALL_PART_EFI" ]] || fatal "EFI partition not found: $AG_INSTALL_PART_EFI"
    [[ -b "$AG_INSTALL_PART_ROOT" ]] || fatal "Root partition not found: $AG_INSTALL_PART_ROOT"
}
