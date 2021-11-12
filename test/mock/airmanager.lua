-- ---------------------------------------------------------
-- Mocking Air Manager API functions
-- ---------------------------------------------------------

-- game_controller_add(name, callback)
-- name :: string
-- callback :: function(type, index, input)
spy_controllers = {}

function game_controller_add(name, callback)
  spy_controllers[name] = callback
  return math.random(1000, 9999)
end
  
-- Helper Functions
-------------------
-- log(type, message ) 
-- type :: "INFO" | "WARN" | "ERROR"
-- message :: string
-- mock as 'Spy'
spy_message = {}

function log(type, text)
  spy_message.level = type
  spy_message.text = text
end


-- Mock Interface
-----------------
return {
  game_controller_add = game_controller_add,
  log = log
}
  