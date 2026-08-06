#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Menu Entry Point
# ==============================================================================
#  lib/menu/run.sh
#
#  Runs the main installer dashboard.
#
#  Requires:
#    - render_menu, handle_input (loaded by module.sh from this same directory)
#
#  Responsibilities:
#    - Execute menu loop
#
#  Does NOT:
#    - Load its own dependencies (module.sh handles that)
#    - Configure installer settings
#    - Validate profiles
#    - Load prepare modules
# ==============================================================================

run_menu()
{
    local key

    while true; do
        render_menu
        read -r -n1 -s key
        printf "\n"
        handle_input "$key"
        [[ "${AG_MENU_EXIT:-0}" == "1" ]] && return
        [[ "${AG_MENU_PROCEED:-0}" == "1" ]] && return
    done
}