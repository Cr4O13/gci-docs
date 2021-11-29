-- ---------------------------------------------------------
-- Test GCI - Parse Subtype Specification
-- ---------------------------------------------------------
--[[---------------------------------------------------------
subtype-field :: "subtype" : { "name" : subtype-keyword ( , "parameters" : { parameter-list } ) }
subtype-keyword :: subtype-keyword
--]]---------------------------------------------------------
-- Imports
local lu = require "test/lib/luaunit"
local parse = require "src/parser/parse"

-- Model Data
-- Test Case Data
local sub_name = "subtype"
local sub_params = { 8 }

-- Test Case Specifications
local testcases = {
  succeeds = {
    test_obj          = { subtype = { name = sub_name } },
    test_obj_pempty   = { subtype = { name = sub_name, parameters = {} } },
    test_obj_pnumber  = { subtype = { name = sub_name, parameters = 8 } },
    test_obj_params   = { subtype = { name = sub_name, parameters = sub_params } }
  },
  fails = {
    test_seq          = { subtype = { sub_name } },
    test_seq_pstring  = { subtype = { sub_name, "eight" } },
    test_seq_pbool    = { subtype = { sub_name, true } },
    test_seq_pnumber  = { subtype = { sub_name, 8 } },

    test_seq_pempty   = { subtype = { sub_name, {} } },
    test_seq_params   = { subtype = { sub_name, sub_params } },
    
    test_name         = { subtype = sub_name },
    
    test_obj_nnumber  = { subtype = { name = 8 } },
    test_obj_nempty   = { subtype = { name = {} } },

    test_seq_bool     = { subtype = { true } },
    test_seq_number   = { subtype = { 8 } },
    test_seq_empty    = { subtype = { {} } },
    
    test_nbool        = { subtype = true },
    test_nnumber      = { subtype = 8 },
    test_empty        = { subtype = {} }
  }
}

-- Create Tests from Test Case Specifications
local function create_tests( cases )
  local tests = {}
  for name, case in pairs(cases.succeeds) do
    tests[name] = function ()
      local subtype = parse.subtype( case.subtype )
      lu.assertNotNil( subtype )
      lu.assertEquals( subtype.name, sub_name )
    end
  end
  for name, case in pairs(cases.fails) do
    tests[name] = function ()
      local subtype = parse.subtype( case.subtype )
      lu.assertNil( subtype )
    end
  end
  return tests
end

-- Test Collection
Test_All = create_tests( testcases )

-- Test Runner
lu.LuaUnit.run()