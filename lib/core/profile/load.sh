#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Profile Loading
# ==============================================================================
#  lib/core/profile/load.sh
#
#  Loads profile .env files into AG_P_* variables.
#
#  Does NOT:
#    - Validate loaded values
#    - Save profiles
# ==============================================================================

profile_load_file()
{
    local file="$1"

    [[ -f "$file" ]] || return 1

    source "$file"
}

load_default_profile()
{
    local file="$AG_DIR_PROFILE_STATE/Default/system.env"

    if [[ -f "$file" ]]; then
        profile_load_file "$file"
        AG_PROFILE_NAME="Default"
        msg "Loaded default profile: $file"
    else
        log_silent "No default profile found — using defaults."
    fi
}
