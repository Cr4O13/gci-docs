-- ---------------------------------------------------------
-- Test Parse Parameters Specification
-- ---------------------------------------------------------
--[[---------------------------------------------------------
parameter-list :: parameter-value ( , parameter-list )
parameter-value :: lua-value
--]]---------------------------------------------------------
-- Imports
local lu = require "test/lib/luaunit"
local parse = require "src/parser/parse"

-- Model Data
-- Test Case Data
local param = 100

-- Test Case Specifications
local testcases = {
  succeeds = {
    test_table    = { parameters = { param } },
    test_item     = { parameters = param },
  },
  fails = {
  }
}

-- Create Tests from Test Case Specifications
local function create_tests( cases )
  local tests = {}
  for name, case in pairs(cases.succeeds) do
    tests[name] = function ()
      local parameters = parse.parameters( case.parameters )
      lu.assertNotNil( parameters )
      lu.assertEquals( parameters, { param } )
    end
  end
  for name, case in pairs(cases.fails) do
  end
  return tests
end

-- Test Collection
Test_All = create_tests( testcases )

-- Test Runner
lu.LuaUnit.run()