-- main.lua
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local localPlayer = Players.LocalPlayer
repeat task.wait() until localPlayer and localPlayer:FindFirstChild("PlayerGui")
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- load config
local config = loadstring(game:HttpGet("https://raw.githubusercontent.com/zqiv/LogansCameraSuite/refs/heads/main/config.lua"))()

-- load all features
local loadedFeatures = {}

-- notification system
local notificationGui
local activeNotifications = {}
local NOTIFICATION_HEIGHT = 35
local NOTIFICATION_SPACING = 5
local FONT_SIZE = 18

local function initNotificationGui()
    if not notificationGui then
        notificationGui = Instance.new("ScreenGui")
        notificationGui.IgnoreGuiInset = true
        notificationGui.ResetOnSpawn = false
        notificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        notificationGui.DisplayOrder = 2147483647 -- maximum int32 value
        notificationGui.Parent = playerGui
    end
end

local function updateNotificationPositions()
    for i, notif in ipairs(activeNotifications) do
        local targetY = 0.85 - ((i - 1) * (NOTIFICATION_HEIGHT + NOTIFICATION_SPACING) / playerGui.AbsoluteSize.Y)
        local pushTween = TweenService:Create(notif.label, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -200, targetY, 0)
        })
        pushTween:Play()
    end
end

local function showNotification(text)
    initNotificationGui()
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(0, 400, 0, NOTIFICATION_HEIGHT)
    textLabel.Position = UDim2.new(0.5, -200, 0.88, 0) 
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextTransparency = 1
    textLabel.TextStrokeTransparency = 1
    textLabel.TextSize = FONT_SIZE
    textLabel.Font = Enum.Font.Gotham
    textLabel.Text = text
    textLabel.ZIndex = 2147483647 -- maximum int32 value
    textLabel.Parent = notificationGui

    local notifData = {label = textLabel, removing = false}
    table.insert(activeNotifications, notifData)
    updateNotificationPositions()

    local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    
    local targetY = 0.85 - ((#activeNotifications - 1) * (NOTIFICATION_HEIGHT + NOTIFICATION_SPACING) / playerGui.AbsoluteSize.Y)
    local fadeIn = TweenService:Create(textLabel, tweenInfo, {
        Position = UDim2.new(0.5, -200, targetY, 0),
        TextTransparency = 0,
        TextStrokeTransparency = 0
    })

    local fadeOut = TweenService:Create(textLabel, tweenInfo, {
        TextTransparency = 1,
        TextStrokeTransparency = 1
    })

    fadeIn:Play()
    
    task.delay(2, function()
        if not notifData.removing then
            notifData.removing = true
            fadeOut:Play()
            fadeOut.Completed:Connect(function()
                for i, notif in ipairs(activeNotifications) do
                    if notif == notifData then
                        table.remove(activeNotifications, i)
                        break
                    end
                end
                updateNotificationPositions()
                textLabel:Destroy()
            end)
        end
    end)
end

local function loadFeature(featurePath)
    print(featurePath .. " is loading")
    showNotification(featurePath .. " is loading")
    task.wait(0.5) -- small delay so notifications don't overlap too fast
    
    local success, feature = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/zqiv/LogansCameraSuite/refs/heads/main/" .. featurePath))()
    end)
    
    if success then
        return feature
    else
        warn("Failed to load feature: " .. featurePath)
        return nil
    end
end

-- load all features from config
for _, category in ipairs(config.categories) do
    for _, featureConfig in ipairs(category.features) do
        local feature = loadFeature(featureConfig.path)
        if feature then
            loadedFeatures[featureConfig.id] = {
                module = feature,
                config = featureConfig,
                active = false
            }
        end
    end
end

-- suite state
local suiteActive = false

-- toggle suite on/off
local function toggleSuite()
    suiteActive = not suiteActive
    
    if suiteActive then
        -- enable all enabled features
        for id, feature in pairs(loadedFeatures) do
            if feature.config.enabled and feature.module.enable then
                feature.module.enable()
                feature.active = true
            end
        end
    else
        -- disable all active features
        for id, feature in pairs(loadedFeatures) do
            if feature.active and feature.module.disable then
                feature.module.disable()
                feature.active = false
            end
        end
    end
end

-- bind toggle key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == config.keybinds.toggle then
        toggleSuite()
    end
end)

-- final notifications
print("logan's camera suite (" .. config.version .. ") has loaded!")
showNotification("logan's camera suite (" .. config.version .. ") has loaded!")

task.wait(2.5)

print('press "z" to activate')
showNotification('press "z" to activate')
