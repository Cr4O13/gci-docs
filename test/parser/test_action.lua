-- ---------------------------------------------------------
-- Test Parse Action Specification
-- ---------------------------------------------------------
--[[---------------------------------------------------------
action-field :: action-keyword : { responder-list }
action-keyword :: "write" | "send" | "publish"
--]]---------------------------------------------------------
responder_model = require "src/model/responder"
control_model = require "src/model/control"
parse = require "src/parser/parse"
lunit = require "test/lib/luaunit"

action_map    = responder_model.action_map
output_map    = responder_model.output_map
local gci_responder = responder_model.gci_responder

input_map     = control_model.input_map
local gci_control   = control_model.gci_control

defaults = {
    
    simulator = "fs2020",
    
    controller = {
      log = false
    },
    
    control = {
      log = false
    },
    
    axis = {
      trigger = "on_change",
      scale = 1, 
      invert = false,
      unit = "DOUBLE",
      initial = 0.0 
    },
    
    button = {
      trigger = "on_true",
      invert = false,
      unit = "BOOL",
      initial = false
    },
    
    timed = {
      trigger = "on_time",
      delay = 0,
      period = 250
    },
    
    modal = {
      trigger = "on_mode1",
      delay = 500
    },
    
    switched = {
      trigger = "on_zero"
    }
  }

sim = defaults.simulator
gci_control_type = "axis"

-- Test Data
local responder_list = { "EVENT" }

action_keywords = { "write", "send", "publish" }

local tests = {
  writes = {
    test_write    = { write   = responder_list },
  },
  sends = {
    test_send     = { send    = responder_list },
  },
  publishes = {
    test_publish  = { publish = responder_list },
  },
  fails = {
    test_null       = { },
    test_bool       = { write = true       },
    test_number     = { send = 8           },
    test_empty      = { publish = "it"     },
    test_obj_alias  = { action = { }       },
  }
}

-- Create Test Cases
local function testcases( cases )
  local tests = {}
  for name, case in pairs(cases.writes) do
    tests[name] = function ()
      local responders = parse.action( "axis", "write", case.write  )
      lunit.assertNotNil( responders )
      lunit.assertNotNil( responders.on_change)
    end
  end
  for name, case in pairs(cases.sends) do
    tests[name] = function ()
      local responders = parse.action( "axis", "send", case.send  )
      lunit.assertNotNil( responders )
      lunit.assertNotNil( responders.on_change)
    end
  end
  for name, case in pairs(cases.publishes) do
    tests[name] = function ()
      local responders = parse.action( "axis", "publish", case.publish )
      lunit.assertNotNil( responders )
      lunit.assertNotNil( responders.on_change)
    end
  end
  for name, case in pairs(cases.fails) do
    tests[name] = function ()
      local responders = parse.action( "axis", "write", case.write or case.send or case.publish )
      lunit.assertNil( responders )

    end
  end
  return tests
end

-- Test Packages and Cases
Test_ParseAction = testcases(tests)

-- Test Runner
lunit.LuaUnit.run()