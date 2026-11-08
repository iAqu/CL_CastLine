-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local AreaEggResetCycle = require(ReplicatedStorage.Data.AreaEggResetCycle)
local AreaEggResetCycleController = require(ReplicatedStorage.Controllers.Game.AreaReset.AreaEggResetCycleController)
local AreaEggResetWall = require(ReplicatedStorage.Client.AreaEggResetWall)
local HalloweenDimension = require(ReplicatedStorage.Shared.Util.HalloweenDimension)
local LightingController = require(ReplicatedStorage.Controllers.Game.LightingController)

require(ReplicatedStorage.Packages.Trove)

local WallTimer = require(script.Parent.WallTimer)
local LocalPlayer = Players.LocalPlayer
local PlayerAttributes = HalloweenDimension.PlayerAttributes
local v1 = TweenInfo.new(1, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
local v2 = TweenInfo.new(AreaEggResetWall.CollapseSeconds, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local t1 = {}

local function isNight(p1) -- line: 49
    if p1 == "Night" then
        return true
    end

    return p1 == "NightTransition"
end

local function bindSky(p2) -- line: 53
    -- upvalues: AreaEggResetCycle (copy), AreaEggResetCycleController (copy), LightingController (copy), LocalPlayer (copy), PlayerAttributes (copy)
    local v3 = AreaEggResetCycleController.GetPhase()

    local function sync(p3) -- line: 56
        -- upvalues: v3 (ref), AreaEggResetCycle (copy), LightingController (copy), LocalPlayer (copy), PlayerAttributes (copy)
        if LocalPlayer:GetAttribute(PlayerAttributes.Inside) == true then
            local v4 = v3

            if v4 == "Night" or v4 == "NightTransition" then
                LightingController.SetLayer("HalloweenDimensionNight", AreaEggResetCycle.NightLighting, 155, p3)

                return
            end
        end

        LightingController.ClearLayer("HalloweenDimensionNight", p3)
    end

    p2:Connect(AreaEggResetCycleController.PhaseChanged, function(p4, p5) -- line: 72
        -- upvalues: v3 (ref), AreaEggResetCycle (copy), LightingController (copy), LocalPlayer (copy), PlayerAttributes (copy)
        v3 = p4

        if LocalPlayer:GetAttribute(PlayerAttributes.Inside) == true then
            local v5 = v3

            if v5 == "Night" or v5 == "NightTransition" then
                LightingController.SetLayer("HalloweenDimensionNight", AreaEggResetCycle.NightLighting, 155, p5)

                return
            end
        end

        LightingController.ClearLayer("HalloweenDimensionNight", p5)
    end)
    p2:Connect(LocalPlayer:GetAttributeChangedSignal(PlayerAttributes.Inside), function() -- line: 77
        -- upvalues: v3 (ref), AreaEggResetCycle (copy), LightingController (copy), LocalPlayer (copy), PlayerAttributes (copy)
        if LocalPlayer:GetAttribute(PlayerAttributes.Inside) == true then
            local v6 = v3

            if v6 == "Night" or v6 == "NightTransition" then
                LightingController.SetLayer("HalloweenDimensionNight", AreaEggResetCycle.NightLighting, 155, 0.8)

                return
            end
        end

        LightingController.ClearLayer("HalloweenDimensionNight", 0.8)
    end)
    p2:Add(function() -- line: 80
        -- upvalues: LightingController (copy)
        LightingController.ClearLayer("HalloweenDimensionNight", 0)
    end)

    local v7 = false

    if LocalPlayer:GetAttribute(PlayerAttributes.Inside) == true then
        local v8 = v3

        v7 = v8 == "Night" or v8 == "NightTransition"
    end

    if v7 then
        LightingController.SetLayer("HalloweenDimensionNight", AreaEggResetCycle.NightLighting, 155, 0)
    else
        LightingController.ClearLayer("HalloweenDimensionNight", 0)
    end
end

local function bindWall(p6, p7) -- line: 86
    -- upvalues: RunService (copy), TweenService (copy), Workspace (copy), AreaEggResetWall (copy), WallTimer (copy), LocalPlayer (copy), v1 (copy), v2 (copy)
    local t2 = {}
    local t3 = {}
    local v9 = false
    local v10 = p7:Add(Instance.new("NumberValue"))
    local v11 = p7:Extend()
    local v12 = OverlapParams.new()

    v12.FilterType = Enum.RaycastFilterType.Include

    local function hiddenModifier() -- line: 96
        -- upvalues: v10 (copy)
        if v10.Value > 0 then
            return 0
        end

        return 1
    end

    local function applyCurtain(p8) -- line: 100
        -- upvalues: v10 (copy)
        local v14 = math.clamp(p8.Height * v10.Value, 0, p8.Height)

        p8.Part.Size = p8.Footprint + Vector3.new(0, 1, 0) * v14
        p8.Part.CFrame = p8.Floor * CFrame.new(0, v14 * 0.5, 0)
        p8.Part.LocalTransparencyModifier = v10.Value > 0 and 0 or 1
    end

    local function apply() -- line: 107
        -- upvalues: t2 (copy), t3 (copy), v10 (copy), applyCurtain (copy)
        for _, v15 in t2 do
            applyCurtain(v15)
        end

        local v16 = if v10.Value > 0 then 0 else 1

        for v17 in t3 do
            v17.LocalTransparencyModifier = v16
        end
    end

    local function setSolid(p9) -- line: 117
        -- upvalues: t3 (copy), v9 (ref)
        v9 = p9

        for v18 in t3 do
            v18.CanCollide = p9
        end
    end

    local function characterInside() -- line: 124
        -- upvalues: t3 (copy), v12 (copy), Workspace (copy), LocalPlayer (copy)
        local Character = LocalPlayer.Character

        if Character ~= nil then
            v12.FilterDescendantsInstances = { Character }

            for v19 in t3 do
                local v20 = v19.Size + Vector3.new(1, 1, 1)

                if #Workspace:GetPartBoundsInBox(v19.CFrame, v20, v12) > 0 then
                    return true
                end
            end
        end

        return false
    end

    local function solidifyWhenClear() -- line: 139
        -- upvalues: t3 (copy), v9 (ref), v11 (copy), characterInside (copy), RunService (copy)
        if characterInside() then
            local connection

            connection = v11:Connect(RunService.Heartbeat, function() -- line: 145
                -- upvalues: connection (ref), t3 (copy), v9 (ref), characterInside (copy)
                if characterInside() then
                    return
                end

                connection:Disconnect()
                v9 = true

                for v21 in t3 do
                    v21.CanCollide = true
                end
            end)
        else
            v9 = true

            for v22 in t3 do
                v22.CanCollide = true
            end
        end
    end

    local function sweep(p10, p11) -- line: 154
        -- upvalues: v10 (copy), v11 (copy), TweenService (copy)
        v11:Add(TweenService:Create(v10, p10, {
            Value = p11
        }), "Cancel"):Play()
    end

    local function seal(p12) -- line: 159
        -- upvalues: t3 (copy), v9 (ref), v10 (copy), v11 (copy), characterInside (copy), RunService (copy), TweenService (copy), v1 (copy)
        v11:Clean()
        v9 = false

        for v23 in t3 do
            v23.CanCollide = false
        end

        if characterInside() then
            local connection

            connection = v11:Connect(RunService.Heartbeat, function() -- line: 145
                -- upvalues: connection (ref), t3 (copy), v9 (ref), characterInside (copy)
                if characterInside() then
                    return
                end

                connection:Disconnect()
                v9 = true

                for v24 in t3 do
                    v24.CanCollide = true
                end
            end)
        else
            v9 = true

            for v25 in t3 do
                v25.CanCollide = true
            end
        end

        if p12 then
            v10.Value = 0
            v11:Add(TweenService:Create(v10, v1, {
                Value = 1
            }), "Cancel"):Play()
        else
            v10.Value = 1
        end
    end

    local function open(p13) -- line: 171
        -- upvalues: t3 (copy), v9 (ref), v10 (copy), v11 (copy), TweenService (copy), v2 (copy)
        v11:Clean()
        v9 = false

        for v26 in t3 do
            v26.CanCollide = false
        end

        if p13 then
            v11:Add(TweenService:Create(v10, v2, {
                Value = 0
            }), "Cancel"):Play()
        else
            v10.Value = 0
        end
    end

    local function isWallPart(p14) -- line: 181
        -- upvalues: p6 (copy)
        local Parent = p14.Parent

        return p14:IsA("BasePart") and Parent ~= nil and Parent.Name == "NightWall" and Parent.Parent == p6
    end

    local function track(p15) -- line: 189
        -- upvalues: p6 (copy), t2 (copy), t3 (copy), v9 (ref), v10 (copy), applyCurtain (copy)
        local Parent = p15.Parent
        local BasePart = p15:IsA("BasePart") and Parent ~= nil and Parent.Name == "NightWall" and Parent.Parent == p6

        if BasePart then
            if p15.Name ~= "Curtain" or t2[p15] ~= nil then
                if p15.Name == "Barrier" and t3[p15] == nil then
                    t3[p15] = true
                    p15.CanCollide = v9
                    p15.LocalTransparencyModifier = v10.Value > 0 and 0 or 1
                end
            else
                local Y = p15.Size.Y
                local t4 = {
                    Part = p15,
                    Footprint = p15.Size * Vector3.new(1, 0, 1),
                    Height = Y,
                    Floor = p15.CFrame * CFrame.new(0, -Y * 0.5, 0)
                }

                t2[p15] = t4
                applyCurtain(t4)
            end
        end
    end

    local function untrack(p16) -- line: 211
        -- upvalues: t2 (copy), t3 (copy)
        if p16:IsA("BasePart") then
            t2[p16] = nil
            t3[p16] = nil
        end
    end

    local function timerCurtain() -- line: 218
        -- upvalues: t2 (copy)
        local v27

        for _, v28 in t2 do
            if v27 == nil or v28.Footprint.X > v27.Footprint.X then
                v27 = v28
            end
        end

        return if v27 ~= nil then v27.Part else nil
    end

    for _, descendant in p6:GetDescendants() do
        track(descendant)
    end

    p7:Connect(p6.DescendantAdded, track)
    p7:Connect(p6.DescendantRemoving, untrack)
    p7:Connect(v10.Changed, apply)
    p7:Connect(AreaEggResetWall.Changed, function(p17) -- line: 235
        -- upvalues: t3 (copy), v9 (ref), v10 (copy), v11 (copy), characterInside (copy), RunService (copy), TweenService (copy), v1 (copy), v2 (copy)
        v11:Clean()
        v9 = false

        if p17 then
            for v29 in t3 do
                v29.CanCollide = false
            end

            if characterInside() then
                local connection

                connection = v11:Connect(RunService.Heartbeat, function() -- line: 145
                    -- upvalues: connection (ref), t3 (copy), v9 (ref), characterInside (copy)
                    if characterInside() then
                        return
                    end

                    connection:Disconnect()
                    v9 = true

                    for v30 in t3 do
                        v30.CanCollide = true
                    end
                end)
            else
                v9 = true

                for v31 in t3 do
                    v31.CanCollide = true
                end
            end

            v10.Value = 0
            v11:Add(TweenService:Create(v10, v1, {
                Value = 1
            }), "Cancel"):Play()
        else
            for v32 in t3 do
                v32.CanCollide = false
            end

            v11:Add(TweenService:Create(v10, v2, {
                Value = 0
            }), "Cancel"):Play()
        end
    end)
    p7:Add(function() -- line: 242
        -- upvalues: t3 (copy), v9 (ref)
        v9 = false

        for v33 in t3 do
            v33.CanCollide = false
        end
    end)

    if AreaEggResetWall.IsSealed() then
        v11:Clean()
        v9 = false

        for v34 in t3 do
            v34.CanCollide = false
        end

        if characterInside() then
            local connection

            connection = v11:Connect(RunService.Heartbeat, function() -- line: 145
                -- upvalues: t3 (copy), v9 (ref), characterInside (copy), connection (ref)
                if characterInside() then
                    return
                end

                connection:Disconnect()
                v9 = true

                for v35 in t3 do
                    v35.CanCollide = true
                end
            end)
        else
            v9 = true

            for v36 in t3 do
                v36.CanCollide = true
            end
        end

        v10.Value = 1
    else
        v11:Clean()
        v9 = false

        for v37 in t3 do
            v37.CanCollide = false
        end

        v10.Value = 0
    end

    for _, v38 in t2 do
        applyCurtain(v38)
    end

    local v39 = if v10.Value > 0 then 0 else 1

    for v40 in t3 do
        v40.LocalTransparencyModifier = v39
    end

    WallTimer.Bind(p7, timerCurtain)
end

local function bindMaps(p18) -- line: 256
    -- upvalues: Workspace (copy), HalloweenDimension (copy), bindWall (copy)
    local v41, v42

    local function unbind() -- line: 260
        -- upvalues: p18 (copy), v41 (ref), v42 (ref)
        local v43 = v41

        v41 = nil
        v42 = nil

        if v43 ~= nil then
            p18:Remove(v43)
        end
    end

    local function bind(p19) -- line: 269
        -- upvalues: p18 (copy), v41 (ref), v42 (ref), bindWall (copy)
        local v44 = v41

        v41 = nil
        v42 = nil

        if v44 ~= nil then
            p18:Remove(v44)
        end

        local v45 = p18:Extend()

        v41 = v45
        v42 = p19
        bindWall(p19, v45)
    end

    p18:Connect(Workspace.ChildAdded, function(p20) -- line: 277
        -- upvalues: p18 (copy), v41 (ref), v42 (ref), HalloweenDimension (copy), bindWall (copy)
        if p20.Name ~= HalloweenDimension.MapName or not p20:IsA("Model") then
            return
        end

        local v46 = v41

        v41 = nil
        v42 = nil

        if v46 ~= nil then
            p18:Remove(v46)
        end

        local v47 = p18:Extend()

        v41 = v47
        v42 = p20
        bindWall(p20, v47)
    end)
    p18:Connect(Workspace.ChildRemoved, function(p21) -- line: 282
        -- upvalues: p18 (copy), v41 (ref), v42 (ref)
        if p21 ~= v42 then
            return
        end

        local v48 = v41

        v41 = nil
        v42 = nil

        if v48 ~= nil then
            p18:Remove(v48)
        end
    end)

    local v49 = Workspace:FindFirstChild(HalloweenDimension.MapName)
    local v50 = true

    if v49 ~= nil then
        if v49:IsA("Model") then
            local v51 = v41

            v41 = nil
            v42 = nil

            if v51 ~= nil then
                p18:Remove(v51)
            end

            v50 = false
        end
    end

    if v50 then
        return
    end

    local v52 = p18:Extend()

    v41 = v52
    v42 = v49
    bindWall(v49, v52)
end

function t1.Start(p22) -- line: 298
    -- upvalues: bindSky (copy), bindMaps (copy)
    bindSky(p22)
    bindMaps(p22)
end

return t1
