#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Disk Preparation Entry Point
# ==============================================================================
#  lib/install/disk/run.sh
# ==============================================================================

configure_disk()
{
    disk_wipe    
    disk_partition
    disk_luks
    disk_lvm
    disk_format
    disk_mount

    msg "Disk preparation completed"
}
