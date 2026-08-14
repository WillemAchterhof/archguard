#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — GPU Package Selection
# ==============================================================================
#
#  Maps already-detected hardware vendors (from precheck) to the
#  pacstrap package names needed for graphics support.
#  The function only echoes package names. It does not detect
#  hardware itself and does not install anything.
#
#  Requires:
#    - AG_HW_GPU_VENDOR (from lib/core/precheck/gpu.sh)
#
#  Does NOT:
#    - Detect hardware (see lib/core/precheck/)
#    - Touch /mnt or install anything (see install_base in base.sh)
# ==============================================================================

get_gpu_pkg()
{
    case "${AG_HW_GPU_VENDOR:-unknown}" in
        amd)
            echo \
                "mesa \
                vulkan-radeon \
                libva-mesa-driver \
                lib32-mesa \
                lib32-vulkan-radeon"
            ;;
        intel)
            echo \
                "mesa \
                vulkan-intel \
                intel-media-driver \
                lib32-mesa \
                lib32-vulkan-intel"
            ;;
        nvidia)
            log "[!] NVIDIA GPU detected."
            log "[!] NVIDIA support is not yet implemented."
            echo "mesa"
            ;;
        *)
            log "[!] Unknown GPU vendor: ${AG_HW_GPU_VENDOR:-unknown}"
            echo "mesa"
            ;;
    esac
