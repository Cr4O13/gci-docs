-- ---------------------------------------------------------
-- Test Button Control
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

local api           = responder_model.api
local gci_responder = responder_model.gci_responder
local gci_control   = control_model.gci_control

-- Test Data
local sim      = "fs2020"
local action   = "send"

local event    = "AP_MASTER"

local output = function(input) end

local button_responder = {
  log = true,
  respond  = api[sim][action],
  var_id   = event,
  output   = output
}

local responders = {}
responders["on_true"]  = gci_responder:new(button_responder)

  
local button = {
  log = true,
  class = "button",
  id = { index = 0, label = "B0" },
  
  map = function (input) if input then return "on_true" else return "on_false" end end,
  
  responders = responders
}

--function button:handler( responder, input )
--  responder:respond(input)
--end

test_handle_true = function()
  local button_control = gci_control:new( button )
  lunit.assertNotNil(button_control.handle)
  spy_variable = {}
  local input = true
  button_control:handle(input)
  lunit.assertEquals(spy_variable[event][1], nil)
  lunit.assertEquals(spy_variable[event][2], nil)
end

test_handle_false = function()
  local button_control = gci_control:new( button )
  lunit.assertNotNil(button_control.handle)
  spy_variable = {}
  local input = false
  button_control:handle(input)
  lunit.assertNil(spy_variable[event])
end

-- Test Runner
lunit.LuaUnit.run()
