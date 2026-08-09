#!/usr/bin/env bash

# ==============================================================================
#  Arch Secure Installer V2.6 — Lock Hardware
# ==============================================================================
#  lib/core/precheck/lock_hardware.sh
#
#  After hardware is detected it should not change
#
# ==============================================================================

lock_hardware()
{
    readonly AG_HW_BOOT_MODE

    readonly AG_HW_SB_AVAILABLE
    readonly AG_HW_SB_ENABLED
    readonly AG_HW_SB_SETUP_MODE
    readonly AG_HW_SB_STATE

    readonly AG_HW_CPU_VENDOR
    readonly AG_HW_CPU_NAME

    readonly AG_HW_MEMORY_TOTAL_KB
    readonly AG_HW_MEMORY_TOTAL_GB

    readonly AG_HW_SWAP_FULL_GB
    readonly AG_HW_SWAP_HALF_GB

    readonly AG_HW_DISKS
    readonly AG_HW_USB_DEVICE

    readonly AG_HW_GPU_VENDOR
    readonly AG_HW_GPU_MODEL

    readonly AG_HW_TPM_PRESENT
    readonly AG_HW_TPM_VERSION
    readonly AG_HW_TPM_READY
}