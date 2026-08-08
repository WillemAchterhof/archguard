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
        # ---- Disk Preparatation ----
        a|A) run_disk ;;
        b) prepare_efi ;;
        c) prepare_lvm_luks ;;
        C) show_luks_passphrase ;;
        d) prepare_filesystem ;;
        D) prepare_btrfs ;;
        e) prepare_swap ;;
        f) prepare_wipe ;;

        # ---- SECURITY ----

        g) prepare_secureboot ;;
        

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
