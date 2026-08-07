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
readonly AG_DIR_STATE="$AG_DIR_MAIN/ag_state"
# ------------------------------------------------------------------------------
# Library
# ------------------------------------------------------------------------------
# /
readonly AG_DIR_LIB="$AG_DIR_INSTALL/lib"
readonly AG_DIR_PIPELINE="$AG_DIR_INSTALL/ag_orchestrator"
readonly AG_DIR_LOG="$AG_DIR_STATE/log"
# /lib
readonly AG_DIR_CORE="$AG_DIR_LIB/core"
readonly AG_DIR_INSTALLER="$AG_DIR_LIB/installer"
readonly AG_DIR_MENU="$AG_DIR_LIB/menu"
readonly AG_DIR_PREPARE="$AG_DIR_LIB/prepare"
readonly AG_DIR_VALIDATE="$AG_DIR_LIB/validate"
# /ag_state
readonly AG_DIR_PROFILE_STATE="$AG_DIR_STATE/profile"
# /lib/core
readonly AG_DIR_LOGGING="$AG_DIR_CORE/logging"
readonly AG_DIR_PRECHECK="$AG_DIR_CORE/precheck"
readonly AG_DIR_PROFILE_LIB="$AG_DIR_CORE/profile"
readonly AG_DIR_VARIABLES="$AG_DIR_CORE/variables"
# ------------------------------------------------------------------------------
# Files
# ------------------------------------------------------------------------------
readonly AG_FILE_LOG="$AG_DIR_LOG/archguard_install.log"
