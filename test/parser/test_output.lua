-- ---------------------------------------------------------
-- Test Parse Output Value Specification
-- ---------------------------------------------------------
--[[---------------------------------------------------------
value-spec      :: "value" : outut-spec
output-spec     :: output-arguments | output-shorthand 

output-arguments:: axis-arguments | button-arguments
axis-arguments  :: { invert-spec, scale-spec, response-spec }
button-arguments:: { invert-spec, value-spec }

invert-spec     :: "invert" : invert-value
invert-value    :: boolean

scale-spec      :: "scale" : scale-value
scale-value     :: number

response-spec : : "response" : response-value
response-value  :: [ fix-points, fix-points, ... ]

value-spec      :: "value" : value
value           :: literal-value | global-variable | literal-table

output-shorthand:: axis-shorthand | button-shorthand
axis-shorthand  :: "invert" | "input"
button-shorthand:: "invert" | "input" | literal-value | global-variable

literal-value   :: number | string | boolean | null
literal-table   :: table
global variable :: identifier
--]]---------------------------------------------------------
local parse = require "src/parser/parse"
local interpolate_functions = require "test/lib/lua_libs/interpolate_functions"
local var_functions = require "test/lib/lua_libs/var_functions"
local lunit = require "test/lib/luaunit"

interpolate_linear = interpolate_functions.interpolate_linear
var_cap = var_functions.var_cap

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

local scale = 100
local val = 100

local outputs = {
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
    test_respon = { output = { response = response_in } }, 
  }
}

local input = 1.0

-- Create Test Cases
local function testcases( cases )
  local tests = {}
  for name, case in pairs(cases.direct) do
    tests[name] = function ()
      local output = parse.output( case.output )
      lunit.assertNotNil( output )
      lunit.assertIsString( output )
      lunit.assertEquals( output, "direct" )
    end
  end
  for name, case in pairs(cases.inverted) do
    tests[name] = function ()
      local output = parse.output( case.output )
      lunit.assertNotNil( output )
      lunit.assertIsString( output )
      lunit.assertEquals( output, "inverted" )
    end
  end
  for name, case in pairs(cases.none) do
    tests[name] = function ()
      local output = parse.output( case.output )
      lunit.assertNil( output )
    end
  end  for name, case in pairs(cases.scaled) do
    tests[name] = function ()
      local output = parse.output( case.output )
      lunit.assertNotNil( output )
      lunit.assertIsString( output )
      lunit.assertEquals( output, "scaled" )
    end
  end
  for name, case in pairs(cases.fixed) do
    tests[name] = function ()
      local output = parse.output( case.output )
      lunit.assertNotNil( output )
      lunit.assertIsString( output )
      lunit.assertEquals( output, "fixed" )
    end
  end
    for name, case in pairs(cases.non_linear) do
    tests[name] = function ()
      local output = parse.output( case.output )
      lunit.assertNotNil( output )
      lunit.assertIsString( output )
      lunit.assertEquals( output, "nonlinear" )
    end
  end
  return tests
end

-- Test Packages and Cases
Test_ParseOutput = testcases(outputs)

-- Test Runner
lunit.LuaUnit.run()