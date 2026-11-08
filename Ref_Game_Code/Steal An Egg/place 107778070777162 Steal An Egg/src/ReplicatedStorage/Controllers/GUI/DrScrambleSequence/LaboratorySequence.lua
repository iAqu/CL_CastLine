-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local EggRecords = require(ReplicatedStorage.Shared.Util.EggRecords)
local Flash = require(ReplicatedStorage.Client.UI.VFX.Flash)
local Shake = require(ReplicatedStorage.Client.Shake)
local VFX = require(ReplicatedStorage.Shared.Utils.VFX)
local RiftTradeIn = ReplicatedStorage.Assets.VFX.RiftTradeIn
local Sounds = ReplicatedStorage.Assets.Sounds
local v1 = Color3.fromRGB(164, 255, 61)
local v2 = Color3.fromRGB(231, 255, 185)
local t1 = {}
local v3 = false

local function machineParts() -- line: 22
    -- upvalues: Workspace (copy)
    local World = Workspace:FindFirstChild("World")
    local Machines = World and World:FindFirstChild("Machines")
    local RiftMachine = Machines and Machines:FindFirstChild("RiftMachine")
    local Rift = RiftMachine and RiftMachine:FindFirstChild("Rift")

    if not (Rift and Rift:IsA("Model")) then
        return nil, nil, nil, {}
    end

    local MainScreen = Rift:FindFirstChild("MainScreen")
    local EggSpawn = MainScreen and MainScreen:FindFirstChild("EggSpawn")

    if MainScreen and MainScreen:IsA("BasePart") and EggSpawn and EggSpawn:IsA("Attachment") then
        local t2 = {}

        for i = 1, 3 do
            local v4 = Rift:FindFirstChild("Pad" .. i)
            local v5 = v4 and v4:FindFirstChild("OfferingSpawn", true)

            if not (v5 and v5:IsA("Attachment")) then
                return nil, nil, nil, {}
            end

            table.insert(t2, v5)
        end

        return Rift, MainScreen, EggSpawn, t2
    end

    return nil, nil, nil, {}
end

local function cue(p1, p2, p3) -- line: 47
    -- upvalues: Audio (copy), Sounds (copy)
    local v6 = Sounds:FindFirstChild(p1) or Sounds:FindFirstChild(p1, true)

    if not (v6 and v6:IsA("Sound")) then
        v6 = v6 and v6:FindFirstChildWhichIsA("Sound")
    end

    if v6 then
        Audio.Play(v6, p2, {
            Volume = p3
        })
    end
end

local function freeze(p4) -- line: 55
    for _, descendant in p4:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
        end
    end
end

local function centerAndScale(p5, p6) -- line: 66
    p5.PrimaryPart = nil

    local BoundingBox, BoundingBox2 = p5:GetBoundingBox()

    p5.WorldPivot = BoundingBox

    local v7 = math.max(BoundingBox2.X, BoundingBox2.Y, BoundingBox2.Z)

    p5:ScaleTo(if v7 > 0.01 then math.clamp(p6 / v7, 0.05, 6) else 1)

    local _, BoundingBox3 = p5:GetBoundingBox()

    return BoundingBox3.Y * 0.5
end

local function offeringModel(p7) -- line: 76
    -- upvalues: EggRecords (copy), v1 (copy), freeze (copy)
    local function v10() -- line: 77
        -- upvalues: p7 (copy), EggRecords (copy)
        return EggRecords.EggModelTemplate(p7.AssetCategory, p7.Mutations, p7.BaseMutation, p7.EggSkin)
    end

    local ok, result = pcall(v10)

    if ok and result and result:IsA("Model") then
        local clone = result:Clone()

        freeze(clone)

        return clone
    end

    local Model = Instance.new("Model")
    local Part = Instance.new("Part")

    Part.Shape = Enum.PartType.Ball
    Part.Size = Vector3.new(2, 2, 2)
    Part.Material = Enum.Material.Neon
    Part.Color = v1
    Part.Parent = Model
    freeze(Model)

    return Model
end

local function tintEffects(p8) -- line: 96
    -- upvalues: v1 (copy)
    for _, descendant in p8:GetDescendants() do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") then
            descendant.Color = ColorSequence.new(v1)
        elseif descendant:IsA("Light") or descendant:IsA("BasePart") and descendant.Material == Enum.Material.Neon then
            descendant.Color = v1
        end
    end
end

local function tweenNumber(p9, p10, p11) -- line: 108
    -- upvalues: TweenService (copy)
    local NumberValue = Instance.new("NumberValue")

    NumberValue.Value = 0

    local connection = NumberValue.Changed:Connect(p11)
    local tween = TweenService:Create(NumberValue, TweenInfo.new(p9, p10), {
        Value = 1
    })

    p11(0)
    tween:Play()
    tween.Completed:Wait()
    connection:Disconnect()
    NumberValue:Destroy()
    p11(1)
end

local function bezier(p12, p13, p14, p15) -- line: 121
    return p12:Lerp(p13, p15):Lerp(p13:Lerp(p14, p15), p15)
end

function t1.Available() -- line: 125
    -- upvalues: machineParts (copy)
    local _, v11, v12, v13 = machineParts()

    if v11 == nil or v12 == nil then
        return false
    end

    return #v13 == 3
end

function t1.IsPlaying() -- line: 130
    -- upvalues: v3 (ref)
    return v3
end

function t1.Play(p16, p17, p18) -- line: 134
    -- upvalues: Players (copy), TweenService (copy), Workspace (copy), Flash (copy), Shake (copy), VFX (copy), RiftTradeIn (copy), v1 (copy), v2 (copy), v3 (ref), machineParts (copy), cue (copy), freeze (copy), offeringModel (copy), tintEffects (copy), tweenNumber (copy), bezier (copy)
    if v3 then
        task.spawn(p17)
    else
        v3 = true
        task.spawn(function() -- line: 140
            -- upvalues: p16 (copy), p17 (copy), p18 (copy), Players (copy), TweenService (copy), Workspace (copy), Flash (copy), Shake (copy), VFX (copy), RiftTradeIn (copy), v1 (copy), v2 (copy), v3 (ref), machineParts (copy), cue (copy), freeze (copy), offeringModel (copy), tintEffects (copy), tweenNumber (copy), bezier (copy)
            local v14 = false
            local t3 = {}
            local t4 = {}

            local function deliver() -- line: 144
                -- upvalues: v14 (ref), p17 (copy)
                if not v14 then
                    v14 = true
                    task.spawn(p17)
                end
            end

            local function keep(p19) -- line: 150
                -- upvalues: t3 (copy)
                table.insert(t3, p19)

                return p19
            end

            local function remember(p20) -- line: 154
                -- upvalues: t4 (copy)
                table.insert(t4, {
                    part = p20,
                    color = p20.Color,
                    material = p20.Material
                })
            end

            local function v15() -- line: 157
                -- upvalues: v14 (ref), t3 (copy), t4 (copy), p16 (copy), p17 (copy), p18 (copy), Players (copy), TweenService (copy), Workspace (copy), Flash (copy), Shake (copy), VFX (copy), RiftTradeIn (copy), v1 (copy), v2 (copy), machineParts (copy), cue (copy), freeze (copy), offeringModel (copy), tintEffects (copy), tweenNumber (copy), bezier (copy)
                local _, v16, v17, v18 = machineParts()

                assert(v16 and v17 and #v18 == 3, "laboratory reveal anchors missing")

                local WorldPosition = v17.WorldPosition
                local Transient = Workspace:WaitForChild("Transient")

                table.insert(t4, {
                    part = v16,
                    color = v16.Color,
                    material = v16.Material
                })
                v16.Material = Enum.Material.Neon

                local t7 = {}

                for _, v20 in v18 do
                    local Parent = v20.Parent

                    assert(Parent and Parent:IsA("BasePart"), "offering anchor must be under a pad part")
                    table.insert(t7, Parent)
                    table.insert(t4, {
                        part = Parent,
                        color = Parent.Color,
                        material = Parent.Material
                    })
                    Parent.Material = Enum.Material.Neon
                end

                local PointLight = Instance.new("PointLight")

                table.insert(t3, PointLight)
                PointLight.Color = v1
                PointLight.Brightness = 0
                PointLight.Range = 15
                PointLight.Parent = v16

                local t9 = {}

                for _, v22 in v18 do
                    local Beam = Instance.new("Beam")

                    table.insert(t3, Beam)
                    Beam.Attachment0 = v22
                    Beam.Attachment1 = v17
                    Beam.Color = ColorSequence.new(v1)
                    Beam.Width0 = 0.18
                    Beam.Width1 = 0.32
                    Beam.LightEmission = 1
                    Beam.FaceCamera = true
                    Beam.Enabled = false
                    Beam.Parent = v22
                    table.insert(t9, Beam)
                end

                cue("CinematicRiser", WorldPosition, 0.55)
                Shake.Play({
                    Seconds = 0.45,
                    Magnitude = 0.7
                })

                local t10 = {}

                for v23, v24 in p16 do
                    local v25 = v18[v23]

                    if not v25 then
                        break
                    end

                    local v26 = offeringModel(v24)

                    table.insert(t3, v26)
                    v26.PrimaryPart = nil

                    local BoundingBox, BoundingBox2 = v26:GetBoundingBox()

                    v26.WorldPivot = BoundingBox

                    local v27 = math.max(BoundingBox2.X, BoundingBox2.Y, BoundingBox2.Z)

                    v26:ScaleTo(if v27 > 0.01 then math.clamp(2.5 / v27, 0.05, 6) else 1)

                    local _, BoundingBox3 = v26:GetBoundingBox()
                    local v30 = BoundingBox3.Y * 0.5
                    local v32 = v25.WorldPosition + Vector3.new(0, v30 + 0.05, 0)
                    local v33 = v32 + Vector3.new(0, 2.3, 0)

                    v26:PivotTo(CFrame.new(v32))
                    v26.Parent = Transient
                    table.insert(t10, {
                        model = v26,
                        start = v32,
                        hover = v33,
                        scale = v26:GetScale()
                    })
                    task.wait(0.12)
                    cue("MechaShake", v32, 0.28)
                    TweenService:Create(t7[v23], TweenInfo.new(0.25), {
                        Color = v2
                    }):Play()
                    tweenNumber(0.45, Enum.EasingStyle.Back, function(p21) -- line: 209
                        -- upvalues: v26 (copy), v32 (copy), v33 (copy)
                        if v26.Parent then
                            v26:PivotTo(CFrame.new(v32:Lerp(v33, p21)))
                        end
                    end)
                end

                task.wait(0.35)

                for v34, v35 in t10 do
                    t9[v34].Enabled = true
                    cue("ImpactBoom", v35.hover, 0.38)

                    local v36 = v35.hover:Lerp(WorldPosition, 0.5) + Vector3.new(0, 1.2, 0)

                    tweenNumber(0.42, Enum.EasingStyle.Quad, function(p22) -- line: 220
                        -- upvalues: WorldPosition (copy), v35 (copy), v36 (copy), bezier (copy)
                        if v35.model.Parent then
                            v35.model:PivotTo(CFrame.new(bezier(v35.hover, v36, WorldPosition, p22)))
                            v35.model:ScaleTo(v35.scale * math.max(1 - p22 * 0.85, 0.15))
                        end
                    end)
                    v35.model:Destroy()
                    task.wait(0.15)
                end

                Flash.Play({
                    Attack = 0.08,
                    Decay = 0.28,
                    Opacity = 0.5,
                    Tint = v1
                })
                Shake.Play({
                    Seconds = 0.55,
                    Magnitude = 1.1
                })
                TweenService:Create(v16, TweenInfo.new(0.4), {
                    Color = v1
                }):Play()
                TweenService:Create(PointLight, TweenInfo.new(0.4), {
                    Brightness = 4
                }):Play()
                cue("CinematicBoom", WorldPosition, 0.8)
                task.wait(0.6)

                for _, v38 in t9 do
                    v38.Enabled = false
                end

                local v39 = if p18 then offeringModel(p18) else RiftTradeIn.Egg:Clone()

                table.insert(t3, v39)
                freeze(v39)

                if p18 == nil then
                    tintEffects(v39)
                end

                v39.PrimaryPart = nil

                local BoundingBox, BoundingBox2 = v39:GetBoundingBox()

                v39.WorldPivot = BoundingBox

                local v40 = math.max(BoundingBox2.X, BoundingBox2.Y, BoundingBox2.Z)

                v39:ScaleTo(if v40 > 0.01 then math.clamp(5 / v40, 0.05, 6) else 1)

                local _, BoundingBox3 = v39:GetBoundingBox()
                local _ = BoundingBox3.Y * 0.5

                v39.Parent = Transient

                local Scale = v39:GetScale()
                local _, BoundingBox4 = v39:GetBoundingBox()
                local v43 = BoundingBox4.Y * 0.5

                v39:ScaleTo(Scale * 0.4)
                v39:PivotTo(CFrame.new(WorldPosition))
                VFX.EmitTree(v39, true)
                cue("MechaHatch", WorldPosition, 0.9)
                Flash.Play({
                    Attack = 0.06,
                    Decay = 0.4,
                    Opacity = 0.75,
                    Tint = v2
                })

                local Character = Players.LocalPlayer.Character
                local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
                local v44 = if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then v16.CFrame.LookVector * Vector3.new(1, 0, 1) else (HumanoidRootPart.Position - WorldPosition) * Vector3.new(1, 0, 1)
                local v47 = WorldPosition + (if v44.Magnitude > 0.05 then v44.Unit else Vector3.new(-1, 0, 0)) * math.clamp(v44.Magnitude * 0.65, 8, 13)
                local v48 = RaycastParams.new()

                v48.FilterType = Enum.RaycastFilterType.Exclude
                v48.FilterDescendantsInstances = {
                    Transient,
                    Workspace.World.Machines.RiftMachine,
                    Character
                }

                local v49 = Workspace:Raycast(v47 + Vector3.new(0, 7, 0), Vector3.new(0, -80, 0), v48)
                local v51 = Vector3.new(v47.X, if v49 then v49.Position.Y + v43 else WorldPosition.Y - 2, v47.Z)
                local v52 = WorldPosition:Lerp(v51, 0.5) + Vector3.new(0, 5, 0)

                tweenNumber(0.9, Enum.EasingStyle.Quad, function(p23) -- line: 267
                    -- upvalues: WorldPosition (copy), v39 (copy), Scale (copy), v51 (copy), v52 (copy), bezier (copy)
                    if v39.Parent then
                        v39:PivotTo(CFrame.new(bezier(WorldPosition, v52, v51, p23)) * CFrame.Angles(0, p23 * 3.141592653589793 * 3, 0))
                        v39:ScaleTo(Scale * (0.4 + p23 * 0.6))
                    end
                end)
                cue("ImpactBoom", v51, 0.7)
                tweenNumber(0.35, Enum.EasingStyle.Quad, function(p24) -- line: 274
                    -- upvalues: v39 (copy), v51 (copy)
                    if v39.Parent then
                        v39:PivotTo(CFrame.new(v51 + Vector3.new(0, math.sin(p24 * 3.141592653589793) * 1.2, 0)))
                    end
                end)
                task.wait(0.25)

                local Character2 = Players.LocalPlayer.Character
                local HumanoidRootPart2 = Character2 and Character2:FindFirstChild("HumanoidRootPart")

                if HumanoidRootPart2 and HumanoidRootPart2:IsA("BasePart") then
                    local Position = v39:GetPivot().Position

                    tweenNumber(0.55, Enum.EasingStyle.Quad, function(p25) -- line: 284
                        -- upvalues: v39 (copy), Scale (copy), Position (copy), Players (copy)
                        if v39.Parent then
                            local Character = Players.LocalPlayer.Character
                            local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
                            local v55 = if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then Position else HumanoidRootPart.Position + Vector3.new(0, 1.4, 0)

                            v39:PivotTo(CFrame.new(Position:Lerp(v55, p25)))
                            v39:ScaleTo(Scale * (1 - p25 * 0.75))
                        end
                    end)
                end

                if not v14 then
                    v14 = true
                    task.spawn(p17)
                end

                task.wait(0.35)
            end

            local ok, result = pcall(v15)

            for _, v56 in t4 do
                if v56.part.Parent then
                    v56.part.Color = v56.color
                    v56.part.Material = v56.material
                end
            end

            for _, v57 in t3 do
                if v57.Parent then
                    v57:Destroy()
                end
            end

            if not ok then
                warn("Laboratory sequence failed: " .. tostring(result))
            end

            if not v14 then
                v14 = true
                task.spawn(p17)
            end

            v3 = false
        end)
    end
end

return table.freeze(t1)
