-- ---------------------------------------------------------
-- Test Parse Boolean Types
-- ---------------------------------------------------------
parse = require "src/parser/parse"
lunit = require "test/lib/luaunit"

-- Test Data
local tests = {
  succeeds = {
    test_true   = true,
    test_false  = false
  },
  fails = {
    test_number = 0,
    test_string = "string",
    test_empty  = {}
  }
}

-- Create Test Cases
local function testcases( cases )
  local tests = {}
  for name, case in pairs(cases.succeeds) do
    tests[name] = function ()
      local bool = parse.boolean( case )
      lunit.assertNotNil( bool )
      lunit.assertIsBoolean( bool )
    end
  end
  for name, case in pairs(cases.fails) do
    tests[name] = function ()
      local bool = parse.boolean( case )
      lunit.assertNil( bool )
    end
  end
  return tests
end

-- Test Packages and Cases
Test_ParseSubtype = testcases(tests)

-- Test Runner
lunit.LuaUnit.run()