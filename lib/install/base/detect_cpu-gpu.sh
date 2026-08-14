#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — CPU/GPU Vendor Detection
# ==============================================================================
#  lib/install/base/detect_cpu-gpu.sh
#
#  Maps already-detected hardware vendors (from precheck) to the
#  pacstrap package names needed for microcode and graphics support.
#  Each function only echoes package names — neither one detects
#  hardware itself, and neither installs anything.
#
#  Requires:
#    - AG_HW_CPU_VENDOR (from lib/core/precheck/cpu.sh)
#    - AG_HW_GPU_VENDOR (from lib/core/precheck/gpu.sh)
#
#  Does NOT:
#    - Detect hardware (see lib/core/precheck/)
#    - Touch /mnt or install anything (see install_base in base.sh)
# ==============================================================================

detect_ucode()
{
    case "${AG_HW_CPU_VENDOR:-unknown}" in
        intel) echo "intel-ucode" ;;
        amd)   echo "amd-ucode"   ;;
        *)
            log "[!] Unknown CPU vendor: ${AG_HW_CPU_VENDOR:-unknown} — skipping microcode"
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
