#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Error Handling
# ==============================================================================
#  lib/core/logging/trap.sh
#
#  ERR trap handler — reports the failing command, file, and module.
#
#  Requires:
#    - AG_FILE_LOG (from lib/variables/paths.sh)
#    - AG_CURRENT_MODULE (set by run_module(), ag_orchestrator/run_module.sh)
#
#  Does NOT:
#    - Decide when the trap is active (caller runs `trap 'trap_err' ERR`)
#    - Perform any recovery — always exits
# ==============================================================================

# ------------------------------------------------------------------------------
# Error handling
# ------------------------------------------------------------------------------

trap_err()
{
    local exit_code=$?
    local command="${BASH_COMMAND:-unknown}"
    local line="${BASH_LINENO[0]:-unknown}"
    local file="${BASH_SOURCE[*]:-unknown}"
    local module="${AG_CURRENT_MODULE:-unknown}"

    local message="[FATAL] Error
    Module  : ${module}
    File    : ${file}:${line}
    Command : ${command}
    Exit    : ${exit_code}"

    printf "%s\n" "$message"

    [[ -n "${AG_FILE_LOG:-}" ]] &&
        printf "%s\n" "$message" >> "$AG_FILE_LOG"

    exit "$exit_code"
}
