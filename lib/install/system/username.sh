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

    if [[ -z "${AGS_USER_PASSWORD:-}" ]]; then
        set_user_password
    fi

    run_chroot useradd \
        -m \
        -G wheel \
        "$AG_P_USERNAME"

    printf '%s:%s\n' \
        "$AG_P_USERNAME" \
        "$AGS_USER_PASSWORD" |
        run_chroot chpasswd

    printf '%s\n' \
        '%wheel ALL=(ALL:ALL) ALL' \
        > "$AG_INSTALL_ROOT/etc/sudoers.d/wheel"

    chmod 440 \
        "$AG_INSTALL_ROOT/etc/sudoers.d/wheel"

    printf '%s\n' \
        'Defaults use_pty' \
        > "$AG_INSTALL_ROOT/etc/sudoers.d/hardening"

    chmod 440 \
        "$AG_INSTALL_ROOT/etc/sudoers.d/hardening"

    run_chroot passwd -l root

    unset AGS_USER_PASSWORD

    msg "Root account locked"
    msg "User $AG_P_USERNAME created"
}