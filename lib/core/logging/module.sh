#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Logging Service
# ==============================================================================
#  lib/core/logging/module.sh
#
#  Loads the logging module components.
#
#  Requires:
#    - variables.sh (for AG_FILE_LOG, AG_DIR_LOGGING)
#
#  Responsibilities:
#    - Load all logging/*.sh components
#
#  Does NOT:
#    - Initialize the log file (call init_logging() after sourcing this)
#    - Activate the ERR trap (the caller decides when: trap 'trap_err' ERR)
# ==============================================================================

# ------------------------------------------------------------------------------
# Load Logging Components
# ------------------------------------------------------------------------------

for file in "$AG_DIR_LOGGING"/*.sh; do
    [[ -f "$file" ]] || continue
    [[ "$(basename "$file")" == "module.sh" ]] && continue
    source "$file"
done

