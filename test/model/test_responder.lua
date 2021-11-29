-- ---------------------------------------------------------
-- Test GCI Responder Model
-- ---------------------------------------------------------
--[[---------------------------------------------------------
requirements to test
--]]---------------------------------------------------------
-- Imports
local lu = require "test/lib/luaunit"

local gci = require "src/gci"
local defaults = gci.defaults

local responder = require "src/model/responder"
local action_map    = responder.action_map
local output_map    = responder.output_map
local gci_responder = responder.gci_responder

local airmanager = require "test/mock/airmanager"
local log = airmanager.log

-- Model Data
local sim      = "fs2020"
local subtype  = "button"
local index    = 0
local label    = "A0"
local action   = "send"

local event  = "AP_MASTER"

local input  = true
local output = "direct"

local model = {
  log = true,
  respond  = action_map[sim][action],
  var_id   = event,
  output   = output_map[subtype][output]
}

-- Test Case Data
-- Test Case Specifications
local testcases = {
  interface = {
    test_handle = model
  },
  create ={
    test_create = model
  },
  maintain ={
    test_maintain = model
  },
  receive ={
    test_receive = model
  }
}

-- Create Tests from Test Case Specifications
local function create_tests( cases )
  local tests = {}
  for name, spec in pairs(cases.interface) do
    tests[name] = function()
      lu.assertNotNil(gci_responder)
      lu.assertNotNil(gci_responder.new)
      lu.assertNotNil(gci_responder.respond)
    end
  end
  for name, spec in pairs(cases.create) do
    tests[name] = function()
      local test_responder = gci_responder:new( spec )
      lu.assertNotNil(test_responder)
      lu.assertNotNil(test_responder.respond)
      lu.assertNotNil(test_responder.var_id)
      lu.assertNotNil(test_responder.output)
    end
  end
  for name, spec in pairs(cases.maintain) do
    tests[name] = function()
      local test_responder = gci_responder:new( spec )
      lu.assertNotNil(test_responder)  
      lu.assertNotNil(test_responder.events)  
    end
  end
  for name, spec in pairs(cases.receive) do
    tests[name] = function()
      local test_responder = gci_responder:new( spec )
      lu.assertNotNil(test_responder)
      spy_variable = {}
      test_responder:respond(input)
      lu.assertNotNil(spy_variable[event])  
      lu.assertEquals(spy_variable[event][1], input)  
    end
  end
  return tests
end

-- Test Collection
Test_All = create_tests( testcases )

-- Test Runner
lu.LuaUnit.run()