return {
  "max397574/better-escape.nvim",
  lazy = true,
  event = { "InsertEnter", "CmdlineEnter" },
  opts = {
    timeout = 350, -- The time in which the keys must be hit in ms. Use option timeoutlen by default
    mappings = {
      i = { j = { k = "<Esc>", j = false } },
      c = { j = { k = "<Esc>", j = false } },
      s = { j = { k = "<Esc>" } },
      t = { j = { k = false } },
      v = { j = { k = false } },
    },
  },
}
