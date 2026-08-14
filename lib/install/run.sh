#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Install Entry Point
# ==============================================================================
#  lib/install/run.sh
# ==============================================================================

run_install()
{
    configure_disk
    install_base
    configure_system

    msg "Install stage completed"
}
