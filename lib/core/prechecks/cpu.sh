#!/usr/bin/env bash

# ==============================================================================
#  Arch Secure Installer V2.6 — CPU Detection
# ==============================================================================
#  lib/core/precheck/cpu.sh
#
#  Detects processor information.
#
#  Responsibilities:
#    - Detect CPU vendor
#    - Detect CPU model
#
#  Populates:
#    - AG_HW_CPU_VENDOR
#    - AG_HW_CPU_NAME
#
#  Does NOT:
#    - Modify hardware
#    - Configure the processor
# ==============================================================================

# ------------------------------------------------------------------------------
# CPU
# ------------------------------------------------------------------------------

detect_cpu()
{
    local vendor

    vendor=$(
        grep -m1 '^vendor_id' /proc/cpuinfo 2>/dev/null |
        awk '{print $3}' |
        tr '[:upper:]' '[:lower:]' ||
        true
    )

    case "$vendor" in
        genuineintel)
            AG_HW_CPU_VENDOR="intel"
            ;;
        authenticamd)
            AG_HW_CPU_VENDOR="amd"
            ;;
        *)
            AG_HW_CPU_VENDOR="unknown"
            ;;
    esac

    AG_HW_CPU_NAME=$(
        grep -m1 '^model name' /proc/cpuinfo 2>/dev/null |
        cut -d: -f2- |
        sed 's/^ *//' ||
        echo "Unknown"
    )
}