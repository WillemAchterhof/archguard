#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — LVM Volumes
# ==============================================================================
#  lib/install/disk/lvm.sh
#
#  Requires:
#    - /dev/mapper/cryptroot (from luks.sh)
#    - AG_P_SWAP_ENABLED, AG_P_SWAP_SIZE
# ==============================================================================

install_disk_lvm()
{
    msg "Creating LVM volumes"

    pvcreate /dev/mapper/cryptroot
    vgcreate vgroot /dev/mapper/cryptroot

    if [[ -n "$AG_P_SWAP_ENABLED" ]]; then
        lvcreate -L "$AG_P_SWAP_SIZE" -n swap vgroot
    fi

    lvcreate -l 100%FREE -n root vgroot
}