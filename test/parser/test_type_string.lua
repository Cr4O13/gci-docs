-- ---------------------------------------------------------
-- Test Parse String Types
-- ---------------------------------------------------------
parse = require "src/parser/parse"
lunit = require "test/lib/luaunit"

-- Test Data
local tests = {
  succeeds = {
    test_zero  = "",
    test_real  = "string",
  },
  fails = {
    test_bool   = false,
    test_number = 8,
    test_empty  = {}
  }
}

-- Create Test Cases
local function testcases( cases )
  local tests = {}
  for name, case in pairs(cases.succeeds) do
    tests[name] = function ()
      local string = parse.string( case )
      lunit.assertNotNil( string )
      lunit.assertIsString( string )
    end
  end
  for name, case in pairs(cases.fails) do
    tests[name] = function ()
      local string = parse.string( case )
      lunit.assertNil( string )
    end
  end
  return tests
end

-- Test Packages and Cases
Test_ParseSubtype = testcases(tests)

-- Test Runner
lunit.LuaUnit.run()