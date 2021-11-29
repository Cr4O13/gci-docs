-- ---------------------------------------------------------
-- Mocking Air Manager API functions
-- ---------------------------------------------------------

-- Game Controller API
-- ---------------------------------------------------------
-- game_controller_add(name, callback)
-- name :: string
-- callback :: function(type, index, input)
spy_controllers = {}

function game_controller_add(name, callback)
  spy_controllers[name] = callback
  return math.random(1000, 9999)
end

-- Simulator API
-- ---------------------------------------------------------
spy_variable = {}

function si_variable_write( var_id, value )
  print(string.format("si_variable_write( '%s', %s )", var_id, value ))
  spy_variable[var_id] = {value}
end

function fs2020_variable_write( variable, unit, value )
  print(string.format("fs2020_variable_write( '%s', '%s', %s )", variable, unit, value ))
  spy_variable[variable] = {value, unit}
end

function fs2020_event( event, value, value2 )
  print(string.format("fs2020_event( '%s', %s, %s )", event, value, value2 ))
  spy_variable[event] = {value}
end

function fsx_variable_write( variable, unit, value )
  print(string.format("fsx_variable_write( '%s', '%s', %s )", variable, unit, value ))
  spy_variable[variable] = {value, unit}
end

function fsx_event( event, value )
  print(string.format("fsx_event( '%s', %s )", event, value ))
  spy_variable[event] = {value}
end

function xpl_dataref_write( dataref, type, value, offset, force )
  print(string.format("xpl_dataref_write( '%s', '%s', %s, %s, %s )", dataref, type, value, offset, force ))
  spy_variable[dataref] = { value, type, offset, force }
end

function xpl_command( commandref, value )
  print(string.format("xpl_command( '%s' )", commandref ))
  spy_variable[commandref] = { value }
end

-- Helper Functions
-- ---------------------------------------------------------
-- log(type, message ) 
-- type :: "INFO" | "WARN" | "ERROR"
-- message :: string
-- mock as 'Spy'
spy_message = {}

function log(type, text)
  print("logging: " .. type .. ", " .. text)
  spy_message.level = type
  spy_message.text = text
end

local static_data_load = function (_) 
  return configuration
end

-- Mock Interface
-----------------
return {
  -- game controller API
  game_controller_add   = game_controller_add,
  -- simulator API
  si_variable_write     = si_variable_write,
  fs2020_variable_write = fs2020_variable_write,
  fs2020_event          = fs2020_event,
  fsx_variable_write    = fsx_variable_write,
  fsx_event             = fsx_event,
  xpl_dataref_write     = xpl_dataref_write,
  xpl_command           = xpl_command,
  -- helper API
  static_data_load      = static_data_load,
  log = log
}
  