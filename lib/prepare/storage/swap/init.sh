#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Swap Setter
# ==============================================================================
#  lib/prepare/storage/swap/init.sh
#
#  Cycles swap between full-RAM (hibernation-capable), half-RAM
#  (no hibernation), and disabled. Swap always lives as an LV inside
#  the mandatory LUKS+LVM container — no file or raw partition modes.
#
#  Populates:
#    - AG_P_SWAP_ENABLED ("full" | "half" | "")
#    - AG_P_SWAP_SIZE (computed from AG_HW_MEMORY_TOTAL_GB)
# ==============================================================================

prepare_swap()
{
    case "${AG_P_SWAP_ENABLED:-}" in
        "")
            AG_P_SWAP_ENABLED="full"
            AG_P_SWAP_SIZE="${AG_HW_MEMORY_TOTAL_GB}G"
            AG_P_SWAP_MENU_DISPLAY="${AG_P_SWAP_SIZE} - Hibernation"
            ;;

        "full")
            AG_P_SWAP_ENABLED="half"
            AG_P_SWAP_SIZE="$(awk -v r="$AG_HW_MEMORY_TOTAL_GB" 'BEGIN{printf "%.1f", r/2}')G"
            AG_P_SWAP_MENU_DISPLAY="${AG_P_SWAP_SIZE} - No Hibernation"
            ;;

        "half")
            AG_P_SWAP_ENABLED=""
            AG_P_SWAP_SIZE=""
            AG_P_SWAP_MENU_DISPLAY="Not used"
            ;;

        *)
            AG_P_SWAP_ENABLED="half"
            AG_P_SWAP_SIZE="$(awk -v r="$AG_HW_MEMORY_TOTAL_GB" 'BEGIN{printf "%.1f", r/2}')G"
            AG_P_SWAP_MENU_DISPLAY="${AG_P_SWAP_SIZE} - No Hibernation"
            ;;
    esac

    limit="$(get_swap_disk_limit_gb 40)"

    if awk -v w="$wanted" -v l="$limit" 'BEGIN { exit !(l > 0 && w > l) }'; then
        AG_P_SWAP_SIZE="${limit}G"
        msg "Swap capped at ${limit}G (40% of target disk)."
    else
        AG_P_SWAP_SIZE="${wanted}G"
    fi

    log_silent "SETTER: swap — AG_P_SWAP_ENABLED=${AG_P_SWAP_ENABLED:-} AG_P_SWAP_SIZE=${AG_P_SWAP_SIZE:-}"
}

