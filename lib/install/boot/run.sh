#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Install Entry Point
# ==============================================================================
#  lib/install/boot/run.sh
# ==============================================================================

create_boot_chain()
{
    create_sb_certificates

    msg "Boot stage completed"
}
