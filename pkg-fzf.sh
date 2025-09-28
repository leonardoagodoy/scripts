#!/usr/bin/env bash

# Check if paru is installed
if ! command -v paru &>/dev/null; then
  echo "Error: 'paru' is not installed. Install it first."
  exit 1
fi

# Interactive selection with preview
selected=$(paru -Qq | fzf \
  --preview 'paru -Qi {}' \
  --preview-window=right:60% \
  --border \
  --prompt="🔍 Packages > ")

# Exit if nothing was selected
[[ -z "$selected" ]] && exit 0

# Action menu
echo -e "\n📦 Selected package: $selected"
echo "[1] Show information"
echo "[2] Remove"
echo "[3] Reinstall"
echo -n "Choose an action: "
read -r action

case $action in
  1) paru -Qi "$selected" ;;
  2) sudo pacman -Rns "$selected" ;;
  3) paru -S "$selected" ;;
  *) echo "Invalid action." ;;
esac

