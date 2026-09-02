#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Plymouth Theme
# ==============================================================================
#  lib/install/boot/plymouth.sh
#
#  Selects the default Plymouth theme. Without this, Plymouth falls
#  back to its built-in "text" plugin — it still runs and still
#  handles the LUKS prompt correctly, it just never renders
#  graphically.
#
#  Deliberately does NOT pass -R (plymouth-set-default-theme's own
#  "regenerate the initramfs now" flag) — build_uki() already runs
#  mkinitcpio -P later in the boot chain, so this only needs to write
#  the theme selection before that happens.
#
#  Requires:
#    - run_chroot()
#    - configure_mkinitcpio must run first (mkinitcpio.conf HOOKS
#      must already list plymouth/sd-plymouth)
#
#  Does NOT:
#    - Configure mkinitcpio
#    - Build the UKI
#    - Install theme packages (bgrt ships with the plymouth package)
# ==============================================================================

configure_plymouth_theme()
{
    msg "Configuring Plymouth theme"

    run_chroot plymouth-set-default-theme bgrt

    msg "Plymouth theme configured"
}