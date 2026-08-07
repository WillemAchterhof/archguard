#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Profile Discovery
# ==============================================================================
#  lib/core/profile/profile_map.sh
#
#  Builds the map of selectable saved profiles for a given page.
#
#  Populates:
#    - PROFILE_MAP (global associative array, letter -> profile name)
#    - AG_PROFILE_PAGE_COUNT (total number of pages)
#
#  Does NOT:
#    - Load profiles
#    - Render menus
# ==============================================================================

build_profile_map()
{
    local page="${1:-0}"

    declare -gA PROFILE_MAP
    PROFILE_MAP=()
    AG_PROFILE_PAGE_COUNT=1

    [[ -d "$AG_DIR_PROFILE_STATE" ]] || return 0

    local letters=( {a..z} )
    local all_names=()
    local name

    while IFS= read -r name; do
        all_names+=("$name")
    done < <(
        find "$AG_DIR_PROFILE_STATE" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' |
        sort
    )

    local total="${#all_names[@]}"
    [[ "$total" -eq 0 ]] && return 0

    AG_PROFILE_PAGE_COUNT=$(( (total + 25) / 26 ))

    local start=$(( page * 26 ))
    local index=0
    local i

    for (( i = start; i < total && index < 26; i++ )); do
        PROFILE_MAP["${letters[$index]}"]="${all_names[$i]}"
        ((index+=1))
    done
}
