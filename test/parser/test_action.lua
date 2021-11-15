-- ---------------------------------------------------------
-- Test Parse Action Specification
-- ---------------------------------------------------------
--[[---------------------------------------------------------
action-spec     :: "action" : action-value
action-value    :: "write" | "send" | "publish"
--]]---------------------------------------------------------
parse = require "src/parser/parse"
lunit = require "test/lib/luaunit"

defaults = {
  action = "write"
}

-- Test Data
local test_action = "send"

local tests = {
  succeeds = {
    test_string     = { action = test_action },
  },
  fails = {
    test_null       = { },
    test_bool       = { action = true        },
    test_number     = { action = 8           },
    test_empty      = { action = {}          },
    test_obj_alias  = { action = { test_action } },
    test_seq_alias  = { action = { 8 }       }
  }
}

-- Create Test Cases
local function testcases( cases )
  local tests = {}
  for name, case in pairs(cases.succeeds) do
    tests[name] = function ()
      local action = parse.action( case.action )
      lunit.assertNotNil( action )
      lunit.assertEquals( action, test_action )
    end
  end
  for name, case in pairs(cases.fails) do
    tests[name] = function ()
      local action = parse.action( case.action )
      lunit.assertNotNil( action )
      lunit.assertEquals( action, defaults.action )
    end
  end
  return tests
end

-- Test Packages and Cases
Test_ParseAction = testcases(tests)

-- Test Runner
lunit.LuaUnit.run()