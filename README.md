# Terminal Setup

A colorful, consistent terminal setup in **Catppuccin Macchiato**: Bash, a [Starship](https://starship.rs) prompt, colored `ls`/`man`/`fzf`, and guides for Arch Linux and Ubuntu (WSL).

## What's inside

| File | Purpose |
|---|---|
| [`bashrc`](bashrc) | Bash configuration: history, PATH, colors, aliases, fzf, Kubernetes/Talos helpers, Starship init |
| [`starship.toml`](starship.toml) | Powerline-style prompt with the input on a new line; git, language, Kubernetes and Terraform segments appear only when relevant |
| [`arch-terminal-colors.md`](arch-terminal-colors.md) | Step-by-step guide: Arch Linux with KDE Konsole |
| [`ubuntu-wsl-terminal-colors.md`](ubuntu-wsl-terminal-colors.md) | Step-by-step guide: Ubuntu 26.04 in WSL with Windows Terminal |
| [`catppuccin_macchiato.yaml`](catppuccin_macchiato.yaml) | Optional: Catppuccin Macchiato theme for Warp |

## Quick start (Arch Linux)

```bash
# 1. Packages
sudo pacman -S --needed eza bat fd ripgrep btop vivid starship fzf bash-completion \
  ttf-jetbrains-mono-nerd noto-fonts-emoji

# 2. Back up existing files, then install the configs
cp ~/.bashrc ~/.bashrc.bak
[ -f ~/.config/starship.toml ] && cp ~/.config/starship.toml ~/.config/starship.toml.bak
mkdir -p ~/.config
cp bashrc ~/.bashrc
cp starship.toml ~/.config/starship.toml

# 3. Apply
source ~/.bashrc
```

To keep the repo as the single source of truth, use symlinks instead of `cp`:

```bash
ln -sf "$PWD/bashrc" ~/.bashrc
ln -sf "$PWD/starship.toml" ~/.config/starship.toml
```

Then set the font and color scheme in your terminal (see below). For Ubuntu/WSL, follow the [Ubuntu guide](ubuntu-wsl-terminal-colors.md): package names and the font setup differ there.

## Terminal settings

The shell configuration is the same everywhere. Each terminal only needs the **Nerd Font** and the **Catppuccin Macchiato** color scheme:

| Terminal | Font | Color scheme |
|---|---|---|
| KDE Konsole | Profile → Appearance | [catppuccin/konsole](https://github.com/catppuccin/konsole) |
| Windows Terminal (WSL) | Profile → Appearance (font installed on Windows) | [catppuccin/windows-terminal](https://github.com/catppuccin/windows-terminal) |
| Ghostty | `font-family = JetBrainsMono Nerd Font` | `theme = Catppuccin Macchiato` (check the name with `ghostty +list-themes`) |
| Warp | Settings → Appearance → Text; set *Input type* to *Shell (PS1)* | [`catppuccin_macchiato.yaml`](catppuccin_macchiato.yaml) |
| VS Code | `terminal.integrated.fontFamily` | Extension `Catppuccin.catppuccin-vsc` |

Note for Warp: multi-line prompts are only supported with zsh and fish, not Bash. With Bash, use a one-line prompt in Warp (set `disabled = true` under `[line_break]` in a separate Starship config).

## Notes

- **Nerd Font required.** Without it, icons and Powerline separators show up as boxes.
- **Personal parts in `bashrc`.** The Rancher Desktop, LM Studio, opencode, Talos and LibreOffice entries are specific to my machine and contain absolute paths (`/home/michael/...`). Remove or adjust them for your own setup.
- **Optional tools.** `kubecolor`, `talosctl` and `fzf` are used only if installed; the config skips them otherwise.
- **Requires Starship 1.20 or newer** (older versions lack the `catppuccin-powerline` preset and the Kubernetes `contexts` option). The Ubuntu package is too old; use the official install script.

## Credits

Color palette: [Catppuccin](https://catppuccin.com). Prompt: [Starship](https://starship.rs).
