#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Base System Install
# ==============================================================================
#  lib/install/base/packstrap.sh
#
#  Requires:
#    - /mnt already mounted (see lib/install/disk/mount.sh)
#
#  Does NOT:
#    - Configure anything inside the new root (see chroot stage, later)
#    - Generate fstab (see fstab.sh)
# ==============================================================================

run_packstrap()
{
    local ucode
    local fs_pkg=""

    ucode="$(detect_ucode)"
    msg "CPU microcode: ${ucode:-none}"

    case "$AG_P_ROOT_FS" in
        btrfs) fs_pkg="btrfs-progs" ;;
        ext4)  ;;
        *)     fatal "Unknown root filesystem: $AG_P_ROOT_FS" ;;
    esac
    msg "Filesystem tools: e2fsprogs${fs_pkg:+, $fs_pkg}"

    msg "Installing base system via pacstrap..."

    pacstrap -K /mnt \
        base base-devel \
        linux linux-headers linux-firmware \
        ${ucode:+"$ucode"} \
        e2fsprogs dosfstools ${fs_pkg:+"$fs_pkg"} \
        cryptsetup lvm2 \
        mkinitcpio \
        sbctl sbsigntools efibootmgr \
        tpm2-tss tpm2-tools \
        apparmor nftables \
        networkmanager iwd \
        bluez bluez-utils \
        pipewire pipewire-audio pipewire-alsa pipewire-pulse wireplumber \
        udisks2 polkit \
        sudo \
        man-db \
        git neovim \
        iproute2 iputils \
        reflector \
        libpwquality \
        inotify-tools \
        tar gzip unzip 7zip binutils \
        plymouth

    msg "Base system installed."
}
