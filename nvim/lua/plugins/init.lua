return {

  -------------------------------------------------
  -- TEMA DRACULA
  -------------------------------------------------
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd [[colorscheme dracula]]
    end,
  },

  -------------------------------------------------
  -- MATAR EL PLUGIN DE NVCHAD Y REEMPLAZARLO
  -------------------------------------------------
  -- 1. Desactivamos la versión de NvChad que da error
  { "lukas-reineke/indent-blankline.nvim", enabled = false },

  -- 2. Instalamos tu versión limpia (sin errores de IblChar)
  {
    "lukas-reineke/indent-blankline.nvim",
    name = "ibl_custom", -- Le damos otro nombre para que no choque
    event = "User FilePost",
    opts = {
      indent = { char = "│" },
      scope = { enabled = false }, -- Apagamos el scope que pide IblScopeChar
    },
    config = function(_, opts)
      -- Definimos los colores mínimos para que funcione
      vim.api.nvim_set_hl(0, "IblChar", { fg = "#44475a" })
      vim.api.nvim_set_hl(0, "IblWhitespace", { fg = "#44475a" })
      require("ibl").setup(opts)
    end,
  },

  -------------------------------------------------
  -- LSP & AUTOCOMPLETADO
  -------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require "cmp"
      cmp.setup {
        snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
      }
    end,
  },

  -------------------------------------------------
  -- LENGUAJES (Treesitter)
  -------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "lua", "python", "javascript", "php", "rust", "bash", "sql" },
      highlight = { enable = true },
    },
  },

  { "nvim-tree/nvim-web-devicons", lazy = false },
  { "windwp/nvim-autopairs", event = "InsertEnter", config = true },
}
