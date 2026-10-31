local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local Workspace = game:GetService("Workspace")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local Knit = require(ReplicatedStorage.Packages.Knit)
-- local DistanceDetectClient = require(ReplicatedStorage.Modules.DistanceDetectClient)
local PlayerDataController = require(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)
local Constants = require(ReplicatedStorage.Modules.Constants)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local GiftBoxesDataHelper = require(ReplicatedFirst.DataHelpers.GiftBoxesDataHelper)
local PerchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)
local SoundHelper = require(ReplicatedStorage.Modules.SoundHelper)
local AreasDataHelper = require(ReplicatedFirst.DataHelpers.AreasDataHelper)
local Zone = require(ReplicatedStorage.Libs.Zone)
local Timer = require(ReplicatedStorage.Packages.Timer)

local localPlayer = game.Players.LocalPlayer

-- local defaultAtmosphere = {
--     Density = Atmosphere.Density,
--     Color = Atmosphere.Color,
--     Offset = Atmosphere.Offset,
--     Decay = Atmosphere.Decay,
--     Glare = Atmosphere.Glare,
--     Haze = Atmosphere.Haze,
-- }

local isDefaultLighting = true

local DefaultLighting = {
    ClockTime = Lighting.ClockTime,
}

local LightingController = Knit.CreateController {
    Name = "LightingController",
}

function LightingController:ChangeLighting(lighting: {}): ()
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
    local tween = TweenService:Create(Lighting, tweenInfo, lighting)
    tween:Play()
end

function LightingController:ChangeAtmosphere(atmosphere: {}): ()
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
    local tween = TweenService:Create(Lighting.Atmosphere, tweenInfo, atmosphere)
    tween:Play()
end

-- function LightingController:InitDetectBoxes()
--     local palyerData = PlayerDataController:GetData()
--     if not palyerData then return end

--     for _, area in Workspace.Areas:GetChildren() do
--         if not area:FindFirstChild("LightingChanger") then continue end
--         for _, part in ipairs(area.LightingChanger:GetChildren()) do
--             if not part:IsA("Part") then continue end

--             if part.Name == "LightingChanger" then
--                 local customZone = Zone.new(part)
--                 customZone.localPlayerEntered:Connect(function()
--                     LogHelper.Print("Lighting Changer Entered")
--                     self:ChangeLighting(part:GetAttributes())
--                     isDefaultLighting = false
--                 end)
--             end

--             if part.Name == "AtmosphereChanger" then
--                 local customZone = Zone.new(part)
--                 customZone.localPlayerEntered:Connect(function()
--                     LogHelper.Print("Atmosphere Changer Entered")
--                     self:ChangeAtmosphere(part:GetAttributes())
--                     isDefaultLighting = false
--                 end)
--             end
--         end
--     end
-- end

local function changeLighting(configItem): ()
    if configItem.Name == "LightingConfiguration" then
        for _, config in pairs(configItem:GetChildren()) do
            if config:IsA("ValueBase") then
                LogHelper.Print("changeLighting", config.Name, config.Value)
                if not pcall(function()
                    Lighting[config.Name] = config.Value
                end) then
                    warn("Failed to set Lighting." .. config.Name .. " to " .. tostring(config.Value))
                end
            end
        end
    else
        local clone = configItem:Clone()
        local old = Lighting:FindFirstChild(configItem.Name)
        if old then old:Destroy() end
        clone.Parent = Lighting
    end
end

local function resetLighting()
    local defaultLighting = ReplicatedStorage.Lightings:FindFirstChild("Default")
    for _, child in pairs(defaultLighting:GetChildren()) do
        changeLighting(child)
    end
    isDefaultLighting = true
end

-- local function changeAreaLighting(areaId: string)
local function changeAreaLighting()
    local currentAreaId = Knit.GetController("AreaController"):GetCurrentArea()
    local areaLighting = ReplicatedStorage.Lightings:FindFirstChild(currentAreaId)
    if areaLighting then
        for _, child in pairs(areaLighting:GetChildren()) do
            changeLighting(child)
        end
        isDefaultLighting = false
    else
        if not isDefaultLighting then
            resetLighting()
            isDefaultLighting = true
        end
    end
end

function LightingController:KnitInit()
    -- Knit.GetController("AreaController").ChangeAreaEvent:Connect(function(areaId)
    local AreaController = Knit.GetController("AreaController")
    AreaController.LoadedNewWorldClientEvent:Connect(function()
        task.wait(0.1)
        changeAreaLighting()
    end)
end

function LightingController:KnitStart()
    -- self:InitDetectBoxes()

    task.delay(1, function()
        changeAreaLighting()
    end)
end

return LightingController
