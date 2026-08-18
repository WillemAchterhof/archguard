#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Timezone configuration
# ==============================================================================
#  lib/install/system/timezone.sh
#
#  Requires:
#    - run_chroot()
#    - AG_P_TIMEZONE
# ==============================================================================

configure_timezone()
{
    msg "Configuring timezone: $AG_P_TIMEZONE"

    run_chroot ln -sf \
        "/usr/share/zoneinfo/$AG_P_TIMEZONE" \
        /etc/localtime

    run_chroot hwclock --systohc
}