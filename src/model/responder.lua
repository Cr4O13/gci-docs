--{{
  gci_base = require "src/model/base"
--}} ---------------------------------------------------------
-- The GCI Responder Model
-- ---------------------------------------------------------

-- Respond functions
-- ---------------------------------------------------------
  local function si_publish(self, input)
    si_variable_write( self.var_id, self.output(input) )
  end

  local function fs2020_write(self, input)
    local variable = self.var_id
    local unit = self.unit_id
    local value = self.output(input)
    self:log_event("INFO", "write", "fs2020_variable_write", variable, unit, value )
    fs2020_variable_write( variable, unit, value )
  end

  local function fs2020_send(self, input)
    local event = self.var_id
    local value = self.output(input)
    self:log_event("INFO", "send", "fs2020_event", event, value )
    fs2020_event( event, value )
  end

  local function fsx_write(self, input)
    local variable = self.var_id
    local unit = self.unit_id
    local value = self.output(input)
    self:log_event("INFO", "write", "fsx_variable_write", variable, unit, value )
    fsx_variable_write( variable, unit, value )
  end

  local function fsx_send(self, input)
    local event = self.var_id
    local value = self.output(input)
    self:log_event("INFO", "send", "fsx_event", event, value )
    fsx_event( event, value )
  end

  local function xpl_write(self, input)
    local dataref = self.var_id
    local type    = self.unit_id
    local value   = self.output(input)
    local offset  = self.offset
    local force   = self.force
    self:log_event("INFO", "xplwrite", "xpl_dataref_write", dataref, type, value, offset, force  )
    xpl_dataref_write( dataref, type, value, offset, force )
  end

  local function xpl_send(self, input)
    local commandref = self.var_id
    self:log_event("INFO", "xplsend", "xpl_command", commandref )
    xpl_command( self.var_id )
  end

-- Respond API
-- ---------------------------------------------------------
  local api = {
    fs2020 = {
      publish   = si_publish,
      write     = fs2020_write,
      send      = fs2020_send
    },
    fsx  = {
      publish   = si_publish,
      write     = fsx_write,
      send      = fsx_send
    },
    p3d  = {
      publish   = si_publish,
      write     = fsx_write,
      send      = fsx_send
    },
    xpl  = {
      publish   = si_publish,
      write     = xpl_write,
      send      = xpl_send
    }
  }

-- GCI Responder 
-- ---------------------------------------------------------
  local gci_responder = gci_base:new {
    events = {
      send     = "responds with %s('%s', '%s')",
      xplsend  = "responds with %s('%s')",
      write    = "responds with %s('%s', '%s', %s)",
      xplwrite = "responds with %s('%s', '%s', %s, '%s', %s)",
      publish  = "responds with %s('%s', '%s', %s)",
      missing  = "respond method missing!"
    }
  }
  
  function gci_responder:respond(input)
    self:log_event("INFO", "missing")
  end
  
  function gci_responder:new (responder)
    responder = responder or {}
    setmetatable(responder, self)
    self.__index = self

    return responder
  end

  --{{
  return {
    api = api,
    gci_responder = gci_responder
  }
--}} ---------------------------------------------------------