#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Filesystem Formatting
# ==============================================================================
#  lib/install/disk/format.sh
#
#  Requires:
#    - AG_INSTALL_PART_EFI (from partition.sh)
#    - /dev/vgroot/root, /dev/vgroot/swap (from lvm.sh)
#    - AG_P_ROOT_FS, AG_BTRFS_SUBVOLUMES
# ==============================================================================

install_disk_format()
{
    msg "Formatting EFI partition"
    mkfs.fat -F32 "$AG_INSTALL_PART_EFI"

    msg "Formatting root ($AG_P_ROOT_FS)"

    case "$AG_P_ROOT_FS" in
        ext4)
            mkfs.ext4 -F /dev/vgroot/root
            ;;

        btrfs)
            mkfs.btrfs -f /dev/vgroot/root

            mkdir -p /mnt/btrfs-tmp
            mount /dev/vgroot/root /mnt/btrfs-tmp

            local subvol
            for subvol in "${AG_BTRFS_SUBVOLUMES[@]}"; do
                btrfs subvolume create "/mnt/btrfs-tmp/$subvol"
            done

            umount /mnt/btrfs-tmp
            rmdir /mnt/btrfs-tmp
            ;;

        *)
            fatal "Unknown root filesystem: $AG_P_ROOT_FS"
            ;;
    esac

    if [[ -n "$AG_P_SWAP_ENABLED" ]]; then
        msg "Formatting swap"
        mkswap /dev/vgroot/swap
    fi
}