-- ---------------------------------------------------------
-- Test GCI - Test main
-- ---------------------------------------------------------
--[[---------------------------------------------------------
main :: call gci
--]]---------------------------------------------------------
-- Imports
local lu = require "test/lib/luaunit"
local main  = require "src/main"

local airmanager = require "test/mock/airmanager"
static_data_load = airmanager.static_data_load

-- Model Data
-- Test Case Data
configuration = {
  defaults = {},
  controllers = {
    { log = true,
      name = "Controller",
      axes = {},
      buttons = {}
    }
  }
}

-- Test Case Specifications
local testcases = {
  succeeds = {
    test_main = {}
  },
  fails = {

  }
}

-- Create Tests from Test Case Specifications
local function create_tests( cases )
  local tests = {}
  for name, spec in pairs(cases.succeeds) do
    tests[name] = function ()
      local controllers = gci()
      lu.assertNotNil( controllers )
    end
  end
  for name, spec in pairs(cases.fails) do
  end
  return tests
end

-- Test Collection
Test_All = create_tests( testcases )

-- Test Runner
lu.LuaUnit.run()