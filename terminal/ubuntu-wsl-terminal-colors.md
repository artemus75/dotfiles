# Colorful Terminal on Ubuntu 26.04 in WSL (Bash)

Goal: Catppuccin Macchiato, colored directory listings, a Starship prompt with the input on a new line.

Important: The font and color scheme are configured in **Windows Terminal**, not in Ubuntu.

## 1. Windows: Nerd Font and color scheme

1. Download a Nerd Font (e.g. JetBrainsMono Nerd Font from nerdfonts.com) and install it **on Windows**.
2. Windows Terminal: *Settings → Profiles → Ubuntu → Appearance → Font face* and select the Nerd Font.
3. Add the color scheme `Catppuccin Macchiato` from `github.com/catppuccin/windows-terminal` to the `"schemes"` section of the Windows Terminal `settings.json`, then select it in the profile under *Appearance → Color scheme*.

Without a Nerd Font you will see boxes instead of icons and Powerline separators.

## 2. Install packages

```bash
sudo apt update
sudo apt install -y eza bat fd-find ripgrep btop vivid
```

If a package is not found, check with `apt-cache policy <package>`. For `vivid` there is a `.deb` as an alternative at `github.com/sharkdp/vivid/releases`.

On Ubuntu two programs have different names. Symlinks give you the usual names back:

```bash
mkdir -p ~/.local/bin
ln -sf /usr/bin/batcat ~/.local/bin/bat
ln -sf /usr/bin/fdfind ~/.local/bin/fd
```

`~/.local/bin` must be in your `PATH`. On Ubuntu this is normally the case as soon as the folder exists (open a new shell, test with `echo $PATH`).

## 3. Install Starship (current version)

The version in the Ubuntu repositories is too old and does not know the `catppuccin-powerline` preset. Use the official script instead:

```bash
sudo apt remove -y starship
curl -sS https://starship.rs/install.sh | sh
hash -r
starship --version
```

(If `starship` was never installed via apt, `apt remove` just reports that there is nothing to remove. That is harmless.)

## 4. Starship configuration

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

## 5. Extend `~/.bashrc`

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

## 6. bat: Catppuccin theme

```bash
mkdir -p "$(bat --config-dir)/themes"
cd "$(bat --config-dir)/themes"
curl -O "https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Macchiato.tmTheme"
bat cache --build
echo '--theme="Catppuccin Macchiato"' >> "$(bat --config-dir)/config"
```

## 7. Smoke test

```bash
ll
bat ~/.bashrc
man ls
```

Troubleshooting:
- `invalid value 'catppuccin-powerline'`: Starship is too old, repeat section 3
- Boxes instead of icons: the Nerd Font is not set in Windows Terminal
- `bat: command not found`: the symlink from section 2 is missing, or you need a new shell
- Colors look wrong: the color scheme is not selected in the Windows Terminal profile

## 8. Optional: switch to ZSH

```bash
sudo apt install -y zsh zsh-syntax-highlighting zsh-autosuggestions
chsh -s "$(which zsh)"
```

`~/.zshrc` (on Ubuntu without the `/plugins/` subfolder):

```bash
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Paste the aliases and exports from section 5 here

eval "$(starship init zsh)"
```

Afterwards restart the WSL session (`wsl --shutdown` in PowerShell, then reopen Ubuntu).
