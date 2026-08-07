#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Filesystem Renderer
# ==============================================================================
#  lib/prepare/storage/filesystem/render.sh
# ==============================================================================

render_filesystem_menu()
{
    printf "\n"
    printf "================================================\n"
    printf " Root Filesystem\n"
    printf "================================================\n\n"
    printf " Current: %s\n\n" ${AG_P_ROOT_FS:-Not set}
    printf " [a] ext4\n"
    printf "     Stable, mature, widely supported\n\n"
    printf " [b] btrfs\n"
    printf "     Snapshots, compression, subvolumes\n\n"
    printf " [z] Return\n\n"
}