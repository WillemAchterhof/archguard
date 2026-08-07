#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Profile Selection
# ==============================================================================
#  lib/core/profile/profile_select.sh
#
#  Validates and loads the chosen profile.
#
#  Requires:
#    - PROFILE_MAP (from profile_map.sh)
#    - profile_load_file (from load.sh)
#
#  Does NOT:
#    - Render menus
#    - Discover profiles
# ==============================================================================

select_profile()
{
    local choice="$1"
    local selected
    local file

    if [[ ! -v "PROFILE_MAP[$choice]" ]]; then
        printf " Invalid selection.\n"
        return 1
    fi

    selected="${PROFILE_MAP[$choice]}"
    file="$AG_DIR_PROFILE_STATE/$selected/system.env"

    if [[ ! -f "$file" ]]; then
        printf " Profile file missing: %s\n" "$file"
        return 1
    fi

    profile_load_file "$file"
    AG_PROFILE_NAME="$selected"

    msg "Loaded profile: $AG_PROFILE_NAME"
    log_silent "LOADER: profile — AG_PROFILE_NAME=$AG_PROFILE_NAME"

    return 0
}

select_default_profile()
{
    local file="$AG_DIR_PROFILE_STATE/Default/system.env"

    if [[ ! -f "$file" ]]; then
        printf " No default profile found.\n"
        sleep 1
        return 1
    fi

    profile_load_file "$file"
    AG_PROFILE_NAME="Default"

    msg "Loaded profile: $AG_PROFILE_NAME"
    log_silent "LOADER: profile — AG_PROFILE_NAME=$AG_PROFILE_NAME"

    return 0
}
