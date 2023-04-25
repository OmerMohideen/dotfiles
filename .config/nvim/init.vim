" Base settings "
:set number
:set mouse=a " set cursor on click
:set autoindent
:set tabstop=4
:set shiftwidth=4 " amount of spaces for tab
:set smarttab
:set encoding=UTF-8
:set guifont=Hack_NF:h11
:set gfw=Hack_NF:h11
:set modifiable

call plug#begin(stdpath('data') . '/plugged')
  " Theme "
  Plug 'catppuccin/nvim', { 'as': 'catppuccin' }

  " Startup Menu " 
  Plug 'goolord/alpha-nvim'
 
  " TypeScript Highlighting "
  Plug 'leafgarland/typescript-vim'
  Plug 'peitalin/vim-jsx-typescript'

  " File Explorer with Icons "
  Plug 'scrooloose/nerdtree'
  Plug 'ryanoasis/vim-devicons'
  Plug 'nvim-tree/nvim-web-devicons'
  Plug 'vwxyutarooo/nerdtree-devicons-syntax'

  " File Search "
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'

  " Auto Pairs "
  Plug 'windwp/nvim-autopairs'

  " Treesitter "
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

  " TS autotag "
  Plug 'windwp/nvim-ts-autotag', {}

  " Preview Markdown "
  Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' } 

  " Telescope "
  Plug 'nvim-telescope/telescope.nvim',
  Plug 'nvim-lua/plenary.nvim'
  
  " LSP "
  Plug 'neovim/nvim-lspconfig'
  Plug 'williamboman/nvim-lsp-installer'
  
  " Tailwind Highlighting "
  Plug 'themaxmarchuk/tailwindcss-colors.nvim'
  Plug 'princejoogie/tailwind-highlight.nvim'

  " Eye Candy
  Plug 'akinsho/bufferline.nvim', { 'tag': 'v3.*' }
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'glepnir/lspsaga.nvim'
  Plug 'folke/trouble.nvim'
  Plug 'onsails/lspkind-nvim'
  Plug 'j-hui/fidget.nvim'

  " Autocomplete
  Plug 'L3MON4D3/LuaSnip'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'saadparwaiz1/cmp_luasnip'

  " Snippet
  Plug 'rafamadriz/friendly-snippets'

  " cmdline
  Plug 'MunifTanjim/nui.nvim'
  Plug 'VonHeikemen/fine-cmdline.nvim'

  " indent-backline
  Plug 'lukas-reineke/indent-blankline.nvim'

  " code format
  Plug 'jose-elias-alvarez/null-ls.nvim'
  Plug 'MunifTanjim/prettier.nvim'

  " lualine
  Plug 'nvim-lualine/lualine.nvim'

  " git 
  Plug 'dinhhuy258/git.nvim'
  Plug 'lewis6991/gitsigns.nvim'  

  " golang
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
call plug#end()

" Enable theming support
if (has("termguicolors"))
	:set termguicolors
endif

" Theme
syntax enable
colorscheme catppuccin-macchiato " catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha

let g:transparent_groups = ['Normal', 'Comment', 'Constant', 'Special', 'Identifier',
                            \ 'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String',
                            \ 'Function', 'Conditional', 'Repeat', 'Operator', 'Structure',
                            \ 'LineNr', 'NonText', 'SignColumn', 'CursorLineNr', 'EndOfBuffer']

let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''

" Automaticaly close nvim if NERDTree is only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Toggle
nnoremap <silent> <C-b> :NERDTreeToggle<CR>

nnoremap <C-p> :FZF<CR>
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit'
  \}

" requires silversearcher-ag
" used to ignore gitignore files
let $FZF_DEFAULT_COMMAND = 'ag -g ""'

" open new split panes to right and below
:set splitright
:set splitbelow

" turn terminal to normal mode with escape
tnoremap <Esc> <C-\><C-n>

" use alt+hjkl to move between split/vsplit panels
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" telescope keymaps
nnoremap <leader>ff <cmd>Telescope find_files<CR>
nnoremap <leader>fg <cmd>Telescope live_grep<CR>
nnoremap <leader>fb <cmd>Telescope buffers<CR>
nnoremap <leader>fh <cmd>Telescope help_tags<CR>

lua << EOF
-- autotag
require("nvim-ts-autotag").setup { enable = true }

-- setup Startup
local alpha = require("alpha")
require("alpha.term")
local function button(sc, txt, keybind)
	local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")
	local opts = {
		position = "center",
		text = txt,
		shortcut = sc,
		cursor = 5,
		width = 36,
		align_shortcut = "right",
		hl = "AlphaButtons",
	}

	if keybind then
		opts.keymap = { "n", sc_, keybind, { noremap = true, silent = true } }
	end

	return {
		type = "button",
		val = txt,
		on_press = function()
			local key = vim.api.nvim_replace_termcodes(sc_, true, false, true)
			vim.api.nvim_feedkeys(key, "normal", false)
		end,
		opts = opts,
	}
end

-- DEFAULT THEME
local default = {}

default.ascii = {
"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣤⣤⣤⣤⡼⠀⢀⡀⣀⢱⡄⡀⠀⠀⠀⢲⣤⣤⣤⣤⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
"⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⣾⣿⣿⣿⣿⣿⡿⠛⠋⠁⣤⣿⣿⣿⣧⣷⠀⠀⠘⠉⠛⢻⣷⣿⣽⣿⣿⣷⣦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀",
"⠀⠀⠀⠀⠀⠀⢀⣴⣞⣽⣿⣿⣿⣿⣿⣿⣿⠁⠀⠀⠠⣿⣿⡟⢻⣿⣿⣇⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣟⢦⡀⠀⠀⠀⠀⠀⠀",
"⠀⠀⠀⠀⠀⣠⣿⡾⣿⣿⣿⣿⣿⠿⣻⣿⣿⡀⠀⠀⠀⢻⣿⣷⡀⠻⣧⣿⠆⠀⠀⠀⠀⣿⣿⣿⡻⣿⣿⣿⣿⣿⠿⣽⣦⡀⠀⠀⠀⠀",
"⠀⠀⠀⠀⣼⠟⣩⣾⣿⣿⣿⢟⣵⣾⣿⣿⣿⣧⠀⠀⠀⠈⠿⣿⣿⣷⣈⠁⠀⠀⠀⠀⣰⣿⣿⣿⣿⣮⣟⢯⣿⣿⣷⣬⡻⣷⡄⠀⠀⠀",
"⠀⠀⢀⡜⣡⣾⣿⢿⣿⣿⣿⣿⣿⢟⣵⣿⣿⣿⣷⣄⠀⣰⣿⣿⣿⣿⣿⣷⣄⠀⢀⣼⣿⣿⣿⣷⡹⣿⣿⣿⣿⣿⣿⢿⣿⣮⡳⡄⠀⠀",
"⠀⢠⢟⣿⡿⠋⣠⣾⢿⣿⣿⠟⢃⣾⢟⣿⢿⣿⣿⣿⣾⡿⠟⠻⣿⣻⣿⣏⠻⣿⣾⣿⣿⣿⣿⡛⣿⡌⠻⣿⣿⡿⣿⣦⡙⢿⣿⡝⣆⠀",
"⠀⢯⣿⠏⣠⠞⠋⠀⣠⡿⠋⢀⣿⠁⢸⡏⣿⠿⣿⣿⠃⢠⣴⣾⣿⣿⣿⡟⠀⠘⢹⣿⠟⣿⣾⣷⠈⣿⡄⠘⢿⣦⠀⠈⠻⣆⠙⣿⣜⠆",
"⢀⣿⠃⡴⠃⢀⡠⠞⠋⠀⠀⠼⠋⠀⠸⡇⠻⠀⠈⠃⠀⣧⢋⣼⣿⣿⣿⣷⣆⠀⠈⠁⠀⠟⠁⡟⠀⠈⠻⠀⠀⠉⠳⢦⡀⠈⢣⠈⢿⡄",
"⣸⠇⢠⣷⠞⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠻⠿⠿⠋⠀⢻⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⢾⣆⠈⣷",
"⡟⠀⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣶⣤⡀⢸⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡄⢹",
"⡇⠀⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠈⣿⣼⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠃⢸",
"⢡⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⠶⣶⡟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡼",
"⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡾⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁",
"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡁⢠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣼⣀⣠⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
		}

default.header = {
	type = "text",
	val = default.ascii,
	opts = {
		position = "center",
		hl = "White" 
	},
}

default.buttons = {
	type = "group",
	val = {
		button("e", "  New File    ", ":enew<CR>"),
		button("f", "  Find File   ", ":Telescope find_files<CR>"),
		button("t", "  Find Text   ", ":Telescope live_grep<CR>"),
		button("c", "  NVIM Config ", ":e C:/Users/MPZ/AppData/Local/nvim/init.vim <CR>"),
		button("q", "  Quit        ", ":qa<CR>"),	
		},
	position = "center",
	opts = {
		spacing = 1,
		}
}

-- load config
alpha.setup({
	layout = {
		{ type = "padding", val = 20 },
		default.header,
		{ type = "padding", val = 1 },
		default.buttons,
	},
	opts = {},
})

vim.api.nvim_set_keymap("n", "<leader>a", "<cmd>Alpha<CR>", { noremap = true, silent = true})

-- setup nvim-autopairs
require("nvim-autopairs").setup ({
	disable_filetype = {"TelescopePrompt"}
})

-- setup nvim_lsp 
require("nvim-lsp-installer").setup {}
local protocol = require('vim.lsp.protocol')
local nvim_lsp = require("lspconfig")

local tw_highlight = require('tailwind-highlight')
protocol.CompletionItemKind = {
	'', -- Text
 	'', -- Method
  	'', -- Function
  	'', -- Constructor
  	'', -- Field
  	'', -- Variable
  	'', -- Class
  	'ﰮ', -- Interface
  	'', -- Module
  	'', -- Property
  	'', -- Unit
 	'', -- Value
  	'', -- Enum
  	'', -- Keyword
  	'﬌', -- Snippet
  	'', -- Color
  	'', -- File
  	'', -- Reference
  	'', -- Folder
  	'', -- EnumMember
  	'', -- Constant
  	'', -- Struct
  	'', -- Event
  	'ﬦ', -- Operator
  	'', -- TypeParameter
}
local capabilities = require('cmp_nvim_lsp').default_capabilities(
  	vim.lsp.protocol.make_client_capabilities()
)

nvim_lsp.flow.setup {
  	on_attach = on_attach,
  	capabilities = capabilities
}

nvim_lsp.tsserver.setup {
  	on_attach = on_attach,
  	filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
  	cmd = { "typescript-language-server.cmd", "--stdio" },
  	capabilities = capabilities
}

nvim_lsp.lua_ls.setup {
	on_attach = on_attach,
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	capabilities = capabilities
}

nvim_lsp.tailwindcss.setup({
  	on_attach = function(client, bufnr)
    	tw_highlight.setup(client, bufnr, {
      		single_column = false,
      		mode = 'background',
      		debounce = 200,
    	})
  	end,
	cmd = { "tailwindcss-language-server.cmd", "--stdio" },
  	capabilities = capabilities
})

nvim_lsp.vimls.setup {
	on_attach = on_attach,
	filetypes = { "vim"},
	capabilities = capabilities
}

nvim_lsp.sqlls.setup {
	on_attach = on_attach,
	filetypes = { "sql", "php" },
	capabilities = capabilities
}

nvim_lsp.html.setup {
	on_attach = on_attach,
	capabilities = capabilities
}

nvim_lsp.intelephense.setup {
	on_attach = on_attach,
	capabilities = capabilities
}

nvim_lsp.pyright.setup {
	on_attach = on_attach,
	capabilities = capabilities
}

nvim_lsp.gopls.setup {
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = {"gopls", "serve"},
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
			linksInHover = false,
			codelenses = {
				generate = true,
				gc_details = true,
				regenerate_cgo = true,
				tidy = true,
				upgrade_depdendency = true,
				vendor = true,
			},
			usePlaceholders = true,
		},
	},
}
-- setup lspsaga
require("lspsaga").setup ({
 	ui = {
        kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
	},
  	server_filetype_map = {
    	typescript = 'typescript'
  	}
})

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<C-j>', '<Cmd>Lspsaga diagnostic_jump_next<CR>', opts)
vim.api.nvim_set_keymap('n', 'K', '<Cmd>Lspsaga hover_doc<CR>', opts)
vim.api.nvim_set_keymap('n', 'gd', '<Cmd>Lspsaga lsp_finder<CR>', opts)
vim.api.nvim_set_keymap('i', '<C-k>', '<Cmd>Lspsaga signature_help<CR>', opts)
vim.api.nvim_set_keymap('n', 'gp', '<Cmd>Lspsaga preview_definition<CR>', opts)
vim.api.nvim_set_keymap('n', 'gr', '<Cmd>Lspsaga rename<CR>', opts)

-- setup nvim-cmp
local lspkind = require 'lspkind'
local cmp = require 'cmp'
require("luasnip.loaders.from_vscode").lazy_load()
cmp.setup ({
	snippet = {
		expand = function(args)
      		require('luasnip').lsp_expand(args.body)
    	end,
	},
 mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true
    }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
	{ name = 'luasnip'},
  }, {
    { name = 'buffer' },
  }),
  formatting = {
    format = lspkind.cmp_format({ with_text = false, maxwidth = 50 })
  }
})

vim.cmd [[
  set completeopt=menuone,noinsert,noselect
  highlight! default link CmpItemKind CmpItemMenuDefault
]]

-- Show line diagnostics automatically in hover window
vim.o.updatetime = 250
vim.cmd [[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]


-- Diagnostic symbols in the sign column (gutter)
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.diagnostic.config({
  virtual_text = {
    prefix = '●'
  },
  update_in_insert = true,
  float = {
    source = "always", -- Or "if_many"
  },
})

-- setup bufferline
require("bufferline").setup({
  options = {
    -- mode = "tabs",
    -- separator_style = 'slant',
    always_show_bufferline = false,
    show_buffer_close_icons = false,
    show_close_icon = false,
    color_icons = true,
	offsets = {{ filetype = "nerdtree", text = "", padding = 1}},
  },
  highlights = {
	  buffer_selected = {
		  bold = true,
		  italic = false
		  }
	  }
})

vim.api.nvim_set_keymap('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>', {})
vim.api.nvim_set_keymap('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', {})

-- setup fidget
require"fidget".setup{}

-- setup cmdline (Remove comment once PlugInstall is completed)
-- vim.api.nvim_set_keymap('n', ':', '<cmd>FineCmdline<CR>', {noremap = true})

-- setup indent-backline
require("indent_blankline").setup {}

-- trouble keymap
vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
  {silent = true, noremap = true}
)

-- code format
local null_ls = require("null-ls")
local prettier = require("prettier")

null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.eslint_d.with({
      diagnostics_format = '[eslint] #{m}\n(#{c})'
    }),
    null_ls.builtins.diagnostics.fish
  }
})

prettier.setup {
  bin = 'prettierd',
  filetypes = {
    "css",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "json",
    "scss",
    "less"
  }
}

-- setup lualine
local lualine = require("lualine")
lualine.setup {
	options = {
		icons_enabled = true,
		theme = 'catppuccin',
		section_separators = { left = '', right = '' },
		component_separators = { left = '', right = '' },
		disabled_filetypes = { "alpha", "nerdtree", "toggleterm" }
	},
	sections = {
		lualine_a = { 'mode'   },
		lualine_b = { 'branch' },
		lualine_c = { {
			'filename',
			file_status = true, -- displays file status (readonly status, modified status)
			path = 0 -- 0 = just filename, 1 = relative path, 2 = absolute path
		} },
		lualine_x = {
			{ 'diagnostics', sources = { "nvim_diagnostic" }, symbols = { error = ' ', warn = ' ', info = ' ',
			hint = ' ' } },
			'encoding',
			'filetype'
		},
		lualine_y = { 'progress' },
		lualine_z = { 'location' }
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { {
			'filename',
			file_status = true, -- displays file status (readonly status, modified status)
			path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
		} },
		lualine_x = { 'location' },
		lualine_y = {},
		lualine_z = {}
	},
	tabline = {},
	extensions = { 'fugitive', 'nerdtree' }
}

-- Transparency
vim.g.transparent_groups = vim.list_extend(
  vim.g.transparent_groups or {},
  vim.tbl_map(function(v)
    return v.hl_group
  end, 
  	vim.tbl_values(require('bufferline.config').highlights))
)

-- Git 
require('gitsigns').setup()
require('git').setup({
  keymaps = {
    -- Open blame window
    blame = "<Leader>gb",
    -- Open file/folder in git repository
    browse = "<Leader>go",
  }
})
EOF
