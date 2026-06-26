return {
  "nvim-mini/mini.ai",
  version = false,
  opts = function()
    local ai = require("mini.ai")
    local gen_spec = require("mini.ai").gen_spec
    return {
      n_lines = 500,
      custom_textobjects = {
        g = LazyVim.mini.ai_buffer, -- buffer
        o = gen_spec.treesitter({ -- code block
          a = { "@block.outer", "@conditional.outer", "@loop.outer" },
          i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        }),
        f = gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
        c = gen_spec.function_call(),
        C = gen_spec.function_call({ name_pattern = "[%w_]" }), -- Without dot in function name
        m = gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
        ["="] = gen_spec.treesitter({ a = "@attribute.outer", i = "@attribute.inner" }),
        -- P = gen_spec.treesitter({ a = "@_pair.outer", i = "@_pair.inner" }),
        v = gen_spec.treesitter({ a = "@assignment.outer", i = "@assignment.rhs" }),
        V = gen_spec.treesitter({ a = "@assignment.outer", i = "@assignment.lhs" }),

        -- e,j,k,l,s,u,x,y,z

        -- Makes aB equivalent to built-in al
        -- B = MiniExtra.gen_ai_spec.buffer(),
        -- -- Makes iL equivalent to built-in il
        -- L = MiniExtra.gen_ai_spec.line(),

        -- ['*'] = gen_spec.pair('*', '*', { type = 'greedy' }),
        -- ['_'] = gen_spec.pair('_', '_', { type = 'greedy' }),
        -- ( [[  ]] )

        t = false,
        -- t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- tags
        r = { { "%b[]" }, "^.().*().$" },
        k = { { "^().*()$" }, { "^%s*().-()%s*$", "^().*()$" } },
        d = { "%f[%d]%d+" }, -- digits
        e = { -- Word with case
          { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
          "^().*()$",
        },
      },
    }
  end,
}
