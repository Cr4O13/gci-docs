-- ---------------------------------------------------------
-- Test GCI - Parse Number Types
-- ---------------------------------------------------------
--[[---------------------------------------------------------
return nil if not a number, otherwise return the number
--]]---------------------------------------------------------
-- Imports
local lu = require "test/lib/luaunit"
local parse = require "src/parser/parse"

-- Model Data
-- Test Case Data
-- Test Case Specifications
local testcases = {
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

-- Create Tests from Test Case Specifications
local function create_tests( cases )
  local tests = {}
  for name, case in pairs(cases.succeeds) do
    tests[name] = function ()
      local number = parse.number( case )
      lu.assertNotNil( number )
      lu.assertIsNumber( number )
    end
  end
  for name, case in pairs(cases.fails) do
    tests[name] = function ()
      local number = parse.number( case )
      lu.assertNil( number )
    end
  end
  return tests
end

-- Test Collection
Test_All = create_tests( testcases )

-- Test Runner
lu.LuaUnit.run()