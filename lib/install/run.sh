#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Install Entry Point
# ==============================================================================
#  lib/install/run.sh
# ==============================================================================

run_install()
{
    run_install_disk
    run_install_base

    msg "Install stage completed"
}
