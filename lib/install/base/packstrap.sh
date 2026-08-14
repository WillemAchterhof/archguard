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

run_pacstrap()
{
    local cpu_pkg
    local gpu_pkg
    local fs_pkg=""

    cpu_pkg="$(set_cpu_pkg)"
    gpu_pkg="$(set_gpu_pkg)"

    msg "CPU package(s): ${cpu_pkg:-none}"
    msg "GPU package(s): ${gpu_pkg:-none}"

    case "$AG_P_ROOT_FS" in
        btrfs) fs_pkg="btrfs-progs" ;;
        ext4)  ;;
        *) fatal "Unknown root filesystem: $AG_P_ROOT_FS" ;;
    esac

    msg "Filesystem tools: e2fsprogs${fs_pkg:+, $fs_pkg}"

    pacstrap -K /mnt \
        base base-devel \
        linux linux-headers linux-firmware \
        $cpu_pkg $gpu_pkg \
        e2fsprogs dosfstools ${fs_pkg:+$fs_pkg} \
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
