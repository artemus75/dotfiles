# Colorful Terminal on Arch Linux (KDE Konsole, Bash)

Goal: Catppuccin Macchiato, colored directory listings, a Starship prompt with the input on a new line.

## 1. Install packages

```bash
sudo pacman -S --needed eza bat fd ripgrep btop vivid starship ttf-jetbrains-mono-nerd
```

Optional for ZSH (see section 8):

```bash
sudo pacman -S --needed zsh zsh-syntax-highlighting zsh-autosuggestions
```

## 2. Konsole: color scheme and font

1. Download the Catppuccin color scheme:

   ```bash
   mkdir -p ~/.local/share/konsole
   cd ~/.local/share/konsole
   curl -O https://raw.githubusercontent.com/catppuccin/konsole/main/themes/catppuccin-macchiato.colorscheme
   ```

2. In Konsole: *Settings → Edit Current Profile → Appearance*
   - Color scheme: **catppuccin-macchiato**
   - Font: **JetBrainsMono Nerd Font** (required for icons and Powerline separators)

Note: If the scheme file has moved in the repository, look for `catppuccin-macchiato.colorscheme` in `github.com/catppuccin/konsole`.

## 3. Starship prompt

```bash
mkdir -p ~/.config
[ -f ~/.config/starship.toml ] && mv ~/.config/starship.toml ~/.config/starship.toml.bak
starship preset catppuccin-powerline -o ~/.config/starship.toml
```

Switch the palette to Macchiato:

```bash
sed -i 's/^palette = .*/palette = "catppuccin_macchiato"/' ~/.config/starship.toml
```

Put the input on a new line:

```bash
if grep -q '^\[line_break\]' ~/.config/starship.toml; then
  sed -i '/^\[line_break\]/,/^$/ s/disabled = true/disabled = false/' ~/.config/starship.toml
else
  printf '\n[line_break]\ndisabled = false\n' >> ~/.config/starship.toml
fi
```

Optional: make the arrow red after a failed command by adding this to the end of `starship.toml`:

```toml
[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"
```

Note: If `starship preset catppuccin-powerline` is not found, your Starship version is too old. This normally does not happen on Arch.

## 4. Extend `~/.bashrc`

```bash
# --- Colors ---
alias ls='eza --icons --group-directories-first'
alias ll='eza -lah --icons --git --group-directories-first'
alias lt='eza --tree --level=2 --icons'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias ip='ip -color=auto'

export LS_COLORS="$(vivid generate catppuccin-macchiato)"

# Colored man pages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

# Prompt (at the very end of the file)
eval "$(starship init bash)"
```

Apply it:

```bash
source ~/.bashrc
```

## 5. bat: Catppuccin theme

```bash
mkdir -p "$(bat --config-dir)/themes"
cd "$(bat --config-dir)/themes"
curl -O "https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Macchiato.tmTheme"
bat cache --build
echo '--theme="Catppuccin Macchiato"' >> "$(bat --config-dir)/config"
```

## 6. btop: Catppuccin theme (optional)

Copy the themes from `github.com/catppuccin/btop` to `~/.config/btop/themes/`, then select the theme `catppuccin_macchiato` in btop via `Esc → Options`.

## 7. Smoke test

```bash
ll
bat ~/.bashrc
man ls
```

Check that:
- Icons and separator arrows show up without boxes
- The prompt has two lines
- File types in `ll` are colored

Troubleshooting:
- Boxes instead of icons: the Nerd Font is not set in the Konsole profile
- Colors look wrong: the color scheme is not selected in the profile
- Old prompt stays: open a new Konsole window or run `source ~/.bashrc`

## 8. Optional: switch to ZSH

```bash
chsh -s /usr/bin/zsh
```

`~/.zshrc`:

```bash
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Paste the aliases and exports from section 4 here

eval "$(starship init zsh)"
```

Advantage of ZSH: commands are colored as you type (valid in green, invalid in red) and suggested from your history.
