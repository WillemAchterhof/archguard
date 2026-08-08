#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Btrfs Volume Setter
# ==============================================================================
#  lib/prepare/storage/filesystem/btrfs_setter.sh
#
#  Does NOT:
#    - Run unless AG_P_ROOT_FS is "btrfs"
# ==============================================================================

prepare_btrfs()
{
    [[ "$AG_P_ROOT_FS" == "btrfs" ]] || return

    local choice
    local confirm

    while true; do
        clear
        render_btrfs_menu

        read -r -n1 -s choice
        printf "\n"

        case "$choice" in
            x)
                write_btrfs_scratch
                if command -v nano >/dev/null; then
                    nano "$AG_FILE_BTRFS_SCRATCH"
                    reload_btrfs_scratch
                else
                    printf " nano not found.\n"
                    sleep 1
                fi
                ;;
            y)
                write_btrfs_scratch
                if command -v vim >/dev/null; then
                    vim "$AG_FILE_BTRFS_SCRATCH"
                    reload_btrfs_scratch
                else
                    printf " vim not found.\n"
                    sleep 1
                fi
                ;;
            w)
                printf " Reset all btrfs settings to defaults? [y/N] "
                read -r -n1 -s confirm
                printf "\n"
                if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                    reset_btrfs_defaults
                    msg "Btrfs settings reset to defaults."
                fi
                ;;
            z)
                return
                ;;
            *)
                printf " Invalid selection.\n"
                sleep 1
                ;;
        esac
    done
}