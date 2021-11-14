-- ---------------------------------------------------------
-- Test Parse String Types
-- ---------------------------------------------------------
parse = require "src/parser/parse"
lunit = require "test/lib/luaunit"

-- Test Data
local tests = {
  succeeds = {
    test_zero  = 0,
    test_real  = 1.0,
    test_neg   = -0.0,
    test_max   = math.maxinteger
  },
  fails = {
    test_bool   = false,
    test_string = "string",
    test_empty  = {}
  }
}

-- Create Test Cases
local function testcases( cases )
  local tests = {}
  for name, case in pairs(cases.succeeds) do
    tests[name] = function ()
      local number = parse.number( case )
      lunit.assertNotNil( number )
      lunit.assertIsNumber( number )
    end
  end
  for name, case in pairs(cases.fails) do
    tests[name] = function ()
      local number = parse.number( case )
      lunit.assertNil( number )
    end
  end
  return tests
end

-- Test Packages and Cases
Test_ParseSubtype = testcases(tests)

-- Test Runner
lunit.LuaUnit.run()