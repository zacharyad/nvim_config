# Minimal Neovim Setup Guide

This is a streamlined Neovim configuration focused on web development with TypeScript, JavaScript, Go, Python, Tailwind CSS, HTML, JSON, and SQL.

## Prerequisites

1. **Neovim 0.9+**
   ```bash
   # macOS (Homebrew)
   brew install neovim
   
   # Ubuntu/Debian
   sudo apt install neovim
   
   # Check version
   nvim --version
   ```

2. **Required tools** (install these for full functionality):
   ```bash
   # Node.js (for TypeScript/JavaScript LSP)
   brew install node
   
   # Python (for Python LSP)
   brew install python
   
   # Go (for Go LSP)
   brew install go
   
   # ripgrep (for telescope live_grep)
   brew install ripgrep
   
   # fd (optional, for better file finding)
   brew install fd
   ```

## Installation

1. **Backup existing config** (if you have one):
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. **Create the config directory**:
   ```bash
   mkdir -p ~/.config/nvim
   ```

3. **Copy the configuration**:
   - Copy the `init.lua` content to `~/.config/nvim/init.lua`

4. **Start Neovim**:
   ```bash
   nvim
   ```

   On first startup:
   - Lazy.nvim will automatically install
   - All plugins will be downloaded and installed
   - LSP servers will be installed via Mason
   - This may take a few minutes

## Key Mappings

### Leader Key: `<Space>`

### File Management
- `<Space>ff` - Find files
- `<Space>fg` - Live grep (search in files)
- `<Space>fb` - List buffers
- `<Space>e` - Toggle file explorer

### LSP Features
- `gd` - Go to definition
- `gr` - Go to references
- `K` - Show hover information
- `<Space>ca` - Code actions
- `<Space>rn` - Rename symbol
- `<Space>f` - Format file

### Buffer Navigation
- `Shift+l` - Next buffer
- `Shift+h` - Previous buffer
- `<Space>bd` - Delete buffer

### Window Navigation
- `Ctrl+h/j/k/l` - Move between windows

### Terminal
- `Ctrl+\` - Toggle terminal

### General
- `jk` - Exit insert mode
- `<Space>w` - Save file
- `<Space>q` - Quit
- `<Space>h` - Clear search highlighting

## Language Support

The setup automatically provides:

### TypeScript/JavaScript
- Syntax highlighting
- LSP features (autocomplete, go-to-definition, etc.)
- Auto-formatting on save
- Error diagnostics

### Python
- Full LSP support via Pyright
- Syntax highlighting
- Auto-formatting

### Go
- Complete Go toolchain integration
- Auto-formatting with gofmt
- Import management

### HTML/CSS/Tailwind
- HTML LSP with tag completion
- CSS LSP with property completion
- Tailwind CSS IntelliSense
- Auto-completion for classes

### JSON/SQL
- JSON schema validation
- SQL syntax highlighting and basic LSP

## Customization

The config is designed to be minimal but extensible. Common customizations:

### Change Color Scheme
Replace `catppuccin-mocha` in the config with:
- `catppuccin-latte` (light theme)
- `catppuccin-frappe` or `catppuccin-macchiato` (other dark themes)

### Add More Languages
Add to the `ensure_installed` lists in:
- Mason-lspconfig (for LSP servers)
- Treesitter (for syntax highlighting)

### Modify Key Mappings
Edit the keymap sections in `init.lua` to suit your preferences.

## Troubleshooting

### LSP Not Working
1. Check if the language server is installed: `:Mason`
2. Restart Neovim: `:qa` then reopen
3. Check LSP status: `:LspInfo`

### Telescope Not Finding Files
1. Make sure you're in a directory with files
2. Install `ripgrep`: `brew install ripgrep`
3. For better performance, install `fd`: `brew install fd`

### Treesitter Errors
1. Update parsers: `:TSUpdate`
2. If errors persist, try: `:TSUpdateSync`

### Plugin Issues
1. Update plugins: `:Lazy update`
2. Clean and reinstall: `:Lazy clean` then restart Neovim

## Features Included

✅ **File Explorer** - nvim-tree for project navigation  
✅ **Fuzzy Finding** - Telescope for file/text search  
✅ **LSP Integration** - Full language server support  
✅ **Autocompletion** - Smart code completion  
✅ **Syntax Highlighting** - Treesitter for all languages  
✅ **Git Integration** - Gitsigns for git status  
✅ **Auto-formatting** - Format on save  
✅ **Terminal Integration** - Built-in terminal toggle  
✅ **Auto-pairs** - Automatic bracket/quote pairing  
✅ **Commenting** - Smart comment toggling  

This setup gives you a modern, efficient development environment that's easy to understand and extend!
