-- ---------------------------------------------------------
-- Test GCI - Button Control
-- ---------------------------------------------------------
--[[---------------------------------------------------------
requirements to test
--]]---------------------------------------------------------
-- Imports
local lu = require "test/lib/luaunit"

local gci = require "src/gci"
local defaults = gci.defaults

local responder = require "src/model/responder"
local action_map    = responder.action_map
local output_map    = responder.output_map
local gci_responder = responder.gci_responder

local control = require "src/model/control"
local input_map   = control.input_map
local gci_control   = control.gci_control

local airmanager = require "test/mock/airmanager"

-- Model Data
local sim      = "fs2020"
local subtype  = "button"
local index    = 0
local label    = "B0"

local action   = "send"
local event    = "AP_MASTER"
local output   = "default"

local button_responder = {
  log = true,
  respond  = action_map[sim][action],
  var_id   = event,
  output   = output_map[subtype][output]
}

local responders = {}
responders[ defaults[subtype].trigger ]  = gci_responder:new(button_responder)

  
local model = {
  log = true,
  subtype = subtype,
  index = index,
  label = label,
  map = input_map[subtype],
  responders = responders
}

-- Test Case Data
-- Test Case Specifications
local testcases = {
  on_true = {
    test_handle_true = model
  },
  on_false = {
    test_handle_false = model
  }
}  

-- Create Tests from Test Case Specifications
local function create_tests( cases )
  local tests = {}
  for name, spec in pairs(cases.on_true) do
    tests[name] = function ()
      local button_control = gci_control:new( model )
      lu.assertNotNil(button_control.handle)
      spy_variable = {}
      local input = true
      button_control:handle(input)
      lu.assertEquals(spy_variable[event][1], nil)
      lu.assertEquals(spy_variable[event][2], nil)
    end
  end
  for name, spec in pairs(cases.on_false) do
    tests[name] = function ()
      local button_control = gci_control:new( model )
      lu.assertNotNil(button_control.handle)
      spy_variable = {}
      local input = false
      button_control:handle(input)
      lu.assertNil(spy_variable[event])
    end
  end
  return tests
end
  
-- Test Collection
Test_All = create_tests( testcases )

-- Test Runner
lu.LuaUnit.run()
