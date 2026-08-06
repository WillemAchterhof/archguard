#!/usr/bin/env bash
set -Eeuo pipefail

# ==============================================================================
#  Arch Secure Installer V2.6
# ==============================================================================
#  Bootstrap entry point for the Arch Secure Installer.
#
#  This script prepares the minimal environment required to start the full
#  installer. Its responsibility is intentionally limited to bootstrap tasks.
#
#  After successful preparation, control is handed off to: sa_main.sh
#
#  The bootstrap script remains intentionally small and self-contained.
#  All actual installation logic lives inside the cloned installer repository.

# ==============================================================================
# Initialization
# ==============================================================================

check_root(){
   [[ $EUID -eq 0 ]] || fatal "Must be run as root. Use: sudo bash sa_install.sh"
}

init_variables(){
    readonly SA_REPO_URL="https://github.com/WillemAchterhof/archguar.git"
    readonly SA_REPO_BRANCH="main"

    readonly SA_DIR_BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    readonly SA_DIR_INSTALL="$SA_DIR_BASE/sa_install"
    readonly SA_DIR_STATE="$SA_DIR_BASE/sa_state"
	
	readonly SA_DIR_LOG="$SA_DIR_STATE/log"
	readonly SA_DIR_CONFIG="$SA_DIR_STATE/config"

    SA_FILE_LOG="$SA_DIR_LOG/install.log"
    SA_FILE_WIFI="$SA_DIR_CONFIG/wifi.env"
	
	SA_WIFI_DEVICE=""
	SA_WIFI_SSID=""
	SAS_WIFI_PASSWORD=""
}

init_state(){
    local dir

    for dir in \
        "$SA_DIR_STATE" \
        "$SA_DIR_LOG" \
        "$SA_DIR_CONFIG"
    do
        [[ -d "$dir" ]] || mkdir -p "$dir"

        if [[ ! -w "$dir" ]]; then
            chmod u+w "$dir" 2>/dev/null || true
        fi

        [[ -w "$dir" ]] \
            || fatal "Directory not writable: $dir"
    done

    : > "$SA_FILE_LOG"
}

# --------------
initialization(){
	init_variables
  check_root
	init_state
}

# ==============================================================================
# Error Handling
# ==============================================================================

trap_err(){
    local exit_code=$?

    local command="${BASH_COMMAND:-unknown}"
    local line="${BASH_LINENO[0]}"
    local file="${BASH_SOURCE[1]:-unknown}"

    local message="[FATAL]
File    : $file:$line
Command : $command
Exit    : $exit_code"

    printf "%s\n" "$message"

    [[ -n "${SA_FILE_LOG:-}" ]] &&
        printf "%s\n" "$message" >> "$SA_FILE_LOG"

    exit "$exit_code"
}

trap 'trap_err' ERR

# ==============================================================================
# Logging
# ==============================================================================

log(){
    printf " %s\n" "$1"
    printf " %s\n" "$1" >> "$SA_FILE_LOG"
}

log_silent(){
    printf " %s\n" "$1" >> "$SA_FILE_LOG"
}

msg(){
    log "[*] $1"
}

fatal(){
    log "[FATAL] $1"
    exit 1
}

log_header(){
    log_silent "================================================================================"
    log_silent "$1"
    log_silent " $(date '+%Y-%m-%d %H:%M:%S')"
    log_silent "================================================================================"
}

log_variables(){
    log_silent "VARIABLES"

    while IFS= read -r var; do
        [[ "$var" == SAS_* ]] && continue
        log_silent "$(printf " %-20s = %q" "$var" "${!var}")"
    done < <(compgen -A variable SA_)

    log_silent "================================================================================"
}

logging_setup(){
    log_header "BOOTSTRAP"
    log_variables
}

# ==============================================================================
# Network Connection
# ==============================================================================

check_internet(){
    timeout 5 ping -c 1 -W 2 1.1.1.1 >/dev/null 2>&1
}

wifi_show(){
    SA_WIFI_DEVICE="$(iwctl device list | awk '/station/ {print $2; exit}')"

    [[ -n "$SA_WIFI_DEVICE" ]] \
        || fatal "No wireless adapter found."

    msg "Scanning for wireless networks..."

    iwctl station "$SA_WIFI_DEVICE" scan
    sleep 2

    printf "\nAvailable wireless networks:\n\n"

    iwctl station "$SA_WIFI_DEVICE" get-networks |
        tail -n +5 |
        sed 's/^[>* ]*//'

    printf "\n"
}

wifi_select(){
    printf "SSID: "
    read -r SA_WIFI_SSID
}

wifi_password(){
    printf "\nPassword: "
    read -rs SAS_WIFI_PASSWORD
    printf "\n"
}

wifi_attempt(){
    iwctl station "$SA_WIFI_DEVICE" connect \
        "$SA_WIFI_SSID" \
        --passphrase "$SAS_WIFI_PASSWORD"
}

wifi_connect(){
    while ! check_internet; do

        wifi_select
        wifi_password

        if wifi_attempt; then
            sleep 3
        fi

        if check_internet; then
            break
        fi

        printf "\nUnable to connect. Please try again.\n\n"

    done

    printf "\nConnected.\n\n"
}

wifi_save(){
    cat > "$SA_FILE_WIFI" <<EOF
SA_WIFI_SSID=$(printf '%q' "$SA_WIFI_SSID")
SAS_WIFI_PASSWORD=$(printf '%q' "$SAS_WIFI_PASSWORD")
EOF

    chmod 600 "$SA_FILE_WIFI"
    
    unset SAS_WIFI_PASSWORD
}

# ------------------
network_connection(){
    check_internet && return
    wifi_show
	wifi_connect
    wifi_save
}

# ==============================================================================
# Packages Check
# ==============================================================================

package_check(){

	SA_INSTALL_PACKAGES=()	
	readonly SA_PACKAGES_BOOTSTRAP=(
		git
		curl
	)
	
    local package

    for package in "${SA_PACKAGES_BOOTSTRAP[@]}"; do

        if command -v "$package" >/dev/null 2>&1; then
            log "[installed] $package"
        else
            SA_INSTALL_PACKAGES+=("$package")
        fi

    done
}

package_install(){
    [[ ${#SA_INSTALL_PACKAGES[@]} -eq 0 ]] && return

    msg "Installing required bootstrap packages..."

    pacman -Sy --noconfirm --needed \
        "${SA_INSTALL_PACKAGES[@]}" \
        || fatal "Failed to install required packages."
}

# --------------
packages_check(){
	package_check
	package_install
}

# ==============================================================================
# Repository
# ==============================================================================

check_install_dir(){
    local base
	local install

    base="$(realpath "$SA_DIR_BASE")"
    install="$(realpath -m "$SA_DIR_INSTALL")"

    [[ "$install" == "$base" ]] \
        && fatal "SA_DIR_INSTALL must not be the base dir itself: $install"

    [[ "$install" == "$base/"* ]] \
        || fatal "SA_DIR_INSTALL is outside base dir, refusing to remove: $install"
}

repository_remove(){
    check_install_dir

    if [[ -d "$SA_DIR_INSTALL" ]]; then
        rm -rf -- "$SA_DIR_INSTALL" \
            || fatal "Failed to remove previous installer."

        msg "Previous repository removed."
    else
        msg "No previous repository detected."
    fi
}

repository_clone(){
    msg "Downloading installer..."

    git clone \
        --branch "$SA_REPO_BRANCH" \
        --depth 1 \
        "$SA_REPO_URL" \
        "$SA_DIR_INSTALL" \
        || fatal "Failed to clone repository."
}

# ---------------
repository_sync(){
    repository_remove
    repository_clone
	
	rm -f "$SA_DIR_INSTALL/sa_install.sh"
}

# ------
handoff(){
    [[ -f "$SA_DIR_INSTALL/sa_main.sh" ]] \
        || fatal "Installer entry point not found."

    msg "Starting installer..."

    exec bash "$SA_DIR_INSTALL/sa_main.sh"
}

# ==============================================================================
# MAIN
# ==============================================================================

main(){
  initialization
	logging_setup
	network_connection
	packages_check
	repository_sync
	handoff
}

main
