return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "//",
        function()
          Snacks.picker.lines()
        end,
        desc = "which_key_ignore",
      },
    },
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
