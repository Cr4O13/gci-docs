-- ---------------------------------------------------------------------
-- Game Controller Integration 
-- ---------------------------------------------------------------------
-- Copyright (C) 2021 Paul Hoesli. <tetrachromat at outlook dot com>.
-- Everyone is permitted to use, copy, change and distribute copies
-- of this software version, according to the GPLv3 license terms.
-- ---------------------------------------------------------------------
-- This code integrates game controllers into Air Manager / Air Player
-- The functionality must be configured in the ressources file gci.json
-- ---------------------------------------------------------------------
function gci() 
--{{
end
--}}
-- Local Data
  local version = {
    semantic = "1.0.0",
    build    = "Lite",
    pre      = "BETA",
    sub_rel  = "5"
  }
  
  local gci_candidate = {}

  local gci_version = version.semantic .. " " .. version.build 
  if version.pre then 
    gci_version = gci_version .. " (" .. version.pre .. " " .. version.sub_rel .. ")"
  end
  
  local base_types = {
    axis = 0,
    button = 1
  }

  local defaults = {
    
    simulator = "xpl",
    
    controller = {
      log = false
    },
    
    control = {
      log = false
    },
    
    axis = {
      scale = 1, 
      invert = false,
      unit = "DOUBLE",
      initial = 0.0 
    },
    
    button = {
      invert = false,
      unit = "BOOL",
      initial = false
    }
  }

  local sim = defaults.simulator
  
--{{
  return {
    version = version,
    gci_version = gci_version,
    gci_candidate = gci_candidate,
    base_types = base_types,
    defaults = defaults,
    sim = sim
  }
--}}