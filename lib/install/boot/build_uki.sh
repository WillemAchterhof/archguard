#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — UKI Build
# ==============================================================================
#  lib/install/boot/build_uki.sh
#
#  Builds the Unified Kernel Image using the mkinitcpio preset configured by
#  uki.sh.
#
#  Requires:
#    - run_chroot()
#
#  Expected output:
#    - /boot/EFI/Linux/arch-linux.efi
#
#  Does NOT:
#    - Configure mkinitcpio
#    - Configure the kernel command line
#    - Create Secure Boot keys
#    - Sign the UKI
#    - Enroll Secure Boot keys
#    - Configure EFI boot entries
# ==============================================================================

build_uki()
{
    local uki="/boot/EFI/Linux/arch-linux.efi"

    msg "Installing UKI tooling"

    run_chroot pacman -S \
        --noconfirm \
        --needed \
        systemd-ukify

    msg "Building Unified Kernel Image"

    run_chroot mkinitcpio -P

    run_chroot test -f "$uki" ||
        fatal "UKI was not created: $uki"

    msg "UKI created: $uki"
}