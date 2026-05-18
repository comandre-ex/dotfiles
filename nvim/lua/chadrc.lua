---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "dracula",

  hl_override = {

    -- comentarios
    Comment = { italic = true },

    -- funciones rojas estilo VSCode Dracula
    Function = { fg = "#ff5555", bold = false },

    -- keywords moradas
    Keyword = { fg = "#ff79c6", bold = false },

    -- if / else / while / for
    Conditional = { fg = "#ff79c6", bold = false },
    Repeat = { fg = "#ff79c6", bold = false },

    -- variables
    Identifier = { fg = "#f8f8f2", bold = false },

    -- tipos
    Type = { fg = "#8be9fd", bold = false },

    -- strings
    String = { fg = "#f1fa8c" },

  },
}

-- configuración del autocompletado
M.ui = {
  cmp = {
    icons = true,
    lspkind_text = true,
    style = "bordered",
  },
}

return M
