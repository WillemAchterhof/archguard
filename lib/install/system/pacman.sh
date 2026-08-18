#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Pacman configuration
# ==============================================================================
#  lib/install/system/pacman.sh
#
#  Configures pacman inside the target system.
#
#  Requires:
#    - run_chroot()
#    - AG_P_PACMAN_PARALLEL
#
# ==============================================================================

configure_pacman()
{
    msg "Configuring pacman"

    run_chroot sed -i \
        -e "s/^#\?ParallelDownloads.*/ParallelDownloads = ${AG_P_PACMAN_PARALLEL}/" \
        -e 's/^#Color/Color/' \
        -e '/^#\[multilib\]/,/^#Include = \/etc\/pacman.d\/mirrorlist/ s/^#//' \
        /etc/pacman.conf
}

update_system()
{
    msg "Updating system"

    run_chroot pacman -Syu --noconfirm
}