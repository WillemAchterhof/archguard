#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Pacman mirrors
# ==============================================================================
#  lib/install/system/mirrors.sh
#
#  Configures the pacman mirrorlist using Reflector.
#
#  Requires:
#    - run_chroot()
#    - AG_P_MIRROR_COUNTRIES
#
# ==============================================================================

chroot_pacman_mirrors()
{
    msg "Configuring pacman mirrors"

    run_chroot reflector \
        --country "$AG_P_MIRROR_COUNTRIES" \
        --protocol https \
        --latest 20 \
        --sort rate \
        --save /etc/pacman.d/mirrorlist
}