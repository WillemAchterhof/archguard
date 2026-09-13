#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Postboot Connectivity
# ==============================================================================
#  lib/postboot/install/base/connectivity.sh
#
#  Provides:
#    - Internet connectivity check
#    - Saved Wi-Fi configuration loading
#    - Saved Wi-Fi connection
#    - Interactive Wi-Fi connection
#    - Base connectivity orchestration
#
#  Network backend:
#    NetworkManager
#      └── iwd
#
#  All Wi-Fi operations are performed through nmcli.
# ==============================================================================

AG_WIFI_ENV="/opt/archguard/state/config/wifi.env"

# ==============================================================================
#  INTERNET CONNECTIVITY
# ==============================================================================

check_internet()
{
    timeout 5 ping -c 1 -W 2 1.1.1.1 >/dev/null 2>&1
}

# ==============================================================================
#  SAVED WI-FI CONFIGURATION
# ==============================================================================

wifi_load()
{
    [[ -f "$AG_WIFI_ENV" ]] || return 0

    log "[*] Loading saved Wi-Fi configuration..."

    # shellcheck disable=SC1090
    source "$AG_WIFI_ENV"

    [[ -n "${AG_WIFI_SSID:-}" ]] \
        || fatal "Wi-Fi configuration is missing AG_WIFI_SSID."

    [[ -n "${AG_WIFI_PASSWORD:-}" ]] \
        || fatal "Wi-Fi configuration is missing AG_WIFI_PASSWORD."
}

wifi_connect_saved()
{
    [[ -n "${AG_WIFI_SSID:-}" ]] \
        || return 1

    [[ -n "${AG_WIFI_PASSWORD:-}" ]] \
        || return 1

    log "[*] Connecting to saved Wi-Fi network..."

    nmcli device wifi connect \
        "$AG_WIFI_SSID" \
        password "$AG_WIFI_PASSWORD"
}

# ==============================================================================
#  INTERACTIVE WI-FI SETUP
# ==============================================================================

wifi_show()
{
    log "[*] Scanning for wireless networks..."

    nmcli device wifi rescan >/dev/null 2>&1 || true

    sleep 2

    printf "\nAvailable wireless networks:\n\n"

    nmcli device wifi list

    printf "\n"
}

wifi_select()
{
    printf "SSID: "
    read -r AG_WIFI_SSID
}

wifi_password()
{
    printf "\nPassword: "
    read -rs AG_WIFI_PASSWORD
    printf "\n"
}

wifi_attempt()
{
    nmcli device wifi connect \
        "$AG_WIFI_SSID" \
        password "$AG_WIFI_PASSWORD"
}

wifi_connect()
{
    wifi_show

    while ! check_internet; do

        wifi_select
        wifi_password

        if wifi_attempt; then
            sleep 3
        fi

        if check_internet; then
            break
        fi

        printf "\nUnable to connect. Please try again.\n\n"

        wifi_show
    done

    unset AG_WIFI_PASSWORD

    printf "\nConnected.\n\n"
}

# ==============================================================================
#  BASE CONNECTIVITY
# ==============================================================================

base_connectivity()
{
    # --------------------------------------------------------------------------
    # Already connected
    # --------------------------------------------------------------------------

    if check_internet; then
        log "[+] Internet connection already available."
        return 0
    fi

    log "[*] No internet connection detected."

    # --------------------------------------------------------------------------
    # Try saved Wi-Fi configuration
    # --------------------------------------------------------------------------

    if [[ -f "$AG_WIFI_ENV" ]]; then
        log "[*] Saved Wi-Fi configuration found."

        wifi_load

        if wifi_connect_saved; then
            sleep 3

            if check_internet; then
                log "[+] Internet connection established."
                unset AG_WIFI_PASSWORD
                return 0
            fi
        fi

        log "[!] Saved Wi-Fi connection failed."
        unset AG_WIFI_PASSWORD
    fi

    # --------------------------------------------------------------------------
    # Interactive Wi-Fi setup
    # --------------------------------------------------------------------------

    log "[*] Starting interactive Wi-Fi setup..."

    wifi_connect

    check_internet \
        || fatal "Unable to establish an internet connection."

    log "[+] Internet connection established."
}
