#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Install Entry Point
# ==============================================================================
#  lib/install/boot/run.sh
# ==============================================================================

create_boot_chain()
{
    create_sb_certificates
    configure_mkinitcpio
    configure_kernel_cmdline
    configure_uki
    build_uki
    sign_uki
    verify_uki
    configure_efi_boot
    enroll_secure_boot


    msg "Boot stage completed"
}
