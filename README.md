my hyprland configuration

packages (aur)
- superfile
- mako
- kitty
- vscode
- pavucontrol
- jq
- pywal-git
- waybar
- rofi-wayland
- neofetch
- swww
- hyprlock
- pywalfox
- neovim

# Cloning The Dotfiles on a New Machine

```
git clone --bare https://github.com/dawc17/hyprdotfilesdaw.git $HOME/.cfg

alias cfg='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

cfg checkout
cfg config --local status.showUntrackedFiles no
```
