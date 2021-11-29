-- ---------------------------------------------------------
-- Test GCI - Parse Ignore Attribute Specification
-- ---------------------------------------------------------
--[[---------------------------------------------------------
ignore-attribute :: "ignore" : ignore-value
ignore-value :: condition

condition :: false-condition | true-condition
false-condition :: false | null
true-condition :: <any value different from false-condition> 
--]]---------------------------------------------------------
-- Imports
local lu = require "test/lib/luaunit"
local parse = require "src/parser/parse"

-- Model Data
-- Test Case Data
-- Test Case Specifications
local testcases = {
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

-- Create Tests from Test Case Specifications
local function create_tests( cases )
  local tests = {}
  for name, case in pairs(cases.succeeds) do
    tests[name] = function ()
      local ignore = parse.ignore( case.ignore )
      lu.assertTrue( ignore )
    end
  end
  for name, case in pairs(cases.fails) do
    tests[name] = function ()
      local ignore = parse.ignore( case.ignore )
      lu.assertNil( ignore )
    end
  end
  return tests
end

-- Test Collection
Test_All = create_tests( testcases )

-- Test Runner
lu.LuaUnit.run()