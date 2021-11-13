-- ---------------------------------------------------------
-- Test GCI Responder Model
-- ---------------------------------------------------------
local model = require "src/model/responder"
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

local api           = model.api
local gci_responder = model.gci_responder

-- Test Data
local sim    = "fs2020"
local action = "send"
local event  = "AP_MASTER"
local variable
local dataref
local commandref
local unit
local type
local offset
local force

local input  = true

local responder = {}
responder.respond  = api[sim][action]
responder.var_id   = event
responder.unit_id  = unit
responder.output   = function(input) return input end


test_interface = function()
  lunit.assertNotNil(gci_responder)
  lunit.assertNotNil(gci_responder.new)
  lunit.assertNotNil(gci_responder.respond)
end

test_create = function()
  local test_responder = gci_responder:new(responder)
  lunit.assertNotNil(test_responder)
  lunit.assertNotNil(test_responder.respond)
  lunit.assertNotNil(test_responder.var_id)
  lunit.assertNotNil(test_responder.output)
end

test_maintain = function()
  local test_responder = gci_responder:new(responder)
  lunit.assertNotNil(test_responder)  
  lunit.assertNotNil(test_responder.events)  
end

test_receive = function()
  local test_responder = gci_responder:new(responder)
  lunit.assertNotNil(test_responder)
  spy_variable = {}
  test_responder:respond(input)
  lunit.assertNotNil(spy_variable[event])  
  lunit.assertEquals(spy_variable[event][1], input)  
end

-- Test Runner
lunit.LuaUnit.run()