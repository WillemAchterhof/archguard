#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Services
# ==============================================================================
#  lib/install/system/services.sh
#
#  Enables target-system services and points resolv.conf at the
#  systemd-resolved stub.
#
#  Note: service masking/disabling is handled later, once all
#  packages are installed — see the desktop stage.
#
#  Requires:
#    - run_chroot()
#    - AG_INSTALL_ROOT
# ==============================================================================

configure_services()
{
    msg "Enabling services"

    run_chroot systemctl enable \
        apparmor \
        NetworkManager \
        nftables \
        fstrim.timer \
        reflector.timer \
        systemd-resolved \
        systemd-timesyncd \
        mask systemd-networkd \
        mask wpa_supplicant \

    ln -sf /run/systemd/resolve/stub-resolv.conf \
        "$AG_INSTALL_ROOT/etc/resolv.conf"

    msg "Services enabled"
}