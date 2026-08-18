#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Keyboard configuration
# ==============================================================================
#  lib/install/system/keyboard.sh
#
#  Requires:
#    - AG_P_KEYBOARD
# ==============================================================================

configure_keyboard()
{
    msg "Configuring keyboard: $AG_P_KEYBOARD"

    printf 'KEYMAP=%s\n' "$AG_P_KEYBOARD" \
        > "$AG_INSTALL_ROOT/etc/vconsole.conf"

    msg "Keyboard configured"
}