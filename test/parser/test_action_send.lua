-- ---------------------------------------------------------
-- Test Parse Send Responders
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
local action = "send"
local gci_control_type = "button"

-- Test Case Specifications
local testcases = {
  full = {
    test_obj = { 
      send = { 
        on_true =  { event = "EVENT" },
        on_false = { event = "EVENT" }
      }
    },
    test_array = { 
      send = { 
        on_true  = { "EVENT" },
        on_false = { "EVENT" }
      }
    },
    test_simple = { 
      send = { 
        on_true  = "EVENT",
        on_false = "EVENT"
      }
    }
  },
  default = {
    test_obj_default = { 
      send = { event = "EVENT" }
    },
    test_array_default = { 
      send = { "EVENT" }
    },
    test_simple_default = { 
      send = "EVENT"
    }
  },
  fails = {
    test_empty      = { send = {}          },
    test_seq_alias  = { send = { 8 }       }
  }
}

-- Create Tests from Test Case Specifications
local function create_tests( cases )
  local tests = {}
  for name, case in pairs(cases.full) do
    tests[name] = function ()
      local responders = parse.action( gci_control_type, action, case.send )
      lu.assertNotNil( responders )
      lu.assertNotNil( responders.on_true )
      lu.assertNotNil( responders.on_false )
    end
  end
  for name, case in pairs(cases.default) do
    tests[name] = function ()
      local responders = parse.action( gci_control_type, action, case.send )
      lu.assertNotNil( responders )
      lu.assertNotNil( responders.on_true )
      lu.assertNil( responders.on_false )
    end
  end
  for name, case in pairs(cases.fails) do
    tests[name] = function ()
      local responders = parse.action( "button", "send", case.send )
      lu.assertNil( responders )
    end
  end
  return tests
end

-- Test Collection
Test_All = create_tests( testcases )

-- Test Runner
lu.LuaUnit.run()