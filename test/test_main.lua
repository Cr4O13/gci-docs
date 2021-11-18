-- ---------------------------------------------------------
-- Test GCI - main
-- ---------------------------------------------------------

--[[---------------------------------------------------------
main :: integrate_controller
--]]---------------------------------------------------------
local src  = require "src/main"
local mock_am = require "test/mock/airmanager"
local lunit = require "test/lib/luaunit"

log = mock_am.log

static_data_load = function (_) 
  return configuration
end

local main = src.main

-- Test Data
gci_version = "v4.1-beta10"

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

-- Test Cases
local tests = {
  succeeds = {
    test_main = {}
  },
  fails = {

  }
}

-- Create Test Cases
local function testcases( cases )
  local tests = {}
  for name, spec in pairs(cases.succeeds) do
    tests[name] = function ()
      local controllers = main()
      lunit.assertNotNil( controllers )
    end
  end
  for name, spec in pairs(cases.fails) do
    
  end
  return tests
end

-- Test Packages and Cases
Test_Main = testcases(tests)

-- Test Runner
lunit.LuaUnit.run()