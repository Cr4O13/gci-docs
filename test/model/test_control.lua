-- ---------------------------------------------------------
-- Test GCI Control Model
-- ---------------------------------------------------------
local control = require "src/model/control"
local mock_am = require "test/mock/airmanager"
local lunit = require "test/lib/luaunit"

log = mock_am.log
local gci_control = control.gci_control

-- Test Data
local event = "added"
local input = true

local responders = {}
responders[input] = nil

local ctrl = { 
  map = function (input) return input end,
  responders = responders,
  class = "Test",
  id = { label = "T0" }  
}

local test_control = gci_control:new(ctrl)

test_constructor = function()
  lunit.assertNotNil(test_control)
  lunit.assertNotNil(test_control.events)
  lunit.assertNotNil(test_control.events[event])
end

test_handle = function()
  lunit.assertNotNil(test_control.handle)
end

-- Test Runner
lunit.LuaUnit.run()