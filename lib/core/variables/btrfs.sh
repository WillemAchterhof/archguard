#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Btrfs Volume Defaults
# ==============================================================================
#  lib/core/variables/btrfs.sh
#
#  Default btrfs volume configuration, held in memory until the user
#  saves the profile (see profile_save).
#
#  Does NOT:
#    - Create btrfs volumes
#    - Persist to disk
# ==============================================================================

AG_BTRFS_LAYOUT="Standard"
AG_BTRFS_COMPRESSION="zstd"
AG_BTRFS_SNAPSHOTS="Enabled"
AG_BTRFS_COW="Enabled"
AG_BTRFS_SUBVOLUMES=(@ @home @log @pkg @snapshots)