-- ---------------------------------------------------------
-- Test Parse configuration
-- ---------------------------------------------------------
--[[---------------------------------------------------------
gci-configuration :: { configuration-spec }
configuration-spec :: controllers-field ( , defaults-field ) 
controllers-field :: "controllers" : [ controller-list ]
defaults-field :: "defaults" : { defaults-list }
--]]---------------------------------------------------------
-- Imports
local lu = require "test/lib/luaunit"
local parse = require "src/parser/parse"

-- Model Data
-- Test Case Data
defaults = {}

-- Test Case Specifications
local testcases = {
  succeeds = {
    test_empty =  { defaults =  {}, controllers = {} }
  },
  fails = {
    
  }
}

-- Create Tests from Test Case Specifications
local function create_tests( cases )
  local tests = {}
  for name, spec in pairs(cases.succeeds) do
    tests[name] = function ()
      local controllers = parse.configuration( spec )
      lu.assertNotNil( controllers )
    end
  end
  for name, spec in pairs(cases.fails) do
    tests[name] = function ()
      local controllers = parse.configuration( spec )
      lu.assertNil( controllers )
    end
  end
  return tests
end

-- Test Collection
Test_All = create_tests( testcases )

-- Test Runner
lu.LuaUnit.run()