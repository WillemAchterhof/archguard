#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Install Module
# ==============================================================================
#  lib/install/module.sh
#
#  Loads all install-stage components, at any depth (disk/, and later
#  pacstrap/, chroot/, etc).
# ==============================================================================

shopt -s globstar

for file in "$AG_DIR_INSTALLER"/**/*.sh; do
    [[ -f "$file" ]] || continue
    [[ "$(basename "$file")" == "module.sh" ]] && continue
    source "$file"
done

shopt -u globstar