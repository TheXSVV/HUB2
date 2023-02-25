local window = {}

local tabs = {}

window.register_tab = function(tab)
    table.insert(tabs, tab)
end

local guiBuilder = loadModuleScript('UI/UI')
local utils = loadModuleScript('Utils/Utils')
local ascentColor = Color3.fromRGB(64, 134, 242)
local renderEvent = game:GetService('RunService').RenderStepped
local mouse = game.Players.LocalPlayer:GetMouse()

local gui = guiBuilder:new('Test')
local frame = gui:add_frame(0, 0, 620, 420):centerize():set_background(Color3.fromRGB(36, 36, 36), 255):apply_rounding(6)

-- Drag start
local prevX, prevY = 0, 0
local animatedX, animatedY = frame:get_x(), frame:get_y()
local drag = false

frame:get_component().InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1) then
        prevX = mouse.X - frame:get_component().AbsolutePosition.X
        prevY = mouse.Y - frame:get_component().AbsolutePosition.Y
        drag = true
    end
end)

frame:get_component().InputEnded:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1) then
        drag = false
    end
end)

mouse.Move:Connect(function()
    if (drag) then
        animatedX = utils.lerp(animatedX, mouse.X - prevX, 0.2)
        animatedY = utils.lerp(animatedY, mouse.Y - prevY, 0.2)

        frame:set_x(animatedX)
        frame:set_y(animatedY)
    end
end)
-- Drag end

local leftPanel = frame:add_frame(0, 0, 200, frame:get_height()):set_background(Color3.fromRGB(0, 0, 0), 0)
leftPanel:add_image(12600570787, 12, 14, 35, 35)
leftPanel:add_text('HUB', 58, 19):set_font(Enum.Font.ArialBold, 26)

local rightPanel = frame:add_frame(leftPanel:get_width(), 0, frame:get_width()-leftPanel:get_width(), frame:get_height()):set_background(Color3.fromRGB(25, 25, 25), 255)

local selectedTab
local settingComponents = {}
local events = {}
window.init = function()
    local tabAlpha = 0
    local tabFrames = {}
    local selectedTabFrame
    local tabOffset = 65
    for index, tab in pairs(tabs) do
        local tabFrame = leftPanel:add_frame(0, tabOffset, leftPanel:get_width(), 40)
        tabFrame:get_component().InputBegan:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseButton1 and selectedTabFrame ~= tabFrame) then
                selectedTabFrame = tabFrame
                selectedTab = tab
                tabAlpha = 0
                initSettings()
            end
        end)
        tabFrame:add_text(tab:get_title(), 25, 12):set_font(Enum.Font.Highway, 14)

        if (index == 1) then
            selectedTabFrame = tabFrame
            selectedTab = tab
            initSettings()
        end
        table.insert(tabFrames, tabFrame)
        tabOffset = tabOffset+tabFrame:get_height()
    end
    -- Alpha tab animation
    renderEvent:Connect(function()
        if (selectedTabFrame == nil) then return end

        for _, frame in pairs(tabFrames) do
            frame:set_background(Color3.fromRGB(29, 29, 29), 255)
        end
        tabAlpha = utils.lerp(tabAlpha, 255, 0.1)
        selectedTabFrame:set_background(ascentColor, tabAlpha)
    end)
    
    return window
end
-- Shadow image
leftPanel:add_image(12600455126, leftPanel:get_width(), 0, 6, leftPanel:get_height()):get_component().ZIndex = 2

function initSettings()
    for _, component in pairs(settingComponents) do
        component:get_component():Destroy()
    end
    settingComponents = {}
    for _, hook in pairs(events) do
        hook:Disconnect()
    end
    events = {}
    
    local settingOffset = 20
    
    for _, setting in pairs(selectedTab:get_settings()) do
        local settingPanel = rightPanel:add_frame(20, settingOffset, rightPanel:get_width()-40, 40):set_background(Color3.fromRGB(35, 35, 35), 255):apply_rounding(6):apply_stroke(1, Color3.fromRGB(71, 71, 71))
        settingPanel:add_text(setting:get_title(), 20, 10):set_font(Enum.Font.RobotoMono, 16)
        
        utils.switch(setting:get_type())
            .case('checkbox', function()
                local booleanSetting = settingPanel:add_frame(0, 8, 50, 26):set_background(Color3.fromRGB(27, 27, 27), 255):apply_rounding(12):apply_stroke(1, Color3.fromRGB(59, 59, 59))
                booleanSetting:set_x(settingPanel:get_width()-booleanSetting:get_width()-20)
                local toggler = booleanSetting:add_frame(2, 2, 22, 22):set_background(Color3.fromRGB(93, 93, 93), 255):apply_rounding(20)
                local togglerX
                if (setting:get_value()) then
                    togglerX = booleanSetting:get_width()-toggler:get_width()-2
                else
                    togglerX = 2
                end
                
                table.insert(events, booleanSetting:get_component().InputBegan:Connect(function(input)
                    if (input.UserInputType == Enum.UserInputType.MouseButton1) then
                        setting:set_value(not setting:get_value())
                        if (setting.click_handler ~= nil) then
                            setting.click_handler()
                        end
                    end
                end))
                -- Toggler x animation
                table.insert(events, renderEvent:Connect(function()
                    if (setting:get_value()) then
                        togglerX = utils.lerp(togglerX, booleanSetting:get_width()-toggler:get_width()-2, 0.15)
                    else
                        togglerX = utils.lerp(togglerX, 2, 0.15)
                    end

                    toggler:set_x(togglerX)
                end))
                settingOffset = settingOffset+settingPanel:get_height()+10
            end)
            .case('slider', function()
                local sliderSetting = settingPanel:add_frame(0, 8, 160, 26):set_background(Color3.fromRGB(27, 27, 27), 255):apply_rounding(12):apply_stroke(1, Color3.fromRGB(59, 59, 59))
                sliderSetting:set_x(settingPanel:get_width()-sliderSetting:get_width()-20)
                
                local sliderRect = sliderSetting:add_frame(2, 2, 0, 22):apply_rounding(20)
                local sliderWidth = setting:get_calculated_value() * (sliderSetting:get_width() - 4)
                local text = sliderSetting:add_text(setting:get_formatted_value(), 0, 4):set_font(Enum.Font.SourceSans, 14)
                sliderSetting:get_component().InputBegan:Connect(function(input)
                    if (input.UserInputType == Enum.UserInputType.MouseButton1) then
                        setting.sliding = true
                    end
                end)
                sliderSetting:get_component().InputEnded:Connect(function(input)
                    if (input.UserInputType == Enum.UserInputType.MouseButton1) then
                        setting.sliding = false
                    end
                end)
                
                -- Slider width and text animation
                table.insert(events, renderEvent:Connect(function()
                    sliderWidth = utils.lerp(sliderWidth, setting:get_calculated_value() * (sliderSetting:get_width() - 4), 0.3)
                    sliderRect:set_width(sliderWidth)
                    text:set_text(setting:get_formatted_value())
                    text:set_x(-text:get_width()-10)
                    
                    if (setting.sliding) then
                        setting:set_value((mouse.X - sliderSetting:get_component().AbsolutePosition.X) * (setting:get_max() - setting:get_min()) / sliderSetting:get_width() + setting.get_min())
                    end    
                end))
            end)
        .process()
        
        table.insert(settingComponents, settingPanel)
    end
end

window.show = function()
    gui:show()
end

window.hide = function()
    gui:hide()
end

return window
