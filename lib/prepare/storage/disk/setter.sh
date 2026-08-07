#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Disk Setter
# ==============================================================================
#  lib/prepare/storage/disk/setter.sh
#
#  Drives the target disk selection menu.
#
#  Responsibilities:
#    - Loop the disk selection menu
#    - Commit the user's choice
#
#  Does NOT:
#    - Detect disks
#    - Render menus
#    - Partition or wipe disks
# ==============================================================================

run_disk()
{
    local choice

    while true; do

        build_disk_map
        clear
        render_disk_menu

        if [[ "${#DISK_MAP[@]}" -eq 0 ]]; then
            printf "  No usable disks found.\n\n"
            printf " Press any key to return..."
            read -r -n1 -s
            return
        fi

        display_disks

        printf "\n"
        printf " [z] return\n\n"

        read -r -n1 -s choice
        printf "\n"

        case "$choice" in
            z)
                return
                ;;
            *)
                select_disk "$choice" && return
                ;;
        esac

    done
}