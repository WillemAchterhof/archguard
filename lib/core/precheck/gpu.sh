#!/usr/bin/env bash

# ==============================================================================
#  Arch Secure Installer V2.6 — GPU Detection
# ==============================================================================
#  lib/core/precheck/gpu.sh
#
#  Detects graphics hardware.
#
#  Responsibilities:
#    - Detect GPU vendor
#    - Detect GPU model
#
#  Populates:
#    - AG_HW_GPU_VENDOR
#    - AG_HW_GPU_MODEL
#
#  Does NOT:
#    - Install GPU drivers
#    - Configure graphics
#    - Modify hardware
# ==============================================================================

# ------------------------------------------------------------------------------
# GPU
# ------------------------------------------------------------------------------

detect_gpu()
{
    local gpu

    command -v lspci >/dev/null || return 0

    gpu=$(
        lspci |
        grep -Ei 'vga|3d|display' |
        head -n1 ||
        true
    )

    [[ -n "$gpu" ]] || return 0

    case "$gpu" in
        *NVIDIA*)
            AG_HW_GPU_VENDOR="nvidia"
            ;;
        *AMD*|*ATI*|*Radeon*)
            AG_HW_GPU_VENDOR="amd"
            ;;
        *Intel*)
            AG_HW_GPU_VENDOR="intel"
            ;;
        *QXL*)
            AG_HW_GPU_VENDOR="qxl"
            ;;
        *VirtIO*|*Virtio*|*Red\ Hat*)
            AG_HW_GPU_VENDOR="virtio"
            ;;
        *VMware*)
            AG_HW_GPU_VENDOR="vmware"
            ;;
        *InnoTek*|*VirtualBox*)
            AG_HW_GPU_VENDOR="vbox"
            ;;
        *Microsoft*|*Hyper-V*)
            AG_HW_GPU_VENDOR="hyperv"
            ;;
        *Bochs*)
            AG_HW_GPU_VENDOR="bochs"
            ;;
        *)
            AG_HW_GPU_VENDOR="unknown"
            ;;
    esac

    AG_HW_GPU_MODEL=$(
        printf "%s\n" "$gpu" |
        sed -E 's/^.*(VGA compatible controller|3D controller|Display controller):[[:space:]]*//'
    )
}