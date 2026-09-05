#!/usr/bin/env bash
# ==============================================================================
#  Arch Secure Installer V2.6 — Postboot Runner
# ==============================================================================
#  lib/postboot/install/run.sh
#
#  Loads all postboot components recursively and executes the final actions.
# ==============================================================================

set -Eeuo pipefail

POSTBOOT_ROOT="/opt/archguard"

# ==============================================================================
#  LOAD ALL POSTBOOT COMPONENTS
# ==============================================================================

while IFS= read -r -d '' file; do
    [[ "$file" == "$POSTBOOT_ROOT/run.sh" ]] && continue

    source "$file"
done < <(
    find "$POSTBOOT_ROOT" \
        -type f \
        -name '*.sh' \
        -print0
)

# ==============================================================================
#  TPM ENROLLMENT
# ==============================================================================

enroll_tpm
verify_tpm

# ==============================================================================
#  CLEANUP
# ==============================================================================

clean_postboot