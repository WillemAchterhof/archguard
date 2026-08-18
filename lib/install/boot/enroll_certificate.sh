#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Secure Boot Enrollment
# ==============================================================================
#  lib/install/boot/enroll_certificate.sh
#
#  Enrolls the Secure Boot keys created by sbctl into UEFI firmware.
#
#  Certificate modes:
#
#    Custom
#        Enroll only the installer's custom Secure Boot keys.
#
#    Microsoft
#        Enroll the installer's custom keys and retain Microsoft's
#        Secure Boot certificates.
#
#  Requires:
#    - run_chroot()
#    - AG_P_SBCert
#
#  Does NOT:
#    - Create Secure Boot keys
#    - Sign UKIs
#    - Build the UKI
#    - Configure EFI boot entries
# ==============================================================================

enroll_secure_boot()
{
    msg "Checking Secure Boot status"

    run_chroot sbctl status

    msg "Enrolling Secure Boot keys"

    case "$AG_P_SBCert" in
        Custom)
            run_chroot sbctl enroll-keys \
            --yes-this-might-brick-my-machine
            ;;

        Microsoft)
            run_chroot sbctl enroll-keys --microsoft
            ;;

        *)
            fatal "Unknown Secure Boot certificate mode: $AG_P_SBCert"
            ;;
    esac

    msg "Secure Boot keys enrolled"

    msg "Verifying Secure Boot key enrollment"

    run_chroot sbctl list-enrolled-keys

    msg "Secure Boot enrollment complete"
}