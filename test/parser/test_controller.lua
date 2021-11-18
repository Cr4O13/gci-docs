-- ---------------------------------------------------------
-- Test Parse Controller Specification
-- ---------------------------------------------------------
--[[---------------------------------------------------------
controller-spec :: { controller-name-field, controls ( , attributes ) }
controller-name-field :: "name" : controller-name
controller-name :: lua-string

controls :: controls-field ( , controls )
controls-field :: axes-field | buttons-field

axes-field :: "axes" : [ control-list ]
buttons-field :: "buttons" : [ control-list ]
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

local controller_spec = { 
  log = true,
  name = controller_name, 
  axes = axes,
  buttons = buttons
}

local tests = {
  succeeds = {
    test_spec = controller_spec
  },
  fails = {

  }
}

-- Create Test Cases
local function testcases( cases )
  local tests = {}
  for name, spec in pairs(cases.succeeds) do
    tests[name] = function ()
      local controller = parse.controller( spec )
      lunit.assertNotNil( controller )

    end
  end
  for name, spec in pairs(cases.fails) do
    tests[name] = function ()
      local controller = parse.controller( spec )
      lunit.assertNil( controller )

    end
  end
  return tests
end

-- Test Packages and Cases
Test_ParseController = testcases(tests)

-- Test Runner
lunit.LuaUnit.run()