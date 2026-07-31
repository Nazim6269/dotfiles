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
-- vim.keymap.set("t", "<C-o>", "<C-\\><C-n>", { desc = "Exit Term mode", })

---@param str string
_G.insert = function(str)
  vim.api.nvim_put({ str }, "v", true, true)
end

vim.keymap.set(
  "n",
  "<leader>ill",
  '<cmd>lua insert("https://picsum.photos/seed/picsum/300/200")<CR>',
  { desc = "Image link" }
)
vim.keymap.set(
  "n",
  "<leader>ild",
  '<cmd>lua insert("http://dummyimage.com/300x200/000000/555555")<CR>',
  { desc = "Dummy image" }
)
vim.keymap.set(
  "n",
  "<leader>ila",
  '<cmd>lua insert("https://i.pravatar.cc/150?img=5")<CR>',
  { desc = "User avatar image" }
)
