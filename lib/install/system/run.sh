#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — System configuration
# ==============================================================================
#  lib/install/system/run.sh
# ==============================================================================

configure_system()
{
    run_chroot
    configure_pacman_mirrors
    configure_timezone

    msg "System Configured"
}
