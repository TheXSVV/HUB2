local utils = loadModuleScript('Utils/Utils')

local textBuilder = {}

function textBuilder:new(child, text, x, y)
    local properties = {}
    local label = Instance.new('TextLabel', child)
    label.BackgroundTransparency = 1
    label.BorderSizePixel = 0
    label.Position = UDim2.fromOffset(x, y)
    label.Size = UDim2.fromOffset(utils.string_width(text, label.Font, label.TextSize), utils.string_height(text, label.Font, label.TextSize))
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Top
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Text = text

    function properties:get_x()
        return label.Position.X.Offset
    end

    function properties:get_y()
        return label.Position.Y.Offset
    end

    function properties:set_x(x)
        label.Position = UDim2.fromOffset(x, label.Position.Y.Offset)
        return self
    end

    function properties:set_y(y)
        label.Position = UDim2.fromOffset(label.Position.X.Offset, y)
        return self
    end
    
    function properties:set_text(text)
        label.Text = text
        label.Size = UDim2.fromOffset(utils.string_width(text, label.Font, label.TextSize), utils.string_height(text, label.Font, label.TextSize))
        return self
    end
    
    function properties:get_width()
        return label.Size.Width.Offset
    end

    function properties:get_height()
        return label.Size.Height.Offset
    end
    
    function properties:get_text()
        return label.Text
    end

    function properties:set_font(font, size)
        label.Font = font
        label.TextSize = size

        return self
    end

    function properties:set_font_style(style)
        label.FontFace.Style = style
        return self
    end

    function properties:set_font_weight(weight)
        label.FontFace.Weight = weight
        return self
    end

    function properties:set_color(color, alpha)
        label.TextColor3 = color
        label.TextTransparency = (255 - alpha) / 255.

        return self
    end
    
    function properties:set_x_aligment(xAligment)
        label.TextXAlignment = xAligment
        return self
    end
    
    
    function properties:set_y_aligment(yAligment)
        label.TextYAlignment = yAligment
        return self
    end

    function properties:centerize()
        label.Position = UDim2.fromOffset(label.Position.X.Offset - utils.string_width(label.Text, label.Font, label.TextSize) / 2, label.Position.Y.Offset)
        return self
    end
    
    function properties:get_component()
        return label
    end

    setmetatable(properties, self)
    return properties
end

local imageBuilder = {}

function imageBuilder:new(child, textureID, x, y, width, height)
    local properties = {}
    local image = Instance.new('ImageLabel', child)
    image.BackgroundTransparency = 1
    image.BorderSizePixel = 0
    image.Position = UDim2.fromOffset(x, y)
    image.Size = UDim2.fromOffset(width, height)
    image.Image = 'rbxassetid://' .. textureID

    function properties:get_x()
        return image.Position.X.Offset
    end

    function properties:get_y()
        return image.Position.Y.Offset
    end

    function properties:get_width()
        return image.Size.Width.Offset
    end

    function properties:get_height()
        return image.Size.Height.Offset
    end

    function properties:set_x(x)
        image.Position = UDim2.fromOffset(x, image.Position.Y.Offset)
        return self
    end

    function properties:set_y(y)
        image.Position = UDim2.fromOffset(image.Position.X.Offset, y)
        return self
    end

    function properties:set_width(width)
        image.Size = UDim2.fromOffset(width, image.Size.Height.Offset)
        return self
    end

    function properties:set_height(height)
        image.Size = UDim2.fromOffset(image.Size.Width.Offset, height)
        return self
    end
    
    function properties:set_alpha(alpha)
        image.ImageTransparency = (255 - alpha) / 255.
        return self
    end

    function properties:set_background(alpha)
        image.BackgroundTransparency = (255 - alpha) / 255.

        return self
    end

    function properties:apply_rounding(radius)
        local uiCorner = Instance.new('UICorner', image)
        uiCorner.CornerRadius = UDim.new(0, radius)

        return self
    end

    function properties:apply_stroke(thickness, color)
        local uiStroke = Instance.new('UIStroke', image)
        uiStroke.Thickness = thickness
        uiStroke.Color = color

        return self
    end
    
    function properties:get_component()
        return image
    end

    setmetatable(properties, self)
    return properties
end

local frameBuilder = {}

function frameBuilder:new(child, x, y, width, height)
	local properties = {}
	local frame = Instance.new('Frame', child)
	frame.BorderSizePixel = 0
	frame.Position = UDim2.fromOffset(x, y)
	frame.Size = UDim2.fromOffset(width, height)
    
    function properties:add_frame(x, y, width, height)
        return frameBuilder:new(frame, x, y, width, height)
    end
    
    function properties:add_image(textureID, x, y, width, height)
        return imageBuilder:new(frame, textureID, x, y, width, height)
    end

    function properties:add_text(text, x, y)	
        return textBuilder:new(frame, text, x, y)
    end
    
	function properties:get_x()
        return frame.Position.X.Offset
	end
	
	function properties:get_y()
        return frame.Position.Y.Offset
	end
	
    function properties:get_width()
        return frame.Size.Width.Offset
	end
	
	function properties:get_height()
        return frame.Size.Height.Offset
	end
	
	function properties:set_x(x)
		frame.Position = UDim2.fromOffset(x, frame.Position.Y.Offset)
		return self
	end
	
	function properties:set_y(y)
		frame.Position = UDim2.fromOffset(frame.Position.X.Offset, y)
		return self
	end
	
	function properties:set_width(width)
		frame.Size = UDim2.fromOffset(width, frame.Size.Height.Offset)
		return self
	end
	
	function properties:set_height(height)
		frame.Size = UDim2.fromOffset(frame.Size.Width.Offset, height)
		return self
	end
	
	function properties:set_background(color, alpha)
		frame.BackgroundColor3 = color
		frame.BackgroundTransparency = (255 - alpha) / 255.
		
		return self
	end
	
	function properties:centerize()
		local mouse = game.Players.LocalPlayer:GetMouse()
		
		frame.Position = UDim2.fromOffset(mouse.ViewSizeX / 2 - frame.Size.Width.Offset / 2, mouse.ViewSizeY / 2 - frame.Size.Height.Offset / 2)
		return self
	end
	
	function properties:apply_rounding(radius)
		local uiCorner = Instance.new('UICorner', frame)
		uiCorner.CornerRadius = UDim.new(0, radius)
		
		return self
	end
	
	function properties:apply_stroke(thickness, color)
		local uiStroke = Instance.new('UIStroke', frame)
		uiStroke.Thickness = thickness
		uiStroke.Color = color

		return self
    end
    
    function properties:get_component()
        return frame
    end
	
	setmetatable(properties, self)
	return properties
end

local guiBuilder = {}

function guiBuilder:new(title)
	local properties = {}
	properties.title = title
    properties.screen = Instance.new('ScreenGui', game.Players.LocalPlayer.PlayerGui)
    properties.screen.Enabled = false
	
	function properties:add_frame(x, y, width, height)
		return frameBuilder:new(self.screen, x, y, width, height)
	end
	
	function properties:show()
		self.screen.Enabled = true
	end
	
	function properties:hide()
		self.screen.Enabled = false
    end
    
    function properties:get_component()
        return self.screen
    end
	
	setmetatable(properties, self)
	return properties
end

return guiBuilder
