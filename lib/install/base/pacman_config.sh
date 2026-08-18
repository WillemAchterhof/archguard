#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Pacman & Mirror Configuration
# ==============================================================================
#  lib/install/base/pacman_config.sh
#
#  Runs on the LIVE ISO, before pacstrap — tunes the live environment's
#  own /etc/pacman.conf and mirrorlist so the actual install downloads
#  faster and multilib (lib32-*) packages can resolve at all.
#
#  Requires:
#    - /etc/pacman.conf
#    - /etc/pacman.d/mirrorlist
#    - reflector
#    - AG_P_MIRROR_COUNTRIES (optional)
#
#  Does NOT:
#    - Touch /mnt or anything inside the target system
# ==============================================================================

configure_pacman_mirrors()
{
    msg "Tuning live pacman.conf (parallel downloads, color, multilib)"

    sed -i \
        -e "s/^#\?ParallelDownloads.*/ParallelDownloads = ${AG_P_PACMAN_PARALLEL}/" \
        -e 's/^#Color/Color/' \
        -e '/^#\[multilib\]/,/^#Include = \/etc\/pacman.d\/mirrorlist/ s/^#//' \
        /etc/pacman.conf

    msg "Refreshing mirrorlist${AG_P_MIRROR_COUNTRIES:+ ($AG_P_MIRROR_COUNTRIES)}..."

   reflector \
        --country "$AG_P_MIRROR_COUNTRIES" \
        --protocol https \
        --latest 20 \
        --sort rate \
        --save /etc/pacman.d/mirrorlisttest

    msg "Mirrorlist refreshed."

    msg "Synchronizing package databases (including newly enabled multilib)"
    pacman -Syy
}