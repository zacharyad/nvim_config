-- ~/.config/nvim/init.lua
 45 -- Minimal Neovim setup for web development
 45
 45 -- Set leader key
 45 vim.g.mapleader = " "
 45 vim.g.maplocalleader = " "
 45
 45 -- Basic settings
 45 vim.opt.number = true
 45 vim.opt.relativenumber = true
 45 vim.opt.tabstop = 2
 45 vim.opt.shiftwidth = 2
 45 vim.opt.expandtab = true
 45 vim.opt.smartindent = true
 45 vim.opt.wrap = false
 45 vim.opt.ignorecase = true
 45 vim.opt.smartcase = true
 45 vim.opt.hlsearch = false
 45 vim.opt.incsearch = true
 45 vim.opt.termguicolors = true
 45 vim.opt.scrolloff = 8
 45 vim.opt.signcolumn = "yes"
 45 vim.opt.updatetime = 50
 45 vim.opt.colorcolumn = "80"
 45 vim.opt.cursorline = true
 45
 45 -- Set up lazy.nvim
 45 local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
 45 if not vim.loop.fs_stat(lazypath) then
 45   vim.fn.system({
 45     "git",
 45     "clone",
 45     "--filter=blob:none",
 45     "https://github.com/folke/lazy.nvim.git",
 45     "--branch=stable",
 45     lazypath,
 45   })
 45 end
 45 vim.opt.rtp:prepend(lazypath)
 45
 45 -- Plugin setup
 45 require("lazy").setup({
 45   -- Color scheme
 45   {
 45     "catppuccin/nvim",
 45     name = "catppuccin",
 45     priority = 1000,
 45     config = function()
 45       vim.cmd.colorscheme "catppuccin-mocha"
 45     end,
 45   },
 45
 45   -- File explorer
 45   {
 45     "nvim-tree/nvim-tree.lua",
 45     dependencies = "nvim-tree/nvim-web-devicons",
 45     config = function()
 45       require("nvim-tree").setup({
 45         view = { width = 30 },
 45         filters = { dotfiles = false },
 45         git = { enable = true },
 45       })
 45       vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true })
 45     end,
 45   },
 45
 45   -- Fuzzy finder
 45   {
 45     "nvim-telescope/telescope.nvim",
 45     dependencies = "nvim-lua/plenary.nvim",
 45     config = function()
 45       local builtin = require("telescope.builtin")
 45       vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
 45       vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
 45       vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
 45     end,
 45   },
 45
 45   -- LSP Configuration
 45   {
 45     "neovim/nvim-lspconfig",
 45     dependencies = {
 45       "williamboman/mason.nvim",
 45       "williamboman/mason-lspconfig.nvim",
 45       "hrsh7th/cmp-nvim-lsp",
 45     },
 45     config = function()
 45       -- Mason setup
 45       require("mason").setup()
 45       require("mason-lspconfig").setup({
 45         ensure_installed = {
 45           "lua_ls",
 45           "tsserver",
 45           "pyright",
 45           "gopls",
 45           "html",
 45           "cssls",
 45           "tailwindcss",
 45           "jsonls",
 45           "sqlls",
 45         },
 45         automatic_installation = true,
 45       })
 45
 45       local lspconfig = require("lspconfig")
 45       local capabilities = require("cmp_nvim_lsp").default_capabilities()
 45
 45       -- LSP keymaps
 45       local on_attach = function(client, bufnr)
 45         local opts = { noremap = true, silent = true, buffer = bufnr }
 45         vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
 45         vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
 45         vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
 45         vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
 45         vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
 45         vim.keymap.set("n", "<leader>f", function()
 45           vim.lsp.buf.format({ async = true })
 45         end, opts)
 45       end
 45
 45       -- Server configurations
 45       local servers = {
 45         lua_ls = {
 45           settings = {
 45             Lua = {
 45               diagnostics = { globals = { "vim" } },
 45               workspace = { library = vim.api.nvim_get_runtime_file("", true) },
 45             },
 45           },
 45         },
 45         ts_ls = {},
 45         pyright = {},
 45         gopls = {},
 45         html = {},
 45         cssls = {},
 45         tailwindcss = {},
 45         jsonls = {},
 45         sqlls = {},
 45       }
 45
 45       -- Setup servers
 45       for server, config in pairs(servers) do
 45         lspconfig[server].setup(vim.tbl_extend("force", {
 45           capabilities = capabilities,
 45           on_attach = on_attach,
 45         }, config))
 45       end
 45     end,
 45   },
 45
 45   -- Autocompletion
 45   {
 45     "hrsh7th/nvim-cmp",
 45     dependencies = {
 45       "hrsh7th/cmp-nvim-lsp",
 45       "hrsh7th/cmp-buffer",
 45       "hrsh7th/cmp-path",
 45       "L3MON4D3/LuaSnip",
 45       "saadparwaiz1/cmp_luasnip",
 45     },
 45     config = function()
 45       local cmp = require("cmp")
 45       local luasnip = require("luasnip")
 45
 45       cmp.setup({
 45         snippet = {
 45           expand = function(args)
 45             luasnip.lsp_expand(args.body)
 45           end,
 45         },
 45         mapping = cmp.mapping.preset.insert({
 45           ["<C-d>"] = cmp.mapping.scroll_docs(-4),
 45           ["<C-f>"] = cmp.mapping.scroll_docs(4),
 45           ["<C-Space>"] = cmp.mapping.complete(),
 45           ["<CR>"] = cmp.mapping.confirm({ select = true }),
 45           ["<Tab>"] = cmp.mapping(function(fallback)
 45             if cmp.visible() then
 45               cmp.select_next_item()
 45             elseif luasnip.expand_or_jumpable() then
 45               luasnip.expand_or_jump()
 45             else
 45               fallback()
 45             end
 45           end, { "i", "s" }),
 45         }),
 45         sources = cmp.config.sources({
 45           { name = "nvim_lsp" },
 45           { name = "luasnip" },
 45         }, {
 45           { name = "buffer" },
 45           { name = "path" },
 45         }),
 45       })
 45     end,
 45   },
 45
 45   -- Syntax highlighting
 45   {
 45     "nvim-treesitter/nvim-treesitter",
 45     build = ":TSUpdate",
 45     config = function()
 45       require("nvim-treesitter.configs").setup({
 45         ensure_installed = {
 45           "typescript",
 45           "javascript",
 45           "tsx",
 45           "go",
 45           "python",
 45           "html",
 45           "css",
 45           "json",
 45           "sql",
 45           "lua",
 45           "vim",
 45         },
 45         highlight = { enable = true },
 45         indent = { enable = true },
 45       })
 45     end,
 45   },
 45
 45   -- Git integration
 45   {
 45     "lewis6991/gitsigns.nvim",
 45     config = function()
 45       require("gitsigns").setup()
 45     end,
 45   },
 45
 45   -- Status line
 45   {
 45     "nvim-lualine/lualine.nvim",
 45     dependencies = "nvim-tree/nvim-web-devicons",
 45     config = function()
 45       require("lualine").setup({
 45         options = {
 45           theme = "catppuccin",
 45           component_separators = "|",
 45           section_separators = "",
 45         },
 45       })
 45     end,
 45   },
 45
 45   -- Auto pairs
 45   {
 45     "windwp/nvim-autopairs",
 45     config = function()
 45       require("nvim-autopairs").setup({})
 45       -- Integrate with cmp
 45       local cmp_autopairs = require("nvim-autopairs.completion.cmp")
 45       local cmp = require("cmp")
 45       cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
 45     end,
 45   },
 45
 45   -- Comment toggling
 45   {
 45     "numToStr/Comment.nvim",
 45     config = function()
 45       require("Comment").setup()
 45     end,
 45   },
 45
 45   -- Better terminal
 45   {
 45     "akinsho/toggleterm.nvim",
 45     version = "*",
 45     config = function()
 45       require("toggleterm").setup({
 45         size = 20,
 45         open_mapping = [[<c-\>]],
 45         direction = "horizontal",
 45         shell = vim.o.shell,
 45       })
 45     end,
 45   },
 45 }, {})
 45
 45 -- Key mappings
 45 local keymap = vim.keymap.set
 45
 45 -- Better escape
 45 keymap("i", "jk", "<ESC>")
 45
 45 -- Save and quit
 45 keymap("n", "<leader>w", ":w<CR>")
 45 keymap("n", "<leader>q", ":q<CR>")
 45
 45 -- Better window navigation
 45 keymap("n", "<C-h>", "<C-w>h")
 45 keymap("n", "<C-j>", "<C-w>j")
 45 keymap("n", "<C-k>", "<C-w>k")
 53 keymap("n", "<C-l>", "<C-w>l")
 52
 51 -- Resize windows
 50 keymap("n", "<C-Up>", ":resize -2<CR>")
 49 keymap("n", "<C-Down>", ":resize +2<CR>")
 48 keymap("n", "<C-Left>", ":vertical resize -2<CR>")
 47 keymap("n", "<C-Right>", ":vertical resize +2<CR>")
 46
 45 -- Buffer navigation
 44 keymap("n", "<S-l>", ":bnext<CR>")
 43 keymap("n", "<S-h>", ":bprevious<CR>")
 42 keymap("n", "<leader>bd", ":bdelete<CR>")
 41
 40 -- Move text up and down
 39 keymap("v", "J", ":m '>+1<CR>gv=gv")
 38 keymap("v", "K", ":m '<-2<CR>gv=gv")
 37
 36 -- Stay in indent mode
 35 keymap("v", "<", "<gv")
 34 keymap("v", ">", ">gv")
 33
 32 -- Clear search highlighting
 31 keymap("n", "<leader>h", ":nohlsearch<CR>")
 30
 29 -- Auto commands
 28 local augroup = vim.api.nvim_create_augroup
 27 local autocmd = vim.api.nvim_create_autocmd
 26
 25 -- Highlight on yank
 24 augroup("YankHighlight", { clear = true })
 23 autocmd("TextYankPost", {
 22   group = "YankHighlight",
 21   callback = function()
 20     vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
 19   end,
 18 })
 17
 16 -- Remove trailing whitespace on save
 15 augroup("TrimWhitespace", { clear = true })
 14 autocmd("BufWritePre", {
 13   group = "TrimWhitespace",
 12   pattern = "*",
 11   command = "%s/\\s\\+$//e",
 10 })
  9
  8 -- Auto format on save for specific filetypes
  7 augroup("AutoFormat", { clear = true })
  6 autocmd("BufWritePre", {
  5   group = "AutoFormat",
  4   pattern = { "*.ts", "*.js", "*.tsx", "*.jsx", "*.go", "*.py", "*.html", "*.css", "*.json" },
  3   callback = function()
  2     vim.lsp.buf.format({ async = false })
  1   end,
347 })
