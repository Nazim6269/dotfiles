-- Simple Lua test snippet
local M = {}

function M.assert_equal(a, b, msg)
  if a ~= b then
    error(("assert_equal failed: %s\n  expected: %s\n  got: %s"):format(msg or "", tostring(b), tostring(a)), 2)
  end
end

function M.assert_true(v, msg)
  if not v then
    error(("assert_true failed: %s"):format(msg or ""), 2)
  end
end

-- Example usage
local function add(x, y)
  return x + y
end

-- Test: 1 + 1 = 2
M.assert_equal(add(1, 1), 2, "1+1 should equal 2")

-- Test: 2 + 3 = 5
M.assert_equal(add(2, 3), 5, "2+3 should equal 5")

print("All tests passed!")