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

  -- Test: OK
  parse.scale = function (spec)
    local scale = parse.number(spec)
    return scale ~= 0 and scale or defaults.axis.scale
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
      local scale = parse.scale(scale)
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

--{{
  return parse
--}} ---------------------------------------------------------