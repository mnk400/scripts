#!/bin/bash

# ------------------------------------------------------------------
# Install Script - Adds scripts directory and subdirectories to PATH
# ------------------------------------------------------------------

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Installing Scripts from: $SCRIPTS_DIR"

SHELL_CONFIG=""
if [[ "$SHELL" == *"/zsh"* ]]; then
    SHELL_CONFIG="$HOME/.zshrc"
    echo "Detected zsh shell"
elif [[ "$SHELL" == *"/bash"* ]]; then
    SHELL_CONFIG="$HOME/.bashrc"
    echo "Detected bash shell"
else
    echo "Unsupported shell: $SHELL"
    echo "Please manually add the Scripts directories to your shell configuration file manually."
    exit 1
fi

# Remove any existing Scripts PATH entries
if grep -q "# BEGIN SCRIPTS PATH" "$SHELL_CONFIG" 2>/dev/null; then
    sed -i.bak '/# BEGIN SCRIPTS PATH/,/# END SCRIPTS PATH/d' "$SHELL_CONFIG"
    echo "Removed existing Scripts PATH entries"
fi

echo "" >> "$SHELL_CONFIG"
echo "# BEGIN SCRIPTS PATH - Automatically generated" >> "$SHELL_CONFIG"
echo "# Main Scripts directory" >> "$SHELL_CONFIG"
echo "export PATH=\"$SCRIPTS_DIR:\$PATH\"" >> "$SHELL_CONFIG"

# Find all subdirectories (excluding hidden directories) to add them to PATH
echo "Adding subdirectories to PATH:"
find "$SCRIPTS_DIR" -type d -not -path "*/\.*" | while read -r dir; do
    if [ "$dir" != "$SCRIPTS_DIR" ]; then
        rel_dir=${dir#$SCRIPTS_DIR/}
        echo "  - $rel_dir"
        echo "# Scripts subdirectory: $rel_dir" >> "$SHELL_CONFIG"
        echo "export PATH=\"$dir:\$PATH\"" >> "$SHELL_CONFIG"
    fi
done
echo "# END SCRIPTS PATH" >> "$SHELL_CONFIG"
echo "Added Scripts directories to PATH in $SHELL_CONFIG"

find "$SCRIPTS_DIR" -type f -name "*.sh" -exec chmod +x {} \;

echo "Made all script files executable"
echo "Installation complete"
