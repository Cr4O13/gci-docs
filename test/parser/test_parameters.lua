-- ---------------------------------------------------------
-- Test Parse Parameters Specification
-- ---------------------------------------------------------
parse = require "src/parser/parse"
lunit = require "test/lib/luaunit"

-- Test Data
local param = 100

local tests = {
  succeeds = {
    test_table    = { parameters = { param } },
    test_item     = { parameters = param },
  },
  fails = {
    
  }
}

-- Create Test Cases
local function testcases( cases )
  local tests = {}
  for name, case in pairs(cases.succeeds) do
    tests[name] = function ()
      local parameters = parse.parameters( case.parameters )
      lunit.assertNotNil( parameters )
      lunit.assertEquals( parameters, { param } )
    end
  end
  for name, case in pairs(cases.fails) do
    tests[name] = function ()
      
    end
  end
  return tests
end

-- Test Packages and Cases
Test_ParseParameters = testcases(tests)

-- Test Runner
lunit.LuaUnit.run()