local active = require("config.colorscheme")
return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      transparent_background = true,
    })
    if active == "catppuccin" then
      vim.cmd.colorscheme("catppuccin")
    end
  end,
}
