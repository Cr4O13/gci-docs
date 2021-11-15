-- ---------------------------------------------------------
-- Test Parse Axis Output Scale Specification
-- ---------------------------------------------------------
parse = require "src/parser/parse"
lunit = require "test/lib/luaunit"

-- Test Data
defaults = {
  axis = {
    scale = 1
  }
}

local tests = {
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

-- Create Test Cases
local function testcases( cases )
  local tests = {}
  for name, case in pairs(cases.succeeds) do
    tests[name] = function ()
      local scale = parse.scale( case.scale )
      lunit.assertNotNil( scale )
      lunit.assertIsNumber( scale )
      lunit.assertNotIs( scale, 0 )
    end
  end
  for name, case in pairs(cases.fails) do
    tests[name] = function ()
      local scale = parse.scale( case.scale )
      lunit.assertNil( scale )
    end
  end
  return tests
end

-- Test Packages and Cases
Test_ParseSubtype = testcases(tests)

-- Test Runner
lunit.LuaUnit.run()