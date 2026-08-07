#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Profile List Display
# ==============================================================================
#  lib/core/profile/profile_render.sh
#
#  Renders the profile selection screen.
#
#  Requires:
#    - PROFILE_MAP (from profile_map.sh)
#
#  Does NOT:
#    - Discover profiles
#    - Select profiles
# ==============================================================================

render_profile_menu()
{
    printf "\n"
    printf "================================================\n"
    printf " Load Profile\n"
    printf "================================================\n\n"
}

display_profiles()
{
    local key

    for key in $(printf "%s\n" "${!PROFILE_MAP[@]}" | sort); do
        printf " [%s] %s\n" "$key" "${PROFILE_MAP[$key]}"
    done
}
