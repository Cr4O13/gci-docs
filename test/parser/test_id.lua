-- ---------------------------------------------------------
-- Test Parse Id Specification
-- ---------------------------------------------------------
--[[---------------------------------------------------------
id-field :: "id" : { "index" : index-value ( , "label" : label-value ) }
index-value :: lua-number
label-value :: lua-string
--]]---------------------------------------------------------
-- Imports
local lu = require "test/lib/luaunit"
local parse = require "src/parser/parse"

-- Model Data
-- Test Case Data
local index = 7
local alias = "Lever 1"

-- Test Case Specifications
local testcases = {
  succeeds = {
    test_obj        = { id = { index = index, label = alias } },
    test_obj_number = { id = { index = index, label = 8 } },
    test_obj_index  = { id = { index = index } }
  },
  fails = {
    test_seq        = { id = { index, alias } },
    test_seq_index  = { id = { index } },
    test_index      = { id = index },
    test_null       = { id = nil },
    test_empty      = { id = {} },
    test_alias      = { id = alias },
    test_obj_alias  = { id = { label = alias } },
    test_seq_alias  = { id = { alias } },
    test_seq_number = { id = { index, 8 } }
  }
}

-- Create Tests from Test Case Specifications
local function create_tests( cases )
  local tests = {}
  for name, case in pairs(cases.succeeds) do
    tests[name] = function ()
      local id = parse.id( case.id )
      lu.assertNotNil( id )
      lu.assertEquals( id.index, index )
    end
  end
  for name, case in pairs(cases.fails) do
    tests[name] = function ()
      local id = parse.id( case.id )
      lu.assertNil( id )
    end
  end
  return tests
end

-- Test Collection
Test_All = create_tests( testcases )

-- Test Runner
lu.LuaUnit.run()