local slider = {}

function slider:new(title, min, max, digits, defaultValue)
    local properties = {}
    properties.title = title
    properties.min = min
    properties.max = max
    properties.value = defaultValue
    
    properties.sliding = false

    function properties:get_type()
        return 'slider'
    end

    function properties:get_title()
        return self.title
    end
    
    function properties:get_min()
        return min
    end
    
    function properties:get_max()
        return max
    end
    
    function properties:set_value(value)
        self.value = math.clamp(value, min, max)
    end

    function properties:get_value()
        return self.value
    end
    
    function properties:get_calculated_value()
        --return self.value / max
        return (self.value - min) * (1. / (max - min))
    end
    
    function properties:get_formatted_value()
        if (self.digits == 0) then
            return tostring(math.floor(self.value))
        else
            return string.format('%.1f', self.value)
        end
    end

    setmetatable(properties, self)
    return properties
end

return slider
