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
    fs2020_variable_write( self.var_id, self.unit_id, self.output(input) )
  end

  local function fs2020_send(self, input)
    fs2020_event( self.var_id, self.output(input) )
  end

  local function fsx_write(self, input)
    fsx_variable_write( self.var_id, self.unit_id, self.output(input) )
  end

  local function fsx_send(self, input)
    fsx_event( self.var_id, self.output(input) )
  end

  local function xpl_write(self, input)
    xpl_dataref_write( self.var_id, self.unit_id, self.output(input), self.offset, self.force )
  end

  local function xpl_send(self, input)
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
      respond  = "responds with '%s'('%s', '%s', %s)",
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