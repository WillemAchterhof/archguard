#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Precheck Entry Point
# ==============================================================================
#  lib/core/precheck/run.sh
#
#  Runs hardware detection in sequence and locks the results.
#
#  Requires:
#    - detect_* functions (loaded by module.sh from this same directory)
#
#  Does NOT:
#    - Load its own dependencies (module.sh handles that)
#    - Validate or use the detected values (validate.sh / install.sh do)
# ==============================================================================

run_precheck()
{
    detect_cpu
    detect_firmware
    detect_gpu
    detect_memory
    detect_swap_recommendations
    detect_storage
    detect_tpm
    lock_hardware

    msg "Hardware detection completed"
}