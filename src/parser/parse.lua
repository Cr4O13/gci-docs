--{{ Required Modules
  local gci        = require "src/gci"
  local controller = require "src/model/controller"
  local control    = require "src/model/control"
  local responder  = require "src/model/responder"

  local base_types      = gci.base_types
  local defaults        = gci.defaults
  local sim             = gci.sim
  
  local gci_controller  = controller.gci_controller
  
  local gci_control     = control.gci_control
  local input_map       = control.input_map

  local gci_responder   = responder.gci_responder  
  local action_map      = responder.action_map
  local output_map      = responder.output_map
--}}
-- ---------------------------------------------------------
-- The GCI Configuration Parser
-- ---------------------------------------------------------
  local parse = {}
  
  -- Test: OK
  parse.boolean = function (spec)
    if type(spec) == "boolean" then
      return spec
    end
  end

  -- Test: OK
  parse.number = function (spec)
    if type(spec) == "number" then
      return spec
    end
  end

  -- Test: OK
  parse.string = function (spec)
    if type(spec) == "string" then
      return spec
    end
  end
    
-- Test: OK
  parse.ignore = function (spec)
    if spec then 
      return true 
    end
  end
  
  -- Test: OK
  parse.log = function (spec)
    if spec then 
      return true 
    end
  end

  -- Test: OK
  parse.id = function (spec)
    if type(spec) == "table" and type(spec.index) == "number" then
      return { index = spec.index | 0, label = tostring( (spec.label or spec.index) ) }  
    end
  end

  -- Test: OK
  parse.parameters = function (spec)
    if type(spec) == "table" then
      return spec
    end
  end
  
  -- Test: OK
  parse.subtype = function (spec)
    if type(spec) == "table" and type(spec.name) == "string" then
      return { name = spec.name, parameters = parse.parameters(spec.parameters) }
    end
  end

  parse.value = function (spec)
    return parse.number(spec) or parse.string(spec) or parse.boolean(spec)
  end
    
  -- Test: OK
  parse.scale = function (spec, invert)
    local scale = parse.number(spec)
    scale = scale ~= 0 and scale or nil
    if scale and invert then
      return -scale
    else
      return scale
    end
  end
 
  parse.output = function ( spec )
    if type(spec) == "string" then
      if spec == "input" then
        spec = { invert = false }
      elseif spec == "invert" then
        spec = { invert = true }
      end
    end

    local output = {}
    if type(spec) == "table" then
      local invert   = parse.boolean(spec.invert)
      local scale    = parse.scale(spec.scale, invert)
      local value    = parse.value(spec.value)
      
      if value then
        output.option = "fixed"
        output.value = value
      elseif scale then
        output.option = "scaled"
        output.scale = scale
      elseif invert == true then
        output.option = "inverted"
      elseif invert == false then
        output.option = "direct"
      end
    end
    return output 
  end
  
  parse.unit_id = function ( spec )
    return parse.string( spec.unit or spec.type or spec.unit_id )
  end
  
  parse.var_id = function ( spec )
    return parse.string( spec.variable or spec.dataref or spec.event or spec.commandref or spec.var_id  )  
  end
  
  parse.responder = function ( subtype, action, spec )
    if type(spec) == "string" then -- simple notation
      spec = { var_id = spec }
    end
    
    if type(spec) == "table" then
      local output = parse.output( spec.output )      
      return gci_responder:new {
        var_id   = parse.var_id( spec ),
        unit_id  = parse.unit_id( spec ),
        offset   = parse.number( spec.offset ),
        force    = parse.boolean( spec.force ),
        initial  = spec.initial,
        value    = output.value,
        scale    = output.scale,
        respond  = action_map[sim][action],
        output   = output_map[subtype][output.option or "default"]
      }
    end
  end
  
  parse.action = function ( subtype, action, spec )
    if spec then
      local responders = {}
      for trigger, spec in pairs(spec) do
        responders[trigger] = parse.responder( subtype, action, spec )
      end
      if next(responders) ~= nil then
        return responders
      end
    end
  end

  parse.control = function ( base_type, spec )
    if type(spec) == "table" then
      if not spec.ignore then
        local id = parse.id(spec.id)
        
        if id then
          local subtype = parse.subtype(spec.subtype or base_type)
          
          if subtype then
            local action
            if spec.write then action = "write" 
            elseif spec.send then  action = "send"
            end
            
            if action then
              local responders = parse.action( subtype.name, action, spec[action] )
              
              if responders then
                local control = {
                  log = parse.log(spec.log) or defaults.control.log,
                  index      = id.index,
                  label      = id.label,
                  subtype    = subtype.name,
                  parameters = subtype.parameters,
                  map        = input_map[subtype.name],
                  responders = responders
                }
                
                return gci_control:new( control ) 
              end
            end
          end
        end
      end
    end
  end

  parse.controls = function (base_type, spec)
    if type(spec) == "table" then
      local controls = {}
      for _, cspec in ipairs(spec) do
        local control = parse.control( base_type, cspec )
        if control then
          control:log_event("INFO", "added", base_type, control.label )
          controls[control.index] = control
        end
      end
      return controls
    end
  end

  parse.controller = function ( spec )
    if not spec.ignore then
      local name = parse.string(spec.name)
      if name then
        
        local controls = {}
        for base_type, type_value in pairs(base_types) do
          controls[type_value] = parse.controls(base_type, spec[base_type]) or {}
        end
        return gci_controller:new{ 
          name = name,
          log = parse.log(spec.log) or defaults.controller.log,
          controls = controls
        }
      end
    end 
  end

  parse.controllers = function (spec)
    if type(spec) == "table" then
      local controllers = {}
      for _, cspec in ipairs(spec) do
        local controller = parse.controller( cspec )
        if controller then
          controllers[controller.name] = controller
        end
      end
      return controllers
    end
  end

  parse.defaults = function (defaults, spec)
    if type(spec) == "table" then
      for k, v in pairs(spec) do
        if (type(v) == "table") and (type(defaults[k] or false) == "table") then
          parse.defaults(defaults[k], spec[k])
        else
          defaults[k] = v
        end
      end
    end
  end

  parse.configuration = function (spec)
    if type(spec) == "table" then
      parse.defaults(defaults, spec.defaults)
      sim = defaults.simulator
      return parse.controllers(spec.controllers)
    end
  end

--{{
  return parse
--}}