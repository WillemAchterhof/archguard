#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Logging Init
# ==============================================================================
#  lib/core/logging/init.sh
#
#  Prepares the log file for writing.
#
#  Requires:
#    - AG_FILE_LOG (from lib/variables/paths.sh)
#
#  Does NOT:
#    - Write log entries
#    - Handle errors
# ==============================================================================

# ------------------------------------------------------------------------------
# Requirements
# ------------------------------------------------------------------------------

: "${AG_FILE_LOG:?AG_FILE_LOG not set — source variables.sh first}"

# ------------------------------------------------------------------------------
# Initialization
# ------------------------------------------------------------------------------

init_logging()
{
    mkdir -p "$(dirname "$AG_FILE_LOG")"

    if [[ ! -f "$AG_FILE_LOG" ]]; then
        touch "$AG_FILE_LOG"
    fi
}
