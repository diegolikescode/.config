-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
local lazyrepo = "https://github.com/folke/lazy.nvim.git"
local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
if vim.v.shell_error ~= 0 then
vim.api.nvim_echo({
    { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
    { out, "WarningMsg" },
    { "\nPress any key to exit..." },
    }, true, {})
  vim.fn.getchar()
os.exit(1)
  end
  end
  vim.opt.rtp:prepend(lazypath)

  -- Make sure to setup `mapleader` and `maplocalleader` before
  -- loading lazy.nvim so that mappings are correct.
  -- This is also a good place to setup other settings (vim.opt)
  vim.g.mapleader = " "
  vim.g.maplocalleader = "\\"

require('lazy').setup({
  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    init = function()
      vim.cmd("colorscheme kanagawa")
      vim.cmd.hi 'Comment gui=none'
    end
  },
  'tpope/vim-sleuth',
  {
    'jose-elias-alvarez/null-ls.nvim',
    event = 'VeryLazy',
    opts = function ()
      return require('belisarius.null-ls')
    end
  },
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      'nvim-telescope/telescope-ui-select.nvim',

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'javascript',
        'typescript',
        'go',
        'rust',
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },
  'nvim-treesitter/playground',
  'nvim-lua/plenary.nvim',
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },

  },
  'mbbill/undotree',
  'tpope/vim-fugitive',
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    -- Optional dependency
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      require('nvim-autopairs').setup {}
      -- If you want to automatically add `(` after selecting a function or method
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      local cmp = require 'cmp'
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },
  {
    'williamboman/mason.nvim',
    cmd = { 'Mason', 'MasonInstall', 'MasonInstallAll', 'MasonUpdate' },
    opts = {
      ensure_installed = {
        'clangd',
        'clang-format',
        'codelldb',
        'gopls',
        'lua_ls',
        "lua-language-server",
        'typescript-language-server',
        'eslint-lsp',
        'prettier'
      },
      ui = {
        icons = {
          package_pending = " ",
          package_installed = "󰄳 ",
          package_uninstalled = " 󰚌",
        },

        keymaps = {
          toggle_server_expand = "<CR>",
          install_server = "i",
          update_server = "u",
          check_server_version = "c",
          update_all_servers = "U",
          check_outdated_servers = "C",
          uninstall_server = "X",
          -- cancel_installation = "<C-c>",
        },
      },
    }
  },
  {
    'mfussenegger/nvim-lint',
    event = 'VeryLazy',
    config = function ()
      require 'plugins.lint'
    end
  },
  -- {
  --   "nvim-neotest/neotest",
  --   event = 'VeryLazy',
  --   dependencies = {
  --     "nvim-neotest/nvim-nio",
  --     "nvim-lua/plenary.nvim",
  --     "antoinemadec/FixCursorHold.nvim",
  --     'nvim-neotest/neotest-jest',
  --     "nvim-treesitter/nvim-treesitter"
  --   },
  --   config = function ()
  --     require 'belisarius.test'
  --   end
  -- },
  {
    'mhartington/formatter.nvim',
    event = 'VeryLazy',
    opts = function ()
      return require 'belisarius.formatter'
    end
  },
  {'williamboman/mason-lspconfig.nvim'},
  require 'plugins.gitsigns',
  {'VonHeikemen/lsp-zero.nvim', branch = 'v4.x'},
  {
    'neovim/nvim-lspconfig',
    config = function ()
      require 'belisarius.lspconfig'
    end
  },
  {'hrsh7th/cmp-nvim-lsp'},
  {'hrsh7th/nvim-cmp'},
  {'numToStr/Comment.nvim'},
  {'vim-test/vim-test'}
},
  -- TODO: verify this thing
  {
    ui = {
      icons = vim.g.have_nerd_font and {} or {
        cmd = '⌘',
        config = '🛠',
        event = '📅',
        ft = '📂',
        init = '⚙',
        keys = '🗝',
        plugin = '🔌',
        runtime = '💻',
        require = '🌙',
        source = '📄',
        start = '🚀',
        task = '📌',
        lazy = '💤 ',
      },
    },
  }
)
