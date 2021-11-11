-- ---------------------------------------------------------
-- Test GCI Model Base class
-- ---------------------------------------------------------
local gci_base = require "src/model/base"
local mock_am = require "test/mock/airmanager"
local lunit = require "test/lib/luaunit"

log = mock_am.log

-- Test Data
local level = "INFO"
local event = "Test"
local message = "gci_base test"
local log_message = "GCI: " .. message

local object = { 
  events = {}
}
object.events[event] = message

local test_object = gci_base:new(object)

test_constructor = function()
  lunit.assertNotNil(test_object)
  lunit.assertNotNil(test_object.events)
  lunit.assertNotNil(test_object.events[event])
  lunit.assertEquals(test_object.events[event], message)
end

test_logging = function()
  test_object.log = true
  local log_entry = test_object:log_event(level, event)
  lunit.assertNotNil(log_entry)
  lunit.assertEquals(log_entry.level, level)
  lunit.assertEquals(log_entry.message, log_message)
end

test_logging_off = function()
  test_object.log = false
  local log_entry = test_object:log_event(level, event)
  lunit.assertNil(log_entry)
end

-- Test Runner
lunit.LuaUnit.run()