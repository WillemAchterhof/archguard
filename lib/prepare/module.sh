#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Prepare Module
# ==============================================================================
#  lib/prepare/module.sh
#
#  Loads all prepare-stage components, at any depth
#  (storage/disk, storage/swap, system/*, security/*, etc).
#
#  Responsibilities:
#    - Recursively load every *.sh under this directory
#
#  Does NOT:
#    - Run any prepare logic itself
#    - Source itself
# ==============================================================================

# shopt -s globstar

# for file in "$AG_DIR_PREPARE"/**/*.sh; do
for file in "$AG_DIR_PREPARE/storage/disk/*.sh; do
    [[ -f "$file" ]] || continue
    [[ "$(basename "$file")" == "module.sh" ]] && continue
    source "$file"
done

# shopt -u globstar