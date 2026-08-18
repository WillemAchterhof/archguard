#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — User configuration
# ==============================================================================
#  lib/install/system/user.sh
#
#  Requires:
#    - run_chroot()
#    - AG_P_USERNAME
# ==============================================================================

configure_user()
{
    msg "Creating user: $AG_P_USERNAME"

    run_chroot useradd \
        -m \
        -G wheel \
        "$AG_P_USERNAME"

    echo
    echo "  Set password for user: $AG_P_USERNAME"

    run_chroot passwd "$AG_P_USERNAME"

    printf '%%wheel ALL=(ALL:ALL) ALL\n' \
        > "$AG_INSTALL_ROOT/etc/sudoers.d/wheel"

    chmod 440 \
        "$AG_INSTALL_ROOT/etc/sudoers.d/wheel"

    printf 'Defaults use_pty\n' \
        > "$AG_INSTALL_ROOT/etc/sudoers.d/hardening"

    chmod 440 \
        "$AG_INSTALL_ROOT/etc/sudoers.d/hardening"

    run_chroot passwd -l root

    msg "Root account locked"
    msg "User $AG_P_USERNAME created"
}