#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Post-Boot Preparation
# ==============================================================================
#  lib/install/system/postboot.sh
# ==============================================================================

configure_postboot()
{
    local postboot_src="$AG_DIR_POSTBOOT"
    local postboot_dst="$AG_INSTALL_ROOT/mnt/postboot"

    msg "Preparing post-boot configuration"

    [[ -d "$postboot_src" ]] \
        || fatal "Postboot directory missing: $postboot_src"

    rm -rf -- "$postboot_dst"
    mkdir -p "$postboot_dst"

    cp -- "$postboot_src"/*.sh "$postboot_dst/"

    chmod 700 "$postboot_dst"
    chmod 700 "$postboot_dst"/*.sh

    msg "Post-boot configuration prepared"
}