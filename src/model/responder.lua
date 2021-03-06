--{{
  local gci_base = require "src/model/base"
--}}
-- ---------------------------------------------------------
-- The GCI Responder Model
-- ---------------------------------------------------------
  local function fs2020_write(self, input)
    local variable = self.var_id
    local unit = self.unit_id
    local value = self:output(input)
    self:log_event("INFO", "write", "fs2020_variable_write", variable, unit, value )
    fs2020_variable_write( variable, unit, value )
  end

  local function fs2020_send(self, input)
    local event = self.var_id
    local value = self:output(input)
    self:log_event("INFO", "send", "fs2020_event", event, value )
    fs2020_event( event, value )
  end

  local function fsx_write(self, input)
    local variable = self.var_id
    local unit = self.unit_id
    local value = self:output(input)
    self:log_event("INFO", "write", "fsx_variable_write", variable, unit, value )
    fsx_variable_write( variable, unit, value )
  end

  local function fsx_send(self, input)
    local event = self.var_id
    local value = self:output(input)
    self:log_event("INFO", "send", "fsx_event", event, value )
    fsx_event( event, value )
  end

  local function xpl_write(self, input)
    local dataref = self.var_id
    local type    = self.unit_id
    local value   = self:output(input)
    local offset  = self.offset
    local force   = self.force
    self:log_event("INFO", "xplwrite", "xpl_dataref_write", dataref, type, value, offset, force  )
    xpl_dataref_write( dataref, type, value, offset, force )
  end

  local function xpl_send(self, input)
    local commandref = self.var_id
    local value      = self:output(input)
    self:log_event("INFO", "xplsend", "xpl_command", commandref, value )
    xpl_command( commandref, value )
  end

-- Action Map
  local action_map = {
    fs2020 = {
      write     = fs2020_write,
      send      = fs2020_send
    },
    fsx  = {
      write     = fsx_write,
      send      = fsx_send
    },
    p3d  = {
      write     = fsx_write,
      send      = fsx_send
    },
    xpl  = {
      write     = xpl_write,
      send      = xpl_send
    }
  }

-- Output Functions
  local function output_null(self, _) 
    return nil
  end  
  
  local function output_fixed(self, _) 
    return self.value
  end  
  
  local function output_scaled(self, input) 
    return input * self.scale
  end
  
  local function output_inverted_boolean(self, input) 
    return not input
  end

  local function output_inverted_numeric(self, input) 
    return -input 
  end

  local function output_direct(self, input) 
    return input 
  end

-- Output Map
  local output_map = {
    axis = {
      default    = output_direct,
      direct     = output_direct,
      scaled     = output_scaled,
      inverted   = output_inverted_numeric
    },
    button = {
      default    = output_null,
      direct     = output_direct,
      fixed      = output_fixed,
      inverted   = output_inverted_boolean
    }
  }

-- GCI Responder 
  local gci_responder = gci_base:new {
    events = {
      send     = "responds with %s('%s', '%s')",
      xplsend  = "responds with %s('%s', '%s')",
      write    = "responds with %s('%s', '%s', %s)",
      xplwrite = "responds with %s('%s', '%s', %s, '%s', %s)",
      missing  = "respond method missing for input = %s!"
    }
  }
  
  function gci_responder:respond(input)
    self:log_event("INFO", "missing", input)
  end
  
  function gci_responder:new (responder)
    responder = responder or {}
    setmetatable(responder, self)
    self.__index = self

    return responder
  end
  
  --{{
  return {
    action_map = action_map,
    output_map = output_map,
    gci_responder = gci_responder
  }
--}}