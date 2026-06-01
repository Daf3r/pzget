#!/usr/bin/env bash
# Symlink pzget binaries into ~/.local/bin (must be on your PATH).
set -euo pipefail

SRC="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)/bin"
DEST="${XDG_BIN_HOME:-$HOME/.local/bin}"
mkdir -p "$DEST"

for f in "$SRC"/*; do
  [[ -f "$f" && -x "$f" ]] || continue   # skip __pycache__ and non-executables
  name="$(basename "$f")"
  ln -sf "$f" "$DEST/$name"
  echo "linked $DEST/$name"
done

# Choose the UI language (stored in ~/.config/pzget/lang).
mkdir -p "$HOME/.config/pzget"
current="$(cat "$HOME/.config/pzget/lang" 2>/dev/null || true)"
echo
echo "Language / Idioma:"
echo "  1) English"
echo "  2) Español"
read -rp "> [${current:-2}] " ans || ans=""
case "$ans" in
  1|en|EN|english|English)            lang=en ;;
  2|es|ES|espanol|español|Español)    lang=es ;;
  "")                                  lang="${current:-es}" ;;
  *)                                   lang="${current:-es}" ;;
esac
echo "$lang" > "$HOME/.config/pzget/lang"
echo "language / idioma: $lang"

case ":$PATH:" in
  *":$DEST:"*) ;;
  *) echo; echo "⚠  $DEST is not on your PATH — add it to your shell config." ;;
esac

echo
echo "Done. Run 'pzget' or bind it to a key in Hyprland:"
echo "  bind = SUPER, I, exec, pzget"
echo "Change language anytime: edit ~/.config/pzget/lang (en|es) or re-run this script."
