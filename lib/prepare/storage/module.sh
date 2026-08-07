run_prepare_storage()
{
    source "$AG_DIR_PREPARE/disk/module.sh" \
        || fatal "Failed loading disks mdoule."

    source "$AG_DIR_PREPARE/efi/module.sh" \
        || fatal "Failed loading efi module."

    source "$AG_DIR_PREPARE/filesystem/module.sh" \
        || fatal "Failed loading filesystem module."

    source "$AG_DIR_PREPARE/swap/module.sh" \
        || fatal "Failed loading swap modul."

    msg "Storage modules loaded"
}