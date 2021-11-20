-- ---------------------------------------------------------
-- Test GCI - Parse Output Value Specification
-- ---------------------------------------------------------
--[[---------------------------------------------------------
output-spec      :: "output" : output-arguments
output-arguments :: axis-arguments | button-arguments

axis-arguments  :: axis-longform | axis-shortform
axis-longform   :: { invert-spec, scale-spec, response-spec }
axis_shortform  :: "invert" | "input" | null

button-arguments:: button-longform | button-shortform
button-longform :: { invert-spec, fixed-value-spec }
button-shortform:: "invert" | "input" | null | literal-value | global-variable

invert-spec     :: "invert" : invert-value
invert-value    :: boolean

scale-spec      :: "scale" : scale-value
scale-value     :: number

response-spec     :: "response" : response-settings
response-settings :: [ fix-point, fix-point, ... ]
fix-point         :: [ input-value, output-value ]
input-value       :: number
output-value      :: number

fixed-value-spec:: (see test_value.lua)
--]]---------------------------------------------------------
-- Imports
local lu = require "test/lib/luaunit"
local parse = require "src/parser/parse"

-- Model Data
-- Test Case Data
local response_settings = {
  {  1.0, -1.0 },
  {  0.0,  0.0 },
  { -1.0,  1.0 }
}

local scale = 100
local val = 100

-- Test Case Specifications
local testcases = {
  none = {
    test_null   = { },
    test_empty  = { output = {} },
    test_num    = { 8 },
    test_number = { output = 8 },
    test_string = { output = "string" }
  },
  fixed = {
    test_value  = { output = { value = val } }
  },
  direct = {
    test_input  = { output = "input" }, --
    test_invfals= { output = { invert = false } } --
  },
  inverted = {
    test_invert = { output = "invert" }, 
    test_invtrue= { output = { invert = true  } } 
  },
  scaled = {
    test_scale  = { output = { scale = scale } } 
  },
  non_linear = {
    test_respon = { output = { response = response_settings } }, 
  }
}

--local input = 1.0

-- Create Tests from Test Case Specifications
local function create_tests( cases )
  local tests = {}
  for name, case in pairs(cases.direct) do
    tests[name] = function ()
      local output = parse.output( case.output )
      lu.assertNotNil( output )
      lu.assertIsString( output )
      lu.assertEquals( output, "direct" )
    end
  end
  for name, case in pairs(cases.inverted) do
    tests[name] = function ()
      local output = parse.output( case.output )
      lu.assertNotNil( output )
      lu.assertIsString( output )
      lu.assertEquals( output, "inverted" )
    end
  end
  for name, case in pairs(cases.none) do
    tests[name] = function ()
      local output = parse.output( case.output )
      lu.assertNil( output )
    end
  end  for name, case in pairs(cases.scaled) do
    tests[name] = function ()
      local output = parse.output( case.output )
      lu.assertNotNil( output )
      lu.assertIsString( output )
      lu.assertEquals( output, "scaled" )
    end
  end
  for name, case in pairs(cases.fixed) do
    tests[name] = function ()
      local output = parse.output( case.output )
      lu.assertNotNil( output )
      lu.assertIsString( output )
      lu.assertEquals( output, "fixed" )
    end
  end
    for name, case in pairs(cases.non_linear) do
    tests[name] = function ()
      local output = parse.output( case.output )
      lu.assertNotNil( output )
      lu.assertIsString( output )
      lu.assertEquals( output, "nonlinear" )
    end
  end
  return tests
end

-- Test Collection
Test_All = create_tests( testcases )

-- Test Runner
lu.LuaUnit.run()