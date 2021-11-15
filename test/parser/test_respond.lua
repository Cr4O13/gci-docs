-- ---------------------------------------------------------
-- Test Parse Respond Specification
-- ---------------------------------------------------------
--[[---------------------------------------------------------
respond-spec    :: "respond" : [ responder-spec, ... ]
responder_spec  :: (see test_responder.lua)
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

