-- ---------------------------------------------------------
-- Test Switched Axis Control
-- ---------------------------------------------------------
-- Imports
local lu = require "test/lib/luaunit"

local gci = require "src/gci"
local sim = gci.sim

local responder = require "src/model/responder"
local action_map    = responder.action_map
local output_map    = responder.output_map
local gci_responder = responder.gci_responder

local control = require "src/model/control"
local input_map     = control.input_map
local gci_control   = control.gci_control

local parse = require "src/parser/parse"

---- Model Data
local log = true
local index = 6
local label = "A6"
local basetype = "axis"
local subtype   = "switched"
local parameters = nil

local action    = "send"
local trigger   = {
  on_plus  = "on_plus",
  on_zero  = "on_zero",
  on_minus = "on_minus"
}

local unit      = "Position"
local output    = "default"

local plus_responder = {
--  log      = log, -- Issue #32
  var_id   = trigger.on_plus,
  respond  = action_map[sim][action],
  output   = output_map[subtype][output]
}

local zero_responder = {
--  log      = log, -- Issue #32
  var_id   = trigger.on_zero,
  respond  = action_map[sim][action],
  output   = output_map[subtype][output]
}

local minus_responder = {
--  log      = log, -- Issue #32
  var_id   = trigger.on_minus,
  respond  = action_map[sim][action],
  output   = output_map[subtype][output]
}

responder_zero  = gci_responder:new(zero_responder)
responder_plus  = gci_responder:new(plus_responder)
responder_minus = gci_responder:new(minus_responder)

local responders = {}
responders[trigger.on_zero]  = responder_zero 
responders[trigger.on_plus]  = responder_plus 
responders[trigger.on_minus] = responder_minus

local responders_zero = {}
responders_zero[trigger.on_zero]  = responder_zero 


local switched_object = {
  log = log,
  index = index, 
  label = label,
  subtype = subtype, 
  parameters = parameters,
  map = input_map[subtype],
  responders = responders
}

local model = gci_control:new( switched_object )

local switched_object_zero = {
  log = log,
  index = index, 
  label = label,
  subtype = subtype, 
  parameters = parameters,
  map = input_map[subtype],
  responders = responders_zero
}

local model_zero = gci_control:new( switched_object_zero )

-- Test Case Data
-- Test Case Specifications
local testcases = {
  succeed = {
    test_obj_max = {
      log = log,
      id = { index = index, label = label },
      subtype = subtype,
      send = { 
        on_plus  = { event = trigger.on_plus  },
        on_zero  = { event = trigger.on_zero  },
        on_minus = { event = trigger.on_minus }        
      }
    },
    test_array = {
      log = log,
      id = { index, label },
      subtype = subtype,
      send = { 
        on_plus  = { trigger.on_plus  },
        on_zero  = { trigger.on_zero  },
        on_minus = { trigger.on_minus }    
      }
    },
    test_simple = {
      log = log,
      id = { index, label },
      subtype = subtype,
      send = { 
        on_plus  = trigger.on_plus,
        on_zero  = trigger.on_zero,
        on_minus = trigger.on_minus     
      }
    }
  },
  default_trigger = {
    test_omit_trigger_obj = {  -- Enhancement #34
      log = log,
      id = { index = index, label = label },
      subtype = subtype,
      send = { event = trigger.on_zero }
    },
    test_omit_trigger_array = {  -- Enhancement #34
      log = log,
      id = { index = index, label = label },
      subtype = subtype,
      send = { trigger.on_zero }
    },
    test_omit_trigger_simple = {  -- Enhancement #34
      log = log,
      id = { index = index, label = label },
      subtype = subtype,
      send = trigger.on_zero
    }
  }
}

-- Create Tests from Test Case Specifications
local function create_tests( cases )
  local tests = {}
  for name, spec in pairs( cases.succeed ) do
    tests[name] = function ()
      local control = parse.control( basetype, spec ) 
      lu.assertNotNil( control )
      lu.assertEquals( control, model )
    end
  end
  for name, spec in pairs( cases.default_trigger ) do
    tests[name] = function ()
      local control = parse.control( basetype, spec ) 
      lu.assertNotNil( control )
      lu.assertEquals( control, model_zero )
    end
  end
  return tests
end

-- Test Collection
Test_All = create_tests( testcases )

-- Test Runner
lu.LuaUnit.run()
