-- ---------------------------------------------------------
-- Test Parse Boolean Types
-- ---------------------------------------------------------
--[[---------------------------------------------------------
requirements to test
--]]---------------------------------------------------------
-- Imports
local lu = require "test/lib/luaunit"
local parse = require "src/parser/parse"

-- Model Data
-- Test Case Data
-- Test Case Specifications
local testcases = {
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

-- Create Tests from Test Case Specifications
local function create_tests( cases )
  local tests = {}
  for name, case in pairs(cases.succeeds) do
    tests[name] = function ()
      local bool = parse.boolean( case )
      lu.assertNotNil( bool )
      lu.assertIsBoolean( bool )
    end
  end
  for name, case in pairs(cases.fails) do
    tests[name] = function ()
      local bool = parse.boolean( case )
      lu.assertNil( bool )
    end
  end
  return tests
end

-- Test Collection
Test_All = create_tests( testcases )

-- Test Runner
lu.LuaUnit.run()