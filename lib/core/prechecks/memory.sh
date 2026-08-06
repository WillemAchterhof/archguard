#!/usr/bin/env bash

# ==============================================================================
#  Arch Secure Installer V2.6 — Memory Detection
# ==============================================================================
#  lib/core/precheck/memory.sh
#
#  Detects system memory.
#
#  Responsibilities:
#    - Detect total system memory
#    - Convert memory to gigabytes
#
#  Populates:
#    - AG_HW_MEMORY_TOTAL_KB
#    - AG_HW_MEMORY_TOTAL_GB
#
#  Does NOT:
#    - Allocate memory
#    - Modify system configuration
#    - Tune kernel parameters
# ==============================================================================

# ------------------------------------------------------------------------------
# Memory
# ------------------------------------------------------------------------------

detect_memory()
{
    local kb

    kb=$(
        awk '/MemTotal/ {print $2}' /proc/meminfo 2>/dev/null ||
        echo 0
    )

    AG_HW_MEMORY_TOTAL_KB="$kb"

    AG_HW_MEMORY_TOTAL_GB=$(
        awk "BEGIN { printf \"%.1f\", $kb / 1024 / 1024 }"
    )
}