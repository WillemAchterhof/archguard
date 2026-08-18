#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — User password
# ==============================================================================
#  lib/validate/password.sh
#
#  Populates:
#    - AGS_USER_PASSWORD (sensitive — never written to a profile)
#
#  Requires:
#    - AG_P_USERNAME
#
#  Does NOT:
#    - Create the user
#    - Write the password to disk
#    - Display the password
#
#  Returns:
#    - 0 if a password was successfully set
# ==============================================================================

set_user_password()
{
    local password
    local password_confirm

    printf "\n  Set password for user: $AG_P_USERNAME\n\n"

    while true; do
        read -rsp "  Enter password: " password
        printf '\n'

        read -rsp "  Confirm password: " password_confirm
        printf '\n'

        if [[ "$password" != "$password_confirm" ]]; then
            printf "\n  ⚠  Passwords do not match — try again.\n\n"
            unset password password_confirm
            continue
        fi

        if [[ -z "$password" ]]; then
            printf "\n  ⚠  Password cannot be empty — try again.\n\n"
            unset password password_confirm
            continue
        fi

        break
    done

    AGS_USER_PASSWORD="$password"

    unset password password_confirm

    log_silent "SETTER: user password — AGS_USER_PASSWORD populated"

    return 0
}