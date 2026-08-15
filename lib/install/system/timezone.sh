#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Set Time Zone
# ==============================================================================
#  lib/install/system/timezone.sh
#
#  Sets the timezone for the system
#
#  Requires:
#    - /mnt mounted and containing a valid Arch installation
# ==============================================================================


configure_timezone() {
    log "[*] Setting timezone: $AG_P_TIMEZONE"
    arch-chroot "$MNT" ln -sf "/usr/share/zoneinfo/$AG_P_TIMEZONE" /etc/localtime
    arch-chroot "$MNT" hwclock --systohc
}