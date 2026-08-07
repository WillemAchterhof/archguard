#!/usr/bin/env bash

# ==============================================================================
#  Arch Secure Installer V2.6 — TPM Detection
# ==============================================================================
#  lib/core/precheck/tpm.sh
#
#  Detects Trusted Platform Module (TPM) capabilities.
#
#  Responsibilities:
#    - Detect TPM presence
#    - Detect TPM version
#    - Detect TPM readiness
#
#  Populates:
#    - AG_HW_TPM_PRESENT
#    - AG_HW_TPM_VERSION
#    - AG_HW_TPM_READY
#
#  Does NOT:
#    - Configure TPM
#    - Enroll TPM keys
#    - Modify firmware
# ==============================================================================

# ------------------------------------------------------------------------------
# TPM
# ------------------------------------------------------------------------------

detect_tpm()
{
    [[ -d /sys/class/tpm/tpm0 ]] || return 0

    AG_HW_TPM_PRESENT="yes"

    if ! command -v tpm2_getcap >/dev/null; then
        AG_HW_TPM_VERSION="unknown"
        return 0
    fi

    AG_HW_TPM_VERSION="2.0"

    if tpm2_getcap properties-fixed >/dev/null 2>&1; then
        AG_HW_TPM_READY="yes"
    fi
}