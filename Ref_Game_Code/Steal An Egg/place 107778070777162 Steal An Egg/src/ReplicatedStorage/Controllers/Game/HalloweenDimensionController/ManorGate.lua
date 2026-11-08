-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local HalloweenDimensionFlags = require(ReplicatedStorage.Shared.Flags.HalloweenDimensionFlags)
local HalloweenManor = require(ReplicatedStorage.Data.HalloweenManor)
local Log = require(ReplicatedStorage.Packages.Log)
local ManorInterior = require(ReplicatedStorage.Shared.Util.ManorInterior)
local PumpkinBossFlags = require(ReplicatedStorage.Shared.Flags.PumpkinBossFlags)
local Shake = require(ReplicatedStorage.Client.Shake)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t1 = {
    DoorLeft = 1.5707963267948966,
    DoorRight = -1.5707963267948966
}
local v1 = TweenInfo.new(1.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0.15)
local v2 = TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local Sounds = ManorInterior.Sounds
local v3 = Color3.fromRGB(122, 108, 96)
local v4 = Log.new()
local t2 = {}
local t3 = {}
local v5 = false
local v6 = false
local v7
local t4 = {}

local function isOpen() -- line: 61
    -- upvalues: ManorInterior (copy), PumpkinBossFlags (copy)
    return PumpkinBossFlags.ContentEnabled:Get() and ManorInterior.GateOpen()
end

local function base(p1) -- line: 65
    local BoundingBox, BoundingBox2 = p1:GetBoundingBox()

    return BoundingBox.Position - Vector3.new(0, BoundingBox2.Y / 2 - 1, 0)
end

local function dust(p2) -- line: 70
    -- upvalues: Workspace (copy), v3 (copy)
    local BoundingBox, BoundingBox2 = p2:GetBoundingBox()
    local Part = Instance.new("Part")

    Part.Name = "ManorGateDust"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(BoundingBox2.X, 1, BoundingBox2.Z)

    local new = CFrame.new
    local BoundingBox3, BoundingBox4 = p2:GetBoundingBox()

    Part.CFrame = new(BoundingBox3.Position - Vector3.new(0, BoundingBox4.Y / 2 - 1, 0)) * BoundingBox.Rotation

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Texture = "rbxasset://textures/particles/smoke_main.dds"
    ParticleEmitter.Color = ColorSequence.new(v3)
    ParticleEmitter.LightEmission = 0
    ParticleEmitter.LightInfluence = 1
    ParticleEmitter.Lifetime = NumberRange.new(1.44, 2.4)
    ParticleEmitter.Speed = NumberRange.new(6, 16)
    ParticleEmitter.SpreadAngle = Vector2.new(80, 20)
    ParticleEmitter.Acceleration = Vector3.new(0, 2, 0)
    ParticleEmitter.Drag = 2.5
    ParticleEmitter.Rotation = NumberRange.new(0, 360)
    ParticleEmitter.RotSpeed = NumberRange.new(-40, 40)
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 3),
        NumberSequenceKeypoint.new(1, 11)
    })
    ParticleEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.15, 0.55),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter.EmissionDirection = Enum.NormalId.Top
    ParticleEmitter.Enabled = false
    ParticleEmitter.Parent = Part
    Part.Parent = Workspace
    ParticleEmitter:Emit(60)
    task.delay(2.9, function() -- line: 107
        -- upvalues: Part (copy)
        Part:Destroy()
    end)
end

local function feedback(p3, p4) -- line: 112
    -- upvalues: Audio (copy), Shake (copy), v2 (copy), Sounds (copy), dust (copy)
    local BoundingBox, BoundingBox2 = p3:GetBoundingBox()
    local v11 = BoundingBox.Position - Vector3.new(0, BoundingBox2.Y / 2 - 1, 0)

    Audio.Play(Sounds.GateClank, v11, {
        Volume = 1.1,
        MaxDistance = 260
    })

    if p4 then
        Audio.Play(Sounds.Creak, v11, {
            Volume = 0.9,
            PlaybackSpeed = 0.7,
            MaxDistance = 260
        })
        dust(p3)
        Shake.Play({
            Seconds = 1.4,
            Magnitude = 0.7,
            Shape = "Pulse",
            Range = {
                Near = 45,
                Far = 120,
                Center = v11
            }
        })

        return
    end

    task.delay(v2.Time, function() -- line: 129
        -- upvalues: p3 (copy), Audio (copy), Shake (copy), Sounds (copy)
        if p3.Parent == nil then
            return
        end

        local Play = Audio.Play
        local GateClank = Sounds.GateClank
        local BoundingBox, BoundingBox2 = p3:GetBoundingBox()

        Play(GateClank, BoundingBox.Position - Vector3.new(0, BoundingBox2.Y / 2 - 1, 0), {
            Volume = 1.2,
            MaxDistance = 260
        })

        local Play2 = Shake.Play
        local t5 = {
            Seconds = 0.5,
            Magnitude = 0.5
        }
        local t6 = {
            Near = 45,
            Far = 120
        }
        local BoundingBox3, BoundingBox4 = p3:GetBoundingBox()

        t6.Center = BoundingBox3.Position - Vector3.new(0, BoundingBox4.Y / 2 - 1, 0)
        t5.Range = t6
        Play2(t5)
    end)
end

local function track(p5) -- line: 146
    -- upvalues: Trove (copy), t1 (copy), v4 (copy), t2 (copy)
    local v14 = t2[p5]

    if v14 ~= nil then
        return v14
    end

    local v15 = Trove.new()
    local v16 = v15:Add(Instance.new("NumberValue"))
    local t7 = {
        Open = false,
        Tween = nil,
        Trove = v15,
        Alpha = v16,
        Center = p5:GetBoundingBox().Position
    }

    t2[p5] = t7

    for v17, v18 in t1 do
        local v19 = p5:FindFirstChild(v17)

        if v19 ~= nil then
            if v19:IsA("Model") then
                local Pivot = v19:GetPivot()

                v15:Connect(v16.Changed, function(p6) -- line: 163
                    -- upvalues: v19 (copy), Pivot (copy), v18 (copy)
                    v19:PivotTo(CFrame.new(Pivot.Position) * CFrame.Angles(0, v18 * p6, 0) * Pivot.Rotation)
                end)
                v15:Add(function() -- line: 168
                    -- upvalues: v19 (copy), Pivot (copy)
                    if v19.Parent ~= nil then
                        v19:PivotTo(Pivot)
                    end
                end)
            else
                v4:AtWarning():Log((("%* is missing %*; skipping its swing"):format(p5:GetFullName(), v17)))
            end
        else
            v4:AtWarning():Log((("%* is missing %*; skipping its swing"):format(p5:GetFullName(), v17)))
        end
    end

    return t7
end

local function setOpen(p7, p8, p9) -- line: 177
    -- upvalues: TweenService (copy), v1 (copy), v2 (copy), feedback (copy), track (copy)
    local v20 = track(p7)

    if v20.Open == p8 then
        return
    end

    v20.Open = p8

    local Tween = v20.Tween

    if Tween ~= nil then
        Tween:Cancel()
        v20.Tween = nil
    end

    local v21 = if p8 then 1 else 0

    if not p9 then
        v20.Alpha.Value = v21

        return
    end

    local tween = TweenService:Create(v20.Alpha, if p8 then v1 else v2, {
        Value = v21
    })

    v20.Tween = tween
    tween:Play()
    feedback(p7, p8)
end

local function forget(p10) -- line: 200
    -- upvalues: t2 (copy)
    local v23 = t2[p10]

    if v23 == nil then
        return
    end

    t2[p10] = nil

    if v23.Tween ~= nil then
        v23.Tween:Cancel()
    end

    v23.Trove:Destroy()
end

local function shown(p11) -- line: 212
    -- upvalues: t2 (copy)
    local v24 = t2[p11]

    return v24 ~= nil and v24.Open
end

local function applyBlocker(p12, p13) -- line: 217
    -- upvalues: t2 (copy)
    if p13.Name ~= "Blocker" or not p13:IsA("BasePart") then
        return
    end

    local v25 = t2[p12]

    p13.CanCollide = not (v25 ~= nil and v25.Open)
end

local function watchBlocker(p14) -- line: 223
    -- upvalues: Trove (copy), t2 (copy), t3 (copy)
    if t3[p14] ~= nil then
        return
    end

    local v26 = Trove.new()

    t3[p14] = v26

    local function watch(p15) -- line: 229
        -- upvalues: p14 (copy), v26 (copy), t2 (copy)
        if p15.Name ~= "Blocker" or not p15:IsA("BasePart") then
            return
        end

        if p15.Name == "Blocker" and p15:IsA("BasePart") then
            local v27 = t2[p14]

            p15.CanCollide = not (v27 ~= nil and v27.Open)
        end

        v26:Connect(p15:GetPropertyChangedSignal("CanCollide"), function() -- line: 234
            -- upvalues: p15 (copy), p14 (copy), t2 (copy)
            if p15.Name ~= "Blocker" or not p15:IsA("BasePart") then
                return
            end

            local v29 = t2[p14]

            p15.CanCollide = not (v29 ~= nil and v29.Open)
        end)
    end

    v26:Connect(p14.ChildAdded, watch)

    for _, child in p14:GetChildren() do
        watch(child)
    end
end

local function unwatch(p16) -- line: 244
    -- upvalues: t2 (copy), t3 (copy)
    local v31 = t2[p16]

    if v31 ~= nil then
        t2[p16] = nil

        if v31.Tween ~= nil then
            v31.Tween:Cancel()
        end

        v31.Trove:Destroy()
    end

    local v32 = t3[p16]

    if v32 ~= nil then
        t3[p16] = nil
        v32:Destroy()
    end
end

local function sync(p17) -- line: 254
    -- upvalues: CollectionService (copy), Workspace (copy), HalloweenManor (copy), ManorInterior (copy), PumpkinBossFlags (copy), t2 (copy), v6 (ref), setOpen (copy), watchBlocker (copy)
    local Gate = HalloweenManor.Tags.Gate

    if Gate == nil then
        return
    end

    if not (PumpkinBossFlags.ContentEnabled:Get() and ManorInterior.GateOpen()) then
        v6 = false
    end

    local v33 = PumpkinBossFlags.ContentEnabled:Get() and ManorInterior.GateOpen() and v6

    for _, v34 in CollectionService:GetTagged(Gate) do
        if v34:IsA("Model") and v34:IsDescendantOf(Workspace) then
            watchBlocker(v34)
            setOpen(v34, v33, p17)

            local Blocker = v34:FindFirstChild("Blocker")

            if Blocker ~= nil and Blocker.Name == "Blocker" and Blocker:IsA("BasePart") then
                local v35 = t2[v34]

                Blocker.CanCollide = not (v35 ~= nil and v35.Open)
            end
        end
    end
end

local function near() -- line: 277
    -- upvalues: Players (copy), t2 (copy)
    local Character = Players.LocalPlayer.Character
    local HumanoidRootPart = if Character == nil then nil else Character:FindFirstChild("HumanoidRootPart")

    if HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") then
        local Position = HumanoidRootPart.Position

        for v36, v37 in t2 do
            if v36.Parent ~= nil then
                local v38 = Position - v37.Center

                if Vector2.new(v38.X, v38.Z).Magnitude <= 140 then
                    return true
                end
            end
        end
    end

    return false
end

local function reveal() -- line: 296
    -- upvalues: ManorInterior (copy), PumpkinBossFlags (copy), v6 (ref), sync (copy), near (copy)
    if not v6 and PumpkinBossFlags.ContentEnabled:Get() and ManorInterior.GateOpen() and near() then
        v6 = true
        sync(true)
    end
end

local function watchApproach() -- line: 304
    -- upvalues: ManorInterior (copy), PumpkinBossFlags (copy), v6 (ref), v7 (ref), sync (copy), near (copy)
    if v7 == nil and not v6 then
        local v39 = PumpkinBossFlags.ContentEnabled:Get() and ManorInterior.GateOpen()

        if v39 then
            v7 = task.spawn(function() -- line: 308
                -- upvalues: ManorInterior (copy), PumpkinBossFlags (copy), v6 (ref), v7 (ref), sync (copy), near (copy)
                while not v6 and PumpkinBossFlags.ContentEnabled:Get() and ManorInterior.GateOpen() do
                    if not v6 and PumpkinBossFlags.ContentEnabled:Get() and ManorInterior.GateOpen() and near() then
                        v6 = true
                        sync(true)
                    end

                    task.wait(0.2)
                end

                v7 = nil
            end)
        end
    end
end

function t4.Start(p18) -- line: 321
    -- upvalues: CollectionService (copy), HalloweenDimensionFlags (copy), HalloweenManor (copy), ManorInterior (copy), PumpkinBossFlags (copy), v4 (copy), t2 (copy), t3 (copy), v5 (ref), v6 (ref), v7 (ref), unwatch (copy), sync (copy), near (copy)
    if PumpkinBossFlags.ContentEnabled:Get() then
        local Gate = HalloweenManor.Tags.Gate

        if Gate ~= nil then
            v5 = HalloweenDimensionFlags.ManorGateOpen:IsSynced()
            p18:Connect(CollectionService:GetInstanceAddedSignal(Gate), function() -- line: 332
                -- upvalues: ManorInterior (copy), PumpkinBossFlags (copy), v6 (ref), v7 (ref), sync (copy), near (copy)
                sync(false)

                if v7 == nil and not v6 then
                    local v40 = PumpkinBossFlags.ContentEnabled:Get() and ManorInterior.GateOpen()

                    if not v40 then
                        return
                    end

                    v7 = task.spawn(function() -- line: 308
                        -- upvalues: ManorInterior (copy), PumpkinBossFlags (copy), v6 (ref), v7 (ref), sync (copy), near (copy)
                        while not v6 and PumpkinBossFlags.ContentEnabled:Get() and ManorInterior.GateOpen() do
                            if not v6 and PumpkinBossFlags.ContentEnabled:Get() and ManorInterior.GateOpen() and near() then
                                v6 = true
                                sync(true)
                            end

                            task.wait(0.2)
                        end

                        v7 = nil
                    end)
                end
            end)
            p18:Connect(CollectionService:GetInstanceRemovedSignal(Gate), unwatch)
            p18:Connect(HalloweenDimensionFlags.ManorGateOpen.Changed, function() -- line: 337
                -- upvalues: ManorInterior (copy), PumpkinBossFlags (copy), v5 (ref), v6 (ref), v7 (ref), sync (copy), near (copy)
                local v41 = v5

                v5 = true
                sync(v41)

                if v7 == nil and not v6 then
                    local v42 = PumpkinBossFlags.ContentEnabled:Get() and ManorInterior.GateOpen()

                    if not v42 then
                        return
                    end

                    v7 = task.spawn(function() -- line: 308
                        -- upvalues: ManorInterior (copy), PumpkinBossFlags (copy), v6 (ref), v7 (ref), sync (copy), near (copy)
                        while not v6 and PumpkinBossFlags.ContentEnabled:Get() and ManorInterior.GateOpen() do
                            if not v6 and PumpkinBossFlags.ContentEnabled:Get() and ManorInterior.GateOpen() and near() then
                                v6 = true
                                sync(true)
                            end

                            task.wait(0.2)
                        end

                        v7 = nil
                    end)
                end
            end)
            p18:Add(function() -- line: 343
                -- upvalues: t2 (copy), t3 (copy), v7 (ref)
                local v43 = v7

                if v43 ~= nil then
                    v7 = nil
                    task.cancel(v43)
                end

                for v44 in t2 do
                    local v45 = t2[v44]

                    if v45 ~= nil then
                        t2[v44] = nil

                        if v45.Tween ~= nil then
                            v45.Tween:Cancel()
                        end

                        v45.Trove:Destroy()
                    end
                end

                for v46 in t3 do
                    local v47 = t2[v46]

                    if v47 ~= nil then
                        t2[v46] = nil

                        if v47.Tween ~= nil then
                            v47.Tween:Cancel()
                        end

                        v47.Trove:Destroy()
                    end

                    local v48 = t3[v46]

                    if v48 ~= nil then
                        t3[v46] = nil
                        v48:Destroy()
                    end
                end
            end)
            sync(false)

            if v7 == nil and not v6 then
                local v49 = PumpkinBossFlags.ContentEnabled:Get() and ManorInterior.GateOpen()

                if not v49 then
                    return
                end

                v7 = task.spawn(function() -- line: 308
                    -- upvalues: ManorInterior (copy), PumpkinBossFlags (copy), v6 (ref), v7 (ref), sync (copy), near (copy)
                    while not v6 and PumpkinBossFlags.ContentEnabled:Get() and ManorInterior.GateOpen() do
                        if not v6 and PumpkinBossFlags.ContentEnabled:Get() and ManorInterior.GateOpen() and near() then
                            v6 = true
                            sync(true)
                        end

                        task.wait(0.2)
                    end

                    v7 = nil
                end)
            end
        else
            v4:AtWarning():Log("HalloweenManor.Tags.Gate is missing; the manor gate won't swing open")
        end
    end
end

return table.freeze(t4)
