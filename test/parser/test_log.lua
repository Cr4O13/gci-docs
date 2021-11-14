-- ---------------------------------------------------------
-- Test Parse Log Specification
-- ---------------------------------------------------------
parse = require "src/parser/parse"
lunit = require "test/lib/luaunit"

defaults = {}

-- Test Data
local tests = {
  succeeds = {
    test_true       = { log = true },
    test_string     = { log = "string" },
    test_number     = { log = 99 },
    test_empty      = { log = {} },
  },
  fails = {
    test_false      = { log = false },
    test_null       = { log = nil },
  }
}

-- Create Test Cases
local function testcases( cases )
  local tests = {}
  for name, case in pairs(cases.succeeds) do
    tests[name] = function ()
      local log = parse.log( case.log )
      lunit.assertTrue( log )
    end
  end
  for name, case in pairs(cases.fails) do
    tests[name] = function ()
      local log = parse.log( case.log )
      lunit.assertNil( log )
    end
  end
  return tests
end

-- Test Packages and Cases
Test_ParseLog = testcases( tests ) 

-- Test Runner
lunit.LuaUnit.run()