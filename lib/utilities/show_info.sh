#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Info Screen
# ==============================================================================
#  lib/utilities/show_info.sh
#
#  Displays a block of pre-formatted text and waits for any key.
#  Callers build the text; this only handles the pause/return.
# ==============================================================================

show_info()
{
    local text="$1"

    clear
    printf "%s\n" "$text"
    printf "\n Press any key to return..."
    read -r -n1 -s
    printf "\n"
}