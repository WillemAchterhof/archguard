#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Validation Output
# ==============================================================================
#  lib/core/logging/checks.sh
#
#  Pass/fail formatting for validation and precheck output.
#
#  Requires:
#    - log() (from lib/core/logging/basic.sh)
#
#  Does NOT:
#    - Perform validation logic itself
#    - Write directly to the log file
# ==============================================================================

# ------------------------------------------------------------------------------
# Validation output
# ------------------------------------------------------------------------------

pass_check()
{
    log "  [✓] $1"
}

fail_check()
{
    log "  [✗] $1"
}
