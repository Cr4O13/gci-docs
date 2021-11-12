-- ---------------------------------------------------------
-- Test GCI Control Model
-- ---------------------------------------------------------
local model = require "src/model/control"
local mock_am = require "test/mock/airmanager"
local lunit = require "test/lib/luaunit"

log = mock_am.log
local gci_control = model.gci_control

-- Test Data
local event = "added"
local input = true

local responders = {}
responders[input] = nil

local control = { 
  map = function (input) return input end,
  responders = responders,
  class = "Test",
  id = { label = "T0" }  
}

test_interface = function()
  lunit.assertNotNil(gci_control)
  lunit.assertNotNil(gci_control.new)
  lunit.assertNotNil(gci_control.handle)
  lunit.assertNotNil(gci_control.handler)
end

test_create = function()
  local test_control = gci_control:new(control)
  lunit.assertNotNil(test_control)
  lunit.assertNotNil(test_control.map)
  lunit.assertNotNil(test_control.responders)
  lunit.assertNotNil(test_control.class)
  lunit.assertNotNil(test_control.id.label)
end

test_maintain = function()
  local test_control = gci_control:new(control)
  lunit.assertNotNil(test_control)
  lunit.assertNotNil(test_control.events)
end

test_receive = function()
  local test_control = gci_control:new(control)
  lunit.assertNotNil(test_control.handle)
  test_control:handle(input)
  lunit.assertNotNil(spy_message)
end

-- Test Runner
lunit.LuaUnit.run()