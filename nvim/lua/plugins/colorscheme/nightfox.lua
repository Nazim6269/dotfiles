local active = require("config.colorscheme")

return {
  "EdenEast/nightfox.nvim",
  priority = 1000,
  config = function()
    require("nightfox").setup({})
    if active == "nightfox" then
      vim.cmd.colorscheme("nightfox")
    end
  end,
}
