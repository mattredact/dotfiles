return {
  -- Add jellybeans
  {
    "wtfox/jellybeans.nvim",
    dependencies = { "tjdevries/colorbuddy.nvim" },
    priority = 1000,
    opts = {
      flat_ui = true,
      italics = true,
      transparent = true,
    },
  },

  -- Tell LazyVim to use it
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "jellybeans",
    },
  },
}
