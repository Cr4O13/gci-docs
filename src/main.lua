--{{
parse = require "src/parser/parse"
function gci()
--}}
-- ---------------------------------------------------------------------
-- Main
-- ---------------------------------------------------------------------
  local function main()
    log("INFO", "GCI: Using Game Controller Integration " .. gci_version)
    local gci_configuration = static_data_load("gci.json")

    if gci_configuration and type(gci_configuration) == "table" then
      return parse.configuration(gci_configuration)
    else
      log("ERROR", "Syntax error in configuration file 'gci.json' or file not found!")
      return {}
    end
  end
  
  return main()
end 

-- ---------------------------------------------------------------------
-- END Game Controller Integration
-- ---------------------------------------------------------------------