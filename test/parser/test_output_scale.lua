-- ---------------------------------------------------------
-- Test GCI - Parse Axis Output Scale Specification
-- ---------------------------------------------------------
--[[---------------------------------------------------------
requirements to test
--]]---------------------------------------------------------
-- Imports
local lu = require "test/lib/luaunit"
local parse = require "src/parser/parse"

-- Model Data
-- Test Case Data
-- Test Case Specifications
local testcases = {
  succeeds = {
    test_ident = { scale = 1 },
    test_real  = { scale = 0.5 },
    test_neg   = { scale = -1.0 },
    test_32k   = { scale = 16383 }
  },
  fails = {
    test_zero   = { scale = 0 },
    test_rzero  = { scale = 0.0 },
    test_bool   = { scale = true },
    test_string = { scale = "true" },
    test_empty  = { scale = {} }
  }
}

-- Create Tests from Test Case Specifications
local function create_tests( cases )
  local tests = {}
  for name, case in pairs(cases.succeeds) do
    tests[name] = function ()
      local scale = parse.scale( case.scale )
      lu.assertNotNil( scale )
      lu.assertIsNumber( scale )
      lu.assertNotIs( scale, 0 )
    end
  end
  for name, case in pairs(cases.fails) do
    tests[name] = function ()
      local scale = parse.scale( case.scale )
      lu.assertNil( scale )
    end
  end
  return tests
end

-- Test Collection
Test_All = create_tests( testcases )

-- Test Runner
lu.LuaUnit.run()