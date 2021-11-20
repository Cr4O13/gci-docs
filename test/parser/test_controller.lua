-- ---------------------------------------------------------
-- Test GCI - Parse Controller Specification
-- ---------------------------------------------------------
--[[---------------------------------------------------------
controller-spec :: { controller-name-field, controls ( , attributes ) }
controller-name-field :: "name" : controller-name
controller-name :: lua-string

controls :: controls-field ( , controls )
controls-field :: axes-field | buttons-field

axes-field :: "axes" : [ control-list ]
buttons-field :: "buttons" : [ control-list ]
--]]---------------------------------------------------------
-- Imports
local lu = require "test/lib/luaunit"
local parse = require "src/parser/parse"
local airmanager = require "test/mock/airmanager"

-- Model Data
-- Test Case Data
local controller_name = "Controller"
local axes = {}
local buttons = {}

local controller_spec = { 
  log = true,
  name = controller_name, 
  axes = axes,
  buttons = buttons
}

-- Test Case Specifications
local testcases = {
  succeeds = {
    test_spec = controller_spec
  },
  fails = {

  }
}

-- Create Tests from Test Case Specifications
local function create_tests( cases )
  local tests = {}
  for name, spec in pairs(cases.succeeds) do
    tests[name] = function ()
      local controller = parse.controller( spec )
      lu.assertNotNil( controller )
    end
  end
  for name, spec in pairs(cases.fails) do
    tests[name] = function ()
      local controller = parse.controller( spec )
      lu.assertNil( controller )
    end
  end
  return tests
end

-- Test Collection
Test_All = create_tests( testcases )

-- Test Runner
lu.LuaUnit.run()