-- ---------------------------------------------------------
-- Test GCI - Parse String Types
-- ---------------------------------------------------------
--[[---------------------------------------------------------
return nil if not a string, otherwise return the string
--]]---------------------------------------------------------
-- Imports
local lu = require "test/lib/luaunit"
local parse = require "src/parser/parse"

-- Model Data
-- Test Case Data
-- Test Case Specifications
local testcases = {
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

-- Create Tests from Test Case Specifications
local function create_tests( cases )
  local tests = {}
  for name, case in pairs(cases.succeeds) do
    tests[name] = function ()
      local string = parse.string( case )
      lu.assertNotNil( string )
      lu.assertIsString( string )
    end
  end
  for name, case in pairs(cases.fails) do
    tests[name] = function ()
      local string = parse.string( case )
      lu.assertNil( string )
    end
  end
  return tests
end

-- Test Collection
Test_All = create_tests( testcases )

-- Test Runner
lu.LuaUnit.run()