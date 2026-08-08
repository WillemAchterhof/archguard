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

AG_P_DISK="not set"
AG_P_EFI_SIZE="500M"
AG_P_LUKS="auto"
AG_P_ROOT_FS="btrfs"
AG_P_SWAP_ENABLED="full"
AG_P_SWAP_SIZE="${AG_HW_MEMORY_TOTAL_GB}G"
AG_P_SWAP_MENU_DISPLAY="${AG_P_SWAP_SIZE} - Hibernation"
AG_P_DISK_WIPE_MODE="secure"

# ------------------------------------------------------------------------------
# Security
# ------------------------------------------------------------------------------


AG_P_SECUREBOOT="Custom"

# ------------------------------------------------------------------------------
# System
# ------------------------------------------------------------------------------

AG_P_HOSTNAME="ArchGuard"
AG_P_USERNAME="willem"
AG_P_LOCALE="en_US.UTF-8"
AG_P_TIMEZONE="Europe/Amsterdam"
AG_P_KEYBOARD="us"
AG_P_MIRROR_COUNTRIES="NL,DE"
AG_P_PACMAN_PARALLEL="20"