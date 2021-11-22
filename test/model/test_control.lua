-- ---------------------------------------------------------
-- Test GCI Control Model
-- ---------------------------------------------------------
--[[---------------------------------------------------------
requirements to test
--]]---------------------------------------------------------
-- Imports
local lu = require "test/lib/luaunit"
local control = require "src/model/control"
local gci_control = control.gci_control

local airmanager = require "test/mock/airmanager"

-- Model Data
local input = true

local responders = {}
responders[input] = nil

local model = { 
  map = function (input) return input end,
  responders = responders,
  subtype = "Test",
  index = 0,
  label = "T0"
}

-- Test Case Data

-- Test Case Specifications
local testcases = {
  interface = {
    test_interface = model
  },
  create = {
    test_create = model
  },
  maintain = {
    test_maintain = model
  },
  receive = {
    test_receive = model
  }
}

-- Create Tests from Test Case Specifications
local function create_tests( cases )
  local tests = {}
  for name, spec in pairs(cases.interface) do
    tests[name] = function ()
      lu.assertNotNil(gci_control)
      lu.assertNotNil(gci_control.new)
      lu.assertNotNil(gci_control.handle)
      lu.assertNotNil(gci_control.handler)
    end
  end
  for name, spec in pairs(cases.create) do
    tests[name] = function ()
      local test_control = gci_control:new(spec)
      lu.assertNotNil(test_control)
      lu.assertNotNil(test_control.map)
      lu.assertNotNil(test_control.responders)
      lu.assertNotNil(test_control.subtype)
      lu.assertNotNil(test_control.label)
    end
  end
  for name, spec in pairs(cases.maintain) do
    tests[name] = function ()
      local test_control = gci_control:new(spec)
      lu.assertNotNil(test_control)
      lu.assertNotNil(test_control.events)
    end
  end
  for name, spec in pairs(cases.receive) do
    tests[name] = function ()
      local test_control = gci_control:new(spec)
      lu.assertNotNil(test_control.handle)
      test_control:handle(input)
      lu.assertNotNil(spy_message)
    end
  end
  return tests
end
  
-- Test Collection
Test_All = create_tests( testcases )

-- Test Runner
lu.LuaUnit.run()