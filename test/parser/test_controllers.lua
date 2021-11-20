-- ---------------------------------------------------------
-- Test Parse Controller Specification
-- ---------------------------------------------------------
--[[---------------------------------------------------------
controllers-field :: "controllers" : [ controller-list ]
controller-list :: controller-spec ( , controller-list )
--]]---------------------------------------------------------
-- Imports
local lu = require "test/lib/luaunit"
local parse = require "src/parser/parse"
local airmanager = require "test/mock/airmanager"

-- Model Data
-- Test Case Data
local axes = {}
local buttons = {}

local controllers_spec = {
  {
    log = true,
    name = "Controller 1", 
    axes = axes,
    buttons = buttons
  },
  {
    log = true,
    name = "Controller 2", 
    axes = axes,
    buttons = buttons
  }
}

-- Test Case Specifications
local testcases = {
  succeeds = {
    test_spec = controllers_spec
  },
  fails = {
  }
}

-- Create Tests from Test Case Specifications
local function create_tests( cases )
  local tests = {}
  for name, spec in pairs(cases.succeeds) do
    tests[name] = function ()
      local controllers = parse.controllers( spec )
      lu.assertNotNil( controllers )
    end
  end
  for name, spec in pairs(cases.fails) do
    tests[name] = function ()
      local controllers = parse.controllers( spec )
      lu.assertNil( controllers )
    end
  end
  return tests
end

-- Test Collection
Test_All = create_tests( testcases )

-- Test Runner
lu.LuaUnit.run()