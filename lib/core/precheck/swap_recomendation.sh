#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Swap Size Recommendations
# ==============================================================================
#  lib/precheck/swap.sh
#
#  Computes RAM-based swap size recommendations once, during precheck.
#  These are uncapped — the 40%-of-disk limit is applied later, after
#  disk selection (see lib/prepare/storage/swap/limit.sh).
#
#  Requires:
#    - AG_HW_MEMORY_TOTAL_GB (must run after detect_memory)
#
#  Populates:
#    - AG_HW_SWAP_FULL_GB
#    - AG_HW_SWAP_HALF_GB
# ==============================================================================

detect_swap_recommendations()
{
    AG_HW_SWAP_FULL_GB="$AG_HW_MEMORY_TOTAL_GB"
    AG_HW_SWAP_HALF_GB=$(awk -v r="$AG_HW_MEMORY_TOTAL_GB" 'BEGIN{printf "%.1f", r/2}')
}