# AGENTS.md — dotfiles

Personal dotfiles for a CachyOS (Arch-based) laptop running Hyprland on Wayland.

**Scope.** This file sits at the root of `$HOME`, so Pi loads it in every session started anywhere under
the home directory. Follow it only when working on the dotfiles themselves (the working directory is
`$HOME`, a path tracked by this repo, or a separate clone of it). In any other project, ignore this file.
Inside a submodule that has its own `AGENTS.md` (such as `.config/nvim`), that file wins.

## Safety

Pi runs tools without asking for approval, so these rules are the only guardrail. Stop and ask in chat before:

- pushing anything, and always before force-pushing (even your own branch);
- deleting files, or editing anything outside the repository (`/etc`, `~/.pi`, `~/.ssh`, untracked parts of `$HOME`);
- running `sudo`, `pacman`/`paru`, `systemctl`, or anything that changes the running session
  (`hyprctl reload`, `hyprctl dispatch`, restarting waybar/mako/etc.).

When the working directory is `$HOME`, **edits are live**: Hyprland and several other programs reload
their config when files change, so a broken file can break the running desktop immediately. Make small
edits and check syntax before saving the next one.

## How the repository works

- **The repository root is `$HOME`.** Paths map one-to-one onto the home directory
  (`.config/hypr/hyprland.lua` is `~/.config/hypr/hyprland.lua`). No stow, no symlinks, no install script.
- **`.gitignore` is an allowlist.** It starts with `/*` and re-includes tracked paths with `!` rules.
  New config needs a matching `!` entry (and the `!dir/` + `dir/*` pair for parent folders) or git won't
  see it. Never weaken `/*` or add broad re-includes: the rest of `$HOME` must stay out. Check with
  `git status --ignored` or `git check-ignore -v <path>`.
- Files outside `$HOME` (udev rules, `/etc` config) are documented in `README.md`, not tracked.

## Git submodules

Separate repositories. Change them in their own repo, then bump the pointer here:

| Path | Repository |
| --- | --- |
| `.config/nvim` | `Thiago-Morais/kickstart.nvim` (has its own `AGENTS.md`) |
| `.config/fish` | `Thiago-Morais/dotfiles-fish` |
| `.config/mpv` | `Thiago-Morais/mpv-settings` |
| `.config/YouTube Music` | `Thiago-Morais/dotfiles-pear-desktop` |
| `.zen/fii5rp1a.Default (release)` | `Thiago-Morais/dotfiles-zen-browser` |
| `.config/matugen/matugen-themes` | `InioX/matugen-themes` (upstream, don't edit) |
| `.config/mpv/scripts/celebi` | `po5/celebi` (upstream, don't edit) |

## Never commit

- **matugen output.** Colors come from the wallpaper (`wpaperd` → `.config/wpaperd/scripts/run-matugen.sh`
  → `matugen`) through the templates in `.config/matugen/templates/` and the targets in
  `.config/matugen/config.toml`. Edit the template, never the generated file (`.config/hypr/colors.lua`,
  `.config/waybar/themes/colors.css`, `.config/rofi/colors.rasi`, …; all listed in `.gitignore`).
  A new template's output path goes into `.gitignore` in the same commit.
- **Hyprland machine-local files** (`.config/hypr/.gitignore`): `monitors.lua`, `hyprmon.lua`, `env.lua`,
  `colors.lua`, `config/patches/init.lua`. Patches are opt-in: `init.example.lua` is the tracked template.
- Caches, logs, histories, `Session.vim`, installed Yazi plugins (they come from `.config/yazi/package.toml`).
- Secrets: anything from `.gnupg` other than `dirmngr.conf`, `~/.ssh`, `~/.pi/agent/auth.json`.

## Hyprland

- **Lua config (Hyprland 0.55+)** with the `hl.*` API, not hyprlang. Entry point `.config/hypr/hyprland.lua`;
  type stubs in `/usr/share/hypr/stubs`.
- Bind groups live in their own files under `config/binds/`, each exposing a `setup()` that
  `config/keybinds.lua` calls; a new group must be added there.
- Style: `stylua` with `.config/hypr/stylua.toml` (**tabs**, double quotes, call parentheses always).
  The Neovim repo uses a different style.
- Some lines are CachyOS defaults left from the original install; don't remove them without saying why.

## Checking a change

Use what is available and say which checks you ran:

- Lua: `stylua --check <file>` (with the right `stylua.toml`), `luac -p <file>`.
- Shell: `bash -n <file>`, `shellcheck <file>`.
- JSON/TOML/CSS: parse them (`jq . <file>` etc.).

Without a Wayland session (e.g. in a sandbox) you can't start Hyprland or waybar. Don't claim the change
works; list what the user should verify on the laptop (e.g. `hyprctl configerrors` after the reload).

## Conventions

- Scripts use bash (`#!/bin/bash`). Fish is only the interactive shell; its config is a submodule.
- Descriptive names; single letters only where common sense allows (tiny lambdas, simple math).
- CSS: prefer 3-digit hex colors (`#fff`) when the color allows it.
- Prefer stock commands and tools over aliases.

## Commits and branches

- Conventional commits with the **program as scope**, capitalized imperative summary:
  `feat(hypr): Add inner gaps to special workspaces`, `fix(matugen): Remove the generated btop theme`.
  Submodule bumps: `Update submodules <name> and <name>`.
- No catch-all types like `chore`; use `feat`, `fix`, `refactor`, `style`, `docs`, `build`, `ci`, `perf`, `revert`.
- Split work so **every commit works on its own**; a series that only works at the last commit is wrong.
- Default branch is `main`. Never commit, push or merge to it directly; work on a new branch.
