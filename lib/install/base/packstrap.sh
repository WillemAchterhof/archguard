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

detect_ucode()
{
    local vendor
    vendor=$(grep -m1 'vendor_id' /proc/cpuinfo | awk '{print $3}' | tr '[:upper:]' '[:lower:]')

    case "$vendor" in
        genuineintel) echo "intel-ucode" ;;
        authenticamd) echo "amd-ucode"   ;;
        *)
            log "[!] Unknown CPU vendor: $vendor — skipping microcode"
            echo ""
            ;;
    esac
}

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
        base base-devel linux linux-headers linux-firmware \
        ${ucode:+"$ucode"} \
        e2fsprogs dosfstools ${fs_pkg:+"$fs_pkg"} \
        cryptsetup lvm2 mkinitcpio sbctl sbsigntools efibootmgr tpm2-tools \
        apparmor nftables networkmanager iwd \
        sudo man-db git neovim \
        iproute2 iputils reflector libpwquality \
        polkit tar gzip unzip p7zip binutils \
        bluez bluez-utils \
        pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber \
        mesa vulkan-radeon libva-mesa-driver mesa-vdpau \
        plymouth \
          base base-devel linux linux-firmware \
        btrfs-progs cryptsetup \
        sbctl sbsigntools \
        tpm2-tss tpm2-tools \
        efibootmgr \
        amd-ucode \
        apparmor \
        lvm2 \
        bluez bluez-utils \
        networkmanager iwd \
        git neovim sudo man-db reflector openssh binutils inotify-tools \
        zsh zsh-completions zsh-autosuggestions kitty pacman nftables udisks2\
        pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber \
        mesa vulkan-radeon libva-mesa-driver mesa-vdpau \
        noto-fonts-cjk \

    msg "Base system installed."
}
