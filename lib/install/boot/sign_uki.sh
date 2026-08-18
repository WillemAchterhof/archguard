#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — UKI Signing
# ==============================================================================
#  lib/install/boot/sign_uki.sh
#
#  Signs the initial Unified Kernel Image with the Secure Boot keys created
#  during the boot preparation stage.
#
#  Requires:
#    - run_chroot()
#    - AG_P_SBCert
#
#  Expected UKI:
#    - /boot/EFI/Linux/arch-linux.efi
#
#  Does NOT:
#    - Create Secure Boot keys
#    - Enroll Secure Boot keys
#    - Configure EFI boot entries
#    - Build the UKI
# ==============================================================================

sign_uki()
{
    local uki="/boot/EFI/Linux/arch-linux.efi"

    msg "Signing UKI"

    run_chroot test -f "$uki" ||
        fatal "UKI not found: $uki"

    case "$AG_P_SBCert" in
        Custom|Microsoft)
            ;;
        *)
            fatal "Unknown Secure Boot certificate mode: $AG_P_SBCert"
            ;;
    esac

    run_chroot sbctl sign \
        --save \
        "$uki"

    msg "UKI signed"
}