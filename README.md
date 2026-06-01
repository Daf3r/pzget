# pzget

A fast, keyboard-driven app & web-app installer for Arch Linux — omarchy-style,
built for [caelestia](https://github.com/caelestia-dots) / Hyprland.

One graphical menu (via [fuzzel](https://codeberg.org/dnkl/fuzzel)) organised by
**source** — official repos, the AUR, and web apps. Install from a curated
catalog, search the full repos/AUR when you need something else, turn any URL
into a desktop web app, or uninstall things — all without leaving the keyboard.
Installs run **fully unattended** (no confirmation or build menus).

> The menu UI is in **Spanish**; code, config keys and this README are in English.

## The menu

```
  pzget »

  📦  Arch (oficial)   programas del repositorio oficial
  📥  AUR              programas de la comunidad
  🌐  Apps web         YouTube, ChatGPT…
  ➕  Crear app web    convierte un sitio web en app
  🗑️  Eliminar app     desinstala programas o webapps
```

Entering a package source shows your curated picks (installed ones marked `✓`)
plus a full-search entry:

```
  Arch (oficial) »

  ✓  Neovim                (ya instalado)
     Zed                   ·  editor de código rápido
     Lutris                ·  plataforma de juegos para Linux
  ─────────────────────────────
  🔎  Buscar cualquier paquete…     → fzf over every package in this source
```

## Features

- **Organised by source** — the top-level menu *is* the sources (📦 Arch / 📥 AUR
  / 🌐 web apps), so you always know where an app comes from. Installed catalog
  items are marked with a check.
- **Curated list + full search** — each package source shows your favourites
  first, plus a “🔎 Buscar cualquier paquete…” entry that opens an omarchy-style
  `fzf` picker over *every* package in that source, with info preview and
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
`PATH`).

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
  name   = "Neovim"
  source = "repo"        # repo | aur | webapp
  pkg    = "neovim"      # package name  (repo / aur)
  desc   = "editor de texto basado en Vim"

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
| `pzget-catalog` | Python — the only piece that parses TOML; emits menu lines |
| `pzget-pkg-pick` | Bash — omarchy-style `fzf` package picker, scoped to one source |
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
