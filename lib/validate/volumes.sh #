#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Btrfs Volume Validation
# ==============================================================================
#  lib/validate/volumes.sh
#
#  Confirms AG_BTRFS_SUBVOLUMES is non-empty and has no blank entries.
#  Only applies when AG_P_ROOT_FS is "btrfs" — for ext4 this is a
#  no-op pass. AG_BTRFS_SUBVOLUMES is free-editable via prepare_btrfs's
#  nano/vim option, which only checks for a syntax error on reload —
#  not for an empty or blank-entry list, which is what this catches.
#
#  Requires:
#    - fail_check (lib/core/logging/checks.sh)
#
#  Sets:
#    - AG_V_VOLUMES ("0" valid, "1" invalid)
#
#  Does NOT:
#    - Touch AG_BTRFS_SUBVOLUMES
#    - Run any check when AG_P_ROOT_FS is not "btrfs"
#
#  Returns:
#    - 0 if not btrfs, or btrfs with a clean subvolume list
#    - 1 if btrfs with an empty or blank-entry subvolume list
# ==============================================================================

validate_volumes()
{
    if [[ "${AG_P_ROOT_FS:-}" != "btrfs" ]]; then
        AG_V_VOLUMES="0"
        return 0
    fi

    if [[ "${#AG_BTRFS_SUBVOLUMES[@]}" -eq 0 ]]; then
        AG_V_VOLUMES="1"
        fail_check "Btrfs has no subvolumes configured"
        return 1
    fi

    local sv
    for sv in "${AG_BTRFS_SUBVOLUMES[@]}"; do
        if [[ -z "$sv" ]]; then
            AG_V_VOLUMES="1"
            fail_check "Btrfs subvolume list has a blank entry"
            return 1
        fi
    done

    AG_V_VOLUMES="0"
    return 0
}
