#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Mounting
# ==============================================================================
#  lib/install/disk/mount.sh
#
#  Requires:
#    - AG_INSTALL_PART_EFI, /dev/vgroot/root, /dev/vgroot/swap
#    - AG_P_ROOT_FS, AG_BTRFS_SUBVOLUMES, AG_BTRFS_COMPRESSION, AG_BTRFS_COW
#
#  Fixed subvolume -> mountpoint convention. Any subvolume name not
#  listed here has no known mountpoint and is skipped with a warning.
# ==============================================================================

disk_mount()
{
    msg "Mounting filesystems"

    case "$AG_P_ROOT_FS" in
        ext4)
            mount -o noatime /dev/vgroot/root /mnt
            ;;

        btrfs)
            local opts="noatime,compress=${AG_BTRFS_COMPRESSION}"
            [[ "$AG_BTRFS_COW" == "Disabled" ]] && opts="$opts,nodatacow"

            mount -o "subvol=@,$opts" /dev/vgroot/root /mnt

            local subvol
            local target
            for subvol in "${AG_BTRFS_SUBVOLUMES[@]}"; do
                [[ "$subvol" == "@" ]] && continue

                case "$subvol" in
                    "@home")      target="/home" ;;
                    "@log")       target="/var/log" ;;
                    "@pkg")       target="/var/cache/pacman/pkg" ;;
                    "@snapshots") target="/.snapshots" ;;
                    *)
                        printf " ⚠ No known mountpoint for subvolume: %s (skipped)\n" "$subvol"
                        continue
                        ;;
                esac

                mkdir -p "/mnt${target}"
                mount -o "subvol=${subvol},$opts" /dev/vgroot/root "/mnt${target}"
            done
            ;;
    esac

    mkdir -p /mnt/boot
    mount "$AG_INSTALL_PART_EFI" /mnt/boot

    if [[ -n "$AG_P_SWAP_ENABLED" ]]; then
        swapon /dev/vgroot/swap
    fi
}
