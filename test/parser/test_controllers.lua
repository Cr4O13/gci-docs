-- ---------------------------------------------------------
-- Test Parse Controller Specification
-- ---------------------------------------------------------
--[[---------------------------------------------------------
controllers-field :: "controllers" : [ controller-list ]
controller-list :: controller-spec ( , controller-list )
--]]---------------------------------------------------------
local model = require "src/model/responder"
local parse = require "src/parser/parse"
local mock_am = require "test/mock/airmanager"
local lunit = require "test/lib/luaunit"

log = mock_am.log

action_map          = model.action_map
output_map          = model.output_map
local gci_responder = model.gci_responder

-- Test Data
sim    = "fs2020"

local controller_name = "Controller"
local axes = {}
local buttons = {}

local control_type = "button"

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

local tests = {
  succeeds = {
    test_spec = controllers_spec
  },
  fails = {

  }
}

-- Create Test Cases
local function testcases( cases )
  local tests = {}
  for name, spec in pairs(cases.succeeds) do
    tests[name] = function ()
      local controllers = parse.controllers( spec )
      lunit.assertNotNil( controllers )

    end
  end
  for name, spec in pairs(cases.fails) do
    tests[name] = function ()
      local controllers = parse.controllers( spec )
      lunit.assertNil( controllers )

    end
  end
  return tests
end

-- Test Packages and Cases
Test_ParseController = testcases(tests)

-- Test Runner
lunit.LuaUnit.run()