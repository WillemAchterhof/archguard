#!/usr/bin/env bash

# ==============================================================================
#  Arch Secure Installer V2.6 — Firmware Detection
# ==============================================================================
#  lib/core/precheck/firmware.sh
#
#  Detects firmware-related hardware state.
#
#  Responsibilities:
#    - Detect boot mode
#    - Detect Secure Boot availability
#    - Detect Secure Boot state
#    - Detect Setup Mode
#
#  Populates:
#    - AG_HW_BOOT_MODE
#    - AG_HW_SB_AVAILABLE
#    - AG_HW_SB_ENABLED       (true | false | undetected)
#    - AG_HW_SB_SETUP_MODE    (true | false | undetected)
#
#  "undetected" means the EFI variable could not be read. The Secure
#  Boot setter menu is responsible for prompting the user to confirm
#  the actual state manually when this occurs — this file only ever
#  reports what it observed, never guesses.
#
#  Does NOT:
#    - Modify firmware
#    - Enable Secure Boot
#    - Change UEFI variables
#    - Prompt the user
# ==============================================================================

# ------------------------------------------------------------------------------
# Boot mode
# ------------------------------------------------------------------------------

detect_boot_mode()
{
    if [[ -d /sys/firmware/efi ]]; then
        AG_HW_BOOT_MODE="uefi"
    else
        AG_HW_BOOT_MODE="bios"
    fi
}

# ------------------------------------------------------------------------------
# Secure Boot
# ------------------------------------------------------------------------------

detect_secureboot_state()
{
    [[ "$AG_HW_BOOT_MODE" == "uefi" ]] || return 0

    local sb_file=""
    local sm_file=""
    local value

    for sb_file in /sys/firmware/efi/efivars/SecureBoot-*; do
        [[ -e "$sb_file" ]] && break
        sb_file=""
    done

    for sm_file in /sys/firmware/efi/efivars/SetupMode-*; do
        [[ -e "$sm_file" ]] && break
        sm_file=""
    done

    if [[ -n "$sb_file" ]]; then
    AG_HW_SB_AVAILABLE="true"

        if value=$(od -An -t u1 -N5 "$sb_file" 2>/dev/null | awk '{print $5}') \
            && [[ -n "$value" ]]; then
            if [[ "$value" == "1" ]]; then
                AG_HW_SB_ENABLED="true"
            else
                AG_HW_SB_ENABLED="false"
            fi
        else
            AG_HW_SB_ENABLED="undetected"
        fi
    fi

    if [[ -n "$sm_file" ]]; then
        if value=$(od -An -t u1 -N5 "$sm_file" 2>/dev/null | awk '{print $5}') \
            && [[ -n "$value" ]]; then
            if [[ "$value" == "1" ]]; then
                AG_HW_SB_SETUP_MODE="true"
            else
                AG_HW_SB_SETUP_MODE="false"
            fi
        else
            AG_HW_SB_SETUP_MODE="undetected"
        fi
    fi
}

set_secureboot_state()
{
    if [[ "$AG_HW_SB_AVAILABLE" != "true" ]]; then
        AG_HW_SB_STATE="unavailable"

    elif [[ "$AG_HW_SB_ENABLED" == "undetected" ]] || [[ "$AG_HW_SB_SETUP_MODE" == "undetected" ]]; then
        AG_HW_SB_STATE="undetected"

    elif [[ "$AG_HW_SB_ENABLED" == "true" ]]; then
        AG_HW_SB_STATE="enabled"

    elif [[ "$AG_HW_SB_SETUP_MODE" == "true" ]]; then
        AG_HW_SB_STATE="setup mode"

    else
        AG_HW_SB_STATE="disabled"
    fi
}

detect_firmware()
{
    detect_boot_mode
    detect_secureboot_state
    set_secureboot_state
}