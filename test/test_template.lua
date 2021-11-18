-- ---------------------------------------------------------
-- Test GCI - <spec>
-- ---------------------------------------------------------

--[[---------------------------------------------------------
<spc>
--]]---------------------------------------------------------

local lunit = require "test/lib/luaunit"

-- Test Data



-- Test Cases
local tests = {
  succeeds = {

  },
  fails = {

  }
}


-- Create Test Cases
local function testcases( cases )
  local tests = {}
  for name, spec in pairs(cases.succeeds) do
    
  end
  for name, spec in pairs(cases.fails) do
    
  end
  return tests
end

-- Test Packages and Cases
Test_<spec> = testcases(tests)

-- Test Runner
lunit.LuaUnit.run()