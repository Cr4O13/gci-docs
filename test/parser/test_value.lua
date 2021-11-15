-- ---------------------------------------------------------
-- Test Parse Output Value Specification
-- ---------------------------------------------------------
--[[---------------------------------------------------------
fixed-value-spec:: "value" : value
value           :: literal-value | global-variable | literal-table

literal-value   :: number | string | boolean | null
literal-table   :: table
global variable :: identifier
--]]---------------------------------------------------------
local parse = require "src/parser/parse"
local lunit = require "test/lib/luaunit"

-- Test Data
local fixed_values = {
  number = {
    test_number = { value = 13.0 },
    test_zero   = { value = 0.00 },
    test_number = { value = 8 },
    test_zero   = { value = 0 },
    test_zeron  = { value = -0 },
    test_maxp   = { value = math.maxinteger },
    test_maxm   = { value = -math.maxinteger }
  },
  string = {
    test_input  = { value = "any string" },
    test_input  = { value = "input"      },
    test_invfals= { value = "invert"     } 
  },
  boolean = {
    test_invert = { value = true  }, 
    test_invtrue= { value = false } 
  },
  null = {
    test_null   = {},
    test_empty  = { value = nil },
    test_num    = { nil },
  },
  fails = {
    test_obj_num  = { value = { 8 } }, 
    test_obj_str  = { value = { "string" } }, 
    test_obj_bool = { value = { true } }, 
  }
}

-- Create Test Cases
local function testcases( cases )
  local tests = {}
  for name, case in pairs(cases.number) do
    tests[name] = function ()
      local result = parse.value( case.value )
      lunit.assertNotNil( result )
      lunit.assertIsNumber( result )
    end
  end
  for name, case in pairs(cases.string) do
    tests[name] = function ()
      local result = parse.value( case.value )
      lunit.assertNotNil( result )
      lunit.assertIsString( result )
    end
  end
  for name, case in pairs(cases.boolean) do
    tests[name] = function ()
      local result = parse.value( case.value )
      lunit.assertNotNil( result )
      lunit.assertIsBoolean( result )
    end
  end
  for name, case in pairs(cases.null) do
    tests[name] = function ()
      local result = parse.value( case.value )
      lunit.assertNil( result )
    end
  end
  for name, case in pairs(cases.fails) do
    tests[name] = function ()
      local result = parse.value( case.value )
      lunit.assertNil( result )
    end
  end
  return tests
end

-- Test Packages and Cases
Test_ParseOutput = testcases(fixed_values)

-- Test Runner
lunit.LuaUnit.run()