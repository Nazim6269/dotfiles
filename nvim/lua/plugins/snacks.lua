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
          enabled = true,
          priority = 1000,
          only_current = true,
          underline = true,
          char = "▏",
        },
        chunk = {
          -- When enabled, scopes will be rendered as chunks, except for the
          -- top-level scope which will be rendered as a scope.
          enabled = true,
          priority = 3000,
          char = {
            corner_top = "┌",
            corner_bottom = "└",
            -- corner_top = "╭",
            -- corner_bottom = "╰",
            horizontal = "─",
            vertical = "│",
            arrow = "▶",
          },
        },
      },
    },
  },
}
