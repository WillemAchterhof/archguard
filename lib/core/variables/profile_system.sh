#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Profile Variables
# ==============================================================================
#  lib/core/variables/profile.sh
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
# Storage
# ------------------------------------------------------------------------------

AG_P_DISK=""
AG_P_EFI_SIZE="500M"
AG_P_LUKS="auto"
AG_P_ROOT_FS="btrfs"
AG_P_SWAP_STATUS=""
AG_P_SWAP_SIZE="${AG_HW_MEMORY_TOTAL_GB}GB"
AG_P_SWAP_SIZE=""
AG_P_DISK_WIPE_MODE="secure"

# ------------------------------------------------------------------------------
# Security
# ------------------------------------------------------------------------------


AG_P_SECUREBOOT=""

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