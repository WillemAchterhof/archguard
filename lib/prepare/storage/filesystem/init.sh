#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Filesystem Setter
# ==============================================================================
#  lib/prepare/storage/filesystem/setter.sh
#
#  Drives the root filesystem selection menu.
#
#  Does NOT:
#    - Format disks
#    - Create filesystems
#    - Validate installation profile
# ==============================================================================

prepare_filesystem()
{
    local choice

    while true; do
        clear
        render_filesystem_menu

        read -r -n1 -s choice
        printf "\n"

        case "$choice" in
            z)
                return
                ;;
            *)
                if select_filesystem "$choice"; then
                    update_swap_for_filesystem
                    return
                fi
                ;;
        esac
    done
}