--{{ Required Modules
  controller = require "src/model/controller"
  control    = require "src/model/control"
  responder  = require "src/model/responder"

  gci_controller  = controller.gci_controller
  gci_control     = control.gci_control
  gci_responder   = responder.gci_responder  
--}} ---------------------------------------------------------
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
    if spec or defaults.ignore then 
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
    if type(spec) == "number" then
      spec = { index = spec }
    elseif type(spec) == "table" and type(spec[1]) == "number" then
      spec = { index = spec[1], label = spec[2] }
    end
    
    if type(spec) == "table" and type(spec.index) == "number" then
      return { index = spec.index | 0, label = tostring( (spec.label or spec.index) ) }  
    end
  end

  -- Test: OK
  parse.parameters = function (spec)
    local parameters
    if type(spec) == "table" then
      parameters = spec
    elseif spec then
      parameters = { spec }
    end
    return parameters
  end
  
  -- Test: OK
  parse.subtype = function (spec)
    if type(spec) == "string" then
      spec = { name = spec }
    elseif type(spec) == "table" and type(spec[1]) == "string" then
--    spec = { name = spec[1], parameters = parse.parameters(table.unpack(spec)) }
      spec = { name = spec[1], parameters = spec[2] }
    end
    
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
 
  -- Test: OK
  parse.response = function ( spec, scale )
    if type(spec) == "table" then
      -- create proper points list
      local points = {}
      for _, point in ipairs(spec) do
        if type(point) == "table" then
          local p1 = parse.number(point[1])
          local p2 = parse.number(point[2])
          if p1 and p2 then
            points[p1] = p2
          end
        end
      end
      -- create the settings table
      local scale = parse.scale(scale) or defaults.axis.scale
      local settings = {}
      for p1, p2 in pairs(points) do
        settings[#settings + 1] = { p1, scale * p2 }
      end
      -- sort the settings table
      if #settings >= 2 then
        table.sort(settings, function (m,n) return (m[1] < n[1]) end )
        return settings
      end
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

    local output, argument
    if type(spec) == "table" then
      local invert   = parse.boolean(spec.invert)
      local scale    = parse.scale(spec.scale, invert)
      local response = parse.response(spec.response, scale)
      local value    = parse.value(spec.value)
      
      if value then
        output = "fixed"; 
        argument = value
      elseif response then
        output = "nonlinear"; 
        argument = response
      elseif scale then
        output = "scaled"; 
        argument = scale
      elseif invert == true then
        output = "inverted"; 
        argument = nil
      elseif invert == false then
        output = "direct"; 
        argument = nil
      end
    end
    return output, argument 
  end
  
  parse.responder = function ( spec )
    if type(spec) == "table" then
      local var_id  = parse.string( spec.variable or spec.dataref or spec.var_id )
      local unit_id = parse.string( spec.unit or spec.type or spec.unit_id )
      local offset  = parse.number( spec.offset )
      local force   = parse.boolean( spec.force )
      local output, value = parse.output( spec.value )
      output = output or "default"
      return gci_responder:new {
        var_id  = var_id,
        unit_id = unit_id,
        offset  = offset,
        force   = force,
        value   = value,
        respond = action_map[sim][gci_action],
        output  = output_map[gci_control_type][output]
      }
    end
  end
  
  parse.action = function ( spec )
    if type(spec) == "table" then
      local responders = {}
      for trigger, spec in pairs(spec) do
        responders[trigger] = parse.responder( spec )
      end
      return responders
    end
  end

  parse.control = function ( spec )
    if type(spec) == "table" then
      if not spec.ignore then
        local id = parse.id(spec.id)
        
        local subtype = parse.subtype(spec.subtype or gci_control_type)
        
        if spec.write then gci_action = "write" 
        elseif spec.send then gci_action = "send"
        elseif spec.publish then gci_action = "publish" 
        end
        local responders = parse.action( spec[gci_action] )
        if id and responders then
          return gci_control:new{
            index = id.index,
            label = id.label,
            log = parse.log(spec.log) or defaults.control.log,
            subtype = subtype.name,
            parameters = subtype.parameters,
            responders = responders
          }
        end
      end
    end
  end

  parse.controls = function (control_type, spec)
    if type(spec) == "table" then
      local controls = {}
      for _, cspec in ipairs(spec) do
        gci_control_type = control_type
        local control = parse.control( cspec )
        if control then
          control:log_event("INFO", "added", control_type, control.label )
          controls[control.index] = control
        end
        gci_control_type = nil
      end
      return controls
    end
  end

  parse.controller = function ( spec )
    if not spec.ignore then
      local name = parse.string(spec.name)
      if name then
        local controls = {}
        controls[0] = parse.controls("axis", spec.axes) or {}
        controls[1] = parse.controls("button", spec.buttons) or {}
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
          -- controller:log_event("INFO", "added", controller.name)
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
      defaults = parse.defaults(defaults, spec.defaults)
      return parse.controllers(spec.controllers)
    end
  end
  
--{{
  return parse
--}} ---------------------------------------------------------