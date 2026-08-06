#!/usr/bin/env bash

# ==============================================================================
#  Arch Secure Installer V2.6 — Storage Detection
# ==============================================================================
#  lib/core/precheck/storage.sh
#
#  Detects storage devices available to the installer.
#
#  Responsibilities:
#    - Detect available disks
#    - Detect installer USB device
#
#  Populates:
#    - AG_HW_DISKS
#    - AG_HW_USB_DEVICE
#
#  Does NOT:
#    - Partition disks
#    - Modify storage devices
#    - Mount filesystems
# ==============================================================================

# ------------------------------------------------------------------------------
# Disks
# ------------------------------------------------------------------------------

detect_disks()
{
    local disks=()

    while read -r name type; do
        [[ "$type" == "disk" ]] || continue
        [[ "$name" =~ ^(loop|sr) ]] && continue

        disks+=("/dev/$name")

    done < <(
        lsblk -dn -o NAME,TYPE 2>/dev/null
    )

    AG_HW_DISKS=$(IFS=,; printf "%s" "${disks[*]:-none}")
}

# ------------------------------------------------------------------------------
# Installer media
# ------------------------------------------------------------------------------

detect_usb_device()
{
    local dev
    local label
    local type
    local parent

    while read -r dev label type; do
        [[ "$label" == ARCH* ]] || continue
        [[ "$type" == "iso9660" ]] || continue

        parent=$(lsblk -no PKNAME "$dev" 2>/dev/null || true)

        [[ -n "$parent" ]] || continue

        AG_HW_USB_DEVICE="/dev/$parent"
        return
    done < <(
        blkid -o export | awk '
        /^$/        { dev=""; label=""; type="" }
        /^DEVNAME=/ { dev=$0; sub("DEVNAME=","",dev) }
        /^LABEL=/   { label=$0; sub("LABEL=","",label) }
        /^TYPE=/    { type=$0; sub("TYPE=","",type); print dev, label, type }
        '
    )

    AG_HW_USB_DEVICE=""
}

detect_storage(){
    detect_disks
    detect_usb_device
}