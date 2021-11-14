-- ---------------------------------------------------------
-- Test Parse Axis Output Response Specification
-- ---------------------------------------------------------
parse = require "src/parser/parse"
lunit = require "test/lib/luaunit"

-- Test Data
defaults = {
  axis = {
    scale = 1
  }
}

local response_in = {
  {  1.0, -1.0 },
  {  0.0,  0.0 },
  { -1.0,  1.0 }
}

local response_acceptable = {
  {  1.0, -1.0, "comment" },
  {  0.0, -0.5 },
  {  0.0,  0.0 },
  {  0.5 },
  {},
  { -1.0,  1.0 }
}

local response_out = {
  { -1.0,  1.0 },
  {  0.0,  0.0 },
  {  1.0, -1.0 }
}

local tests = {
  succeeds = {
    test_ok = { response = response_in     },
    test_ok = { response = response_acceptable }
  },
  fails = {
    test_rzero  = { response = 0.0    },
    test_bool   = { response = true   },
    test_string = { response = "true" },
    test_empty  = { response = {}     },
    test_point  = { response = { 1.0, -1.0 }       },
    test_zero   = { response = { {}, {} }          },
    test_one    = { response = { {1.0, -1.0}, {} } }
  }
}

-- Create Test Cases
local function testcases( cases )
  local tests = {}
  for name, case in pairs(cases.succeeds) do
    tests[name] = function ()
      local response = parse.response( case.response )
      lunit.assertNotNil( response )
      lunit.assertIsTable( response )
      lunit.assertEquals( response, response_out )
    end
  end
  for name, case in pairs(cases.fails) do
    tests[name] = function ()
      local response = parse.response( case.response )
      lunit.assertNil( response )
    end
  end
  return tests
end

-- Test Packages and Cases
Test_ParseSubtype = testcases(tests)

-- Test Runner
lunit.LuaUnit.run()