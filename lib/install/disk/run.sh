#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Disk Preparation Entry Point
# ==============================================================================
#  lib/install/disk/run.sh
# ==============================================================================

run_install_disk()
{
    confirm_disk_destruction || { msg "Install cancelled."; return 1; }
    
    install_disk_partition
    install_disk_luks
    install_disk_lvm
    install_disk_format
    install_disk_mount

    msg "Disk preparation completed"
}