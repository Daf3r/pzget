#!/usr/bin/env bash
# Symlink pzget binaries into ~/.local/bin (must be on your PATH).
set -euo pipefail

SRC="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)/bin"
DEST="${XDG_BIN_HOME:-$HOME/.local/bin}"
mkdir -p "$DEST"

for f in "$SRC"/*; do
  name="$(basename "$f")"
  ln -sf "$f" "$DEST/$name"
  echo "linked $DEST/$name"
done

case ":$PATH:" in
  *":$DEST:"*) ;;
  *) echo; echo "⚠  $DEST is not on your PATH — add it to your shell config." ;;
esac

echo
echo "Done. Run 'pzget' or bind it to a key in Hyprland:"
echo "  bind = SUPER, A, exec, pzget"
