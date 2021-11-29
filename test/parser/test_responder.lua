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
local action = "write"
local subtype = "axis"

local dataref = "a/simple/dataref"
local unit    = "INT[8]"
local offset  = 3
local force   = true
local initial = 0.0
local output_spec = "input"

local responder_spec = {
  var_id  = dataref,
  unit_id = unit,
  offset  = offset,
  force   = force,
  value   = output_spec
}
  
-- Test Case Specifications
local testcases = {
  send = {
--    test_send_full = responder_spec,
    test_send_min = { var_id  = dataref }
  },
  write = {
    test_write_min = { var_id  = dataref, unit_id = unit }
  },
  publish = {
  -- not implemented
  },
  send_fail = {
    test_empty = {}
  },
  write_fail = {
    test_varonly = { var_id  = dataref },
    test_unitonly = { unit_id = unit }
  },
  publish_fail = {
    test_publish_min = { var_id  = dataref, unit_id = unit, initial = initial },
    test_missingvar = { unit_id = unit, initial = initial },
    test_missingunit = { var_id  = dataref, initial = initial },
    test_missinginitial = { var_id  = dataref, unit_id = unit }
  }
}

-- Create Tests from Test Case Specifications
local function create_tests( cases )
  local tests = {}
  for name, case in pairs(cases.send) do
    tests[name] = function ()
      local responder = parse.responder( subtype, "send", case )
      lu.assertNotNil( responder )
    end
  end
  for name, case in pairs(cases.write) do
    tests[name] = function ()
      local responder = parse.responder( subtype, "write", case )
      lu.assertNotNil( responder )
    end
  end
  for name, case in pairs(cases.publish) do
    tests[name] = function ()
      local responder = parse.responder( subtype, "publish", case )
      lu.assertNotNil( responder )
    end
  end
  for name, case in pairs(cases.send_fail) do
    tests[name] = function ()
      local responder = parse.responder( subtype, "send", case )
      lu.assertNil( responder )
    end
  end
  for name, case in pairs(cases.write_fail) do
    tests[name] = function ()
      local responder = parse.responder( subtype, "write", case )
      lu.assertNil( responder )
    end
  end
  for name, case in pairs(cases.publish_fail) do
    tests[name] = function ()
      local responder = parse.responder( subtype, "publish", case )
      lu.assertNil( responder )
    end
  end
  return tests
end

-- Test Collection
Test_All = create_tests( testcases )

-- Test Runner
lu.LuaUnit.run()