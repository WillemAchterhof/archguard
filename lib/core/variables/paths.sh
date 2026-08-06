#!/usr/bin/env bash

# ==============================================================================
#  Arch Secure Installer V2.6 — Path Variables
# ==============================================================================
#  lib/core/variables/paths.sh
#
#  Defines installer directories and file locations.
#
#  Responsibilities:
#    - Installer paths
#    - State directories
#    - Log files
#    - Profile locations
#
#  Does NOT:
#    - Create directories
#    - Validate paths
#    - Modify files
# ==============================================================================

# ------------------------------------------------------------------------------
# Base
# ------------------------------------------------------------------------------

readonly AG_DIR_INSTALL="$AG_DIR_MAIN/ag_install"

# ------------------------------------------------------------------------------
# Library
# ------------------------------------------------------------------------------

readonly AG_DIR_LIB="$AG_DIR_INSTALL/lib"
readonly AG_DIR_PIPELINE="$AG_DIR_INSTALL/ag_orchestrator"
readonly AG_DIR_STATE="$AG_DIR_MAIN/ag_state"

readonly AG_DIR_CORE="$AG_DIR_LIB/core"
readonly AG_DIR_LOG="$AG_DIR_STATE/log"

readonly AG_DIR_LOGGING="$AG_DIR_CORE/logging"

# ------------------------------------------------------------------------------
# Files
# ------------------------------------------------------------------------------

readonly AG_FILE_LOG="$AG_DIR_LOG/archguard_install.log"
