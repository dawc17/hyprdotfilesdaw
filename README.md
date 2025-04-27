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

# 📜 Dotfiles Cheatsheet (cfg)

## 📂 Adding Files

```cfg add path/to/file_or_folder```

## ❌ Unstaging Files (after cfg add, before commit)

```cfg reset HEAD path/to/file_or_folder```

### Unstage everything:

```cfg reset HEAD```

## 📝 Committing

```cfg commit -m "your commit message"```

## 🚀 Pushing to GitHub

```cfg push```

## ⬇️ Pulling from GitHub

```cfg pull --rebase```

## 💥 Fixing Mistakes

## 🧹 Undo Last Commit

### Undo commit but keep staged changes

```cfg reset --soft HEAD~1```

### Undo commit and unstage changes

```cfg reset --mixed HEAD~1```

### Undo commit and discard all changes

```cfg reset --hard HEAD~1 (⚠️ careful)```

## 🔥 Other Useful Commands

## 🗑️ Removing Files from Repo

### Remove a file:

```
cfg rm path/to/file
cfg commit -m "remove file"
cfg push
```

### Remove a folder:

```
cfg rm -r path/to/folder
cfg commit -m "remove folder"
cfg push
```

### Stop tracking a file but keep it locally:

```
cfg rm --cached path/to/file
cfg commit -m "stop tracking file"
cfg push
```

## ⚡ Bonus: Cloning Your Dotfiles on a New Machine

```
git clone --bare https://github.com/yourusername/yourdotfilesrepo.git $HOME/.cfg

alias cfg='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

cfg checkout
cfg config --local status.showUntrackedFiles no
```

# 🚀 Done!

