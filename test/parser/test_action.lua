-- ---------------------------------------------------------
-- Test GCI - Parse Action Specification
-- ---------------------------------------------------------
--[[---------------------------------------------------------
action-field :: action-keyword : { responder-list }
action-keyword :: "write" | "send" | "publish"
--]]---------------------------------------------------------
-- Imports
local parse = require "src/parser/parse"

local lu = require "test/lib/luaunit"

-- Model Data

-- Test Case Data
local responder_list = { on_true = { event = "EVENT" } }

-- Test Case Specifications
local testcases = {
  writes = {
    test_write    = { write   = { on_change = { variable = "VARIABLE", unit = "UNIT" } } },
  },
  sends = {
    test_send     = { send    = { on_change = { event = "EVENT" } } },
  },
  fails = {
    test_null       = { },
    test_bool       = { write = true       },
    test_number     = { send = 8           },
    test_empty      = { publish = "it"     },
    test_obj_alias  = { action = { }       },
    test_publish    = { publish = { on_change = { variable = "VARIABLE", unit = "UNIT", initial = 0.0 } } },
  }
}

-- Create Tests from Test Case Specifications
local function create_tests( cases )
  local tests = {}
  for name, case in pairs(cases.writes) do
    tests[name] = function ()
      local responders = parse.action( "axis", "write", case.write  )
      lu.assertNotNil( responders )
      lu.assertNotNil( responders.on_change)
    end
  end
  for name, case in pairs(cases.sends) do
    tests[name] = function ()
      local responders = parse.action( "axis", "send", case.send  )
      lu.assertNotNil( responders )
      lu.assertNotNil( responders.on_change)
    end
  end
  for name, case in pairs(cases.fails) do
    tests[name] = function ()
      local responders = parse.action( "axis", "write", case.write or case.send )
      lu.assertNil( responders )

    end
  end
  return tests
end

-- Test Collection
Test_All = create_tests( testcases )

-- Test Runner
lu.LuaUnit.run()