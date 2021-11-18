-- ---------------------------------------------------------
-- Test Parse Controller-List Specification
-- ---------------------------------------------------------
--[[---------------------------------------------------------
controls :: controls-field ( , controls )
controls-field :: axes-field | buttons-field

axes-field :: "axes" : [ control-list ]
buttons-field :: "buttons" : [ control-list ]

control-list :: control-spec ( , control-list )
control-spec :: { required-control-fields ( optional-control-fields ) }

--]]---------------------------------------------------------
local model = require "src/model/responder"
local parse = require "src/parser/parse"
local mock_am = require "test/mock/airmanager"
local lunit = require "test/lib/luaunit"

log = mock_am.log

action_map          = model.action_map
output_map          = model.output_map
local gci_responder = model.gci_responder

-- Test Data
sim    = "fs2020"

-- Test Data
local control_type = "button"

local tests = {
  succeeds = {
    test_ctrls = { 
      { log = true,
        id = { index = 0, label = "Label" },
        send = { on_true = { event = "EVENT" } }
      }
    }
  },
  fails = {

  }
}

-- Create Test Cases
local function testcases( cases )
  local tests = {}
  for name, spec in pairs(cases.succeeds) do
    tests[name] = function ()
      local controls = parse.controls( control_type, spec )
      lunit.assertNotNil( controls )

    end
  end
  for name, spec in pairs(cases.fails) do
    tests[name] = function ()
      local controls = parse.controls( control_type, spec )
      lunit.assertNil( controls )

    end
  end
  return tests
end

-- Test Packages and Cases
Test_ParseControls = testcases(tests)

-- Test Runner
lunit.LuaUnit.run()