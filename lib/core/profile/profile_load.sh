#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Profile Loader
# ==============================================================================
#  lib/core/profile/profile_load.sh
#
#  Drives the saved-profile selection menu.
#
#  Requires:
#    - build_profile_map, render_profile_menu, display_profiles,
#      select_profile, profile_git_download, profile_git_set_url
#      (all loaded by module.sh from this same directory)
#
#  Does NOT:
#    - Discover profiles
#    - Render menus itself
#    - Save profiles
# ==============================================================================

profile_load()
{
    local choice
    local page=0

    while true; do

        build_profile_map "$page"
        clear
        render_profile_menu "$page"

        if [[ "${#PROFILE_MAP[@]}" -eq 0 ]]; then
            printf "  No saved profiles found.\n\n"
        else
            display_profiles
        fi

        printf "\n"
        if [[ "$AG_PROFILE_PAGE_COUNT" -gt 1 ]]; then
            printf " [N] Next page    [P] Previous page\n"
        fi
        printf " [1] Download profiles from git\n"
        printf " [2] Change default git URL\n"
        printf " [z] Return\n\n"

        read -r -n1 -s choice
        printf "\n"

        case "$choice" in
            z)
                return
                ;;
            N)
                if [[ "$AG_PROFILE_PAGE_COUNT" -gt 1 ]]; then
                    page=$(( (page + 1) % AG_PROFILE_PAGE_COUNT ))
                fi
                ;;
            P)
                if [[ "$AG_PROFILE_PAGE_COUNT" -gt 1 ]]; then
                    page=$(( (page - 1 + AG_PROFILE_PAGE_COUNT) % AG_PROFILE_PAGE_COUNT ))
                fi
                ;;
            1)
                profile_git_download
                ;;
            2)
                profile_git_set_url
                ;;
            *)
                select_profile "$choice" && return
                ;;
        esac

    done
}
