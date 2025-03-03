
# Fzfm - Fuzzy File Manager

**Note:** This project is still a work in progress. Please read the entire README before cloning or using, and proceed at your own risk.

Fzfm is a terminal-based file manager inspired by tools like Ranger, nnn, lf, vifm, etc. It leverages `bash`, `fzf`, and `Kitty` (via `icat` for image preview) to offer a user-friendly way to navigate and manage files from the terminal. Fzfm supports file previewing, directory traversal, and viewing images (albeit with limited functionality).

![Screenshot](fzfm.png)

## Installation

To install Fzfm, follow these steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/jdpedersen1/fzfm.git
   ```
2. Navigate to the `fzfm` directory:
   ```bash
   cd fzfm
   ```
3. Grant execution permissions to the scripts:
   ```bash
   chmod +x *.sh
   ```
4. Optionally, add the directory to your `PATH` if you prefer to run the scripts without typing the full path.

## Dependencies

### Required Dependencies
- `fzf`: For fuzzy file searching and selection.

### Preview Functionality Dependencies
The following programs are required for file previews. You can modify the scripts to use alternatives if needed:

- `libreoffice`: For opening Word documents.
- `zathura`: For opening PDFs.
- `mpv`: For video playback.
- `sxiv`: For image viewing.
- `neovim` or `vim`: For editing text files.
- `gimp`: For opening `.xcf` files.
- `bat`: For previewing text files with syntax highlighting.
- `kitty`: For image preview (Kitty terminal emulator is required for this feature).

## Features

### Fully Supported:
- Traverse file tree.
- Preview files and directories before opening.
- Open files with appropriate applications based on file type.
- Create new files and directories.
- Delete files and directories.
- Image preview (requires `kitty` terminal emulator).

### In Progress:
- Copy files and directories.
  - **Warning:** If the target directory already contains a file or directory with the same name, it will be overwritten.

### Planned Features (TODO):
- File extraction and compression.
- File renaming functionality.

## Known Issues
- **Unexpected behavior** may occur after creating files or directories. This is being investigated.
