-- ---------------------------------------------------------
-- Test Axis Control
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
local gci_control = control.gci_control

local airmanager = require "test/mock/airmanager"

-- Model Data
local sim      = "fs2020"
local subtype  = "axis"
local index    = 0
local label    = "A0"
local action   = "write"

local variable = "RUDDER POSITION"
local unit     = "Position"

local input  = -0.222
local output = "direct"

local axis_responder = {
  log = true,
  respond  = action_map[sim][action],
  var_id   = variable,
  unit_id  = unit,
  output   = output_map[subtype][output]
}

local responders = {}
responders[ defaults[subtype].trigger ] = gci_responder:new(axis_responder)
  
local model = {
  log = true,
  index = index, 
  label = label,
  subtype = subtype,
  map = input_map[subtype],
  responders = responders
}

-- Test Case Data
-- Test Case Specifications
local testcases = {
  handle = {
    test_handle = model
  }
}

-- Create Tests from Test Case Specifications
local function create_tests( cases )
  local tests = {}
  for name, spec in pairs(cases.handle) do
    tests[name] = function ()
      local axis_control = gci_control:new( spec )
      lu.assertNotNil(axis_control)
      lu.assertNotNil(axis_control.handle)
      spy_variable = {}
      axis_control:handle(input)
      lu.assertEquals(spy_variable[variable][1], input)
      lu.assertEquals(spy_variable[variable][2], unit)
    end
  end
  return tests
end

-- Test Collection
Test_All = create_tests( testcases )

-- Test Runner
lu.LuaUnit.run()
