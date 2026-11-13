# AGENTS.md

Personal dotfiles for a CachyOS (Arch-based) laptop running Hyprland on Wayland.

## How the repository works

- **The repository root is `$HOME`.** Paths in the repo map one-to-one onto the home directory
  (`.config/hypr/hyprland.lua` is `~/.config/hypr/hyprland.lua`). There is no stow, no symlink
  farm and no install script.
- **`.gitignore` is an allowlist.** It starts with `/*` and re-includes only what is tracked with
  `!` rules. When adding config for a new program, add a matching `!` entry (and the
  `!dir/` + `dir/*` pair for parent folders) or git will not see the files. Never weaken the
  `/*` rule or add broad re-includes: the rest of `$HOME` must stay out.
- Files that live outside `$HOME` (udev rules, `/etc` config) are documented in `README.md` instead
  of tracked. Add new ones there, with path and content.

## Git submodules

These folders are separate repositories. Change them in their own repo, then bump the pointer here:

| Path | Repository |
| --- | --- |
| `.config/nvim` | `Thiago-Morais/kickstart.nvim` (has its own `AGENTS.md`) |
| `.config/fish` | `Thiago-Morais/dotfiles-fish` |
| `.config/mpv` | `Thiago-Morais/mpv-settings` |
| `.config/YouTube Music` | `Thiago-Morais/dotfiles-pear-desktop` |
| `.zen/fii5rp1a.Default (release)` | `Thiago-Morais/dotfiles-zen-browser` |
| `.config/matugen/matugen-themes` | `InioX/matugen-themes` (upstream, don't edit) |
| `.config/mpv/scripts/celebi` | `po5/celebi` (upstream, don't edit) |

## Generated and machine-local files: never commit

- **matugen output.** Colors are generated from the wallpaper (`wpaperd` → `.config/wpaperd/scripts/run-matugen.sh`
  → `matugen`) using the templates in `.config/matugen/templates/` and the targets in
  `.config/matugen/config.toml`. Edit the **template**, never the generated file. Generated files
  (`.config/hypr/colors.lua`, `.config/waybar/themes/colors.css`, `.config/rofi/colors.rasi`,
  `.config/btop/themes/matugen.theme`, …) are listed in `.gitignore`. When adding a template, add its
  output path to `.gitignore` in the same commit.
- **Hyprland local files** (see `.config/hypr/.gitignore`): `monitors.lua`, `hyprmon.lua`, `env.lua`,
  `colors.lua`, `config/patches/init.lua`. Patches are opt-in per machine: `init.example.lua` is the
  tracked template, copied to `init.lua` locally.
- Caches, logs, histories, session files (`Session.vim`) and installed plugins (Yazi plugins come from
  `.config/yazi/package.toml` via `ya pkg install`).

## Hyprland

- Config uses the **Lua format (Hyprland 0.55+)** with the `hl.*` API, not hyprlang.
  Entry point: `.config/hypr/hyprland.lua`. Type stubs: `/usr/share/hypr/stubs` (see `.luarc.json`).
- Layout: `config/variables/` (options), `config/binds/` (one file per bind group, each exposing
  `setup()`), `config/windowrules.lua`, `config/autostart.lua`, `config/patches/` (optional overrides),
  `plugins/`, `scripts/`.
- Format Lua here with `stylua` using `.config/hypr/stylua.toml` (**tabs**, double quotes, call parentheses
  always). This differs from the Neovim repo's style.
- Some settings are CachyOS defaults left over from the original install; don't assume every line is
  deliberate, but don't remove things without saying why.

## Conventions

- Shell scripts use bash (`#!/bin/bash`). Fish is only the interactive shell, and its config lives in
  its own submodule.
- Clean code with descriptive names; single-letter names only where common sense allows (tiny lambdas,
  simple math).
- CSS: prefer 3-digit hex colors (`#fff`) whenever the color allows it.
- Prefer stock commands and tools over aliases, so things work on other machines and servers.

## Commits

- Conventional commits with the **program as scope** and a capitalized imperative summary:
  `feat(hypr): Add inner gaps to special workspaces`, `fix(matugen): Remove the generated btop theme`.
- Don't use catch-all types like `chore`; pick a type with a clear meaning
  (`feat`, `fix`, `refactor`, `style`, `docs`, `build`, `ci`, `perf`, `revert`).
- Submodule bumps: `Update submodules <name> and <name>`.
- When splitting work into several commits, **every commit must work on its own** (Hyprland and the
  affected programs still start without errors).

## Branches and pushing

- Default branch is `main`. Never commit, push or merge directly to it; work on a new branch.
- Always ask before force-pushing any branch.
