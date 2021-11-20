-- ---------------------------------------------------------
-- Test Axis Control
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
local index = 0
local label = "A0"
local basetype = "axis"
local subtype    = "axis"
local parameters = nil

local trigger  = "on_change"
local action   = "write"
local variable = "RUDDER POSITION"
local unit     = "Position"
local output   = "default"

local axis_responder = {
--  log      = log, -- Issue #32
  var_id   = variable,
  unit_id  = unit,
  output   = output,
  
  respond  = action_map[sim][action],
  output   = output_map[subtype][output]
}

local responders = {}
responders[trigger] = gci_responder:new(axis_responder)

local axis_object = {
  log = log,
  index = index, 
  label = label,
  subtype = subtype, 
  parameters = parameters,
  map = input_map[subtype],
  responders = responders
}

local model = gci_control:new( axis_object )

-- Test Case Data
-- Test Case Specifications
local testcases = {
  succeed = {
    test_obj_max = {
      log = log,
      id = { index = index, label = label },
      subtype = "axis",
      write = { 
        on_change = {
          variable = variable,
          unit = unit,
          offset = nil,
          force = nil,
          output = "input"
        }
      }
    },
    test_obj_min = {
      log = log,
      id = { index = index, label = label },
      write = { 
        on_change = {
          variable = variable,
          unit = unit
        }
      }
    },
    test_id_array_min = {
      log = log,
      id = { index, label },
      write = { 
        on_change = {
          variable = variable,
          unit = unit
        }
      }
    },
    test_on_change_array_min = {  -- Enhancement #33
      log = log,
      id = { index = index, label = label },
      write = { 
        on_change = { variable, unit }
      }
    },    
    test_omit_trigger_min = {  -- Enhancement #34
      log = log,
      id = { index = index, label = label },
      write = {
        variable = variable,
        unit = unit
      }
    },
    test_omit_trigger_array_min = {  -- Enhancement #34
      log = log,
      id = { index = index, label = label },
      write = { variable, unit }
    },
  },
  fail = {

  }
}

-- Create Tests from Test Case Specifications
local function create_tests( cases )
  local tests = {}
  for name, spec in pairs( cases.succeed ) do
    tests[name] = function ()
      local axis = parse.control( basetype, spec ) 
      lu.assertNotNil( axis )
      lu.assertEquals( axis, model )
    end
  end
  for name, spec in pairs( cases.fail ) do
    tests[name] = function ()
      local axis = parse.control( basetype, spec ) 
      lu.assertNil( axis )
    end
  end
  return tests
end

-- Test Collection
Test_All = create_tests( testcases )

-- Test Runner
lu.LuaUnit.run()
