# pzget

A fast, keyboard-driven app & webapp installer for Arch Linux — omarchy-style.

A single graphical menu (via [fuzzel](https://codeberg.org/dnkl/fuzzel)) that lets
you install apps from a **curated catalog** — or spin up a **Chromium web app**
from any URL in seconds. No package hunting: the catalog is the list, installs
run fully unattended (omarchy-style).

Built for [caelestia](https://github.com/caelestia-dots) / Hyprland, but works on
any Arch setup with `fuzzel` and `yay`.

## Features

- **Organised by source** — the main menu is the sources themselves: 📦 Arch
  (official repos), 📥 AUR, 🌐 web apps. You always know where each app comes
  from. The catalog lives in a simple `catalog.toml`; installed items show a check.
- **Curated list + full search** — inside 📦 Arch / 📥 AUR you get your favourite
  apps first, plus a “🔎 Buscar cualquier paquete…” entry that opens an
  omarchy-style `fzf` picker over *every* package in that source.
- **Unattended installs** — pacman/AUR packages install with no prompts at all
  (no cleanBuild/diff menus); only your sudo password is asked once.
- **Webapps** — turn any URL into a desktop app (`chromium --app`) with a
  high-quality auto-fetched icon (unavatar/clearbit) and a proper `.desktop`.
- **Uninstall** — “🗑️ Eliminar app” opens an `fzf` picker of explicitly-installed
  packages and removes the chosen ones with `pacman -Rns`.

## Requirements

- `fuzzel` — the graphical menu
- `fzf` — the “search any package” picker inside Arch/AUR
- `yay` — installs from official repos and the AUR
- `python3` (3.11+) — reads the TOML catalog (`tomllib`)
- A chromium-family browser (`chromium`, `brave`, …) — for webapps
- A terminal: `kitty`, `foot`, or any `xdg-terminal-exec` provider

## Install

```sh
git clone https://github.com/Daf3r/pzget ~/.local/share/pzget
~/.local/share/pzget/install.sh
```

`install.sh` symlinks the binaries into `~/.local/bin` (make sure that's on your
`PATH`). Then bind `pzget` to a key in Hyprland, e.g.:

```ini
bind = SUPER, I, exec, pzget
```

## Configuring the catalog

Edit `catalog.toml` (or copy it to `~/.config/pzget/catalog.toml` to override
without touching the repo):

```toml
[[categories]]
id = "dev"
name = "Development"

  [[categories.apps]]
  name = "Neovim"
  source = "repo"        # repo | aur | webapp
  pkg = "neovim"         # package name (repo/aur)
  desc = "Vim-based editor"

  [[categories.apps]]
  name = "YouTube"
  source = "webapp"
  url = "https://youtube.com"
```

Webapps you add from the menu are stored separately in
`~/.config/pzget/webapps.toml` and shown under **My Webapps** — you never have to
hand-edit those.

## Components

| Binary | Role |
|--------|------|
| `pzget` | Bash orchestrator — the fuzzel menu and router |
| `pzget-catalog` | Python — the only piece that parses TOML; emits menu lines |
| `pzget-pkg-pick` | Bash — omarchy-style `fzf` package picker, scoped to one source |
| `pzget-pkg-remove` | Bash — `fzf` uninstaller for installed packages |
| `pzget-webapp-add` | Bash — creates a webapp `.desktop` + icon |

## License

MIT © Polarzero Dev / Daf3r
