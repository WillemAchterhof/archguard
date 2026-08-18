#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Locale configuration
# ==============================================================================
#  lib/install/system/locale.sh
#
#  Requires:
#    - run_chroot()
#    - AG_P_LOCALE
# ==============================================================================

configure_locale()
{
    msg "Configuring locale: $AG_P_LOCALE"

    run_chroot sed -i \
        -e "s/^#\(${AG_P_LOCALE//./\\.}\)/\1/" \
        /etc/locale.gen

    run_chroot locale-gen

    printf 'LANG=%s\n' "$AG_P_LOCALE" \
        > "$AG_INSTALL_ROOT/etc/locale.conf"

    msg "Locale configured"
}