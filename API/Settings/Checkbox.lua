local checkbox = {}

function checkbox:new(title, defaultValue)
    local properties = {}
    properties.title = title
    properties.value = defaultValue
    properties.click_handler = nil
    
    function properties:get_type()
        return 'checkbox'
    end
    
    function properties:get_title()
        return self.title
    end
    
    function properties:set_value(value)
        self.value = value
    end
    
    function properties:get_value()
        return self.value
    end
    
    setmetatable(properties, self)
    return properties
end

return checkbox
