local tab = {}

function tab:new(title)
    local properties = {}
    properties.title = title
    properties.settings = {}
    
    function properties:get_title()
        return self.title
    end
    
    function properties:register_setting(setting)
        table.insert(self.settings, setting)
        print(' | Registered ' .. setting:get_title() .. ' setting with `' .. setting:get_type() .. '` type')
    end
    
    function properties:get_settings()
        return self.settings
    end
    
    setmetatable(properties, self)
    return properties
end

return tab
