-- ---------------------------------------------------------
-- Test Parse Control Specification
-- ---------------------------------------------------------
--[[---------------------------------------------------------
action-field :: action-keyword : { responder-list }
action-keyword :: "write" | "send" | "publish"
--]]---------------------------------------------------------
-- Imports
local lu = require "test/lib/luaunit"
--local control = require "src/model/control"
--local responder = require "src/model/responder"
local parse = require "src/parser/parse"

-- Model Data
-- Test Case Data
local base_type = "axis"

-- Test Case Specifications
local testcases = {
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

-- Create Tests from Test Case Specifications
local function create_tests( cases )
  local tests = {}
  for name, spec in pairs(cases.succeeds) do
    tests[name] = function ()
      local control = parse.control( base_type, spec )
      lu.assertNotNil( control )
    end
  end
  for name, spec in pairs(cases.fails) do
    tests[name] = function ()
      local control = parse.control( spec )
      lu.assertNil( control )
    end
  end
  return tests
end

-- Test Collection
Test_All = create_tests( testcases )

-- Test Runner
lu.LuaUnit.run()