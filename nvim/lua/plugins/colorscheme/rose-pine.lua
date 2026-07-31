local active = require("config.colorscheme")
return {
  "rose-pine/neovim",
  name = "rose-pine",
  priority = 1000,
  config = function()
    require("rose-pine").setup({
      variant = "main",
    })
    if active == "rose-pine" then
      vim.cmd.colorscheme("rose-pine")
    end
  end,
}
