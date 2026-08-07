#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Profile Discovery
# ==============================================================================
#  lib/core/profile/profile_map.sh
#
#  Builds the map of selectable saved profiles.
#
#  Populates:
#    - PROFILE_MAP (global associative array, letter -> profile name)
#
#  Does NOT:
#    - Load profiles
#    - Render menus
# ==============================================================================

build_profile_map()
{
    declare -gA PROFILE_MAP
    PROFILE_MAP=()

    [[ -d "$AG_DIR_PROFILE_STATE" ]] || return 0

    local letters=( {a..z} )
    local index=0
    local name

    while IFS= read -r name; do
        [[ $index -lt 26 ]] || break

        PROFILE_MAP["${letters[$index]}"]="$name"
        ((index+=1))

    done < <(
        find "$AG_DIR_PROFILE_STATE" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' |
        sort
    )
}
