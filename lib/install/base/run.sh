#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Disk Preparation Entry Point
# ==============================================================================
#  lib/install/base/run.sh
# ==============================================================================

install_base()
{
    configure_pacman_mirrors
    install_base_packstrap
    install_fstab

    msg "Base Install completed"
}
