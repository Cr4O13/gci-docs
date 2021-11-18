-- ---------------------------------------------------------------------
-- Game Controller Integration 
-- ---------------------------------------------------------------------
-- This code integrates game controllers into Air Manager / Air Player
-- The functionality must be configured in the ressources file gci.json
-- ---------------------------------------------------------------------
function gci() 
  
-- Local Data
  local gci_version = "4.1 (BETA 10)"

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
    },
    
    repeating = {
      delay = 0,
      period = 250
    },
    
    modal = {
      delay = 500
    }
  }

  local sim = defaults.simulator
  
--{{
end
--}}