return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    opts.diagnostics.virtual_text = false

    opts.servers = opts.servers or {}
    opts.servers.intelephense = {
      settings = {
        intelephense = {
          stubs = {
            "wordpress",
            "Core",
            "standard",
            "SPL",
            "pcre",
            "json",
            "mysqli",
            "mbstring",
            "curl",
          },
          environment = {
            includePaths = { vim.fn.getcwd() .. "/vendor/php-stubs/wordpress-stubs" },
          },
        },
      },
    }
  end,
}
