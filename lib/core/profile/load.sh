#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Profile Loading
# ==============================================================================
#  lib/profile/load.sh
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
    if [[ -f "$AG_FILE_PROFILE_DEFAULT" ]]; then
        profile_load_file "$AG_FILE_PROFILE_DEFAULT"
        msg "Loaded default profile: $AG_FILE_PROFILE_DEFAULT"
    else
        log_silent "No default profile found — using defaults."
    fi
}
