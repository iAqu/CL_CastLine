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

local localPlayer = game.Players.LocalPlayer
local Atmosphere = Lighting.Atmosphere

local defaultAtmosphere = {
    Density = Atmosphere.Density,
    Color = Atmosphere.Color,
    Offset = Atmosphere.Offset,
    Decay = Atmosphere.Decay,
    Glare = Atmosphere.Glare,
    Haze = Atmosphere.Haze,
}

local AtmosphereController = Knit.CreateController {
    Name = "AtmosphereController",
}

-- function AtmosphereController:ResetAtmosphere()
--     self:ChangeAtmosphere(defaultAtmosphere)
-- end

-- function AtmosphereController:ChangeAtmosphere(atmosphere: {}): ()
--     local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
--     local tween = TweenService:Create(Atmosphere, tweenInfo, atmosphere)
--     tween:Play()
-- end

-- function AtmosphereController:InitDetectBoxes()
--     local palyerData = PlayerDataController:GetData()
--     if not palyerData then return end

--     for _, area in Workspace.Areas:GetChildren() do
--         if not area:FindFirstChild("LightingChanger") then continue end
--         -- if not area.LightingChanger:FindFirstChild("AtmosphereChanger") then continue end
--         for _, part in ipairs(area.LightingChanger:GetChildren()) do
--             if not part:IsA("Part") then continue end
--             if part.Name ~= "AtmosphereChanger" then continue end

--             -- local container = area.Items.AtmosphereChanger
--             local customZone = Zone.new(part)
--             customZone.localPlayerEntered:Connect(function()
--                 -- local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
--                 -- local tween = TweenService:Create(Atmosphere, tweenInfo, container:GetAttributes())
--                 -- tween:Play()
--                 self:ChangeAtmosphere(part:GetAttributes())
--             end)
--         end
--     end
-- end

function AtmosphereController:KnitInit()
end

function AtmosphereController:KnitStart()
    -- self:InitDetectBoxes()
end

return AtmosphereController
