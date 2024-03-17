lvim.colorscheme = "tokyonight"
lvim.log.level = "warn"
vim.lsp.set_log_level("error")
lvim.lsp.code_lens_refresh = true
lvim.builtin.presence = { active = true }

lvim.builtin.telescope.on_config_done = function(telescope)
  pcall(telescope.load_extension, "telescope-project")
  pcall(telescope.load_extension, "neoclip")
  -- any other extensions loading
end

lvim.builtin.treesitter.rainbow = { enabled = true }

lvim.builtin.which_key.mappings["t"] = {
  name = "Diagnostics",
  t = { "<cmd>TroubleToggle<cr>", "trouble" },
  w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "workspace" },
  d = { "<cmd>TroubleToggle document_diagnostics<cr>", "document" },
  q = { "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
  l = { "<cmd>TroubleToggle loclist<cr>", "loclist" },
  r = { "<cmd>TroubleToggle lsp_references<cr>", "references" },
}

lvim.builtin.which_key.mappings["S"] = {
  name = "Session",
  c    = { "<cmd>lua require('persistence').load()<cr>", "Restore last session for current dir" },
  l    = { "<cmd>lua require('persistence').load({ last = true })<cr>", "Restore last session" },
  Q    = { "<cmd>lua require('persistence').stop()<cr>", "Quit without saving session" },
}

lvim.plugins = {
  { "lunarvim/colorschemes" },
  { "MunifTanjim/nui.nvim" },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  {
    "stevearc/dressing.nvim",
    config = function()
      require("dressing").setup({
        input = { enabled = false },
      })
    end,
  },
  {
    "nvim-neorg/neorg",
    ft = "norg",   -- lazy-load on filetype
    config = true, -- run require("neorg").setup()
  },
  {
    "ggandor/leap.nvim",
    name = "leap",
    config = function()
      require("leap").add_default_mappings()
    end,
  },
  {
    "kevinhwang91/rnvimr",
    cmd = "RnvimrToggle",
    config = function()
      vim.g.rnvimr_draw_border = 1
      vim.g.rnvimr_pick_enable = 1
      vim.g.rnvimr_bw_enable = 1
    end,
  },
  { "HiPhish/nvim-ts-rainbow2" },
  {
    "romgrk/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup {
        enable = true,   -- Enable this plugin (Can be enabled/disabled later via commands)
        throttle = true, -- Throttles plugin updates (may improve performance)
        max_lines = 0,   -- How many lines the window should span. Values <= 0 mean no limit.
        patterns = {     -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
          -- For all filetypes
          -- Note that setting an entry here replaces all other patterns for this entry.
          -- By setting the 'default' entry below, you can control which nodes you want to
          -- appear in the context window.
          default = {
            'class',
            'function',
            'method',
          },
        },
      }
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({ "css", "scss", "html", "javascript" }, {
        RGB = true,      -- #RGB hex codes
        RRGGBB = true,   -- #RRGGBB hex codes
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        rgb_fn = true,   -- CSS rgb() and rgba() functions
        hsl_fn = true,   -- CSS hsl() and hsla() functions
        css = true,      -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true,   -- Enable all CSS *functions*: rgb_fn, hsl_fn
      })
    end,
  },
  {
    "rmagatti/goto-preview",
    config = function()
      require('goto-preview').setup {
        width = 120,            -- Width of the floating window
        height = 25,            -- Height of the floating window
        default_mappings = false, -- Bind default mappings
        debug = false,          -- Print debug information
        opacity = nil,          -- 0-100 opacity level of the floating window where 100 is fully transparent.
        post_open_hook = nil    -- A function taking two arguments, a buffer and a window to be ran as a hook.
        -- You can use "default_mappings = true" setup option
        -- Or explicitly set keybindings
        -- vim.cmd("nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>")
        -- vim.cmd("nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>")
        -- vim.cmd("nnoremap gP <cmd>lua require('goto-preview').close_all_win()<CR>")
      }
    end,
  },
  {
    "ahmedkhalf/project.nvim",
    event = "BufRead",
    config = function()
      require("project_nvim").setup {
        show_hidden = true,
      }
    end,
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function()
      require("lsp_signature").on_attach()
    end,
  },
  {
    "simrat39/symbols-outline.nvim",
    config = function()
      require('symbols-outline').setup()
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  {
    "Pocco81/auto-save.nvim",
    config = function()
      require("auto-save").setup()
    end,
  },
  {
    "npxbr/glow.nvim",
    ft = { "markdown" }
    -- build = "yay -S glow"
  },
  {
    "karb94/neoscroll.nvim",
    event = "WinScrolled",
    config = function()
      require('neoscroll').setup({
        -- All these keys will be mapped to their corresponding default scrolling animation
        mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>',
          '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
        hide_cursor = true,          -- Hide cursor while scrolling
        stop_eof = true,             -- Stop at <EOF> when scrolling downwards
        use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
        respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
        cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
        easing_function = nil,       -- Default easing function
        pre_hook = nil,              -- Function to run before the scrolling animation starts
        post_hook = nil,             -- Function to run after the scrolling animation ends
      })
    end,
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    lazy = true,
    config = function()
      require("persistence").setup {
        dir = vim.fn.expand(vim.fn.stdpath "config" .. "/session/"),
        options = { "buffers", "curdir", "tabpages", "winsize" },
      }
    end,
  },
  {
    "andweeb/presence.nvim",
    config = function()
      require("user.presence").config()
    end,
  },
  {
    "danymat/neogen",
    lazy = true,
    config = function()
      require("neogen").setup {
        enabled = true,
      }
    end,
    --dependencies = "nvim-treesitter/nvim-treesitter",
  },
  {
    "vuki656/package-info.nvim",
    config = function()
      require("package-info").setup()
    end,
    lazy = true,
    event = { "BufReadPre", "BufNew" },
  },
  {
    "sidebar-nvim/sidebar.nvim",
    config = function()
      require("user.sidebar").config()
    end,
    -- event = "BufRead",
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    config = function()
      require("user.noice").config()
    end,
    dependencies = {
      "rcarriga/nvim-notify",
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {}
  },
}
