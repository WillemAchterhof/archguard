#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Profile Variables
# ==============================================================================
#  lib/core/variables/profile_system.sh
#
#  Declares default values for all user-configurable profile settings.
#  Each prepare-stage setter overwrites its own AG_P_* value(s) once the
#  user makes a selection.
#
#  Responsibilities:
#    - Give every AG_P_* variable a safe default before any setter runs
#
#  Does NOT:
#    - Detect hardware
#    - Validate configuration
#    - Persist across installer runs
# ==============================================================================

# ------------------------------------------------------------------------------
# Name
# ------------------------------------------------------------------------------

AG_PROFILE_NAME="Default"

# ------------------------------------------------------------------------------
# Disk Preperation
# ------------------------------------------------------------------------------

AG_P_DISK=""
AG_P_EFI_SIZE=""
AG_P_LUKS=""
AG_P_ROOT_FS=""
AG_P_SWAP_ENABLED=""
AG_P_SWAP_SIZE=""
AG_P_DISK_WIPE_MODE=""

# ------------------------------------------------------------------------------
# System
# ------------------------------------------------------------------------------

AG_P_HOSTNAME=""
AG_P_USERNAME=""
AG_P_LOCALE=""
AG_P_TIMEZONE=""
AG_P_KEYBOARD=""
AG_P_MIRROR_COUNTRIES=""
AG_P_PACMAN_PARALLEL=""

AG_P_SBCert=""