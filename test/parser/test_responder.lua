-- ---------------------------------------------------------
-- Test Parse Responder Specification
-- ---------------------------------------------------------
--[[---------------------------------------------------------
responder-spec  :: trigger-name : { var-spec, unit-spec, offset-spec, force-spec, output-spec }
trigger-name    :: axis-trigger | button-trigger | timed-trigger | switched-trigger | modal-trigger

axis-trigger    :: "on-change"
button-trigger  :: "on-true"  | "on-false"
timed-trigger   :: "on-time"  | "on-stop"
switched-trigger:: "on-plus"  | "on-zero"  | "on-minus"
modal-trigger   :: "on-mode1" | "on-mode2"

var-spec        :: var-id-name : var_id
var-id-name     :: "var-id" | "variable" | "dataref" | "event" | "commandref"
var_id          :: string

unit-spec       :: unit-id-name : unit_id
unit-id-name    :: "unit-id" | "unit" | "type"
unit_id         :: string | null

offset-spec     :: "offset" : offset
offset          :: integer | null

force-spec      :: "force" : force
force           :: boolean | null

output-spec      :: (see test_output.lua)
--]]---------------------------------------------------------
-- Imports
local lu = require "test/lib/luaunit"
local parse = require "src/parser/parse"

-- Model Data
-- Test Case Data
--local sim    = "fs2020"
local action = "send"
local subtype = "axis"

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
  
-- Test Case Specifications
local testcases = {
  succeeds = {
    test_obj = { on_trigger = responder_spec },
  },
  fails = {
  }
}

-- Create Tests from Test Case Specifications
local function create_tests( cases )
  local tests = {}
  for name, case in pairs(cases.succeeds) do
    tests[name] = function ()
      local responder = parse.responder( subtype, action, case.on_trigger )
      lu.assertNotNil( responder )
    end
  end
  for name, case in pairs(cases.fails) do
    tests[name] = function ()
      local responder = parse.responder( subtype, action, case.on_trigger )
      lu.assertNil( responder )
    end
  end
  return tests
end

-- Test Collection
Test_All = create_tests( testcases )

-- Test Runner
lu.LuaUnit.run()