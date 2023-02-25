local utils = {}

local textService = game:GetService('TextService')

utils.lerp = function(current, target, speed)
    local larger = target > current

    local diff = math.max(target, current) - math.min(target, current)
    local factor = diff * speed

    if (larger) then
        return current + factor
    else
        return current - factor
    end
end

utils.switch = function(element)
    local Table = {
        ["Value"] = element,
        ["DefaultFunction"] = nil,
        ["Functions"] = {}
    }

    Table.case = function(testElement, callback)
        Table.Functions[testElement] = callback
        return Table
    end

    Table.default = function(callback)
        Table.DefaultFunction = callback
        return Table
    end

    Table.process = function()
        local Case = Table.Functions[Table.Value]
        if Case then
            Case()
        elseif Table.DefaultFunction then
            Table.DefaultFunction()
        end
    end

    return Table
end

utils.string_bounds = function(text, font, size)
    return textService:GetTextSize(text, size, font, Vector2.new(math.huge, math.huge))
end

utils.string_width = function(text, font, size)
    return utils.string_bounds(text, font, size).X
end

utils.string_height = function(text, font, size)
    return utils.string_bounds(text, font, size).Y
end

return utils
