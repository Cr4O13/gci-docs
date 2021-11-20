-- ---------------------------------------------------------
-- Test GCI - <spec>
-- ---------------------------------------------------------
--[[---------------------------------------------------------
requirements to test
--]]---------------------------------------------------------
-- Imports
local lu = require "test/lib/luaunit"

-- Model Data
-- Test Case Data
-- Test Case Specifications
local testcases = {
  succeed = {
  },
  fail = {
  }
}

-- Create Tests from Test Case Specifications
local function create_tests( cases )
  local tests = {}
  for name, spec in pairs(cases.succeed) do
  end
  for name, spec in pairs(cases.fail) do
  end
  return tests
end

-- Test Collection
Test_All = create_tests( testcases )

-- Test Runner
lu.LuaUnit.run()