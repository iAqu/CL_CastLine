-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

require(ReplicatedStorage.Shared.Types.AreaEggs)

local Areas = require(ReplicatedStorage.Data.Areas)
local AssetIconShape = require(ReplicatedStorage.Client.UI.AssetIconShape)
local Assets = require(ReplicatedStorage.Data.Assets)
local EggRecords = require(ReplicatedStorage.Shared.Util.EggRecords)
local EggState = require(ReplicatedStorage.Client.EggState)

require(ReplicatedStorage.Shared.Types.Eggs)

local GuardChasePolicy = require(ReplicatedStorage.Shared.Modules.GuardAreas.GuardChasePolicy)
local GuardEscape = require(ReplicatedStorage.Shared.Utils.GuardEscape)
local GuardEscapePrediction = require(ReplicatedStorage.Shared.Modules.GuardAreas.GuardEscapePrediction)
local Guards = require(ReplicatedStorage.Data.Guards)
local HotbarImagePreloadPolicy = require(ReplicatedStorage.Client.HotbarImagePreloadPolicy)
local ImagePreloader = require(ReplicatedStorage.Client.ImagePreloader)
local Log = require(ReplicatedStorage.Packages.Log)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local Player = require(ReplicatedStorage.Shared.Player)
local SpeedPowerProjection = require(ReplicatedStorage.Client.SpeedPowerProjection)
local Timer = require(ReplicatedStorage.Packages.Timer)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t1 = {
    [10650210095] = true,
    [10737944401] = true
}
local LocalPlayer = Players.LocalPlayer
local v1 = Log.new()
local Areas2 = Workspace:WaitForChild("World"):WaitForChild("Areas")
local GuardAreas = Areas2:WaitForChild("GuardAreas")
local SeparationLine = Areas2:WaitForChild("SeparationLine")

assert(GuardAreas:IsA("Folder"), "Workspace.World.Areas.GuardAreas must be a Folder")
assert(SeparationLine:IsA("BasePart"), "Workspace.World.Areas.SeparationLine must be a BasePart")

local function showDebugNotification(p1) -- line: 73
    -- upvalues: Toast (copy), t1 (copy)
    if t1[game.GameId] then
        Toast.Show({
            Seconds = 1.5,
            Unique = true,
            Text = ("[DEBUG]: %*"):format(p1),
            Color = Color3.fromRGB(100, 200, 255)
        })
    end
end

local function getAreaModel(p2) -- line: 86
    -- upvalues: GuardAreas (copy)
    local v2 = GuardAreas:FindFirstChild(p2)

    return if v2 ~= nil and v2:IsA("Model") then v2 else nil
end

local function getGuardRoot(p3) -- line: 91
    local Guard = p3:FindFirstChild("Guard")

    if Guard == nil or not Guard:IsA("Model") then
        return nil
    end

    local HumanoidRootPart = Guard:FindFirstChild("HumanoidRootPart")

    return if HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") then HumanoidRootPart else nil
end

local function resolveRequiredSpeedPower(p4) -- line: 101
    -- upvalues: Areas (copy), GuardChasePolicy (copy), GuardEscape (copy), GuardEscapePrediction (copy), Guards (copy), v1 (copy), SeparationLine (copy), getGuardRoot (copy)
    local v3 = getGuardRoot(p4)

    if v3 ~= nil then
        local function v4() -- line: 107
            -- upvalues: p4 (copy), v3 (copy), Areas (copy), GuardChasePolicy (copy), GuardEscape (copy), GuardEscapePrediction (copy), Guards (copy), SeparationLine (copy)
            local v5 = Areas.Directory[p4.Name]
            local v6 = Guards.Directory[v5.GuardId]
            local Bounds = p4:FindFirstChild("Bounds")
            local ClosestExitPoint = p4:FindFirstChild("ClosestExitPoint")

            assert(Bounds ~= nil and Bounds:IsA("BasePart"), (("%*.Bounds must be a BasePart"):format((p4:GetFullName()))))
            assert(ClosestExitPoint ~= nil and ClosestExitPoint:IsA("BasePart"), (("%*.ClosestExitPoint must be a BasePart"):format((p4:GetFullName()))))

            local v11 = -SeparationLine.CFrame.LookVector

            return GuardEscape.RequiredSpeedPower({
                BaseGuardWalkSpeed = v6.WalkSpeed,
                ExitDirection = v11,
                ExitDistance = GuardEscapePrediction.ResolveExitDistance(Bounds.CFrame, Bounds.Size, ClosestExitPoint.Position, v11),
                FlatRadius = v6.FlatRadius,
                GuardStartPosition = v3.Position,
                HitDistance = GuardChasePolicy.ResolveHitDistance(v6.HitDistance),
                PlayerStartPosition = ClosestExitPoint.Position
            })
        end

        local ok, result = pcall(v4)

        if ok then
            return result
        end

        v1:AtWarning():Log((("Unable to resolve guard escape requirement for %*: %*"):format(p4.Name, result)))
    end

    return nil
end

local function cacheRequiredSpeedPower(p5, p6) -- line: 144
    -- upvalues: resolveRequiredSpeedPower (copy)
    local v12 = resolveRequiredSpeedPower(p6)

    if v12 ~= nil then
        p5.RequiredSpeedPowerByAreaId[p6.Name] = v12
    end
end

local function getRequiredSpeedPower(p7, p8) -- line: 151
    -- upvalues: GuardAreas (copy), resolveRequiredSpeedPower (copy)
    local v13 = p7.RequiredSpeedPowerByAreaId[p8]

    if v13 ~= nil then
        return v13
    end

    local v14 = GuardAreas:FindFirstChild(p8)

    if v14 == nil or not v14:IsA("Model") then
        v14 = nil
    end

    if v14 == nil then
        return nil
    end

    local v15 = resolveRequiredSpeedPower(v14)

    if v15 ~= nil then
        p7.RequiredSpeedPowerByAreaId[v14.Name] = v15
    end

    return p7.RequiredSpeedPowerByAreaId[p8]
end

local function getDistanceToClaimLine() -- line: 165
    -- upvalues: HotbarImagePreloadPolicy (copy), Player (copy), LocalPlayer (copy), SeparationLine (copy)
    local v16 = Player.FindRootPart(LocalPlayer)

    if v16 == nil or not v16:IsA("BasePart") then
        return nil
    end

    return HotbarImagePreloadPolicy.GetShortestDistanceToClaimLine(SeparationLine, v16.Position)
end

local function requestEggIcon(p9) -- line: 173
    -- upvalues: Assets (copy), ImagePreloader (copy), showDebugNotification (copy)
    local v17 = Assets.Directory[p9]

    if ImagePreloader.Request(v17.Egg.Icon) then
        showDebugNotification((("Preloading image for %* egg"):format(v17.DisplayName)))
    end
end

local function requestPetIcons(p10) -- line: 180
    -- upvalues: AssetIconShape (copy), Assets (copy), EggRecords (copy), ImagePreloader (copy), showDebugNotification (copy)
    local v18 = EggRecords.ToAssetItemData(p10)
    local v19 = AssetIconShape.ResolveImages(v18)
    local t2 = {
        v19.Icon
    }

    if v19.RainbowOverlay ~= nil then
        t2[#t2 + 1] = v19.RainbowOverlay
    end

    if ImagePreloader.RequestAll(t2) > 0 then
        showDebugNotification((("Preloading image for %* pet"):format(Assets.Directory[p10.AssetCategory].DisplayName)))
    end
end

local function scanReadyEggs(p11) -- line: 193
    -- upvalues: EggState (copy), LocalPlayer (copy), requestPetIcons (copy)
    if p11.Destroyed then
        return
    end

    local v21 = EggState.ReadOwnerEggs(LocalPlayer.UserId)

    for v22, v23 in v21 do
        if not p11.ReadyPreloadedByUid[v22] and v23.Placement ~= nil and EggState.IsReadyToHatch(v22) then
            p11.ReadyPreloadedByUid[v22] = true
            requestPetIcons(v23)
        end
    end

    for v24 in p11.ReadyPreloadedByUid do
        if v21[v24] == nil then
            p11.ReadyPreloadedByUid[v24] = nil
        end
    end
end

local function handleCarryState(p12, p13) -- line: 219
    -- upvalues: Assets (copy), HotbarImagePreloadPolicy (copy), ImagePreloader (copy), Player (copy), SpeedPowerProjection (copy), Timer (copy), LocalPlayer (copy), GuardAreas (copy), SeparationLine (copy), showDebugNotification (copy), resolveRequiredSpeedPower (copy)
    p12.CarryGeneration += 1
    p12.CarryTrove:Clean()

    local CarryGeneration, AssetCategory, v25

    if not p13.IsCarrying or p13.AreaId == nil or p13.AssetCategory == nil then
        return
    else
        CarryGeneration = p12.CarryGeneration

        local AreaId = p13.AreaId

        AssetCategory = p13.AssetCategory
        v25 = p12.RequiredSpeedPowerByAreaId[AreaId]

        if v25 == nil then
            local v27 = GuardAreas:FindFirstChild(AreaId)

            if v27 ~= nil then
                if not v27:IsA("Model") or v27 == nil then
                    v25 = nil
                else
                    local v28 = resolveRequiredSpeedPower(v27)

                    if v28 ~= nil then
                        p12.RequiredSpeedPowerByAreaId[v27.Name] = v28
                    end

                    v25 = p12.RequiredSpeedPowerByAreaId[AreaId]
                end
            else
                v25 = nil
            end
        end
    end

    local v29 = SpeedPowerProjection.ReadProjected()
    local v30 = Player.FindRootPart(LocalPlayer)
    local v31 = if v30 == nil or not v30:IsA("BasePart") then nil else HotbarImagePreloadPolicy.GetShortestDistanceToClaimLine(SeparationLine, v30.Position)

    if HotbarImagePreloadPolicy.ShouldPreloadCarriedEgg(v29, v25, v31) then
        local v32 = Assets.Directory[AssetCategory]

        if ImagePreloader.Request(v32.Egg.Icon) then
            showDebugNotification((("Preloading image for %* egg"):format(v32.DisplayName)))
        end
    else
        local CarryTrove = p12.CarryTrove
        local Simple = Timer.Simple
        local CarryGeneration2 = CarryGeneration
        local AssetCategory2 = AssetCategory

        CarryTrove:Add(Simple(0.1, function() -- line: 237
            -- upvalues: p12 (copy), CarryGeneration2 (copy), AssetCategory2 (copy), Assets (copy), HotbarImagePreloadPolicy (copy), ImagePreloader (copy), Player (copy), LocalPlayer (copy), SeparationLine (copy), showDebugNotification (copy)
            local v33, v34

            if p12.Destroyed then
                v34 = true
            elseif p12.CarryGeneration == CarryGeneration2 then
                local v35 = Player.FindRootPart(LocalPlayer)

                if v35 ~= nil and v35:IsA("BasePart") then
                    v33 = HotbarImagePreloadPolicy.GetShortestDistanceToClaimLine(SeparationLine, v35.Position)
                end

                v34 = false
            else
                v34 = true
            end

            if v34 then
                return
            end

            if v33 ~= nil and HotbarImagePreloadPolicy.IsWithinClaimPreloadDistance(v33) then
                local v36 = Assets.Directory[AssetCategory2]

                if ImagePreloader.Request(v36.Egg.Icon) then
                    showDebugNotification((("Preloading image for %* egg"):format(v36.DisplayName)))
                end

                p12.CarryTrove:Clean()
            end
        end))
    end
end

local function Start(p14) -- line: 259
    -- upvalues: EggState (copy), Timer (copy), LocalPlayer (copy), GuardAreas (copy), resolveRequiredSpeedPower (copy), scanReadyEggs (copy), handleCarryState (copy)
    assert(not p14.Started, "HotbarImagePreloadController already started")
    assert(not p14.Destroyed, "HotbarImagePreloadController is destroyed")
    p14.Started = true

    for _, child in GuardAreas:GetChildren() do
        if child:IsA("Model") then
            local v39 = resolveRequiredSpeedPower(child)

            if v39 ~= nil then
                p14.RequiredSpeedPowerByAreaId[child.Name] = v39
            end
        end
    end

    p14.Trove:Connect(GuardAreas.ChildAdded, function(p15) -- line: 270
        -- upvalues: p14 (copy), resolveRequiredSpeedPower (copy)
        if p15:IsA("Model") then
            local v40 = resolveRequiredSpeedPower(p15)

            if v40 ~= nil then
                p14.RequiredSpeedPowerByAreaId[p15.Name] = v40
            end
        end
    end)
    p14.Trove:Connect(GuardAreas.ChildRemoved, function(p16) -- line: 275
        -- upvalues: p14 (copy)
        p14.RequiredSpeedPowerByAreaId[p16.Name] = nil
    end)
    p14.Trove:Add(EggState.CarryChanged:Connect(function(p17) -- line: 278
        -- upvalues: p14 (copy), handleCarryState (copy)
        handleCarryState(p14, p17)
    end))
    p14.Trove:Add(EggState.OwnerRefreshed:Connect(function(p18) -- line: 281
        -- upvalues: p14 (copy), LocalPlayer (copy), scanReadyEggs (copy)
        if p18 == LocalPlayer.UserId then
            scanReadyEggs(p14)
        end
    end))
    p14.Trove:Add(Timer.Simple(0.25, function() -- line: 286
        -- upvalues: p14 (copy), scanReadyEggs (copy)
        scanReadyEggs(p14)
    end))
    scanReadyEggs(p14)
end

local function Destroy(p19) -- line: 292
    if p19.Destroyed then
        return
    end

    p19.Destroyed = true
    p19.CarryGeneration += 1
    p19.Trove:Destroy()
end

local v41 = table.freeze({
    Start = Start,
    Destroy = Destroy
})
local v42 = table.freeze({
    __index = v41
})

local function IsA(p20) -- line: 311
    -- upvalues: v42 (copy)
    if type(p20) == "table" then
        return getmetatable(p20) == v42
    end

    return false
end

local function Assert(p21) -- line: 315
    -- upvalues: v42 (copy)
    assert(type(p21) == "table" and getmetatable(p21) == v42, "Expected HotbarImagePreloadController")

    return p21
end

local t3 = {
    new = function() -- new | line: 322
        -- upvalues: Trove (copy), v42 (copy)
        local v44 = Trove.new()

        return (setmetatable({
            CarryGeneration = 0,
            Destroyed = false,
            Started = false,
            CarryTrove = v44:Extend(),
            ReadyPreloadedByUid = {},
            RequiredSpeedPowerByAreaId = {},
            Trove = v44
        }, v42))
    end,
    IsA = IsA,
    Assert = Assert
}

return table.freeze(t3)
