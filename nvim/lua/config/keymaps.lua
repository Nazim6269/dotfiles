-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
vim.keymap.set("n", "g.", function()
  local ok, _ = pcall(vim.lsp.buf.code_action)
  if not ok then
    vim.notify("No code action available", vim.log.levels.INFO)
  end
end, { desc = "LSP Code Action" })

vim.keymap.set("n", "<Tab>", "za", { desc = "Toggle fold" })
