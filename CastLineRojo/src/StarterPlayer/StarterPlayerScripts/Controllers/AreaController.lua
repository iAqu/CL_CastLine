local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local StarterPlayer = game:GetService("StarterPlayer")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ContentProvider = game:GetService("ContentProvider")
local TweenService = game:GetService('TweenService')
local StarterGui = game:GetService("StarterGui")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Signal = require(ReplicatedStorage.Packages.Signal)
local PlayerDataController = require(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)
local AreasDataHelper = require(ReplicatedFirst.DataHelpers.AreasDataHelper)
local MathUtil = require(ReplicatedStorage.Modules.MathUtil)
local Constants = require(ReplicatedStorage.Modules.Constants)
local NotificationClient = require(ReplicatedStorage.Modules.NotificationClient)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)
local CharacterUtil = require(ReplicatedStorage.Modules.CharacterUtil)
local SoundHelper = require(ReplicatedStorage.Modules.SoundHelper)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local Zone = require(ReplicatedStorage.Libs.Zone)
local GuiAnimationUtil = require(ReplicatedStorage.Modules.GuiAnimationUtil)
local GameDataUtil = require(ReplicatedStorage.Modules.GameDataUtil)
local PlotWorkspaceUtil = require(ReplicatedStorage.Modules.PlotWorkspaceUtil)
local EffectUtil = require(ReplicatedStorage.Modules.EffectUtil)

local localPlayer = Players.LocalPlayer
-- local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local PlayerGui = localPlayer:WaitForChild("PlayerGui")

local LoadingAreaGui = PlayerGui:WaitForChild("LoadingAreaGui")

local ResetBindable = Instance.new("BindableEvent")

local DEFAULT_AREA = "Area_1"
local LOCK_TEXT_TEMPLATE = "<stroke color=\"#000000\" joins=\"miter\" thickness=\"6\" transparency=\"0\">UNLOCK_TEXT</stroke>"
-- local doorDebounce = false
local portalDebounce = false

local isTeleporting = false
local currentAreaId = DEFAULT_AREA
local currentWorldIndex = 1

-- local initDoorsWorlds = {}            -- {worldIndex: number}
-- local initPortalsWorlds = {}          -- {worldIndex: number}
-- local activeZones = {}                -- {areaId: string : zone: Zone}
-- local activeZone = nil

local AreaController = Knit.CreateController {
    Name = "AreaController",
    ChangeAreaEvent = Signal.new(),
    LoadedNewWorldClientEvent = Signal.new(),

    _AllPlayersLocation = {},       -- {UserId: string, areaId: string}
}

local function getSortedPlots(): { Instance }
    return PlotWorkspaceUtil.getSortedPlots()
end

local function getPlotBySlot(slotId: number): Instance?
    return PlotWorkspaceUtil.getPlotBySlot(slotId)
end

local function getPlotSpawnBySlot(): BasePart?
    local slotId = localPlayer:GetAttribute("PlotSlotId")
    if type(slotId) ~= "number" then
        return nil
    end
    local plot = getPlotBySlot(slotId)
    if not plot then
        return nil
    end
    local spawn = plot:FindFirstChild("AreaSpawnPoint")
    if spawn and spawn:IsA("BasePart") then
        return spawn
    end
    return nil
end

local function resolveAreaSpawnPoint(targetAreaId: string): BasePart?
    local areas = Workspace:FindFirstChild("Areas")
    if not areas then
        return nil
    end

    if targetAreaId == Constants.AREA_NAME.Area_1 then
        local plotSpawn = getPlotSpawnBySlot()
        if plotSpawn then
            return plotSpawn
        end
    end

    local fallback = areas:FindFirstChild("AreaSpawnPoint")
    if fallback and fallback:IsA("BasePart") then
        return fallback
    end
    return nil
end

function AreaController:GetCurrentArea(): string
    return currentAreaId
end

function AreaController:SetCurrentArea(areaId: string)
    currentAreaId = areaId
    currentWorldIndex = AreasDataHelper.GetWorldIndexByAreaId(areaId)
end

function AreaController:IsTeleporting(): boolean
    return isTeleporting
end

-- local function hideRootPart()
local function hideDevParts()
    if RunService:IsStudio() then
        return
    end
    if Constants.DEBUG == true then
        return
    end

    local function setPartTransparent(inst: Instance?)
        if inst and inst:IsA("BasePart") then
            inst.Transparency = 1
        end
    end

    local function setDecalTransparent(inst: Instance?)
        if inst and inst:IsA("Decal") then
            inst.Transparency = 1
        end
    end

    local success, result = pcall(function()
        local areas = Workspace:FindFirstChild("Areas")
        if not areas then
            return
        end

        setPartTransparent(areas:FindFirstChild("AreaSpawnPoint"))

        local spawnLocation = Workspace:FindFirstChild("SpawnLocation")
        setPartTransparent(spawnLocation)
        if spawnLocation then
            setDecalTransparent(spawnLocation:FindFirstChild("Decal"))
        end

        setPartTransparent(areas:FindFirstChild("WorldRootPart"))
        setPartTransparent(areas:FindFirstChild("RootPart"))
        setPartTransparent(areas:FindFirstChild("TeleportPart_Shop"))

        for _, child in pairs(areas:GetChildren()) do
            if (not child:IsA("Folder")) and (not child:IsA("Model")) then continue end

            setPartTransparent(child:FindFirstChild("RootPart"))
            setPartTransparent(child:FindFirstChild("AreaSpawnPoint"))
            setPartTransparent(child:FindFirstChild("TeleportPart_Shop"))

            if child.Name == "Plot" then
                for _, plot in ipairs(getSortedPlots()) do
					setPartTransparent(plot:FindFirstChild("BuildBoundsPart"))
                    setPartTransparent(plot:FindFirstChild("AreaSpawnPoint"))
                end
            end
        end
    end)

    if not success then
        warn("Error hiding dev parts: ", result)
    end
end

-- 家园定位用的 Part 只在客户端隐藏，仍提供出生、交互和相机所需的位置。
local PLOT_RUNTIME_MARKERS = {
    LoadingScreenCam = true,
    AreaSpawnPoint = true,
    SellShopAnchor = true,
    TrainingAnchor = true,
    TrainingExitAnchor = true,
    TrainingUpgradeAnchor = true,
    RodShopAnchor = true,
}

local function hidePlotRuntimeMarkers(plot: Instance)
    if not PlotWorkspaceUtil.isValidPlot(plot) then
        return
    end

    for markerName in pairs(PLOT_RUNTIME_MARKERS) do
        local marker = plot:FindFirstChild(markerName)
        if marker and marker:IsA("BasePart") then
            marker.LocalTransparencyModifier = 1
        end
    end
end

-- Studio Play 客户端与正式服都会经过这里。
local function initPlotRuntimeMarkerHiding()
    local areas = Workspace:FindFirstChild("Areas")
    if not areas then
        return
    end

    local leaderboardTeleportPart = areas:FindFirstChild("TeleportPart_Leaderboard")
    if leaderboardTeleportPart and leaderboardTeleportPart:IsA("BasePart") then
        leaderboardTeleportPart.LocalTransparencyModifier = 1
    end

    local plotRoot = areas:FindFirstChild("Plot")
    if not plotRoot then
        return
    end

    for _, plot in ipairs(getSortedPlots()) do
        hidePlotRuntimeMarkers(plot)
    end

    plotRoot.DescendantAdded:Connect(function(descendant)
        local ancestor: Instance? = descendant
        while ancestor and ancestor ~= plotRoot do
            if PlotWorkspaceUtil.isValidPlot(ancestor) then
                hidePlotRuntimeMarkers(ancestor)
                return
            end
            ancestor = ancestor.Parent
        end
    end)
end

function AreaController:Init()
    hideDevParts()
    initPlotRuntimeMarkerHiding()
end

local function initAirWalls()
    if Constants.DEBUG == false then
        local function hideAirWalls(airWallsFolder: Instance?)
            if not airWallsFolder then
                return
            end
            for _, airWall in airWallsFolder:GetChildren() do
                if airWall:IsA("Part") then
                    airWall.Transparency = 1
                end
            end
        end

        for _, area in workspace.Areas:GetChildren() do
            if not area:FindFirstChild("AirWalls") then continue end
            hideAirWalls(area.AirWalls)
        end
    end
end

local function touchPortal(targetAreaId: string) 
    if not targetAreaId then warn("No TargetAreaId") return end

    local playerData = PlayerDataController:GetData()
    if not playerData then warn("No PlayerData!") return end

    if playerData.Areas[targetAreaId] then
        AreaController:TeleportToArea(targetAreaId)
    else
        NotificationClient.RedNotify("Not unlocked yet")
    end
end

local function initPortals()
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("No PlayerData!") return end

    for _, area in pairs(workspace.Areas:GetChildren()) do
        -- if not area:FindFirstChild("Items") then warn("No Items ", area.Name) continue end
        if not area.Name:match("Area_") then continue end
        for _, child in pairs(area.Items:GetChildren()) do
            if child.Name == "Portal" then
                if not child:FindFirstChild("TouchPart") then warn("No TouchPart", area); continue end
                LogHelper.Print("Init Portal", child.Name, area.Name)
                local portalZone = Zone.new(child.TouchPart)
                portalZone.localPlayerEntered:Connect(function()
                    if portalDebounce then return end
                    portalDebounce = true
                    task.delay(1, function()
                        portalDebounce = false
                    end)

                    -- if not GameDataUtil.IsCompleteTutorial(playerData) then NotificationClient.GreenNotify("Complete Tutorial First!") return end
                    LogHelper.Print("localPlayerEntered Portal")
                    local targetAreaId = child:GetAttribute("AreaId")
                    touchPortal(targetAreaId)
                    -- if targetAreaId then
                    --     AreaController:TeleportToArea(targetAreaId)
                    -- else
                    --     warn("No TargetAreaId")
                    -- end
                end)

                local targetAreaId = child:GetAttribute("AreaId")
                local success, result = pcall(function()
                    if not child:FindFirstChild("SurfaceGui") then return end
                    if AreasDataHelper.GetWorldIndexByAreaId(targetAreaId) < AreasDataHelper.GetWorldIndexByAreaId(currentAreaId) then
                        child.SurfaceGui.Frame.NameLabel.Text = "Return to " .. AreasDataHelper.GetName(targetAreaId)
                        child.SurfaceGui.Frame.RebirthLabel.Visible = false
                        child.SurfaceGui.Frame.TrophyLabel.Visible = false
                        child.SurfaceGui.Frame.RebirthImage.Visible = false
                        child.SurfaceGui.Frame.TrophyImage.Visible = false
                    else
                        child.SurfaceGui.Frame.NameLabel.Text = AreasDataHelper.GetName(targetAreaId)
                        child.SurfaceGui.Frame.RebirthLabel.Text = "Rebirth: " .. AreasDataHelper.GetUnlockRebirth(targetAreaId)
                        child.SurfaceGui.Frame.TrophyLabel.Text = "Wins: " .. NumberUtil.FormatWinsAmount(AreasDataHelper.GetUnlockTrophy(targetAreaId))
                    end
                end)
                if not success then
                    warn("Error updating portal gui: ", result)
                end
            end
        end
    end
end

function AreaController:UnlockArea(areaId: string, isSuccess: boolean, resultMsg: string)
    if isSuccess then
        NotificationClient.GreenNotify(resultMsg)
    else
        NotificationClient.RedNotify(resultMsg)
    end
end

local function endLoadingGui()
	local Fade = LoadingAreaGui.Fade
	local A = TweenService:Create(Fade,TweenInfo.new(0.75,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),{BackgroundTransparency=0})
	A.Completed:Connect(function()
		local B = TweenService:Create(Fade,TweenInfo.new(0.75,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),{BackgroundTransparency=1})
		LoadingAreaGui.Frame.Visible = false
        B:Play()
		B.Completed:Connect(function()
            LoadingAreaGui.Enabled = false
            B:Destroy()
		end)
        A:Destroy()
	end)
	A:Play()
end

local function startLoadingGui(areaId: string)
    LoadingAreaGui.Enabled = true
    LoadingAreaGui.Frame.Visible = true
    LoadingAreaGui.Fade.Transparency = 1
    LoadingAreaGui.Frame.NameLabel.Text = AreasDataHelper.GetName(areaId)
    LoadingAreaGui.Frame.LoadingFrame.LoadingRing.Rotation = 0

    local tweenInfo = TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1)
	local ringTween = TweenService:Create(LoadingAreaGui.Frame.LoadingFrame.LoadingRing, tweenInfo, {Rotation = 360})
    ringTween:Play()

    task.delay(2.5, function()
        ringTween:Cancel()
        ringTween:Destroy()
        endLoadingGui()
    end)
end

local function initNewArea()
    portalDebounce = false

    -- if Constants.DEBUG == false then
    --     hideRootPart()
    -- end
    hideDevParts()

    initAirWalls()
    initPortals()
end

local function loadNewWorld(areaId: string)
    local success, areaModelClone = pcall(function()
        return ReplicatedStorage.Worlds:FindFirstChild(areaId):Clone()
    end)
    if not success then warn("AreaModel not found", areaId) return end

    -- 检查是否为Model
    if not areaModelClone:IsA("Model") then warn("AreaModel is not a Model", areaId) return end
    -- 检查是否有PrimaryPart
    if not areaModelClone.PrimaryPart then
        if areaModelClone:FindFirstChild("RootPart") then
            areaModelClone.PrimaryPart = areaModelClone.RootPart
        else
            warn("AreaModel has no RootPart and PrimaryPart", areaId)
        end
    end

    local WorldRootPart = Workspace.Areas:FindFirstChild("WorldRootPart") 
    if not WorldRootPart then warn("No WorldRootPart") return end
    areaModelClone:SetPrimaryPartCFrame(WorldRootPart.CFrame)

    areaModelClone.Parent = Workspace.Areas

    for _, child in pairs(workspace.Areas:GetChildren()) do
        if child:IsA("Folder") and child.Name:match("Area_") then   -- delete other area folders(Test)
            child:Destroy()
        end
        if child:IsA("Model") and child.Name ~= areaId then   -- delete other area models
            child:Destroy()
        end
    end

    initNewArea()

    AreaController.LoadedNewWorldClientEvent:Fire()
end

function AreaController:TeleportToArea(targetAreaId: string)
    -- local targetWorldIndex = AreasDataHelper.GetWorldIndexByAreaId(targetAreaId)
    -- if targetWorldIndex == currentWorldIndex then NotificationClient.GreenNotify("Already in this area") return end

    isTeleporting = true

    local isTeleportingNewArea = false

    if targetAreaId ~= currentAreaId then
        startLoadingGui(targetAreaId)
        isTeleportingNewArea = true
    end

    local spanLocation = resolveAreaSpawnPoint(targetAreaId)
    if not spanLocation then warn("No AreaSpawnPoint") return end

    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    CharacterUtil.TeleportTo(character, spanLocation.CFrame)

    character.HumanoidRootPart.Anchored = false

    self:ChangeArea(targetAreaId)
    isTeleporting = false

    if isTeleportingNewArea then
        loadNewWorld(targetAreaId)
    end
end

function AreaController:ChangeArea(areaId: string)
    self:SetCurrentArea(areaId)

    local AreaService = Knit.GetService("AreaService")
    AreaService.UpdatePlayerCurrentArea:Fire(areaId)

    self.ChangeAreaEvent:Fire(areaId)

    -- if areaId == Constants.AREA_NAME.DUNGEON then
    --     BottomFrame.Visible = false
    -- else
    --     BottomFrame.Visible = true
    -- end
end

ResetBindable.Event:connect(function()
    local fishingController = Knit.GetController("FishingController")
    if fishingController:IsPreparing() then
        fishingController:ReturnToSpawn()
        return
    end
    -- Implement custom reset logic here
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    if character:FindFirstChild("HumanoidRootPart") then
        if currentAreaId then
            AreaController:TeleportToArea(currentAreaId)
        else
            AreaController:TeleportToArea(Constants.AREA_NAME.Area_1)
        end
    else
        Knit.GetService("AreaService").ResetCharacter:Fire()
    end
end)

function AreaController:GetCurrentAreaPercent(): number
    return 0
end

function AreaController:KnitInit()
    Players.PlayerRemoving:Connect(function(player)
        self._AllPlayersLocation[player.UserId] = nil
    end)

    --  fix: setcore: ResetButtoncal1back has not been registered by the Corescripts
    -- https://devforum.roblox.com/t/resetbuttoncallback-has-not-been-registered-by-the-corescripts/78470/8
    local coreCall do
        local MAX_RETRIES = 8
        function coreCall(method, ...)
            local result = {}
            for retries = 1, MAX_RETRIES do
                result = {pcall(StarterGui[method], StarterGui, ...)}
                if result[1] then
                    break
                end
                RunService.Stepped:Wait()
            end
            return unpack(result)
        end
    end

    coreCall('SetCore', 'ResetButtonCallback', ResetBindable)

    local AreaService = Knit.GetService("AreaService")
    AreaService.ResetAreas:Connect(function()
        task.delay(0, function()
            Knit.GetController("AreaController"):TeleportToArea(Constants.AREA_NAME.Area_1)
        end)
    end)

    -- AreaService.OtherPlayerChangeArea:Connect(function(userId: number, area: string)
    --     self._AllPlayersLocation[tonumber(userId)] = area
    -- end)

end

function AreaController:KnitStart()
    self:Init()
    initNewArea()

    local playerData = PlayerDataController:GetData()   -- just for make sure playerData is loaded
    -- local AreaService = Knit.GetService("AreaService")
    -- AreaService.UpdatePlayerCurrentArea:Fire(currentAreaId)

    self:SetCurrentArea(playerData.PlayerLocation)
     if currentAreaId ~= Constants.AREA_NAME.Area_1 then
        loadNewWorld(currentAreaId)
    end
end

return AreaController
