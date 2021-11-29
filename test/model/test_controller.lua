-- ---------------------------------------------------------
-- Test GCI Controller Model
-- ---------------------------------------------------------
--[[---------------------------------------------------------
requirements to test
--]]---------------------------------------------------------
-- Imports
local lu = require "test/lib/luaunit"

local controller = require "src/model/controller"
local gci_controller = controller.gci_controller

local airmanager = require "test/mock/airmanager"

-- Model Data
local controller_name = "Flight Yoke System"
local controls = {}
controls[0] = {}
controls[1] = {}

local control = { 
  type = 1, -- button
  index = 3,
  input = true
}

local model = {
  log = true,
  name = controller_name,
  controls = controls
}

-- Test Case Data

-- Test Case Specifications
local testcases = {
  interface = {
    test_interface = model
  },
  construct = {
    test_construct = model
  },
  functional = {
    test_functional = model
  },
  dispatch = {
    test_dispatch = model
  }
}

-- Create Tests from Test Case Specifications
local function create_tests( cases )
  local tests = {}
  for name, _ in pairs(cases.interface) do
    tests[name] = function ()
      lu.assertNotNil(gci_controller)
      lu.assertNotNil(gci_controller.new)
      lu.assertNotNil(gci_controller.dispatcher)
    end
  end
  for name, _ in pairs(cases.functional) do
    tests[name] = function()
      lu.assertNotNil(gci_controller.events)
      lu.assertNotNil(gci_controller.events.added)
      lu.assertNotNil(gci_controller.events.called)
      lu.assertNotNil(gci_controller.events.not_found)
      lu.assertNotNil(gci_controller.events.dispatched)
    end
  end
  for name, spec in pairs(cases.construct) do
    tests[name] = function()
      spy_controllers = {}
      spy_message = {}
      local test_controller = gci_controller:new( spec )
      lu.assertNotNil(test_controller)
      lu.assertNotNil(test_controller.name)
      lu.assertEquals(test_controller.name, controller_name)
      lu.assertNotNil(test_controller.controls)
      lu.assertEquals(test_controller.controls, controls)
      lu.assertNotNil(test_controller.id)
      lu.assertNotNil(spy_controllers[controller_name])
      lu.assertEquals(spy_message.level, "INFO")
      lu.assertEquals(spy_message.text, "GCI: Controller 'Flight Yoke System' registered")
    end
  end
  for name, spec in pairs(cases.dispatch) do
    tests[name] = function()
      spy_controllers = {}
      local test_controller = gci_controller:new( spec )
      lu.assertNotNil(test_controller.dispatcher)
      spy_controllers[controller_name](control.type, control.index, control.input)
      lu.assertEquals(spy_message.level, "INFO")
      lu.assertEquals(spy_message.text, "GCI: 'Flight Yoke System' called with: (1, 3, true)")
    end
  end
  return tests
end

-- Test Collection
Test_All = create_tests( testcases )

-- Test Runner
lu.LuaUnit.run()
