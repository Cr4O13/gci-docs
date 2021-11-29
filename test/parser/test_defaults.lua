-- ---------------------------------------------------------
-- Test Parse User Defaults Spec
-- ---------------------------------------------------------
--[[---------------------------------------------------------
defaults-field :: "defaults" : { defaults-list }
defaults-list :: defaults-field ( , defaults-list )

defaults-field :: controller-defaults | control-defaults
  axis-defaults | button-defaults | timer-defaults | modal-defaults

controller-defaults :: "controller" : { controller-default-list }
controller-default-list :: controller-default ( , controller-default-list )
controller-default :: log-attribute

control-defaults :: "control" : { control-default-list }
control-default-list :: control-default ( , control-default-list )
control-default :: log-attribute

axis-defaults :: "axis" : { axis-default-list }
axis-default-list :: axis-default ( , axis-default-list )
axis-default :: axis-scale-default | axis-invert-default | axis-unit-default | axis-initial-default
axis-scale-default :: lua-number
axis-invert-default :: lua-boolean
axis-unit-default :: unit-string
axis-initial-default :: lua-value

button-defaults :: "button" : { button-default-list }
button-default-list :: button-default ( , button-default-list )
button-default :: button-invert-default | button-unit-default | axis-initial-default
button-invert-default :: lua-boolean
button-unit-default :: unit-string
button-initial-default :: lua-value

timer-defaults :: "timer" : { timer-default-list }
timer-default-list :: timer-default ( , timer-default-list )
timer-default :: timer-delay-default | timer-period-default
timer-delay-default :: lua-number
timer-period-default :: lua-number

modal-defaults :: "modal" : { modal-default-list }
modal-default-list :: modal-default ( , modal-default-list )
modal-default :: modal-delay-default
modal-delay-default :: lua-number
--]]---------------------------------------------------------
-- Imports
local lu = require "test/lib/luaunit"
local parse = require "src/parser/parse"

-- Model Data
local value = true

local defaults = {
  section = {
    attribute = value
  },
}

-- Test Case Data
-- Test Case Specifications
local testcases = {
  succeeds = {
    test_bool = { section = { attribute = not value } },
  },
  fails = {

  }
}

-- Create Tests from Test Case Specifications
local function create_tests( cases )
  local tests = {}
  for name, spec in pairs(cases.succeeds) do
    tests[name] = function ()
      parse.defaults( defaults, spec )
      lu.assertNotNil( defaults )
      lu.assertNotNil( defaults.section )
      lu.assertNotNil( defaults.section.attribute )
      lu.assertEquals( defaults.section.attribute, not value )
    end
  end
  for name, spec in pairs(cases.fails) do
    tests[name] = function ()
      local new_defaults = parse.defaults( defaults, spec )
      lu.assertNil( new_defaults )
      
    end
  end
  return tests
end

-- Test Collection
Test_All = create_tests( testcases )

-- Test Runner
lu.LuaUnit.run()