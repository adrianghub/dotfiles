set scrolloff=8
set number
set relativenumber
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set termguicolors
set background=dark

" Leader key
let mapleader = " "

" vim-plug
call plug#begin()

" Core dependencies
Plug 'nvim-lua/plenary.nvim'              " Utility functions for Lua plugins
Plug 'nvim-lua/popup.nvim'                " Popup API for Neovim
Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' } " Fuzzy Finder
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' } " Faster Telescope
Plug 'nvim-tree/nvim-tree.lua'            " File explorer
Plug 'nvim-lualine/lualine.nvim'          " Status line
Plug 'akinsho/toggleterm.nvim'            " Terminal inside Neovim
Plug 'Luxed/ayu-vim'                      " Color scheme
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " Syntax highlighting
Plug 'windwp/nvim-ts-autotag'             " Auto close and rename JSX/HTML tags

" LSP, Autocompletion, and Snippets
Plug 'neovim/nvim-lspconfig'              " LSP configurations
Plug 'williamboman/mason.nvim'            " LSP installer
Plug 'williamboman/mason-lspconfig.nvim'  " Integrates Mason with lspconfig
Plug 'hrsh7th/nvim-cmp'                   " Autocompletion engine
Plug 'hrsh7th/cmp-nvim-lsp'               " LSP completions
Plug 'hrsh7th/cmp-buffer'                 " Buffer completions
Plug 'L3MON4D3/LuaSnip'                   " Snippets engine
Plug 'saadparwaiz1/cmp_luasnip'           " Snippets source for nvim-cmp
Plug 'rafamadriz/friendly-snippets'       " Predefined snippets

" Formatting and linting
Plug 'jose-elias-alvarez/null-ls.nvim'    " Use LSP for linters & formatters
Plug 'MunifTanjim/prettier.nvim'          " Prettier integration

" Debugging
Plug 'mfussenegger/nvim-dap'              " Debug Adapter Protocol (DAP)
Plug 'rcarriga/nvim-dap-ui'               " Debugging UI

" Git Integration
Plug 'tpope/vim-fugitive'                 " Git commands
Plug 'lewis6991/gitsigns.nvim'            " Git diff signs

Plug 'ThePrimeagen/vim-be-good'
call plug#end()

" Reload Configuration
nnoremap <leader><CR> :so ~/.config/nvim/init.vim<CR>

" General UI Enhancements
set signcolumn=yes
set cursorline

" Colorscheme
let ayucolor="dark"
colorscheme ayu

" Lualine Setup
lua << EOF
require('lualine').setup({
  options = {
    theme = 'ayu_dark',
    icons_enabled = true,
  }
})
EOF

" Nvim-tree Setup
lua << EOF
require('nvim-tree').setup({
  view = {
    side = 'left',
    width = 30,
  },
  git = {
    enable = true,
  }
})
EOF
nnoremap <leader>e :NvimTreeToggle<CR>

lua << EOF
require('nvim-treesitter.configs').setup({
  ensure_installed = { "javascript", "typescript", "tsx", "html", "css", "json", "yaml" },
  highlight = {
    enable = true,
  },
  autotag = {
    enable = true,
  },
})
EOF

lua << EOF
require('mason').setup()

require('mason-lspconfig').setup({
  ensure_installed = {
    'ts_ls',
    'eslint',
    'html', 
    'cssls',
    'jsonls',
    'tailwindcss',
  },
})

-- LSP Configurations
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

require('lspconfig').ts_ls.setup({
  capabilities = capabilities,
  on_attach = function(_, bufnr)
    local opts = { noremap = true, silent = true }

    -- Keymaps for LSP functions
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to definition" })
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover documentation" })
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename symbol" })
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code action" })
  end,
})
EOF

" Autocompletion Settings
lua << EOF
local cmp_status, cmp = pcall(require, 'cmp')
if not cmp_status then
  print("Error: cmp not loaded")
  return
end

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<C-e>'] = cmp.mapping.abort(),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  }),
})
EOF

" Telescope Keymaps
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Git Signs
lua << EOF
require('gitsigns').setup({
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
})
EOF

" Quality of Life Improvements
vnoremap <leader>p "_dP   " Paste without replacing register
nnoremap <leader>y "+y   " Yank to system clipboard
vnoremap <leader>y "+y
nnoremap <leader>Y gg"+yG

" Debug Adapter Protocol (DAP) Keymaps
nnoremap <leader>db :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <leader>dc :lua require'dap'.continue()<CR>
nnoremap <leader>ds :lua require'dap'.step_over()<CR>
nnoremap <leader>di :lua require'dap'.step_into()<CR>

" Terminal Toggle
lua << EOF
require("toggleterm").setup{
  open_mapping = [[<c-\>]],
  direction = "horizontal",
  size = 15,
}
EOF
