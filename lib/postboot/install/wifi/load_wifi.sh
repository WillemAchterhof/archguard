# ==============================================================================
# Network Connection
# ==============================================================================

AG_WIFI_ENV="/opt/archguard/state/config/wifi.env"

wifi_load() {
    [[ -f "$AG_WIFI_ENV" ]] || return 0

    log "[*] Loading saved Wi-Fi configuration..."

    # shellcheck disable=SC1090
    source "$AG_WIFI_ENV"

    [[ -n "${AG_WIFI_SSID:-}" ]] \
        || fatal "Wi-Fi configuration is missing AG_WIFI_SSID."

    [[ -n "${AGS_WIFI_PASSWORD:-}" ]] \
        || fatal "Wi-Fi configuration is missing AGS_WIFI_PASSWORD."
}

wifi_connect_saved() {
    [[ -n "${AG_WIFI_SSID:-}" ]] || return 0
    [[ -n "${AGS_WIFI_PASSWORD:-}" ]] || return 0

    log "[*] Connecting to saved Wi-Fi network..."

    nmcli device wifi connect \
        "$AG_WIFI_SSID" \
        password "$AGS_WIFI_PASSWORD" \
        || fatal "Failed to connect to saved Wi-Fi network."

    unset AGS_WIFI_PASSWORD
}