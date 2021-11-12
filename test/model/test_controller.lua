-- ---------------------------------------------------------
-- Test GCI Controller Model
-- ---------------------------------------------------------
local model = require "src/model/controller"
local mock_am = require "test/mock/airmanager"
local lunit = require "test/lib/luaunit"

log = mock_am.log
game_controller_add = mock_am.game_controller_add

gci_controller = model.gci_controller

-- Test Data
local name = "Flight Yoke System"
local controls = {}
controls[0] = {}
controls[1] = {}

local control = { 
  type = 1, -- button
  index = 3,
  input = true
}

local controller = {
  log = true,
  name = name,
  controls = controls
}

test_interface = function()
  lunit.assertNotNil(gci_controller)
  lunit.assertNotNil(gci_controller.new)
  lunit.assertNotNil(gci_controller.dispatcher)
end

test_functional_events = function()
  lunit.assertNotNil(gci_controller.events)
  lunit.assertNotNil(gci_controller.events.added)
  lunit.assertNotNil(gci_controller.events.called)
  lunit.assertNotNil(gci_controller.events.not_found)
  lunit.assertNotNil(gci_controller.events.dispatched)
end

test_constructor = function()
  spy_controllers = {}
  spy_message = {}
  local test_controller = gci_controller:new(controller)
  lunit.assertNotNil(test_controller)
  lunit.assertNotNil(test_controller.name)
  lunit.assertEquals(test_controller.name, name)
  lunit.assertNotNil(test_controller.controls)
  lunit.assertEquals(test_controller.controls, controls)
  lunit.assertNotNil(test_controller.id)
  lunit.assertNotNil(spy_controllers[name])
  lunit.assertEquals(spy_message.level, "INFO")
  lunit.assertEquals(spy_message.text, "GCI: Controller 'Flight Yoke System' registered")
end

test_dispatcher_called = function()
  spy_controllers = {}
  local test_controller = gci_controller:new(controller)
  lunit.assertNotNil(test_controller.dispatcher)
  spy_controllers[name](control.type, control.index, control.input)
  lunit.assertEquals(spy_message.level, "INFO")
  lunit.assertEquals(spy_message.text, "GCI: 'Flight Yoke System' called with: (1, 3, true)")
end

-- Test Runner
lunit.LuaUnit.run()
