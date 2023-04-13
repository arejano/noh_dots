--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================

I have left several `:help X` comments throughout the init.lua
You should run that command and read the help for the section for more information.

In addition, I have some `NOTE:` items throughout the file.
These are for you, the reader to help understand what is happening. Feel free to delete
them once you know what you're doing, but they should serve as a guide for when you
are first encountering a few different constructs in your nvim config.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now :)

--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.laststatus = 3
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = true;
vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration
  'andreasvc/vim-256noir',

  'rebelot/kanagawa.nvim',

  'folke/tokyonight.nvim',

  'catppuccin/nvim',
  'rose-pine/neovim',
  { 'stevearc/aerial.nvim',
    config = function()
      require('aerial').setup({
        width = 50,
        default_direction = "prefer_left",
        placement = "edge",
      })

      vim.keymap.set("n", "<leader>at", ":AerialToggle<cr>")

    end },

  { 'simrat39/rust-tools.nvim',

    config = function()
      local opts = {
        tools = { -- rust-tools options

          -- how to execute terminal commands
          -- options right now: termopen / quickfix
          executor = require("rust-tools.executors").termopen,

          -- callback to execute once rust-analyzer is done initializing the workspace
          -- The callback receives one parameter indicating the `health` of the server: "ok" | "warning" | "error"
          on_initialized = nil,

          -- automatically call RustReloadWorkspace when writing to a Cargo.toml file.
          reload_workspace_from_cargo_toml = true,

          -- These apply to the default RustSetInlayHints command
          inlay_hints = {
            -- automatically set inlay hints (type hints)
            -- default: true
            auto = true,

            -- Only show inlay hints for the current line
            only_current_line = false,

            -- whether to show parameter hints with the inlay hints or not
            -- default: true
            show_parameter_hints = true,

            -- prefix for parameter hints
            -- default: "<-"
            parameter_hints_prefix = "<- ",

            -- prefix for all the other hints (type, chaining)
            -- default: "=>"
            other_hints_prefix = "=> ",

            -- whether to align to the length of the longest line in the file
            max_len_align = false,

            -- padding from the left if max_len_align is true
            max_len_align_padding = 1,

            -- whether to align to the extreme right or not
            right_align = false,

            -- padding from the right if right_align is true
            right_align_padding = 7,

            -- The color of the hints
            highlight = "Comment",
          },

          -- options same as lsp hover / vim.lsp.util.open_floating_preview()
          hover_actions = {

            -- the border that is used for the hover window
            -- see vim.api.nvim_open_win()
            border = {
              { "╭", "FloatBorder" },
              { "─", "FloatBorder" },
              { "╮", "FloatBorder" },
              { "│", "FloatBorder" },
              { "╯", "FloatBorder" },
              { "─", "FloatBorder" },
              { "╰", "FloatBorder" },
              { "│", "FloatBorder" },
            },

            -- Maximal width of the hover window. Nil means no max.
            max_width = nil,

            -- Maximal height of the hover window. Nil means no max.
            max_height = nil,

            -- whether the hover action window gets automatically focused
            -- default: false
            auto_focus = false,
          },

          -- settings for showing the crate graph based on graphviz and the dot
          -- command
          crate_graph = {
            -- Backend used for displaying the graph
            -- see: https://graphviz.org/docs/outputs/
            -- default: x11
            backend = "x11",
            -- where to store the output, nil for no output stored (relative
            -- path from pwd)
            -- default: nil
            output = nil,
            -- true for all crates.io and external crates, false only the local
            -- crates
            -- default: true
            full = true,

            -- List of backends found on: https://graphviz.org/docs/outputs/
            -- Is used for input validation and autocompletion
            -- Last updated: 2021-08-26
            enabled_graphviz_backends = {
              "bmp",
              "cgimage",
              "canon",
              "dot",
              "gv",
              "xdot",
              "xdot1.2",
              "xdot1.4",
              "eps",
              "exr",
              "fig",
              "gd",
              "gd2",
              "gif",
              "gtk",
              "ico",
              "cmap",
              "ismap",
              "imap",
              "cmapx",
              "imap_np",
              "cmapx_np",
              "jpg",
              "jpeg",
              "jpe",
              "jp2",
              "json",
              "json0",
              "dot_json",
              "xdot_json",
              "pdf",
              "pic",
              "pct",
              "pict",
              "plain",
              "plain-ext",
              "png",
              "pov",
              "ps",
              "ps2",
              "psd",
              "sgi",
              "svg",
              "svgz",
              "tga",
              "tiff",
              "tif",
              "tk",
              "vml",
              "vmlz",
              "wbmp",
              "webp",
              "xlib",
              "x11",
            },
          },
        },

        -- all the opts to send to nvim-lspconfig
        -- these override the defaults set by rust-tools.nvim
        -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
        server = {
          -- standalone file support
          -- setting it to false may improve startup time
          standalone = true,
        }, -- rust-analyzer options

        -- debugging stuff
        dap = {
          adapter = {
            type = "executable",
            command = "lldb-vscode",
            name = "rt_lldb",
          },
        },
      }
      require("rust-tools").setup(opts)
    end },
  'mfussenegger/nvim-dap',
  "ellisonleao/gruvbox.nvim",
  'ziglang/zig.vim',
  'Exafunction/codeium.vim',
  { 'theprimeagen/harpoon',
    config = function()

      local mark = require('harpoon.mark')
      local ui = require('harpoon.ui')

      vim.keymap.set("n", "<A-a>", mark.add_file)
      vim.keymap.set("n", "<A-e>", ui.toggle_quick_menu)

      vim.keymap.set("n", "<A-1>", function() ui.nav_file(1) end)
      vim.keymap.set("n", "<A-2>", function() ui.nav_file(2) end)
      vim.keymap.set("n", "<A-3>", function() ui.nav_file(3) end)
      vim.keymap.set("n", "<A-4>", function() ui.nav_file(4) end)
    end
  },
  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  { "Pocco81/true-zen.nvim",
    config = function()
      require("true-zen").setup(
        {
          modes = { -- configurations per mode
            ataraxis = {
              shade = "dark", -- if `dark` then dim the padding windows, otherwise if it's `light` it'll brighten said windows
              backdrop = 0, -- percentage by which padding windows should be dimmed/brightened. Must be a number between 0 and 1. Set to 0 to keep the same background color
              minimum_writing_area = { -- minimum size of main window
                width = 10,
                height = 44,
              },
              quit_untoggles = true, -- type :q or :qa to quit Ataraxis mode
              padding = { -- padding windows
                left = 52,
                right = 52,
                top = 0,
                bottom = 0,
              },
              callbacks = { -- run functions when opening/closing Ataraxis mode
                open_pre = nil,
                open_pos = nil,
                close_pre = nil,
                close_pos = nil
              },
            },
            minimalist = {
              ignored_buf_types = { "nofile" }, -- save current options from any window except ones displaying these kinds of buffers
              options = { -- options to be disabled when entering Minimalist mode
                number = false,
                relativenumber = false,
                showtabline = 0,
                signcolumn = "no",
                statusline = "",
                cmdheight = 1,
                laststatus = 0,
                showcmd = false,
                showmode = false,
                ruler = false,
                numberwidth = 1
              },
              callbacks = { -- run functions when opening/closing Minimalist mode
                open_pre = nil,
                open_pos = nil,
                close_pre = nil,
                close_pos = nil
              },
            },
            narrow = {
              --- change the style of the fold lines. Set it to:
              --- `informative`: to get nice pre-baked folds
              --- `invisible`: hide them
              --- function() end: pass a custom func with your fold lines. See :h foldtext
              folds_style = "informative",
              run_ataraxis = true, -- display narrowed text in a Ataraxis session
              callbacks = { -- run functions when opening/closing Narrow mode
                open_pre = nil,
                open_pos = nil,
                close_pre = nil,
                close_pos = nil
              },
            },
            focus = {
              callbacks = { -- run functions when opening/closing Focus mode
                open_pre = nil,
                open_pos = nil,
                close_pre = nil,
                close_pos = nil
              },
            }
          },
          integrations = {
            tmux = false, -- hide tmux status bar in (minimalist, ataraxis)
            kitty = { -- increment font size in Kitty. Note: you must set `allow_remote_control socket-only` and `listen_on unix:/tmp/kitty` in your personal config (ataraxis)
              enabled = false,
              font = "+3"
            },
            twilight = false, -- enable twilight (ataraxis)
            lualine = false -- hide nvim-lualine (ataraxis)
          },
        }
      )

      -- Reload Source
      vim.keymap.set("n", "<leader>zf", require("true-zen").focus, { noremap = true })
      vim.keymap.set("n", "<leader>zm", require("true-zen").minimalist, { noremap = true })
      vim.keymap.set("n", "<leader>za", require("true-zen").ataraxis, { noremap = true })

    end
  },


  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      { -- Useful status updates for LSP
        'j-hui/fidget.nvim',
        config = function()
          require('fidget').setup()
        end,
      },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  { -- Autopairs
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end
  },

  { 'filipdutescu/renamer.nvim',
    config = function()
      vim.keymap.set("n", "<leader>rn", function() require("renamer").rename() end)
    end
  },

  { 'folke/trouble.nvim',
    config = function()
      require("trouble").setup({

        position = "bottom", -- position of the list can be: bottom, top, left, right
        height = 10, -- height of the trouble list when position is top or bottom
        width = 50, -- width of the list when position is left or right
        icons = false, -- use devicons for filenames
        mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
        fold_open = "", -- icon used for open folds
        fold_closed = "", -- icon used for closed folds
        group = true, -- group results by file
        padding = true, -- add an extra new line on top of the list
        action_keys = { -- key mappings for actions in the trouble list
          -- map to {} to remove a mapping, for example:
          -- close = {},
          close = "q", -- close the list
          cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
          refresh = "r", -- manually refresh
          jump = { "<cr>", "<tab>" }, -- jump to the diagnostic or open / close folds
          open_split = { "<c-x>" }, -- open buffer in new split
          open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
          open_tab = { "<c-t>" }, -- open buffer in new tab
          jump_close = { "o" }, -- jump to the diagnostic and close the list
          toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
          toggle_preview = "P", -- toggle auto_preview
          hover = "K", -- opens a small popup with the full multiline message
          preview = "p", -- preview the diagnostic location
          close_folds = { "zM", "zm" }, -- close all folds
          open_folds = { "zR", "zr" }, -- open all folds
          toggle_fold = { "zA", "za" }, -- toggle fold of current file
          previous = "k", -- previous item
          next = "j" -- next item
        },
        indent_lines = true, -- add an indent guide below the fold icons
        auto_open = false, -- automatically open the list when you have diagnostics
        auto_close = false, -- automatically close the list when you have no diagnostics
        auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
        auto_fold = false, -- automatically fold a file trouble list at creation
        auto_jump = { "lsp_definitions" }, -- for the given modes, automatically jump if there is only a single result
        signs = {
          -- icons / text used for a diagnostic
          error = "",
          warning = "",
          hint = "",
          information = "",
          other = "﫠"
        },
        use_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
      })

      vim.keymap.set("n", "<F1>", function()
        vim.cmd("TroubleToggle")
      end)

    end },

  { "folke/todo-comments.nvim", },

  { "chentoast/marks.nvim" },


  { -- File explorer
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    tag = 'nightly', -- optional, updated every week. (see issue #1193)
    config = function()
      require("nvim-tree").setup()

      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<cr>")
      vim.keymap.set("n", "<leader>o", ":NvimTreeFocus<cr>")
    end
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
  },

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require('which-key').setup {}
    end,
  },

  { -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    config = function()
      -- See `:help gitsigns.txt`
      require('gitsigns').setup {
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
      }
    end,
  },

  { -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    config = function()
      -- vim.cmd.colorscheme 'onedark'
    end,
  },

  { -- Fancier statusline
    'nvim-lualine/lualine.nvim',
    config = function()
      -- Set lualine as statusline
      -- See `:help lualine.txt`
      require('lualine').setup {
        options = {
          icons_enabled = false,
          theme = 'rose-pine',
          component_separators = '|',
          section_separators = '',
        },
      }
    end,
  },

  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      -- Enable `lukas-reineke/indent-blankline.nvim`
      -- See `:help indent_blankline.txt`
      require('indent_blankline').setup {
        char = '┊',
        show_trailing_blankline_indent = false,
      }
    end,
  },

  { -- "gc" to comment visual regions/lines
    'numToStr/Comment.nvim',
    config = function()

      local api = require("Comment.api")

      vim.keymap.set("n", "<leader>/",
        function()
          api.toggle.linewise.current()
        end
      )
      vim.keymap.set("v", "<leader>/",
        "<esc><cmd>lua require('Comment.api').toggle.linewise.current(vim.fn.visualmode())<cr>"
      )
      require('Comment').setup()
    end,
  },
  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  },

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: Add your own custom plugins to `lua/custom/plugins/*.lua`
  --    There are examples in the README.md for kickstar.nvim
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  { import = 'custom.plugins' },
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
--[[ vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true }) ]]

vim.keymap.set({ 'n', 'v', 'i' }, '<C-s>', '<esc><cmd>w!<cr>', { silent = true })

-- grep string command line
vim.keymap.set('n', '<leader>fs', function()
  require('telescope.builtin').grep_string({
    search = vim.fn.input("find: ")
  })
end)

-- nohkeys

vim.keymap.set("n", "<S-l>", ":bnext<CR>")
vim.keymap.set("n", "<S-h>", ":bprevious<CR>")

-- Center in search
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")


-- Split Right
vim.keymap.set({ 'n' }, '<leader>v', ':vsplit<cr>', { silent = true })
-- Split Down
vim.keymap.set({ 'n' }, '<leader>sh', ':split<cr>', { silent = true })

--Exit
vim.keymap.set({ 'n', 'v' }, '<leader>q', ':q<cr>', { silent = true })
--Duplicate Line
vim.keymap.set({ 'n' }, '<A-d>', 'yyp', { silent = true })

vim.keymap.set({ 'n' }, '<leader>cs', ':source<cr>', { silent = true })

-- Move in  splits
vim.keymap.set({ 'n' }, '<C-h>', '<C-w>h', { silent = true })
vim.keymap.set({ 'n' }, '<C-j>', '<C-w>j', { silent = true })
vim.keymap.set({ 'n' }, '<C-k>', '<C-w>k', { silent = true })
vim.keymap.set({ 'n' }, '<C-l>', '<C-w>l', { silent = true })

vim.keymap.set({ 'n', }, '<C-f>',
  function()
    vim.lsp.buf.format()
  end
  , { silent = true }
)


-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    layout_strategies = "horizontal",
    layout_config ={
      horizontal = {
        prompt_position = "top",
      }
    },
    sorting_strategy = "ascending",
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>w', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
--vim.keymap.set('n', '<leader>/', function()
-- You can pass additional configuration to telescope to change theme, layout, etc.
--require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
--winblend = 10,
--previewer = false,
--})
--end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<C-p>', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>fw', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'help', 'vim' },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,

  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist)

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ls', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>la', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>lr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>ll', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    --['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et


-- ColorMyPencils
function ColorMyPencils()
  local time = tonumber(os.date('%H', os.time()))

  if time < 18 then
    GruvLightBoxTheme()
  else
    CatTheme();
  end

end

function CatTheme()
  vim.cmd("colorscheme catppuccin-frappe")
  vim.api.nvim_set_hl(0, "Normal", { bg = "#0c0c0c" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  vim.cmd("highlight! link SignColumn LineNr")
end

function CatLightTheme()
  vim.cmd("colorscheme catppuccin-latte")
  vim.api.nvim_set_hl(0, "Normal", { bg = "#0c0c0c" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  vim.cmd("highlight! link SignColumn LineNr")
end

function GruvLightBoxTheme()
  vim.cmd("colorscheme gruvbox")
  vim.opt.background = "light"
  vim.cmd("highlight! link SignColumn LineNr")
end

vim.cmd("set winbar=%f")

ColorMyPencils()
