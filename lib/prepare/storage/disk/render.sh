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
    printf " Choose the disk to install to. This disk will be\n"
    printf " wiped and partitioned according to your other\n"
    printf " settings (filesystem, LVM, wipe mode) once install\n"
    printf " begins. Nothing is modified until then.\n\n"
    printf "================================================\n\n"

    if [[ -n "$AG_HW_USB_DEVICE" ]]; then
        printf " Installer USB: %s (excluded)\n\n" \
            "$AG_HW_USB_DEVICE"
    fi
}