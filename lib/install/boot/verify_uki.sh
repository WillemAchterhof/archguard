#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — UKI Verification
# ==============================================================================
#  lib/install/boot/verify_uki.sh
#
#  Verifies that the generated UKI exists and has a valid Secure Boot
#  signature recognized by sbctl.
#
#  Requires:
#    - run_chroot()
#
#  Expected UKI:
#    - /boot/EFI/Linux/arch-linux.efi
#
#  Does NOT:
#    - Build the UKI
#    - Sign the UKI
#    - Create Secure Boot keys
#    - Enroll Secure Boot keys
#    - Configure EFI boot entries
# ==============================================================================

verify_uki()
{
    local uki="/boot/EFI/Linux/arch-linux.efi"

    msg "Verifying Unified Kernel Image"

    run_chroot test -f "$uki" ||
        fatal "UKI not found: $uki"

    msg "Verifying Secure Boot signature"

    run_chroot sbctl verify "$uki" ||
        fatal "UKI signature verification failed: $uki"

    msg "Verifying TPM2 PCR signature"

    run_chroot ukify inspect "$uki" | grep -q '\.pcrsig' ||
        fatal "UKI missing .pcrsig section: $uki"

    msg "UKI verification successful"
}