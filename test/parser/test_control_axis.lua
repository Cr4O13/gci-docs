-- ---------------------------------------------------------
-- Test Axis Control
-- ---------------------------------------------------------
local responder_model = require "src/model/responder"
local control_model = require "src/model/control"
local mock_am = require "test/mock/airmanager"
local parse = require "src/parser/parse"
local lunit = require "test/lib/luaunit"

log = mock_am.log

si_variable_write     = mock_am.si_variable_write
fs2020_variable_write = mock_am.fs2020_variable_write
fs2020_event          = mock_am.fs2020_event
fsx_variable_write    = mock_am.sx_variable_write
fsx_event             = mock_am.sx_event
xpl_dataref_write     = mock_am.pl_dataref_write
xpl_command           = mock_am.pl_command

action_map    = responder_model.action_map
output_map    = responder_model.output_map
local gci_responder = responder_model.gci_responder

input_map     = control_model.input_map
local gci_control   = control_model.gci_control

-- ===== Model Data =====
sim = "fs2020"
gci_control_type = "axis"

local log = true
local index = 0
local label = "A0"
local subtype = "axis"
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

-- ==== Test Cases  ====
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
--    test_on_change_array_min = {  -- Enhancement #33
--      log = log,
--      id = { index = index, label = label },
--      write = { 
--        on_change = { variable, unit }
--      }
--    },    
--    test_omit_trigger_min = {  -- Enhancement #34
--      log = log,
--      id = { index = index, label = label },
--      write = {
--        variable = variable,
--        unit = unit
--      }
--    },
--    test_omit_trigger_array_min = {  -- Enhancement #34
--      log = log,
--      id = { index = index, label = label },
--      write = { variable, unit }
--    },
  },
  fail = {

  }
}

-- ==== Test Cases  ====
local function createtest( cases )
  local tests = {}
  for name, spec in pairs( cases.succeed ) do
    tests[name] = function ()
      local axis = parse.control( spec ) 
      lunit.assertNotNil( axis )
      lunit.assertEquals( axis, model )
    end
  end
  for name, spec in pairs( cases.fail ) do
    tests[name] = function ()
      local axis = parse.control( spec ) 
      lunit.assertNil( axis )
    end
  end
  return tests
end

-- Test Packages and Cases
Test_Control_Axis = createtest( testcases )

-- Test Runner
lunit.LuaUnit.run()
