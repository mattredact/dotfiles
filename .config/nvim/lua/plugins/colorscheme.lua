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

  -- Add ash (monochrome, used by felix theme)
  {
    "bjarneo/ash.nvim",
    lazy = true,
  },

  -- Add solarized-osaka
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = true,
    opts = {
      transparent = true,
    },
  },

  -- Add gruvbox-material
  {
    "sainnhe/gruvbox-material",
    lazy = true,
  },

  -- Add everblush
  {
    "Everblush/nvim",
    name = "everblush",
    lazy = true,
  },

  -- Tell LazyVim to use it
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "solarized-osaka",
    },
  },
}
