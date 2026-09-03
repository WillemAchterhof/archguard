#!/usr/bin/env bash

# ==============================================================================
#  Arch Secure Installer V2.6 — Hardware Variables
# ==============================================================================
#  lib/core/variables/hardware.sh
#
#  Defines hardware information detected during the precheck phase.
#
#  Responsibilities:
#    - Boot firmware
#    - CPU information
#    - Memory information
#    - Storage devices
#    - Graphics hardware
#    - TPM state
#    - Secure Boot state
#    - Boot USB device
#    - WAN network interface
#
#  Does NOT:
#    - Detect hardware
#    - Modify hardware settings
#    - Store profile configuration
#    - Define filesystem paths
# ==============================================================================

# ------------------------------------------------------------------------------
# Boot / Firmware
# ------------------------------------------------------------------------------

AG_HW_BOOT_MODE="unknown"

AG_HW_SB_AVAILABLE="false"
AG_HW_SB_ENABLED="false"
AG_HW_SB_SETUP_MODE="false"
AG_HW_SB_STATE="unknown"

# ------------------------------------------------------------------------------
# CPU
# ------------------------------------------------------------------------------

AG_HW_CPU_VENDOR="unknown"
AG_HW_CPU_NAME="unknown"

# ------------------------------------------------------------------------------
# Memory
# ------------------------------------------------------------------------------

AG_HW_MEMORY_TOTAL_KB="0"
AG_HW_MEMORY_TOTAL_GB="0"

# ------------------------------------------------------------------------------
# Swap
# ------------------------------------------------------------------------------

AG_HW_SWAP_FULL_GB="0"
AG_HW_SWAP_HALF_GB="0"

# ------------------------------------------------------------------------------
# Storage
# ------------------------------------------------------------------------------

AG_HW_DISKS=""
AG_HW_USB_DEVICE=""

# ------------------------------------------------------------------------------
# Graphics
# ------------------------------------------------------------------------------

AG_HW_GPU_VENDOR="unknown"
AG_HW_GPU_MODEL="unknown"

# ------------------------------------------------------------------------------
# TPM
# ------------------------------------------------------------------------------

AG_HW_TPM_PRESENT="no"
AG_HW_TPM_VERSION="none"
AG_HW_TPM_READY="no"

# ------------------------------------------------------------------------------
# Network
# ------------------------------------------------------------------------------

AG_HW_WAN_IFACE="unknown"