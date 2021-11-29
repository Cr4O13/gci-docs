--{{
local data = require "src/gci"
local parse = require "src/parser/parse"

local gci_version = data.gci_version
local gci_candidate = data.gci_candidate

function gci()
--}}
-- ---------------------------------------------------------------------
-- Main
-- ---------------------------------------------------------------------
  local function main()
    log("INFO", "GCI: Using Game Controller Integration " .. gci_version)
    
    local model = {}
    
    gci_candidate = game_controller_list()
    if type(gci_candidate) == "table" and gci_candidate[0] then
      
      local candidate = {}
      for i, name in pairs(gci_candidate) do
        log("INFO", "GCI: Game Controller '" .. name .. "' recognized.")
        candidate[name] = i
      end
      gci_candidate = candidate
      
      local gci_configuration = static_data_load("gci.json")

      if gci_configuration then
        model = parse.configuration(gci_configuration)
      else
        log("ERROR", "Loading configuration file 'gci.json' failed!")
      end
    else
      log("INFO", "GCI: No Game Controllers found.")
    end  
    return model
  end
  
  return main()
end 

-- ---------------------------------------------------------------------
-- END Game Controller Integration
-- ---------------------------------------------------------------------