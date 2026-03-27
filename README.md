# Fzfm - Fuzzy File Manager

A modern, terminal-based file manager written in bash that leverages [fzf](https://github.com/junegunn/fzf) for fuzzy searching and navigation. Inspired by tools like Ranger, nnn, lf, and vifm.

![Screenshot](fzfm.png)

## Installation

```bash
git clone https://github.com/jdpedersen1/fzfm.git
cd fzfm
chmod +x fzfm.sh
```

Add to your shell profile for convenient access:
```bash
# In ~/.bashrc or ~/.zshrc
source /path/to/fzfm/fzfm.sh
```

## Dependencies

### Required
- [fzf](https://github.com/junegunn/fzf) - Fuzzy file searching
- `lsd` - Modern ls replacement with icons
- `jq` - JSON processing for clipboard

### Optional (for previews)
| Tool | Purpose |
|------|---------|
| `bat` | Text file preview with syntax highlighting |
| `neovim` / `vim` | Text file editing |
| `kitty` + `icat` | Image preview (Kitty terminal) |
| `ueberzugpp` | Image preview (all terminals) |
| `sxiv` | Image viewing (fallback) |
| `zathura` | PDF viewing |
| `libreoffice` | Word documents |
| `mpv` | Video playback |
| `gimp` | `.xcf` files |
| `trash-put` | Trash support |

## Configuration

Copy the example config and customize:
```bash
mkdir -p ~/.config/fzfm
cp config.example ~/.config/fzfm/config
```

### Key Settings

```bash
# Image preview backend: "kitty", "ueberzugpp", or "auto"
IMAGE_BACKEND="auto"

# Show hidden files (yes/no)
SHOW_HIDDEN="no"

# Use trash for deletion (yes/no)
USE_TRASH="yes"

# Preview window size
PREVIEW_SIZE="65%"

# Sort order: name, size, time, extension
SORT_ORDER="name"
```

## Usage

```bash
./fzfm.sh
```

### Keybindings

| Key | Action |
|-----|--------|
| `Enter` | Open file/directory |
| `Left` | Go to parent directory |
| `Right` | Open file |
| `Tab` | Toggle selection |
| `Space` | Toggle selection (alternative) |
| `Alt+n` | Create new file |
| `Alt+d` | Create new directory |
| `Alt+c` | Copy selected files |
| `Alt+m` | Move selected files |
| `Alt+v` | Paste files |
| `Alt+r` | Rename file |
| `Alt+t` | Trash selected files |
| `Alt+b` | Set as wallpaper (image) |
| `Alt+s` | Play video fullscreen |
| `Ctrl+r` | Refresh directory |
| `Esc` | Clear clipboard and quit |
| `q` | Quit |

## Features

### Implemented
- Fuzzy file and directory navigation
- File/directory preview before opening
- Image preview (Kitty or ueberzugpp)
- Video thumbnail preview with metadata
- Create, rename, delete files and directories
- Copy/Move/Paste file operations with clipboard
- Set wallpaper from image files
- Directory history tracking
- Configurable via `~/.config/fzfm/config`
- Proper error handling and logging

### Image Preview
- **Kitty**: Best performance, requires Kitty terminal
- **ueberzugpp**: Works with Alacritty, foot, Wezterm, Windows Terminal
- **Auto-detect**: Automatically uses best available backend

### Clipboard System
- Copy (`Alt+c`) stores files to JSON clipboard
- Move (`Alt+m`) stores files as "move" action
- Paste (`Alt+v`) pastes to current directory
- Clipboard persists across sessions (in `~/.cache/fzfm/clipboard`)

## Troubleshooting

### Image preview not working
1. Ensure you're using Kitty terminal OR have `ueberzugpp` installed
2. Set `IMAGE_BACKEND="kitty"` or `IMAGE_BACKEND="ueberzugpp"` explicitly

### Missing dependencies
```bash
# Arch
sudo pacman -S fzf lsd jq

# Debian/Ubuntu
sudo apt install fzf lsd jq
```

### Logs
Check logs at `~/.cache/fzfm/fzfm.log` for debugging.

## License

MIT