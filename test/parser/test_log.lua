-- ---------------------------------------------------------
-- Test GCI - Parse Log Attribute Specification
-- ---------------------------------------------------------
--[[---------------------------------------------------------
log-attribute :: "log" : log-value
log-value :: condition

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

-- Create Tests from Test Case Specifications
local function create_tests( cases )
  local tests = {}
  for name, case in pairs(cases.succeeds) do
    tests[name] = function ()
      local log = parse.log( case.log )
      lu.assertTrue( log )
    end
  end
  for name, case in pairs(cases.fails) do
    tests[name] = function ()
      local log = parse.log( case.log )
      lu.assertNil( log )
    end
  end
  return tests
end

-- Test Collection
Test_All = create_tests( testcases )

-- Test Runner
lu.LuaUnit.run()