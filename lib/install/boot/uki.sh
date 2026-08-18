#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Unified Kernel Image
# ==============================================================================
#  lib/install/boot/uki.sh
#
#  Configures:
#    - UKI output directory
#    - mkinitcpio UKI preset
#    - pacman hook for automatic UKI signing
#
#  Requires:
#    - run_chroot()
#
#  Does NOT:
#    - Configure mkinitcpio
#    - Configure the kernel command line
#    - Build the UKI
#    - Create Secure Boot keys
#    - Sign the initial UKI
#    - Enroll Secure Boot keys
#    - Configure EFI boot entries
# ==============================================================================

configure_uki()
{
    msg "Configuring UKI"

    # --------------------------------------------------------------------------
    # UKI directory
    # --------------------------------------------------------------------------

    run_chroot mkdir -p /boot/EFI/Linux

    # --------------------------------------------------------------------------
    # mkinitcpio UKI preset
    # --------------------------------------------------------------------------

    run_chroot tee /etc/mkinitcpio.d/linux.preset >/dev/null <<'EOF'
PRESETS=('default')

ALL_kver="/boot/vmlinuz-linux"

default_uki="/boot/EFI/Linux/arch-linux.efi"
EOF

    # --------------------------------------------------------------------------
    # Automatic UKI signing
    # --------------------------------------------------------------------------

    msg "Configuring automatic UKI signing"

    run_chroot mkdir -p /etc/pacman.d/hooks

    run_chroot tee /etc/pacman.d/hooks/zz-sbctl-uki.hook >/dev/null <<'EOF'
[Trigger]
Type = Path
Operation = Install
Operation = Upgrade
Target = boot/EFI/Linux/*.efi

[Action]
Description = Signing UKIs with sbctl...
When = PostTransaction
Exec = /usr/bin/sbctl sign --path /boot/EFI/Linux
NeedsTargets
EOF

    msg "UKI configuration complete"
}