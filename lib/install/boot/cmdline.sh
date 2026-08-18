#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Kernel Command Line
# ==============================================================================
#  lib/install/boot/cmdline.sh
#
#  Configures the kernel command line used by the UKI.
#
#  Requires:
#    - run_chroot()
#    - AG_INSTALL_PART_ROOT
#    - AG_P_ROOT_FS
#
#  Does NOT:
#    - Build the UKI
#    - Sign the UKI
#    - Configure EFI boot entries
#    - Enroll Secure Boot keys
#    - Enroll the LUKS TPM key
#
#  Storage layout:
#    EFI
#      └── /boot
#
#    LUKS2
#      └── cryptroot
#          └── LVM
#              └── vgroot/root
# ==============================================================================

configure_kernel_cmdline()
{
    local luks_uuid
    local cmdline

    msg "Configuring kernel command line"

    luks_uuid=$(run_chroot blkid -s UUID -o value "$AG_INSTALL_PART_ROOT")

    [[ -n "$luks_uuid" ]] ||
        fatal "Unable to determine LUKS UUID: $AG_INSTALL_PART_ROOT"

    cmdline="rd.luks.name=${luks_uuid}=cryptroot"
    cmdline+=" rd.luks.options=${luks_uuid}=tpm2-device=auto"
    cmdline+=" root=/dev/vgroot/root"
    cmdline+=" rootfstype=${AG_P_ROOT_FS}"
    cmdline+=" rw"

    case "$AG_P_ROOT_FS" in
        btrfs)
            cmdline+=" rootflags=subvol=@"
            ;;
        ext4)
            ;;
        *)
            fatal "Unknown root filesystem: $AG_P_ROOT_FS"
            ;;
    esac

    cmdline+=" lsm=landlock,lockdown,yama,integrity,apparmor,bpf"
    cmdline+=" apparmor=1"
    cmdline+=" lockdown=confidentiality"
    cmdline+=" quiet splash"

    printf '%s\n' "$cmdline" |
        run_chroot tee /etc/kernel/cmdline >/dev/null

    msg "Kernel command line configured"
}