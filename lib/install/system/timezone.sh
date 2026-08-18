#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Timezone configuration
# ==============================================================================
#  lib/install/system/timezone.sh
#
#  Requires:
#    - AG_INSTALL_ROOT
#    - AG_P_TIMEZONE
# ==============================================================================

configure_timezone()
{
    msg "Configuring timezone: $AG_P_TIMEZONE"

    ln -sf \
        "/usr/share/zoneinfo/$AG_P_TIMEZONE" \
        "$AG_INSTALL_ROOT/etc/localtime"

    run_chroot hwclock --systohc

    msg "Timezone configured"
}