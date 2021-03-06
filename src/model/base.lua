--{{ 
  -- local gci = require "src/gci"
--}}
-- ---------------------------------------------------------
-- The GCI Model Base class
-- ---------------------------------------------------------
  local gci_base = {}
  
  function gci_base:log_event (level, event, ... )
    if self.log then
      log(level, "GCI: " .. string.format(self.events[event], ... ) )
    end
  end

  function gci_base:new ( base )
    base = base or {}
    setmetatable(base, self)
    self.__index = self

    return base
  end
  
--{{
  return gci_base
--}}