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
    local page="$1"

    printf "\n"
    printf "================================================\n"
    if [[ "$AG_PROFILE_PAGE_COUNT" -gt 1 ]]; then
        printf " Load Profile  (page %s of %s)\n" "$((page + 1))" "$AG_PROFILE_PAGE_COUNT"
    else
        printf " Load Profile\n"
    fi
    printf "================================================\n\n"
}

display_profiles()
{
    local key

    for key in $(printf "%s\n" "${!PROFILE_MAP[@]}" | sort); do
        printf " [%s] %s\n" "$key" "${PROFILE_MAP[$key]}"
    done
}
