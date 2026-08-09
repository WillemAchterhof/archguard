#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Swap Size Recalculation
# ==============================================================================
#  lib/prepare/storage/swap/recalc.sh
#
#  Recomputes AG_P_SWAP_SIZE against current hardware after a profile
#  loads. AG_P_SWAP_ENABLED (the mode) is trusted as loaded; the size
#  itself is always derived fresh, since it depends on this session's
#  RAM and disk, not whatever was true when the profile was saved.
#
#  Requires:
#    - get_swap_disk_limit_gb (from limit.sh)
# ==============================================================================

recalc_swap_size()
{
    local wanted
    local limit

    case "${AG_P_SWAP_ENABLED:-}" in
        full) wanted="$AG_HW_SWAP_FULL_GB" ;;
        half) wanted="$AG_HW_SWAP_HALF_GB" ;;
        *)
            AG_P_SWAP_SIZE=""
            return
            ;;
    esac

    limit="$(get_swap_disk_limit_gb 40)"

    if awk -v w="$wanted" -v l="$limit" 'BEGIN { exit !(l > 0 && w > l) }'; then
        AG_P_SWAP_SIZE="${limit}G"
    else
        AG_P_SWAP_SIZE="${wanted}G"
    fi
}