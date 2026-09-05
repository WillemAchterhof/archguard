#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Prepare Postboot Environment
# ==============================================================================
#  lib/postboot/prepare/environment.sh
# ==============================================================================

prepare_post_environment()
{
    local source_dir="$AG_DIR_POSTBOOT/install"
    local target_dir="$AG_INSTALL_ROOT/opt/archguard"

    msg "Preparing postboot environment"

    [[ -d "$source_dir" ]] \
        || fatal "Postboot install directory missing: $source_dir"

    rm -rf -- "$target_dir"
    mkdir -p -- "$target_dir"

    cp -a -- "$source_dir/." "$target_dir/"

    msg "Postboot environment prepared"
}