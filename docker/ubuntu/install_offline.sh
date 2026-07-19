#!/bin/bash
set -e

echo ">>> Starting Offline Installation..."

# 1. Parse arguments
TARGET_USER=""
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -u|--user) TARGET_USER="$2"; shift ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

# 2. Auto-detect target user
if [ -z "$TARGET_USER" ]; then
    if [ -n "$SUDO_USER" ]; then
        TARGET_USER="$SUDO_USER"
        echo ">>> Auto-detected target user from sudo context: $TARGET_USER"
    else
        TARGET_USER="$(id -un)"
        echo ">>> Auto-detected target user from current session: $TARGET_USER"
    fi
fi

# Validate target user
if ! id "$TARGET_USER" >/dev/null 2>&1; then
    echo "Error: Target user '$TARGET_USER' does not exist."
    exit 1
fi

TARGET_HOME=$(getent passwd "$TARGET_USER" | cut -d: -f6)
if [ -z "$TARGET_HOME" ] || [ ! -d "$TARGET_HOME" ]; then
    echo "Error: Home directory for user '$TARGET_USER' not found at '$TARGET_HOME'."
    exit 1
fi

# Ensure running as root/sudo
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This script must be run as root or with sudo."
    exit 1
fi

echo ">>> Installing for user: $TARGET_USER (home: $TARGET_HOME)"

# 3. Install system packages (.debs)
echo ">>> Installing system packages (.debs)..."
if ls debs/*.deb >/dev/null 2>&1; then
    dpkg -i debs/*.deb
else
    echo "No .deb files found in debs/ directory."
fi

# 4. Install Neovim
echo ">>> Installing Neovim..."
if [ -f nvim-linux64.tar.gz ]; then
    tar -C /usr/local -xzf nvim-linux64.tar.gz --strip-components=1
else
    echo "Warning: nvim-linux64.tar.gz not found, skipping Neovim extraction."
fi

# 5. Extract home snapshot with correct ownership
echo ">>> Extracting home snapshot to $TARGET_HOME..."
tar -xzf home_snapshot.tar.gz -C "$TARGET_HOME" \
    --owner="$TARGET_USER" \
    --group="$(id -gn "$TARGET_USER")"

# 6. Setup chezmoi binary
echo ">>> Setting up chezmoi..."
mkdir -p "$TARGET_HOME/bin"
cp chezmoi "$TARGET_HOME/bin/"
chown "$TARGET_USER:$(id -gn "$TARGET_USER")" "$TARGET_HOME/bin/chezmoi"
chmod +x "$TARGET_HOME/bin/chezmoi"

# 7. Run chezmoi apply in offline mode as target user
echo ">>> Applying dotfiles for $TARGET_USER..."
sudo -u "$TARGET_USER" -i "$TARGET_HOME/bin/chezmoi" apply \
    --source "$TARGET_HOME/xProfile" \
    --override-data '{"is_offline": true}'

echo ">>> Offline Installation Complete!"
