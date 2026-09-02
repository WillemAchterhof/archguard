#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — mkinitcpio Configuration
# ==============================================================================
#  lib/install/boot/mkinitcpio.sh
#
#  Configures mkinitcpio for the installed system.
#
#  Requires:
#    - run_chroot()
#    - AG_HW_GPU_VENDOR
#
#  Does NOT:
#    - Write the kernel command line
#    - Build the UKI
#    - Sign the UKI
#    - Configure EFI boot entries
#    - Enroll Secure Boot keys
# ==============================================================================

configure_mkinitcpio()
{
    local modules

    case "${AG_HW_GPU_VENDOR:-unknown}" in
        amd)
            modules="amdgpu"
            ;;

        intel)
            modules="i915"
            ;;

        nvidia)
            modules="nvidia"
            ;;

        qxl)
            modules="qxl"
            ;;

        virtio)
            modules="virtio_gpu"
            ;;

        vmware)
            modules="vmwgfx"
            ;;

        vbox)
            modules="vboxvideo"
            ;;

        hyperv)
            modules="hyperv_drm"
            ;;

        bochs)
            modules="bochs"
            ;;

        *)
            modules=""
            ;;
    esac

    msg "Configuring mkinitcpio"

    run_chroot sed -i \
        "s|^MODULES=.*|MODULES=($modules)|" \
        /etc/mkinitcpio.conf

    run_chroot sed -i \
        's|^BINARIES=.*|BINARIES=()|' \
        /etc/mkinitcpio.conf

    run_chroot sed -i \
        's|^HOOKS=.*|HOOKS=(base systemd keyboard autodetect modconf kms microcode plymouth block sd-encrypt lvm2 filesystems fsck)|' \
        /etc/mkinitcpio.conf

    run_chroot sed -i \
        's|^#*COMPRESSION=.*|COMPRESSION="zstd"|' \
        /etc/mkinitcpio.conf

    run_chroot sed -i \
        's|^#*COMPRESSION_OPTIONS=.*|COMPRESSION_OPTIONS="-3"|' \
        /etc/mkinitcpio.conf

    msg "mkinitcpio configured"
}