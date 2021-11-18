-- ---------------------------------------------------------
-- Test Axis Control
-- ---------------------------------------------------------
local responder_model = require "src/model/responder"
local control_model = require "src/model/control"
local mock_am = require "test/mock/airmanager"
local lunit = require "test/lib/luaunit"

log = mock_am.log

si_variable_write     = mock_am.si_variable_write
fs2020_variable_write = mock_am.fs2020_variable_write
fs2020_event          = mock_am.fs2020_event
fsx_variable_write    = mock_am.sx_variable_write
fsx_event             = mock_am.sx_event
xpl_dataref_write     = mock_am.pl_dataref_write
xpl_command           = mock_am.pl_command

local action_map    = responder_model.action_map
local gci_responder = responder_model.gci_responder
local gci_control   = control_model.gci_control

-- Test Data
local sim      = "fs2020"
local action   = "write"

local variable = "RUDDER POSITION"
local unit     = "Position"

local input = -0.222
local output = function(input) return input end

local axis_responder = {
  log = true,
  respond  = action_map[sim][action],
  var_id   = variable,
  unit_id  = unit,
  output   = output
}

local responders = {}
responders["on_change"] = gci_responder:new(axis_responder)
  
local axis = {
  log = true,
  subtype = "axis",
  id = { index = 0, label = "A0" },
  
  map = function (input) return "on_change" end,
  
  responders = responders
}

--function axis:handler( responder, input )
--  responder:respond(input)
--end

test_handle = function()
  local axis_control = gci_control:new( axis )
  lunit.assertNotNil(axis_control.handle)
  spy_variable = {}
  axis_control:handle(input)
  lunit.assertEquals(spy_variable[variable][1], input)
  lunit.assertEquals(spy_variable[variable][2], unit)
end

-- Test Runner
lunit.LuaUnit.run()
