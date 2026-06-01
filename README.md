# pzget

A fast, keyboard-driven app & webapp installer for Arch Linux — omarchy-style.

A single graphical menu (via [fuzzel](https://codeberg.org/dnkl/fuzzel)) that lets
you install from a **curated catalog** of your favourite apps, fall back to a
**universal search** across the official repos and the AUR, or spin up a
**Chromium web app** from any URL in seconds.

Built for [caelestia](https://github.com/caelestia-dots) / Hyprland, but works on
any Arch setup with `fuzzel`, `fzf` and `yay`.

## Features

- **Curated catalog** — your hand-picked apps grouped by category, defined in a
  simple `catalog.toml`. Installed items are marked with a check.
- **Universal search** — type to search official repos **and** the AUR live,
  with package info preview. Tab to multi-select, Enter to install.
- **Webapps** — turn any URL into a desktop app (`chromium --app`) with an
  auto-fetched favicon and a proper `.desktop` entry.

## Requirements

- `fuzzel` — the graphical menu
- `fzf` — universal search UI
- `yay` (or another AUR helper exposing `-Ssq`/`-Sii`) — repo + AUR
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
bind = SUPER, A, exec, pzget
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
| `pzget-search` | Bash — live repo + AUR search via `fzf` |
| `pzget-webapp-add` | Bash — creates a webapp `.desktop` + icon |

## License

MIT © Polarzero Dev / Daf3r
