-- ---------------------------------------------------------
-- Test GCI Model Base class
-- ---------------------------------------------------------
--[[---------------------------------------------------------
requirements to test
--]]---------------------------------------------------------
-- Imports
local lu = require "test/lib/luaunit"
local gci_base = require "src/model/base"
local airmanager = require "test/mock/airmanager"

-- Model Data
-- Test Case Data
local level = "INFO"
local event = "Test"
local message = "gci_base test"
local log_message = "GCI: " .. message

local object = { 
  events = {}
}
object.events[event] = message

local test_object = gci_base:new(object)

-- Test Case Specifications
local testcases = {
  construct = {
    test_constructor = object
  },
  logging = {
    test_true = object
  },
  nolog = {
    test_false = object
  }
}

-- Create Tests from Test Case Specifications
local function create_tests( cases )
  local tests = {}
  for name, spec in pairs(cases.construct) do
    tests[name] = function ()
      local test_object = gci_base:new(spec)
      lu.assertNotNil(test_object)
      lu.assertNotNil(test_object.events)
      lu.assertNotNil(test_object.events[event])
      lu.assertEquals(test_object.events[event], message)
    end
  end
  for name, spec in pairs(cases.logging) do
    tests[name] = function ()
      local test_object = gci_base:new(spec)
      spy_message = {}
      test_object.log = true
      test_object:log_event(level, event)
      lu.assertEquals(spy_message.level, level)
      lu.assertEquals(spy_message.text, log_message)
    end
  end
  for name, spec in pairs(cases.nolog) do
    tests[name] = function ()
      local test_object = gci_base:new(spec)
      spy_message = {}
      test_object.log = false
      test_object:log_event(level, event)
      lu.assertEquals(spy_message, {} )
    end
  end
  return tests
end

-- Test Collection
Test_All = create_tests( testcases )

-- Test Runner
lu.LuaUnit.run()