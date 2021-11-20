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
-- Imports
local lu = require "test/lib/luaunit"
local parse = require "src/parser/parse"
local airmanager = require "test/mock/airmanager"

-- Test Data
-- Model Data
-- Test Case Data
local base_type = "button"

-- Test Case Specifications
local testcases = {
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

-- Create Tests from Test Case Specifications
local function create_tests( cases )
  local tests = {}
  for name, spec in pairs(cases.succeeds) do
    tests[name] = function ()
      local controls = parse.controls( base_type, spec )
      lu.assertNotNil( controls )
    end
  end
  for name, spec in pairs(cases.fails) do
    tests[name] = function ()
      local controls = parse.controls( base_type, spec )
      lu.assertNil( controls )
    end
  end
  return tests
end

-- Test Collection
Test_All = create_tests( testcases )

-- Test Runner
lu.LuaUnit.run()