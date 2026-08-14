#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Base System Install
# ==============================================================================
#  lib/install/base/detect_cpu-gpu.sh
#
#  Requires:
#    - /mnt already mounted (see lib/install/disk/mount.sh)
#
#  Does NOT:
#    - Configure anything inside the new root (see chroot stage, later)
#    - Generate fstab (see fstab.sh)
# ==============================================================================

detect_ucode()
{
    local vendor
    vendor=$(grep -m1 'vendor_id' /proc/cpuinfo | awk '{print $3}' | tr '[:upper:]' '[:lower:]')

    case "$vendor" in
        genuineintel) echo "intel-ucode" ;;
        authenticamd) echo "amd-ucode"   ;;
        *)
            log "[!] Unknown CPU vendor: $vendor — skipping microcode"
            echo ""
            ;;
    esac
}

detect_gpu_packages()
{
    case "${AG_HW_GPU_VENDOR:-unknown}" in
        amd)
            echo "vulkan-radeon libva-mesa-driver"
            ;;
        intel)
            echo "vulkan-intel intel-media-driver"
            ;;
        nvidia)
            log "[!] NVIDIA GPU detected — proprietary driver setup is not supported by this installer yet."
            log "[!] See the Arch Wiki for manual setup: <TODO: URL>"
            echo ""
            ;;
        *)
            log "[!] Unknown/unsupported GPU vendor: ${AG_HW_GPU_VENDOR:-unknown} — mesa only (software rendering)"
            echo ""
            ;;
    esac
}
