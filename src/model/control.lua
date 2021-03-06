--{{ 
  local gci_base = require "src/model/base"
--}}
-- ---------------------------------------------------------
-- The GCI Control Model
-- ---------------------------------------------------------
  local input_map = {
    axis = function (self, _) 
      return "on_change" 
    end,
    
    button = function (self, input)
      if input == true then
        return "on_true"
      elseif input == false then
        return "on_false"
      end
    end
  }

  local gci_control = gci_base:new  {
    events = {
      added        = "%s '%s' added",
      handle       = "%s control '%s' handles input (%s)",
      no_responder = "%s control '%s' has no response configured for input '%s'",
      no_handler   = "%s control '%s' has no handler implemented"
    }
  }

  function gci_control:handler( responder, input )
    responder:respond(input)
  end

  function gci_control:handle(input)
    self:log_event("INFO", "handle", self.subtype, self.label, input)
    local responder = self.responders[ self:map(input) ]
    if responder then
      self:handler( responder, input )
    else
      self:log_event("INFO", "no_responder", self.subtype, self.label, input )
    end
  end

  function gci_control:new (control)
    control = control or {}
    setmetatable(control, self)
    self.__index = self

    return control
  end

--{{
  return {
    gci_control   = gci_control,
    input_map     = input_map
  }
--}}