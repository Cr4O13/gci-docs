-- ---------------------------------------------------------
-- Test Parse configuration
-- ---------------------------------------------------------
--[[---------------------------------------------------------
gci-configuration :: { configuration-spec }
configuration-spec :: controllers-field ( , defaults-field ) 
controllers-field :: "controllers" : [ controller-list ]
defaults-field :: "defaults" : { defaults-list }
--]]---------------------------------------------------------
local parse = require "src/parser/parse"
local lunit = require "test/lib/luaunit"

-- Test Data

defaults = {}

-- Test Cases
local tests = {
  succeeds = {
    test_empty =  { defaults =  {}, controllers = {} }
  },
  fails = {
    
  }
}

-- Create Test cases
local function testcases( cases )
  local tests = {}
  for name, spec in pairs(cases.succeeds) do
    tests[name] = function ()
      local controllers = parse.configuration( spec )
      lunit.assertNotNil( controllers )

    end
  end
  for name, spec in pairs(cases.fails) do
    tests[name] = function ()
      local controllers = parse.configuration( spec )
      lunit.assertNil( controllers )
      
    end
  end
  return tests
end

-- Test Packages and Cases
Test_ParseConfiguration = testcases(tests)

-- Test Runner
lunit.LuaUnit.run()