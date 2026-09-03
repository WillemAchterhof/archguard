#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Reboot to UEFI
# ==============================================================================
#  lib/install/system/reboot_uefi.sh
# ==============================================================================

reboot_to_uefi()
{
    log_header "UEFI SECURE BOOT SETUP"

    msg "Installation completed successfully."
    msg ""
    msg "The system will now reboot into UEFI firmware setup."
    msg ""
    msg "IMPORTANT:"
    msg "Enable Secure Boot in the UEFI settings."
    msg "Also: Remove the USB-Installer"
    msg ""
    msg "Then save the changes and exit UEFI."
    msg ""
    msg "Rebooting to UEFI in 3 seconds..."

    sleep 3

    systemctl reboot --firmware-setup
}