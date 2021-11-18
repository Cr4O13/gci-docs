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
local parse = require "src/parser/parse"
local lunit = require "test/lib/luaunit"

-- Test Data
local value = true

local defaults = {
  section = {
    attribute = value
  },
}

-- Test Cases
local tests = {
  succeeds = {
    test_bool = { section = { attribute = not value } },
  },
  fails = {

  }
}

-- Create Test Cases
local function testcases( cases )
  local tests = {}
  for name, spec in pairs(cases.succeeds) do
    tests[name] = function ()
      parse.defaults( defaults, spec )
      lunit.assertNotNil( defaults )
      lunit.assertNotNil( defaults.section )
      lunit.assertNotNil( defaults.section.attribute )
      lunit.assertEquals( defaults.section.attribute, not value )
    end
  end
  for name, spec in pairs(cases.fails) do
    tests[name] = function ()
      local new_defaults = parse.defaults( defaults, spec )
      lunit.assertNil( controllers )
      
    end
  end
  return tests
end

-- Test Packages and Cases
Test_ParseController = testcases(tests)

-- Test Runner
lunit.LuaUnit.run()