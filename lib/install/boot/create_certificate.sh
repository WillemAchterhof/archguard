#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Secure Boot Keys
# ==============================================================================
#  lib/install/boot/create_certificate.sh
#
#  Creates the Secure Boot signing keys when custom certificates are selected.
#
#  Requires:
#    - run_chroot()
#    - AG_P_SBCert
#
#  Does NOT:
#    - Enroll keys into firmware
#    - Enable Secure Boot
#    - Sign UKIs
#    - Modify EFI boot entries
#
#  Certificate modes:
#    - Custom
#        Create custom Secure Boot keys.
#
#    - Microsoft
#        Do not create custom keys. Microsoft certificates are used.
#
#    - Custom with Microsoft available
#        Create custom Secure Boot keys. Microsoft certificates are
#        enrolled later alongside the custom keys.
# ==============================================================================

create_sb_certificates()
{
    msg "Checking Secure Boot status"

    run_chroot sbctl status

    msg "Creating Secure Boot keys"

    run_chroot sbctl create-keys

    msg "Secure Boot keys created"
}