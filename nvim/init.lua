-- 1. SILENCIAR AVISOS DE DEPRECACIÓN (LSP 0.11+)
-- Esto evita que el mensaje de "lspconfig is deprecated" bloquee tu pantalla.
vim.g.deprecation_warnings = false

local notify = vim.notify
vim.notify = function(msg, level, opts)
  if msg and type(msg) == "string" and msg:find("lspconfig") then
    return
  end
  return notify(msg, level, opts)
end

-- 2. CONFIGURACIÓN DE NVCHAD
vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- Bootstrap de lazy.nvim (gestor de plugins)
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- 3. CARGA DE PLUGINS
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" }, -- Esto carga tu archivo lua/plugins/init.lua
}, lazy_config)

-- 4. CARGA DE INTERFAZ Y OPCIONES
-- Esto asegura que el tema (incluyendo Dracula) y la statusline carguen bien.
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "autocmds"

vim.schedule(function()
  require "mappings"
  vim.cmd "colorscheme dracula" 
end)
