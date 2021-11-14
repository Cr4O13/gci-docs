-- ---------------------------------------------------------
-- Test Parse Ignore Specification
-- ---------------------------------------------------------
parse = require "src/parser/parse"
lunit = require "test/lib/luaunit"

defaults = {}

-- Test Data
local tests = {
  succeeds = {
    test_true       = { ignore = true },
    test_string     = { ignore = "string" },
    test_number     = { ignore = 99 },
    test_empty      = { ignore = {} },
  },
  fails = {
    test_false      = { ignore = false },
    test_null       = { ignore = nil },
  }
}

-- Create Test Cases
local function testcases( cases )
  local tests = {}
  for name, case in pairs(cases.succeeds) do
    tests[name] = function ()
      local ignore = parse.ignore( case.ignore )
      lunit.assertTrue( ignore )
    end
  end
  for name, case in pairs(cases.fails) do
    tests[name] = function ()
      local ignore = parse.ignore( case.ignore )
      lunit.assertNil( ignore )
    end
  end
  return tests
end

-- Test Packages and Cases
Test_ParseIgnore = testcases( tests )

-- Test Runner
lunit.LuaUnit.run()