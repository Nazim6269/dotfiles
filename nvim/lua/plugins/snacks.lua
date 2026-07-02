return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        layouts = {
          sidebar = {
            layout = {
              width = 28, -- default is usually wider
            },
          },
        },
      },
      indent = {
        animate = { enabled = false },
        scope = {
          only_current = true,
          underline = true,
          char = "▏",
        },
      },
    },
  },
}
