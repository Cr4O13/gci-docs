-- ---------------------------------------------------------------------
-- Game Controller Integration 
-- ---------------------------------------------------------------------
-- This code integrates game controllers into Air Manager / Air Player
-- The functionality must be configured in the ressources file gci.json
-- ---------------------------------------------------------------------
function gci() 
--{{
end
--}}
-- Local Data
  local gci_version = "4.1 (BETA 10)"
  
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
      trigger = "on_change",
      scale = 1, 
      invert = false,
      unit = "DOUBLE",
      initial = 0.0 
    },
    
    button = {
      trigger = "on_true",
      invert = false,
      unit = "BOOL",
      initial = false
    },
    
    timed = {
      trigger = "on_time",
      delay = 0,
      period = 250
    },
    
    modal = {
      trigger = "on_mode1",
      delay = 500
    },
    
    switched = {
      trigger = "on_zero"
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