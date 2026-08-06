#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Structured Logging
# ==============================================================================
#  lib/core/logging/structured.sh
#
#  Section headers and full-variable-state dumps for the log file.
#
#  Requires:
#    - log_silent() (from lib/core/logging/basic.sh)
#
#  Convention:
#    - Any variable holding a secret (passphrase, password, etc.) MUST
#      include "_SECRET" in its name, e.g. AG_P_LUKS_PASSPHRASE_SECRET.
#      log_variables() below relies on this to redact automatically.
#
#  Does NOT:
#    - Initialize the log file
#    - Handle validation-specific output
# ==============================================================================

# ------------------------------------------------------------------------------
# Section Headers
# ------------------------------------------------------------------------------

log_header()
{
    log_silent "================================================================================"
    log_silent "$1"
    log_silent "$(date '+%Y-%m-%d %H:%M:%S')"
    log_silent "================================================================================"
}

# ------------------------------------------------------------------------------
# Variable Dump
# ------------------------------------------------------------------------------

log_variables()
{
    log_silent "VARIABLES"

    while IFS= read -r var; do
        if [[ "$var" == *_SECRET* ]]; then
            log_silent "$(printf " %-30s = [REDACTED]" "$var")"
            continue
        fi

        log_silent "$(printf " %-30s = %q" "$var" "${!var}")"
    done < <(compgen -A variable AG_)

    log_silent "================================================================================"
}
