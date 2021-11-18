-- ---------------------------------------------------------
-- Test Parse Control Specification
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

-- Test Data
gci_control_type = "button"

local tests = {
  succeeds = {
    test_ctrl = { 
      log = true,
      id = { index = 0, label = "Label" },
      send = { on_true = { event = "EVENT" } }
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
      local control = parse.control( spec )
      lunit.assertNotNil( control )

    end
  end
  for name, spec in pairs(cases.fails) do
    tests[name] = function ()
      local control = parse.control( spec )
      lunit.assertNil( control )

    end
  end
  return tests
end

-- Test Packages and Cases
Test_ParseControl = testcases(tests)

-- Test Runner
lunit.LuaUnit.run()