#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Required Field Validation
# ==============================================================================
#  lib/validate/required.sh
#
#  Presence-only checks for the plain AG_P_* fields the wipe/partition/
#  format stage needs: disk, EFI size, root filesystem, wipe mode,
#  LUKS key method. Looped instead of one function per field, since
#  the check is identical for all five — only the variable name
#  differs.
#
#  Not part of this loop, each for its own reason:
#    - AG_P_SWAP_*  — empty is a legitimate deliberate state ("no
#                     swap"), not just "not yet set" (see validate_optional.sh)
#    - btrfs volumes — only applies when AG_P_ROOT_FS is "btrfs"
#                     (see validate_volumes)
#
#  Note: this only confirms a LUKS method was chosen. Actually
#  resolving the passphrase happens once, at the end of run_validation,
#  after every other check has passed (see validate_luks.sh).
#
#  Requires:
#    - fail_check (lib/core/logging/checks.sh)
#
#  Sets:
#    - AG_V_DISK, AG_V_EFI, AG_V_FILESYSTEM, AG_V_WIPE, AG_V_LUKS
#      ("0" valid, "1" invalid)
#
#  Does NOT:
#    - Touch any AG_P_* value
#    - Check swap or btrfs volumes
#    - Resolve the LUKS passphrase
#
#  Returns:
#    - 0 if every field is set
#    - 1 if one or more are missing
# ==============================================================================

validate_required_fields()
{
    local -a fields=(AG_P_DISK           AG_P_EFI_SIZE      AG_P_ROOT_FS         AG_P_DISK_WIPE_MODE  AG_P_LUKS)
    local -a flags=(AG_V_DISK            AG_V_EFI           AG_V_FILESYSTEM      AG_V_WIPE             AG_V_LUKS)
    local -a labels=("Disk not selected" "EFI size not set" "Filesystem not set" "Wipe mode not set"   "LUKS key method not set")

    local i field flag failed=0

    for i in "${!fields[@]}"; do
        field="${fields[$i]}"
        flag="${flags[$i]}"

        if [[ -n "${!field:-}" ]]; then
            printf -v "$flag" "0"
        else
            printf -v "$flag" "1"
            fail_check "${labels[$i]}"
            failed=1
        fi
    done

    return "$failed"
}
