#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Basic Logging
# ==============================================================================
#  lib/core/logging/basic.sh
#
#  Core message output — to screen and to the log file.
#
#  Requires:
#    - AG_FILE_LOG (from lib/variables/paths.sh)
#
#  Does NOT:
#    - Initialize the log file
#    - Handle validation-specific output
#    - Handle trapped errors
# ==============================================================================

# ------------------------------------------------------------------------------
# Basic logging
# ------------------------------------------------------------------------------

log()
{
    local message="$1"
    printf " %s\n" "$message"
    printf " %s\n" "$message" >> "$AG_FILE_LOG"
}

log_silent()
{
    printf " %s\n" "$1" >> "$AG_FILE_LOG"
}

msg()
{
    log "[*] $1"
}

fatal()
{
    log "[FATAL] $1"
    exit 1
}
