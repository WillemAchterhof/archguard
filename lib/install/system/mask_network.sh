#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Network Masking
# ==============================================================================
#  lib/install/system/mask_network.sh
# ==============================================================================

network_masking()
{
    run_chroot systemctl \
        mask systemd-networkd \
        mask wpa_supplicant

    msg "Masked Network"
}