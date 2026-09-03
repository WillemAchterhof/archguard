#!/usr/bin/env bash

# ==============================================================================
#  Arch Secure Installer V2.6 — Network Detection
# ==============================================================================
#  lib/core/precheck/network.sh
#
#  Detects the interface currently holding the default route — i.e.
#  whichever interface network_connection() (bootstrap) brought up,
#  wifi or ethernet.
#
#  Responsibilities:
#    - Detect the WAN-facing interface name
#
#  Populates:
#    - AG_HW_WAN_IFACE
#
#  Does NOT:
#    - Modify network configuration
#    - Configure the interface
# ==============================================================================

# ------------------------------------------------------------------------------
# Network
# ------------------------------------------------------------------------------

detect_wan_iface()
{
    command -v ip >/dev/null || return 0

    AG_HW_WAN_IFACE=$(
        ip -o route show default |
        awk '{for (i=1;i<=NF;i++) if ($i=="dev") print $(i+1)}' |
        head -n1 ||
        true
    )

    [[ -n "$AG_HW_WAN_IFACE" ]] || AG_HW_WAN_IFACE="unknown"
}