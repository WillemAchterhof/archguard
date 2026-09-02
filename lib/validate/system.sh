#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — System Field Validation
# ==============================================================================
#  lib/validate/system.sh
#
#  Presence-only checks for the plain AG_P_* fields the system stage
#  needs: hostname, username, locale, timezone, keyboard, pacman
#  parallel downloads, Secure Boot certificate mode. Looped instead of
#  one function per field, since the check is identical for all seven
#  — only the variable name differs. Same pattern as
#  validate_required.sh, kept in its own file since these fields come
#  from the System menu section, not the Prepare Disk section.
#
#  Not part of this loop:
#    - AG_P_MIRROR_COUNTRIES — documented as optional; blank means
#      "no country filter", not "not yet set"
#
#  Requires:
#    - fail_check (lib/core/logging/checks.sh)
#
#  Sets:
#    - AG_V_HOSTNAME, AG_V_USERNAME, AG_V_LOCALE, AG_V_TIMEZONE,
#      AG_V_KEYBOARD, AG_V_PACMAN, AG_V_SBCERT
#      ("0" valid, "1" invalid)
#
#  Does NOT:
#    - Touch any AG_P_* value
#    - Check AG_P_MIRROR_COUNTRIES
#
#  Returns:
#    - 0 if every field is set
#    - 1 if one or more are missing
# ==============================================================================

validate_system_fields()
{
    local -a fields=(AG_P_HOSTNAME      AG_P_USERNAME      AG_P_LOCALE      AG_P_TIMEZONE      AG_P_KEYBOARD      AG_P_PACMAN_PARALLEL         AG_P_SBCert)
    local -a flags=(AG_V_HOSTNAME       AG_V_USERNAME      AG_V_LOCALE      AG_V_TIMEZONE      AG_V_KEYBOARD      AG_V_PACMAN                  AG_V_SBCERT)
    local -a labels=("Hostname not set" "Username not set" "Locale not set" "Timezone not set" "Keyboard not set" "Pacman parallel downloads not set" "Secure Boot certificate mode not set")

    local i field flag failed=0

    for i in "${!fields[@]}"; do
        field="${fields[$i]}"
        flag="${flags[$i]}"

        if [[ -n "${!field:-}" ]]; then
            printf -v "$flag" "0"
        else
            printf -v "$flag" "1"
            fail_check "${labels[$i]}"
            failed=1
        fi
    done

    return "$failed"
}