-- Lua snippet using Neovim's built-in vim.snippet
-- Place this in after/ftplugin/lua.lua or init.lua

vim.snippet.add({
  trigger = 'fn',
  name = 'Function',
  dscr = 'Create a new Lua function',
  pattern = 'lua',
  body = [[function $1(...)
  $2
end
<$3>]],
})