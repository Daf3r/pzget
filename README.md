# pzget

[![Release](https://img.shields.io/github/v/release/Daf3r/pzget?style=flat-square&color=1793d1)](https://github.com/Daf3r/pzget/releases)
[![License](https://img.shields.io/github/license/Daf3r/pzget?style=flat-square&color=1793d1)](LICENSE)
![Arch Linux](https://img.shields.io/badge/Arch-repos%20%2B%20AUR-1793d1?style=flat-square)
![Hyprland](https://img.shields.io/badge/Hyprland-fuzzel-1793d1?style=flat-square)

A fast, keyboard-driven app & web-app installer for Arch Linux — omarchy-style,
built for [caelestia](https://github.com/caelestia-dots) / Hyprland.

One graphical menu (via [fuzzel](https://codeberg.org/dnkl/fuzzel)) organised by
**source** — official repos, the AUR, and web apps. Install from a curated
catalog, search the full repos/AUR when you need something else, turn any URL
into a desktop web app, or uninstall things — all without leaving the keyboard.
Installs run **fully unattended** (no confirmation or build menus).

> The menu UI is available in **English or Spanish**, chosen at install time
> (stored in `~/.config/pzget/lang`). Code, config keys and this README are in English.

> **Demo GIF goes here.**

## The menu

```
  pzget »

  📦  Arch (oficial)   programas del repositorio oficial
  📥  AUR              programas de la comunidad
  🌐  Apps web         YouTube, ChatGPT…
  ➕  Crear app web    convierte un sitio web en app
  🗑️  Eliminar app     desinstala programas o webapps
```

Picking a package source drops you straight into an `fzf` picker over
*everything* in it, with your curated favourites merged at the top (`*`) and
installed packages checked:

```
  > reproductor
  ┌───────────────────────────────────────────────────────────┐
  │ * ✓ mpv          a free, open source, and cross-platform… │
  │ *   vlc          multi-platform MPEG, DVD, and DivX player│
  │     audacious    lightweight, advanced audio player       │
  └───────────────────────────────────────────────────────────┘
```

## Search by what a package does

Typing `reproductor` finds `mpv`. That is the point of the whole thing.

Arch package descriptions are English-only, so a Spanish speaker searching their
own language finds nothing — and a name-only picker means you can only find a
package if you already know what it's called. pzget fixes both:

- **Descriptions are searchable**, not just names. `expac -S` dumps all ~23k repo
  packages *with* their descriptions in ~0.2 s, so the list is built once and
  `fzf` filters locally.
- **Spanish keywords are attached invisibly.** `share/synonyms-es.tsv` maps
  Spanish terms onto packages whose English description matches. They're
  searchable but hidden from the display (`fzf --nth` vs `--with-nth`), so the
  list stays clean.
- **The AUR is searched live** through its RPC rather than listing ~90k bare
  names. The RPC returns descriptions *and* vote counts — and votes are what let
  you tell a real package from its near-identical forks.

## Features

- **Organised by source** — the top-level menu *is* the sources (📦 Arch / 📥 AUR
  / 🌐 web apps), so you always know where an app comes from. Installed catalog
  items are marked with a check.
- **One picker, everything in it** — choosing a source opens an omarchy-style
  `fzf` picker over *every* package it has, searchable by description and by
  Spanish keyword, with your favourites merged at the top, info preview and
  multi-select.
- **Unattended installs** — pacman/AUR packages install with no prompts
  (`--noconfirm` plus `--answerdiff/clean=None`); only your sudo password is
  asked once.
- **Web apps** — turn any URL into a Chromium `--app` desktop entry with a
  high-quality icon (auto-fetched from unavatar/clearbit/icon.horse and always
  converted to PNG so launchers render it).
- **Uninstall anything** — “🗑️ Eliminar app” opens an `fzf` picker of installed
  packages **and** your pzget web apps; removes packages with `pacman -Rns` and
  web apps by deleting their `.desktop`/icon (and their `webapps.toml` entry).

## Requirements

| Tool | Used for |
|------|----------|
| `fuzzel` | the graphical menu |
| `fzf` | the “search / uninstall” pickers |
| `expac` | listing repo packages with their descriptions (~0.2 s for ~23k) |
| `yay` | installing from official repos and the AUR |
| `python3` (≥ 3.11) | reading the TOML catalog (`tomllib`) |
| a chromium-family browser (`chromium`, `brave`, …) | web apps |
| `curl` + `imagemagick` (or `python-pillow`) | fetching/converting web-app icons |
| a terminal: `kitty`, `foot`, or any `xdg-terminal-exec` provider | install/search windows |

## Install

```sh
git clone https://github.com/Daf3r/pzget ~/.local/share/pzget
~/.local/share/pzget/install.sh
```

`install.sh` symlinks the binaries into `~/.local/bin` (make sure that's on your
`PATH`) and asks for your **UI language** (English or Spanish). You can change it
later by editing `~/.config/pzget/lang` (`en` or `es`) or re-running the script.

### Hyprland integration

Bind a key to launch it, and make its terminal windows float nicely
(`~/.config/hypr/...` or, on caelestia, `~/.config/caelestia/hypr-user.conf`):

```ini
# launch pzget
bind = Super, I, exec, /home/youruser/.local/share/pzget/bin/pzget

# pzget's install/search terminal: floating, centred (the size is set by the
# terminal itself — see pzget's term_run; Hyprland's `size` rule is ignored by
# terminals)
windowrule = float true, match:class ^pzget$
windowrule = center true, match:class ^pzget$
```

> Tip: use the absolute path in the bind — Hyprland doesn't always inherit your
> shell `PATH`.

## Configuring the catalog

Edit `catalog.toml` (or copy it to `~/.config/pzget/catalog.toml` to override
without touching the repo). Apps are grouped by topic for easy editing; the menu
re-groups them by source automatically.

```toml
[[categories]]
id    = "dev"
name  = "Desarrollo"
icon  = "🛠️"
blurb = "editores, git, terminales"

  [[categories.apps]]
  name    = "Neovim"
  source  = "repo"        # repo | aur | webapp
  pkg     = "neovim"      # package name  (repo / aur)
  desc    = "editor de texto basado en Vim"   # default / fallback
  desc_en = "Vim-based text editor"           # used when language = en

  [[categories.apps]]
  name   = "YouTube"
  source = "webapp"
  url    = "https://youtube.com"
  desc   = "vídeos"
```

Web apps you create from the menu are stored separately in
`~/.config/pzget/webapps.toml` and shown under **Mis webapps** — you never
hand-edit those.

## Components

| Binary | Role |
|--------|------|
| `pzget` | Bash orchestrator — the fuzzel menu and router |
| `pzget-i18n` | Bash — sourced translation table (en/es) + `t()` helper |
| `pzget-catalog` | Python — the only piece that parses TOML; emits menu lines (lang-aware `desc`) |
| `pzget-pkg-list` | Python — builds the searchable list via `expac`, merging favourites and Spanish keywords |
| `pzget-pkg-pick` | Bash — omarchy-style `fzf` package picker, scoped to one source |
| `pzget-aur-search` | Bash — live AUR RPC search (descriptions + vote counts) |
| `pzget-theme` | Bash — fuzzel styling derived from the desktop's live colour scheme, so the menu never clashes with your theme |
| `pzget-pkg-remove` | Bash — `fzf` uninstaller for packages + pzget web apps |
| `pzget-preview` | Bash — shell-agnostic `fzf` preview helper for the uninstaller |
| `pzget-webapp-add` | Bash — creates a web-app `.desktop` + icon |

Design note: Bash never parses TOML — it always asks `pzget-catalog` and reads
back plain tab-separated lines, so the catalog format can change without
touching the menu.

## Troubleshooting

**Web-app or app icons show as broken/pink squares.**

- *pzget web apps*: make sure `imagemagick` (or `python-pillow`) is installed so
  icons get converted to PNG — many launchers can't render `.webp`/`.ico`.
- *Qt apps in general, on caelestia*: caelestia renders its bar/launcher with a
  Qt shell, so it needs the **`qtengine`** Qt platform theme (it sets
  `QT_QPA_PLATFORMTHEME=qtengine`). If that package is missing, Qt can't resolve
  any icon theme and everything shows broken. Install it and re-login:

  ```sh
  yay -S qtengine-git      # or: qtengine
  ```

  Its icon theme is read from `~/.config/qtengine/config.json`
  (`"iconTheme": "Papirus-Dark"` by default on caelestia).

## License

MIT © Polarzero Dev / Daf3r — see [LICENSE](LICENSE).
