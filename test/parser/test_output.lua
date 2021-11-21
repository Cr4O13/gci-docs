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
local settings = {
  { -1.0,  1.0 },
  {  0.0,  0.0 },
  {  1.0, -1.0 }
}

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
      lu.assertEquals( output.option, "direct" )
      lu.assertNil( output.scale )
      lu.assertNil( output.setting )
      lu.assertNil( output.value )
    end
  end
  for name, case in pairs(cases.inverted) do
    tests[name] = function ()
      local output = parse.output( case.output )
      lu.assertNotNil( output )
      lu.assertEquals( output.option, "inverted" )
      lu.assertNil( output.scale )
      lu.assertNil( output.setting )
      lu.assertNil( output.value )
    end
  end
  for name, case in pairs(cases.scaled) do
    tests[name] = function ()
      local output = parse.output( case.output )
      lu.assertNotNil( output )
      lu.assertEquals( output.option, "scaled" )
      lu.assertEquals( output.scale, scale )
      lu.assertNil( output.setting )
      lu.assertNil( output.value )
    end
  end
  for name, case in pairs(cases.fixed) do
    tests[name] = function ()
      local output = parse.output( case.output )
      lu.assertNotNil( output )
      lu.assertEquals( output.option, "fixed" )
      lu.assertEquals( output.value, val )
      lu.assertNil( output.scale )
      lu.assertNil( output.setting )
    end
  end
    for name, case in pairs(cases.non_linear) do
    tests[name] = function ()
      local output = parse.output( case.output )
      lu.assertNotNil( output )
      lu.assertEquals( output.option, "nonlinear" )
      lu.assertEquals( output.settings, settings )
      lu.assertNil( output.scale )
      lu.assertNil( output.value )
    end
  end
  for name, case in pairs(cases.none) do
    tests[name] = function ()
      local output = parse.output( case.output )
      lu.assertNil( output.option )
      lu.assertNil( output.scale )
      lu.assertNil( output.setting )
      lu.assertNil( output.value )
    end
  end
  return tests
end

-- Test Collection
Test_All = create_tests( testcases )

-- Test Runner
lu.LuaUnit.run()