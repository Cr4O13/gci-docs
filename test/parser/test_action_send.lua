-- ---------------------------------------------------------
-- Test Parse Send Responders
-- ---------------------------------------------------------
--[[---------------------------------------------------------
action-field :: action-keyword : { responder-list }
action-keyword :: "write" | "send" | "publish"
--]]---------------------------------------------------------
local model = require "src/model/responder"
local parse = require "src/parser/parse"
local lunit = require "test/lib/luaunit"

action_map          = model.action_map
output_map          = model.output_map
local gci_responder = model.gci_responder

-- Test Data
-- Test Data
sim    = "fs2020"
action = "send"
gci_control_type = "button"


local tests = {
  succeeds = {
    test_send = { 
      send = { 
        on_true = { event = "EVENT" },
        on_false = { event = "EVENT" }
      }
    }
  },
  fails = {
    test_empty      = { send = {}          },
    test_obj_alias  = { send = { test_action } },
    test_seq_alias  = { send = { 8 }       }
  }
}

-- Create Test Cases
local function testcases( cases )
  local tests = {}
  for name, case in pairs(cases.succeeds) do
    tests[name] = function ()
      local responders = parse.action( gci_control_type, action, case.send )
      lunit.assertNotNil( responders )
      lunit.assertNotNil( responders.on_true )
      lunit.assertNotNil( responders.on_false )
    end
  end
  for name, case in pairs(cases.fails) do
    tests[name] = function ()
      local responders = parse.action( "button", "send", case.send )
      lunit.assertNil( responders )
    end
  end
  return tests
end

-- Test Packages and Cases
Test_ParseAction = testcases(tests)

-- Test Runner
lunit.LuaUnit.run()