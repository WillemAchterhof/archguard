#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Swap Disk-Relative Limit
# ==============================================================================
#  lib/prepare/storage/swap/limit.sh
#
#  Caps swap size relative to the target disk, so "full" RAM-sized
#  swap can never claim an unreasonable share of a small disk.
#
#  Requires:
#    - AG_P_DISK (set before this stage; run_disk runs unconditionally
#      in the pipeline, before the menu)
# ==============================================================================

get_swap_disk_limit_gb()
{
    local percent="$1"
    local disk_bytes
    local disk_gb

    [[ -n "${AG_P_DISK:-}" ]] || { printf "0"; return; }

    disk_bytes=$(lsblk -bdno SIZE "$AG_P_DISK" 2>/dev/null || echo 0)
    disk_gb=$(awk -v b="$disk_bytes" 'BEGIN { printf "%.1f", b / 1024 / 1024 / 1024 }')

    awk -v d="$disk_gb" -v p="$percent" 'BEGIN { printf "%.1f", d * p / 100 }'
}