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

  -- Add solarized
  {
    "maxmx03/solarized.nvim",
    lazy = true,
    opts = {
      transparent = { enabled = true },
    },
  },

  -- Add nordic
  {
    "AlexvZyl/nordic.nvim",
    lazy = true,
    opts = {
      transparent = { bg = true },
    },
  },

  -- Add nightfox (nightfox, duskfox, nordfox, carbonfox, terafox, dayfox, dawnfox)
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    opts = {
      options = {
        transparent = true,
      },
    },
  },

  -- Add oxocarbon
  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = true,
  },

  -- Add moonfly
  {
    "bluz71/vim-moonfly-colors",
    name = "moonfly",
    lazy = true,
  },

  -- Add miasma
  {
    "xero/miasma.nvim",
    lazy = false,
  },

  -- Tell LazyVim to use it
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "miasma",
    },
  },
}
