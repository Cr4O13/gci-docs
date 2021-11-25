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
  local gci_version = "4.1.0 Lite (BETA 23)"
  
  local base_types = {
    axis = 0,
    button = 1
  }

  local defaults = {
    
    simulator = "fs2020",
    
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
    gci_version = gci_version,
    base_types = base_types,
    defaults = defaults,
    sim = sim
  }
--}}