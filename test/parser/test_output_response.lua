-- ---------------------------------------------------------
-- Test GCI - Parse Axis Output Response Specification
-- ---------------------------------------------------------
--[[---------------------------------------------------------
axis-output-spec :: { axis-output-field-list }
axis-output-field-list :: axis-output-field ( , axis-output-field-list )
axis-output-field :: invert-field | scale-field | response-field
--]]---------------------------------------------------------
-- Imports
local lu = require "test/lib/luaunit"
local parse = require "src/parser/parse"

-- Model Data
-- Test Case Data
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

-- Test Case Specifications
local testcases = {
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

-- Create Tests from Test Case Specifications
local function create_tests( cases )
  local tests = {}
  for name, case in pairs(cases.succeeds) do
    tests[name] = function ()
      local response = parse.response( case.response )
      lu.assertNotNil( response )
      lu.assertIsTable( response )
      lu.assertEquals( response, response_out )
    end
  end
  for name, case in pairs(cases.fails) do
    tests[name] = function ()
      local response = parse.response( case.response )
      lu.assertNil( response )
    end
  end
  return tests
end

-- Test Collection
Test_All = create_tests( testcases )

-- Test Runner
lu.LuaUnit.run()