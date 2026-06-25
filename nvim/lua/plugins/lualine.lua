-- Set lualine as statusline (bubbles)
return {
  "nvim-lualine/lualine.nvim",
  config = function()
    local onedark = {
      blue = "#61afef",
      green = "#98c379",
      purple = "#c678dd",
      cyan = "#56b6c2",
      red = "#e06c75",
      yellow = "#e5c07b",
      fg = "#abb2bf",
      bg = "#282c34",
      gray1 = "#828997",
      gray3 = "#3e4452",
    }

    local nord = {
      blue = "#81a1c1",
      green = "#a3be8c",
      purple = "#b48ead",
      cyan = "#88c0d0",
      red = "#bf616a",
      yellow = "#ebcb8b",
      fg = "#d8dee9",
      bg = "#2e3440",
      gray1 = "#4c566a",
      gray3 = "#434c5e",
    }

    -- "Bubbles" theme: `c` (and the unspecified x/y/z, which fall back to
    -- `c`) are left with no background so they blend into the statusline
    -- bg. Only `a` and `b` are filled. That, plus section_separators and
    -- the explicit caps on mode/location below, produces the two pills.
    local function bubbles_theme(c)
      return {
        normal = {
          a = { fg = c.bg, bg = c.green, gui = "bold" },
          b = { fg = c.fg, bg = c.gray3 },
          c = { fg = c.fg },
        },
        insert = { a = { fg = c.bg, bg = c.blue, gui = "bold" } },
        visual = { a = { fg = c.bg, bg = c.purple, gui = "bold" } },
        terminal = { a = { fg = c.bg, bg = c.cyan, gui = "bold" } },
        replace = { a = { fg = c.bg, bg = c.red, gui = "bold" } },
        inactive = {
          a = { fg = c.gray1, bg = c.bg },
          b = { fg = c.gray1, bg = c.bg },
          c = { fg = c.gray1 },
        },
      }
    end

    -- Pick palette based on NVIM_THEME (defaults to nord)
    local palettes = { onedark = onedark, nord = nord }
    local env_theme = os.getenv("NVIM_THEME") or "nord"
    local colors = palettes[env_theme] or nord

    local hide_in_width = function()
      return vim.fn.winwidth(0) > 80
    end

    local diagnostics = {
      "diagnostics",
      sources = { "nvim_diagnostic" },
      sections = { "error", "warn" },
      symbols = { error = " ", warn = " ", info = " ", hint = " " },
      colored = false,
      update_in_insert = false,
      always_visible = true,
    }

    local diff = {
      "diff",
      colored = false,
      symbols = { added = " ", modified = " ", removed = " " },
      cond = hide_in_width,
    }

    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = bubbles_theme(colors),
        component_separators = "",
        section_separators = { left = "", right = "" },
        disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
        always_divide_middle = true,
        globalstatus = true,
      },
      sections = {
        lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
        lualine_b = {
          { "filename", file_status = true, path = 0 },
          "branch",
          diff,
        },
        lualine_c = {
          "%=", -- spacer: pushes x/y/z to the right, opening the middle gap
        },
        lualine_x = { diagnostics },
        lualine_y = { "encoding", "filetype" },
        lualine_z = {
          { "location", separator = { right = "" }, left_padding = 2 },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = { { "filename", path = 1 } },
        lualine_c = {},
        lualine_x = {},
        lualine_y = { "location" },
        lualine_z = {},
      },
      tabline = {},
      extensions = { "fugitive" },
    })
  end,
}
