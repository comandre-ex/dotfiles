local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- Configuración específica para PHP (intelephense)
lspconfig.intelephense.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  settings = {
    intelephense = {
      files = { maxSize = 1000000 },
      stubs = {
        "bcmath", "bz2", "calendar", "curl", "date", "dba", "dom",
        "exif", "fileinfo", "filter", "ftp", "gd", "gmp", "hash",
        "iconv", "imap", "intl", "json", "ldap", "libxml", "mbstring",
        "mysqli", "odbc", "openssl", "pcntl", "pcre", "pdo",
        "pdo_mysql", "pdo_sqlite", "pgsql", "phar", "posix", "pspell",
        "readline", "recode", "session", "soap", "sockets", "sqlite3",
        "standard", "sysvmsg", "sysvsem", "sysvshm", "tokenizer",
        "xml", "xsl", "zip", "zlib",
      },
    },
  },
}

-- Auto-iniciar LSP al detectar filetype php
vim.api.nvim_create_autocmd("FileType", {
  pattern = "php",
  callback = function(args)
    local Buf = args.buf
    vim.lsp.start({
      name = "intelephense",
      cmd = { "intelephense", "--stdio" },
      root_dir = vim.fs.root(Buf, { "composer.json", "*.php", "index.php" }) or vim.fn.getcwd(),
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end,
})

-- LISTA DE SERVIDORES
local servers = { 
   "bashls",
   "pyright",
   "ts_ls",
   "html",
}

-- CONFIGURACIÓN AUTOMÁTICA
-- Este bucle recorre la lista y activa cada servidor con las funciones de NvChad
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

-- Configuración específica para Lua (el lenguaje de Neovim)
lspconfig.lua_ls.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" }, -- Evita que marque 'vim' como error
      },
    },
  },
}
