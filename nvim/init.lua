-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.api.nvim_create_autocmd({ "BufEnter", "BufFilePost" }, {
  callback = function()
    local fname = vim.fn.expand("%:t")
    if fname ~= "" then
      io.write(string.format("\027]0;%s\007", fname))
    end
  end,
})
