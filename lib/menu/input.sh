#!/usr/bin/env bash

# ==============================================================================
# Arch Secure Installer V2.6 — Input Handler
# ==============================================================================
# lib/core/input.sh
#
# Dispatches menu selections to setter modules.
# Does not contain configuration logic.
# ==============================================================================

handle_input()
{
    case "$1" in
        # ---- STORAGE ----
        a) prepare_disk ;;
        b) prepare_filesystem ;;
        c) prepare_efi ;;
        d) prepare_swap ;;

        # ---- SECURITY ----
        e) prepare_luks ;;
        f) prepare_secureboot ;;
        g) prepare_wipe ;;

        # ---- SYSTEM ----
        h) prepare_hostname ;;
        i) prepare_username ;;
        l) prepare_locale ;;
        m) prepare_timezone ;;
        n) prepare_keyboard ;;
        o) prepare_mirrors ;;
        p) prepare_pacman ;;

        # ---- ACTIONS ----
        w) profile_load ;;
        x) profile_save ;;
        X) profile_save_as ;;
        y) AG_MENU_PROCEED="1" ;;
        z) AG_MENU_EXIT="1" ;;
        *) msg "Invalid selection." ;;
    esac
}
