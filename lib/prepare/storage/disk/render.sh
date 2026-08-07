#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Disk Menu Renderer
# ==============================================================================
#  lib/prepare/storage/disk/render.sh
#
#  Renders the disk selection screen header.
#
#  Does NOT:
#    - List disks (see display.sh)
#    - Modify installer variables
#    - Read user input
# ==============================================================================

render_disk_menu()
{
    printf "\n"
    printf "================================================\n"
    printf " Target Disk Selection\n"
    printf "================================================\n\n"

    if [[ -n "$SA_HW_USB_DEVICE" ]]; then
        printf " Installer USB: %s (excluded)\n\n" \
            "$SA_HW_USB_DEVICE"
    fi
}