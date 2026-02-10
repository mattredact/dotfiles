-- WTFox Jellybeans configuration for Neovim
require("jellybeans").setup({
  background = {
    dark = "jellybeans", -- Use the vibrant dark palette
  },
  plugins = {
    all = false,
    auto = true, -- Auto-detect installed plugins
  },
  flat_ui = true, -- Modern flat UI
  italics = true,
  transparent = false,
})

-- Apply the colorscheme
vim.cmd.colorscheme("jellybeans")

-- Ensure true colors
if vim.fn.has("termguicolors") == 1 then
  vim.opt.termguicolors = true
end
