require "nvchad.autocmds"

-- Ensure filetype is set for PHP files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.php" },
  callback = function()
    vim.bo.filetype = "php"
  end,
})
