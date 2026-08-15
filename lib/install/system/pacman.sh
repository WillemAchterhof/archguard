#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Pacman & Mirror Configuration
# ==============================================================================
#  lib/install/base/pacman_config.sh
#
#  Runs on the LIVE ISO, before pacstrap — tunes the live environment's
#  own /etc/pacman.conf and mirrorlist so the actual install downloads
#  faster and multilib (lib32-*) packages can resolve at all. None of
#  this persists to the installed system; pacstrap writes a fresh
#  /mnt/etc/pacman.conf from the pacman package regardless. If any of
#  this should also apply to the finished system, it needs its own
#  step later, in the chroot stage.
#
#  Requires:
#    - /etc/pacman.conf, /etc/pacman.d/mirrorlist (live ISO)
#    - reflector (present on the live ISO)
#    - AG_P_MIRROR_COUNTRY (optional — from the system-settings stage,
#      not yet built. Falls back to reflector's own worldwide/rate
#      sort if unset, rather than forcing a hardcoded region.)
#
#  Does NOT:
#    - Touch /mnt or anything inside the target system
# ==============================================================================


configure_pacman() {
    log "[*] Configuring pacman in chroot..."

    arch-chroot "$MNT" sed -i \
        -e "s/^#\?ParallelDownloads.*/ParallelDownloads = 10/" \
        -e 's/^#Color/Color/' \
        -e '/^#\[multilib\]/,/^#Include = \/etc\/pacman.d\/mirrorlist/ s/^#//' \
        /etc/pacman.conf

    log "[*] Updating system in chroot..."
    arch-chroot "$MNT" pacman -Syu --noconfirm
}