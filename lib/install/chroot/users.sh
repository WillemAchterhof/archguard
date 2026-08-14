#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — User Configuration
# ==============================================================================
#  lib/install/chroot/users.sh
# ==============================================================================

configure_users()
{
    msg "Creating user: $AG_P_USERNAME"

    run_chroot useradd \
        -m \
        -G wheel \
        "$AG_P_USERNAME"

    msg "Set password for user: $AG_P_USERNAME"
    run_chroot passwd "$AG_P_USERNAME"

    printf '%%wheel ALL=(ALL:ALL) ALL\n' \
        > /mnt/etc/sudoers.d/wheel

    chmod 440 /mnt/etc/sudoers.d/wheel

    printf 'Defaults use_pty\n' \
        > /mnt/etc/sudoers.d/hardening

    chmod 440 /mnt/etc/sudoers.d/hardening

    run_chroot passwd -l root

    msg "Root account locked."

    msg "User configuration completed."
}
