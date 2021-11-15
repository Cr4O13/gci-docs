-- ---------------------------------------------------------
-- Test Parse Responder Specification
-- ---------------------------------------------------------
--[[---------------------------------------------------------
responder-spec  :: trigger-name : { var-spec, unit-spec, offset-spec, force-spec, value-spec }
trigger-name    :: axis-trigger | button-trigger | timed-trigger | switched-trigger | modal-trigger

axis-trigger    :: "on-change"
button-trigger  :: "on-true"  | "on-false"
timed-trigger   :: "on-time"  | "on-stop"
switched-trigger:: "on-plus"  | "on-zero"  | "on-minus"
modal-trigger   :: "on-mode1" | "on-mode2"

var-spec        :: var-id-name : var
var-id-name     :: "var-id" | "variable" | "dataref" 
var             :: string

unit-spec       :: unit-id-name : unit
unit-id-name    :: "unit-id" | "unit" | "type"
unit            :: string | null

offset-spec     :: "offset" : offset
offset          :: integer | null

force-spec      :: "force" : force
force           :: boolean | null

value-spec      :: (see test_output.lua)
--]]---------------------------------------------------------
local model = require "src/model/responder"
local parse = require "src/parser/parse"
local lunit = require "test/lib/luaunit"

action_map          = model.action_map
output_map          = model.output_map
local gci_responder = model.gci_responder

-- Test Data
sim    = "fs2020"
action = "send"
subtype = "axis"

local event      = "AP_MASTER"
local commandref = "a/simple/commandref"

local variable   = "RUDDER POSITION"
local unit       = "Position"

local dataref = "a/simple/dataref"
local type    = "INT[8]"
local offset  = 3
local force   = true

local output_spec = "input"

local responder_spec = {
  var_id  = dataref,
  unit_id = type,
  offset  = offset,
  force   = force,
  value   = output_spec
}
  
local tests = {
  succeeds = {
    test_obj = { on_trigger = responder_spec },
  },
  fails = {

  }
}

-- Create Test Cases
local function testcases( cases )
  local tests = {}
  for name, case in pairs(cases.succeeds) do
    tests[name] = function ()
      local responder = parse.responder( case.on_trigger )
      lunit.assertNotNil( responder )

    end
  end
  for name, case in pairs(cases.fails) do
    tests[name] = function ()
      local responder = parse.responder( case.on_trigger )
      lunit.assertNil( responder )

    end
  end
  return tests
end

-- Test Packages and Cases
Test_ParseResponder = testcases(tests)

-- Test Runner
lunit.LuaUnit.run()