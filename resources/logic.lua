-- This code adds the game controller integration
local controllers

function event_callback(event)
  if event == "STARTED" then
    controllers = gci()
  elseif event == "CLOSING" then
    controllers = nil
  end
end

event_subscribe(event_callback)
-- END –-  