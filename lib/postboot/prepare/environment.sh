#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Prepare Postboot Environment
# ==============================================================================
#  lib/postboot/prepare/environment.sh
# ==============================================================================

prepare_environment()
{
    local source_dir="$AG_DIR_POSTBOOT/install"
    local target_dir="$AG_INSTALL_ROOT/opt/archguard"
    local wifi_source="$AG_FILE_WIFI"
    local wifi_target="$target_dir/config/base/wifi.env"

    msg "Preparing postboot environment"

    [[ -d "$source_dir" ]] \
        || fatal "Postboot install directory missing: $source_dir"

    rm -rf -- "$target_dir"
    mkdir -p -- "$target_dir"

    cp -a -- "$source_dir/." "$target_dir/"

    # --------------------------------------------------------------------------
    # Wi-Fi configuration
    # --------------------------------------------------------------------------

    if [[ -f "$wifi_source" ]]; then
        mkdir -p -- "$(dirname "$wifi_target")"

        cp -f -- "$wifi_source" "$wifi_target"
        chmod 600 "$wifi_target"

        msg "Saved Wi-Fi configuration copied to postboot environment"
    else
        msg "No saved Wi-Fi configuration found"
    fi

    msg "Postboot environment prepared"
}