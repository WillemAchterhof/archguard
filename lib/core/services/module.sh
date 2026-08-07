#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Services Module
# ==============================================================================
#  lib/core/services/module.sh
#
#  Loads any components local to the services stage itself.
#  Utilities and profile handling are loaded explicitly by run.sh,
#  since they live in their own directories with their own modules.
#
#  Does NOT:
#    - Source itself
# ==============================================================================

for file in "$AG_DIR_SERVICES"/*.sh; do
    [[ -f "$file" ]] || continue
    [[ "$(basename "$file")" == "module.sh" ]] && continue
    source "$file"
done
