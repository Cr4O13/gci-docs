-- ---------------------------------------------------------
-- Test Parse Action Specification
-- ---------------------------------------------------------
--[[---------------------------------------------------------
action-field :: action-keyword : { responder-list }
action-keyword :: "write" | "send" | "publish"
--]]---------------------------------------------------------
parse = require "src/parser/parse"
lunit = require "test/lib/luaunit"

-- Test Data
local responder_list = {
}

action_keywords = { "write", "send", "publish" }

local tests = {
  succeeds = {
    test_write    = { write = responder_list },
    test_send     = { send = responder_list },
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
  for name, case in pairs(cases.succeeds) do
    tests[name] = function ()
      local responders = parse.action( case.write or case.send or case.publish )
      lunit.assertNotNil( responders )
      lunit.assertEquals( responders, {} )
    end
  end
  for name, case in pairs(cases.fails) do
    tests[name] = function ()
      local responders = parse.action( case.write or case.send or case.publish )
      lunit.assertNil( responders )

    end
  end
  return tests
end

-- Test Packages and Cases
Test_ParseAction = testcases(tests)

-- Test Runner
lunit.LuaUnit.run()