-- ---------------------------------------------------------
-- Test Parse Id Specification
-- ---------------------------------------------------------
parse = require "src/parser/parse"
lunit = require "test/lib/luaunit"

-- Test Data
local index = 7
local alias = "Lever 1"

local tests = {
  succeeds = {
    test_obj        = { id = { index = index, label = alias } },
    test_obj_index  = { id = { index = index } },
    test_seq        = { id = { index, alias } },
    test_seq_index  = { id = { index } },
    test_index      = { id = index },
    
    test_obj_number = { id = { index = index, label = 8 } },
    test_seq_number = { id = { index, 8 } }
  },
  fails = {
    test_null       = { id = nil },
    test_empty      = { id = {} },
    test_alias      = { id = alias },
    test_obj_alias  = { id = { label = alias } },
    test_seq_alias  = { id = { alias } }
  }
}

-- Create Test Cases
local function testcases( cases )
  local tests = {}
  for name, case in pairs(cases.succeeds) do
    tests[name] = function ()
      local id = parse.id( case.id )
      lunit.assertNotNil( id )
      lunit.assertEquals( id.index, index )
    end
  end
  for name, case in pairs(cases.fails) do
    tests[name] = function ()
      local id = parse.id( case.id )
      lunit.assertNil( id )
    end
  end
  return tests
end

-- Test Packages and Cases
Test_ParseId = testcases(tests)

-- Test Runner
lunit.LuaUnit.run()