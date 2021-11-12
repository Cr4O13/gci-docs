--{{
  gci_base = require "src/model/base"
--}} ---------------------------------------------------------
-- The GCI Controller Model
-- ---------------------------------------------------------
  local gci_controller = gci_base:new {
    events = {
      not_found  = "Game controller '%s' not found or not connected!",
      added      = "Controller '%s' registered",
      called     = "'%s' called with: (%s, %s, %s)",
      dispatched = "Controller dispatched input to control[%s]"
    }
  }

  function gci_controller:dispatcher(type, index, input)
    self:log_event("INFO", "called", self.name, type, index, input)
    
    local control = self.controls[type][index]
    if control then
      self:log_event("INFO", "dispatched", control.id.label)
      control:handle(input)
    end
  end
  
  function gci_controller:new (controller)
    controller = controller or {}
    setmetatable(controller, self)
    self.__index = self
    
    local gc_id = game_controller_add(controller.name, 
      function (type, index, input)
        controller:dispatcher(type, index, input)
      end
    )

    if gc_id then
      controller:log_event("INFO", "added", controller.name)
      controller.id = gc_id
      return controller
    else
      self:log_event("WARN", "not_found", controller.name)
    end
  end
--{{
  return {
    gci_controller = gci_controller
  }
--}} ---------------------------------------------------------