#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — System Settings
# ==============================================================================
#  lib/install/chroot/system_settings.sh
#
#  Configures the newly installed system's basic operating environment.
#
#  Requires:
#    - Base system installed in /mnt
#    - AG_P_TIMEZONE
#    - AG_P_HOSTNAME
#    - AG_P_LOCALE
#    - AG_P_KEYMAP
#
#  Does NOT:
#    - Create users
#    - Configure bootloader
#    - Configure mkinitcpio
# ==============================================================================

configure_system_settings()
{
    msg "Configuring pacman"

    sed -i \
        -e 's/^ParallelDownloads =.*/ParallelDownloads = 20/' \
        -e 's/^#Color/Color/' \
        -e '/^#\[multilib\]/,/^#Include = \/etc\/pacman.d\/mirrorlist/ s/^#//' \
        /mnt/etc/pacman.conf

    msg "Configuring timezone: $AG_P_TIMEZONE"

    run_chroot ln -sf \
        "/usr/share/zoneinfo/$AG_P_TIMEZONE" \
        /etc/localtime

    run_chroot hwclock --systohc

    msg "Configuring locale: $AG_P_LOCALE"

    sed -i \
        "s/^#${AG_P_LOCALE}/${AG_P_LOCALE}/" \
        /mnt/etc/locale.gen

    run_chroot locale-gen

    printf 'LANG=%s\n' "$AG_P_LOCALE" \
        > /mnt/etc/locale.conf

    printf 'KEYMAP=%s\n' "$AG_P_KEYMAP" \
        > /mnt/etc/vconsole.conf

    msg "Configuring hostname: $AG_P_HOSTNAME"

    printf '%s\n' "$AG_P_HOSTNAME" \
        > /mnt/etc/hostname

    cat > /mnt/etc/hosts <<EOF
127.0.0.1 localhost
::1       localhost
127.0.1.1 ${AG_P_HOSTNAME}.localdomain ${AG_P_HOSTNAME}
EOF

    msg "System settings configured."
}
