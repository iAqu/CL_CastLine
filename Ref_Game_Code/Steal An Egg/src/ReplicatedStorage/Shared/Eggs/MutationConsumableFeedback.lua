-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local BossMastery = require(ReplicatedStorage.Data.BossMastery)
local Shake = require(ReplicatedStorage.Client.Shake)
local EggActionMovement = require(script.Parent.EggActionMovement)
local Log = require(ReplicatedStorage.Packages.Log)
local Mutations = require(ReplicatedStorage.Shared.Modules.Mutations)
local PlayVFX = require(ReplicatedStorage.UserGenerated.VFX.PlayVFX)
local VisibleBounds = require(ReplicatedStorage.Shared.Utils.VisibleBounds)
local Trove = require(ReplicatedStorage.Packages.Trove)
local TryCall = require(ReplicatedStorage.Shared.Utils.TryCall)
local Preload = require(ReplicatedStorage.Shared.Utils.Preload)
local t1 = {
    Scrambled = "DrScrambleMutationVFX",
    Nitro = "NitroMutationVFX",
    Spectral = "SpectralMutationVFX",
    [BossMastery.MutationId] = "FractureVFX"
}
local v1 = Color3.fromRGB(170, 30, 30)
local v2 = Color3.fromRGB(255, 214, 110)
local v3 = Color3.fromRGB(255, 196, 80)
local v4 = Color3.fromRGB(150, 150, 150)
local v5 = Color3.new(1, 1, 1)
local v6 = TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
local v7 = Log.new()
local v8 = Workspace:FindFirstChild("Transient") or Workspace
local v9 = Random.new()
local t2 = nil
local t3 = {}

if RunService:IsClient() then
    task.spawn(Preload.WarmSounds, 128148316301690, 87821961053710, 92093418106897)
end

local function easeInOutSine(p1) -- line: 232
    -- upvalues: TweenService (copy)
    return TweenService:GetValue(p1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
end

local function getMutationTint(p2) -- line: 240
    -- upvalues: BossMastery (copy), Mutations (copy), v1 (copy)
    local v10 = Mutations.Get(p2 or BossMastery.MutationId)

    if v10 == nil then
        return v1
    end

    return v10.Tint
end

local function getMutationVfxName(p3) -- line: 245
    -- upvalues: BossMastery (copy), t1 (copy)
    return t1[p3 or BossMastery.MutationId] or t1[BossMastery.MutationId]
end

local function liveModel(p4) -- line: 251
    -- upvalues: Workspace (copy)
    local v12 = p4.GetModel()

    return if v12 ~= nil and v12:IsDescendantOf(Workspace) then v12 else nil
end

local function syncHighlight(p5) -- line: 259
    -- upvalues: Workspace (copy)
    local v13 = p5.GetModel()

    if v13 == nil or not v13:IsDescendantOf(Workspace) then
        v13 = nil
    end

    if p5.Highlight.Adornee ~= v13 then
        p5.Highlight.Adornee = v13
    end
end

local function setScreenGlow(p6, p7, p8) -- line: 266
    local v14 = 1 - math.clamp(p7, 0, 1)

    for _, v15 in p6.ScreenEdges do
        v15.BackgroundTransparency = v14

        if p8 ~= nil then
            v15.BackgroundColor3 = p8
        end
    end
end

local function fadeOutScreenGlow(p9, p10) -- line: 276
    -- upvalues: Debris (copy), TweenService (copy), v6 (copy)
    local v16

    for _, v17 in p10 do
        v16 = TweenService:Create(v17, v6, {
            BackgroundTransparency = 1
        })
        v16:Play()
    end

    if v16 ~= nil then
        v16.Completed:Once(function() -- line: 286
            -- upvalues: p9 (copy)
            p9:Destroy()
        end)
    end

    Debris:AddItem(p9, 1.6)
end

local function createScreenEdge(p11, p12, p13, p14, p15, p16) -- line: 293
    local Frame = Instance.new("Frame")

    Frame.AnchorPoint = p13
    Frame.BackgroundColor3 = p12
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.Position = p14
    Frame.Size = p15

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Rotation = p16
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.35),
        NumberSequenceKeypoint.new(1, 1)
    })
    UIGradient.Parent = Frame
    Frame.Parent = p11

    return Frame
end

local function createScreenGlow(p17) -- line: 321
    -- upvalues: Players (copy), createScreenEdge (copy)
    local PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

    assert(PlayerGui ~= nil, "Local player is missing PlayerGui")

    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "MutationConsumableGlow"
    ScreenGui.DisplayOrder = 5
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    return ScreenGui, {
        createScreenEdge(ScreenGui, p17, Vector2.new(0.5, 0), UDim2.fromScale(0.5, 0), UDim2.fromScale(1, 0.22), 90),
        createScreenEdge(ScreenGui, p17, Vector2.new(0.5, 1), UDim2.fromScale(0.5, 1), UDim2.fromScale(1, 0.22), 270),
        createScreenEdge(ScreenGui, p17, Vector2.new(0, 0.5), UDim2.fromScale(0, 0.5), UDim2.fromScale(0.22, 1), 0),
        (createScreenEdge(ScreenGui, p17, Vector2.new(1, 0.5), UDim2.fromScale(1, 0.5), UDim2.fromScale(0.22, 1), 180))
    }
end

local function offsetModel(p18, p19) -- line: 371
    -- upvalues: Workspace (copy), EggActionMovement (copy)
    if p18.Motion then
        local v19 = p18.GetModel()

        if v19 == nil or not v19:IsDescendantOf(Workspace) then
            v19 = nil
        end

        if v19 ~= nil and v19.PrimaryPart ~= nil then
            p18.Moved = true
            EggActionMovement.SetPivot(v19, p18.Pivot * p19)
        end
    end
end

local function restoreModel(p20) -- line: 383
    -- upvalues: Workspace (copy), EggActionMovement (copy)
    if p20.Moved then
        p20.Moved = false

        local v20 = p20.GetModel()

        if v20 == nil or not v20:IsDescendantOf(Workspace) then
            v20 = nil
        end

        if v20 ~= nil and v20.PrimaryPart ~= nil then
            EggActionMovement.SetPivot(v20, p20.Pivot)
        end
    end
end

local function moveHost(p21, p22) -- line: 395
    local v21 = if p21.Motion then p22 else 0

    p21.Host.CFrame = CFrame.new(p21.Pivot.Position + p21.CenterOffset + Vector3.new(0, 1, 0) * v21)
end

local function groundCFrame(p23) -- line: 402
    local v22 = p23.Pivot.Position + p23.CenterOffset

    return CFrame.new((Vector3.new(v22.X, p23.Pivot.Position.Y, v22.Z)))
end

local function measureModel(p24, p25) -- line: 407
    -- upvalues: VisibleBounds (copy)
    local v23 = p24.Position + Vector3.new(0, 1, 0)
    local v24

    if p25 ~= nil then
        local v25

        v25, v24 = VisibleBounds(p25)

        if v24.Magnitude > 0 then
            v23 = v25.Position
        else
            v24 = Vector3.new(2, 2, 2)
        end
    else
        v24 = Vector3.new(2, 2, 2)
    end

    return v23 - p24.Position, v24
end

local function createHost(p26, p27) -- line: 420
    -- upvalues: v8 (copy)
    local Part = Instance.new("Part")

    Part.Name = "MutationConsumableFeedback"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Size = p27 * 0.8
    Part.CFrame = p26
    Part.Parent = v8

    return Part
end

local function createEmitter(p28, p29) -- line: 435
    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Name = p29.Name
    ParticleEmitter.Texture = p29.Texture
    ParticleEmitter.Color = p29.Color
    ParticleEmitter.Size = p29.Size
    ParticleEmitter.Transparency = p29.Transparency
    ParticleEmitter.Lifetime = p29.Lifetime
    ParticleEmitter.Speed = p29.Speed
    ParticleEmitter.Acceleration = p29.Acceleration or Vector3.new(0, 0, 0)
    ParticleEmitter.Drag = p29.Drag or 0
    ParticleEmitter.LightEmission = p29.LightEmission or 0
    ParticleEmitter.LightInfluence = p29.LightInfluence or 0
    ParticleEmitter.RotSpeed = p29.RotSpeed or NumberRange.new(0)
    ParticleEmitter.Rotation = p29.Rotation or NumberRange.new(0)
    ParticleEmitter.Rate = p29.Rate or 0
    ParticleEmitter.SpreadAngle = p29.SpreadAngle or Vector2.new(180, 180)
    ParticleEmitter.Orientation = p29.Orientation or Enum.ParticleOrientation.FacingCamera
    ParticleEmitter.Squash = p29.Squash or NumberSequence.new(0)
    ParticleEmitter.Shape = Enum.ParticleEmitterShape.Sphere
    ParticleEmitter.ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward
    ParticleEmitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
    ParticleEmitter.Enabled = false
    ParticleEmitter.Parent = p28

    return ParticleEmitter
end

local function openScene(p30, p31, p32, p33) -- line: 466
    -- upvalues: Debris (copy), GuiService (copy), Workspace (copy), EggActionMovement (copy), VisibleBounds (copy), Trove (copy), v8 (copy), t2 (ref), fadeOutScreenGlow (copy), createScreenGlow (copy)
    local t4 = t2

    if t4 ~= nil then
        t2 = nil
        t4.Trove:Destroy()
    end

    local v26 = p31()
    local v27 = p30.Position + Vector3.new(0, 1, 0)
    local v28

    if v26 ~= nil then
        local v29

        v29, v28 = VisibleBounds(v26)

        if v28.Magnitude > 0 then
            v27 = v29.Position
        else
            v28 = Vector3.new(2, 2, 2)
        end
    else
        v28 = Vector3.new(2, 2, 2)
    end

    local v30 = v27 - p30.Position
    local v31 = CFrame.new(p30.Position + v30)
    local Part = Instance.new("Part")

    Part.Name = "MutationConsumableFeedback"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Size = v28 * 0.8
    Part.CFrame = v31
    Part.Parent = v8

    local Attachment = Instance.new("Attachment")

    Attachment.Name = "Center"
    Attachment.Parent = Part

    local Attachment2 = Instance.new("Attachment")

    Attachment2.Name = "Base"
    Attachment2.Position = Vector3.new(0, -Part.Size.Y * 0.5 / 0.8, 0)
    Attachment2.Parent = Part

    local Highlight = Instance.new("Highlight")

    Highlight.Name = "Glow"
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight.FillColor = p32
    Highlight.OutlineColor = p33
    Highlight.FillTransparency = 1
    Highlight.OutlineTransparency = 1
    Highlight.Adornee = v26
    Highlight.Parent = Part

    local v33, v34 = createScreenGlow(p32)
    local v35 = Trove.new()
    local t5 = {
        Moved = false,
        GetModel = p31,
        Pivot = p30,
        Radius = math.max(v28.X, v28.Y, v28.Z) * 0.5,
        CenterOffset = v30,
        Host = Part,
        Center = Attachment,
        Base = Attachment2,
        Highlight = Highlight,
        ScreenEdges = v34,
        Trove = v35,
        Motion = not GuiService.ReducedMotionEnabled
    }

    v35:Add(Highlight)
    v35:Add(function() -- line: 519
        -- upvalues: Part (copy), v33 (copy), v34 (copy), t5 (copy), Debris (copy), Workspace (copy), EggActionMovement (copy), fadeOutScreenGlow (copy)
        for _, descendant in Part:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false
            end
        end

        Debris:AddItem(Part, 3)
        fadeOutScreenGlow(v33, v34)

        if t5.Moved then
            t5.Moved = false

            local v36 = t5.GetModel()

            if v36 == nil or not v36:IsDescendantOf(Workspace) then
                v36 = nil
            end

            if v36 ~= nil then
                if v36.PrimaryPart == nil then
                    return
                end

                EggActionMovement.SetPivot(v36, t5.Pivot)
            end
        end
    end)
    t2 = t5

    return t5
end

local function playSound(p34, p35, p36) -- line: 559
    -- upvalues: Audio (copy)
    p36 = p36 or {}
    p36.MaxDistance = p36.MaxDistance or 70
    Audio.Play(p35, p34.Host.CFrame, p36)
end

local function findNamedSound(p37) -- line: 569
    -- upvalues: ReplicatedStorage (copy), v7 (copy)
    local Sounds = ReplicatedStorage.Assets:FindFirstChild("Sounds")
    local v38 = if Sounds then Sounds:FindFirstChild(p37) else nil

    if v38 ~= nil and v38:IsA("Sound") then
        return v38
    end

    v7:AtWarning():Log((("Missing ReplicatedStorage.Assets.Sounds.%*; sound skipped"):format(p37)))

    return nil
end

local function findParticles(p38) -- line: 582
    -- upvalues: ReplicatedStorage (copy), v7 (copy)
    local Particles = ReplicatedStorage.Assets:FindFirstChild("Particles")
    local v39 = if Particles then Particles:FindFirstChild(p38) else nil

    if v39 == nil then
        v7:AtWarning():Log((("Missing ReplicatedStorage.Assets.Particles.%*; VFX skipped"):format(p38)))
    end

    return v39
end

local function emitImpactVfx(p39) -- line: 594
    -- upvalues: Debris (copy), ReplicatedStorage (copy), PlayVFX (copy), TryCall (copy), v7 (copy), v8 (copy)
    local Particles = ReplicatedStorage.Assets:FindFirstChild("Particles")
    local BigHitGroundAttach = if Particles then Particles:FindFirstChild("BigHitGroundAttach") else nil

    if BigHitGroundAttach == nil then
        v7:AtWarning():Log("Missing ReplicatedStorage.Assets.Particles.BigHitGroundAttach; VFX skipped")
    end

    if BigHitGroundAttach == nil then
        return
    end

    local v40 = p39.Pivot.Position + p39.CenterOffset
    local v41 = CFrame.new((Vector3.new(v40.X, p39.Pivot.Position.Y, v40.Z)))
    local Part = Instance.new("Part")

    Part.Name = "MutationConsumableFeedback"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Size = Vector3.new(0.080000006, 0.080000006, 0.080000006)
    Part.CFrame = v41
    Part.Parent = v8
    Debris:AddItem(Part, 10)

    local clone = BigHitGroundAttach:Clone()

    if not TryCall(PlayVFX, Part, v41, clone) then
        clone:Destroy()
    end
end

local function scaleSequence(p40, p41) -- line: 609
    local v42 = table.create(#p40.Keypoints)

    for v43, v44 in p40.Keypoints do
        v42[v43] = NumberSequenceKeypoint.new(v44.Time, v44.Value * p41, v44.Envelope * p41)
    end

    return NumberSequence.new(v42)
end

local function mutationVfxScale(p42, p43) -- line: 624
    local SourceRadius = p43:GetAttribute("SourceRadius")

    if type(SourceRadius) ~= "number" or not (SourceRadius > 0) then
        SourceRadius = 10.7
    end

    return (math.clamp(p42 / SourceRadius, 0.12, 1))
end

local function cloneScaledEmitter(p44, p45) -- line: 638
    -- upvalues: scaleSequence (copy)
    local clone = p44:Clone()

    clone.Enabled = false
    clone.Size = scaleSequence(p44.Size, p45)
    clone.Speed = NumberRange.new(p44.Speed.Min * p45, p44.Speed.Max * p45)

    return clone
end

local function emitMutationVfx(p46, p47) -- line: 650
    -- upvalues: Debris (copy), ReplicatedStorage (copy), v7 (copy), v8 (copy), scaleSequence (copy)
    local Particles = ReplicatedStorage.Assets:FindFirstChild("Particles")
    local v46 = if Particles then Particles:FindFirstChild(p47) else nil

    if v46 == nil then
        v7:AtWarning():Log((("Missing ReplicatedStorage.Assets.Particles.%*; VFX skipped"):format(p47)))
    end

    if v46 == nil then
        return
    end

    local CFrame = p46.Host.CFrame
    local v47 = Vector3.new(1, 1, 1) * p46.Radius * 2
    local Part = Instance.new("Part")

    Part.Name = "MutationConsumableFeedback"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Size = v47 * 0.8
    Part.CFrame = CFrame
    Part.Parent = v8
    Debris:AddItem(Part, 6)

    local Radius = p46.Radius
    local SourceRadius = v46:GetAttribute("SourceRadius")

    if type(SourceRadius) ~= "number" or not (SourceRadius > 0) then
        SourceRadius = 10.7
    end

    local v49 = math.clamp(Radius / SourceRadius, 0.12, 1)

    for _, descendant in v46:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            local clone = descendant:Clone()

            clone.Enabled = false
            clone.Size = scaleSequence(descendant.Size, v49)
            clone.Speed = NumberRange.new(descendant.Speed.Min * v49, descendant.Speed.Max * v49)
            clone.Parent = Part
            clone:Emit((math.max(1, (math.round(descendant.Rate * 0.55)))))
        end
    end
end

local function shakeOffset(p48, p49, p50) -- line: 674
    -- upvalues: v9 (copy)
    local v53 = math.min(p48.Radius * 0.08, 0.3) * p50
    local v54 = p50 * 0.12217304763960307

    return CFrame.new(v9:NextNumber(-1, 1) * v53, p49 + v9:NextNumber(-1, 1) * v53, v9:NextNumber(-1, 1) * v53) * CFrame.Angles(v9:NextNumber(-1, 1) * v54, 0, v9:NextNumber(-1, 1) * v54)
end

local function createSuccessEmitters(p51, p52, p53) -- line: 695
    -- upvalues: v2 (copy), v5 (copy), createEmitter (copy)
    local Radius = p51.Radius

    return {
        Twinkle = createEmitter(p51.Host, {
            Name = "Twinkle",
            Texture = "rbxassetid://78284231250884",
            LightEmission = 1,
            Rate = 18,
            Color = ColorSequence.new(v5, v2),
            Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.5, 0.4),
                NumberSequenceKeypoint.new(1, 0)
            }),
            Transparency = NumberSequence.new(0),
            Lifetime = NumberRange.new(0.35, 0.6),
            Speed = NumberRange.new(0)
        }),
        Flare = createEmitter(p51.Center, {
            Name = "Flare",
            Texture = "rbxassetid://85665154415342",
            LightEmission = 1,
            Color = ColorSequence.new(v5, v2),
            Size = NumberSequence.new(math.min(Radius * 3, 10), (math.min(Radius * 5, 10))),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.2),
                NumberSequenceKeypoint.new(0.4, 0.45),
                NumberSequenceKeypoint.new(1, 1)
            }),
            Lifetime = NumberRange.new(0.6),
            Speed = NumberRange.new(0),
            RotSpeed = NumberRange.new(40),
            Rotation = NumberRange.new(-180, 180)
        }),
        Ring = createEmitter(p51.Base, {
            Name = "Ring",
            Texture = "rbxassetid://109600784699514",
            LightEmission = 1,
            Color = ColorSequence.new(v2, p53),
            Size = NumberSequence.new(0, (math.min(Radius * 6, 10))),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.2),
                NumberSequenceKeypoint.new(1, 1)
            }),
            Lifetime = NumberRange.new(0.6),
            Speed = NumberRange.new(0.5),
            SpreadAngle = Vector2.zero,
            Orientation = Enum.ParticleOrientation.VelocityPerpendicular
        }),
        Sparks = createEmitter(p51.Host, {
            Name = "Sparks",
            Texture = "rbxassetid://78284231250884",
            Drag = 5,
            LightEmission = 1,
            Color = ColorSequence.new(v2, p52),
            Size = NumberSequence.new(0.5, 0),
            Transparency = NumberSequence.new(0, 1),
            Lifetime = NumberRange.new(0.7, 1.2),
            Speed = NumberRange.new(Radius * 8, Radius * 14),
            SpreadAngle = Vector2.new(25, 25)
        }),
        Streaks = createEmitter(p51.Host, {
            Name = "Streaks",
            Texture = "rbxassetid://78284231250884",
            Drag = 8,
            LightEmission = 1,
            Color = ColorSequence.new(v5, v2),
            Size = NumberSequence.new(0.35, 0),
            Transparency = NumberSequence.new(0, 1),
            Lifetime = NumberRange.new(0.35, 0.5),
            Speed = NumberRange.new(Radius * 18, Radius * 26),
            SpreadAngle = Vector2.new(10, 10),
            Orientation = Enum.ParticleOrientation.VelocityParallel,
            Squash = NumberSequence.new(-1.5)
        }),
        Embers = createEmitter(p51.Host, {
            Name = "Embers",
            Texture = "rbxassetid://128641440631741",
            Acceleration = Vector3.new(0, 3.5, 0),
            Drag = 1.5,
            LightEmission = 1,
            Rate = 20,
            Color = ColorSequence.new(v2, p52),
            Size = NumberSequence.new(0.25, 0),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.1, 0),
                NumberSequenceKeypoint.new(1, 1)
            }),
            Lifetime = NumberRange.new(1.8, 2.6),
            Speed = NumberRange.new(1, 2.5)
        })
    }
end

local function afterglowHost(p54) -- line: 800
    local Hitbox = p54:FindFirstChild("Hitbox")

    return if Hitbox ~= nil and Hitbox:IsA("BasePart") then Hitbox else nil
end

local function removeAfterglow(p55) -- line: 805
    for _, child in p55:GetChildren() do
        if child:IsA("ParticleEmitter") and string.find(child.Name, "Afterglow_", 1, true) == 1 then
            child:Destroy()
        end
    end

    p55:SetAttribute("AfterglowMutationId", nil)
end

local function holdAfterglowLift(p56, p57) -- line: 821
    local t9 = {}

    for _, v59 in p57 do
        t9[v59] = v59.ZOffset < 0
    end

    local function lift() -- line: 829
        -- upvalues: p56 (copy), p57 (copy), t9 (copy)
        local v61 = math.min(p56.Size.Y * 0.2, 2)

        for _, v62 in p57 do
            if t9[v62] then
                v62.ZOffset = -v61
            else
                v62.ZOffset = v61
            end
        end
    end

    local v64 = math.min(p56.Size.Y * 0.2, 2)

    for _, v65 in p57 do
        if t9[v65] then
            v65.ZOffset = -v64
        else
            v65.ZOffset = v64
        end
    end

    local connection = p56:GetPropertyChangedSignal("Size"):Connect(lift)

    for _, v66 in p57 do
        v66.Destroying:Once(function() -- line: 841
            -- upvalues: connection (copy)
            connection:Disconnect()
        end)
    end
end

function t3.AttachAfterglow(p58, p59, p60) -- line: 849
    -- upvalues: ReplicatedStorage (copy), Mutations (copy), t1 (copy), v7 (copy), scaleSequence (copy), removeAfterglow (copy), holdAfterglowLift (copy)
    local Hitbox = p58:FindFirstChild("Hitbox")

    if Hitbox == nil or not Hitbox:IsA("BasePart") then
        Hitbox = nil
    end

    if Hitbox == nil then
        return
    end

    local v67

    for _, v68 in Mutations.Sanitize(p59, p60) do
        if t1[v68] ~= nil then
            v67 = v68
            break
        end
    end

    if Hitbox:GetAttribute("AfterglowMutationId") ~= v67 then
        removeAfterglow(Hitbox)

        if v67 ~= nil then
            Hitbox:SetAttribute("AfterglowMutationId", v67)

            local v69 = t1[v67]
            local Particles = ReplicatedStorage.Assets:FindFirstChild("Particles")
            local v70 = if Particles then Particles:FindFirstChild(v69) else nil

            if v70 == nil then
                v7:AtWarning():Log((("Missing ReplicatedStorage.Assets.Particles.%*; VFX skipped"):format(v69)))
            end

            if v70 ~= nil then
                local t10 = {}
                local n1 = 0

                for _, descendant in v70:GetDescendants() do
                    if descendant:IsA("ParticleEmitter") then
                        table.insert(t10, descendant)
                        n1 += descendant.Rate
                    end
                end

                if not (n1 <= 0) then
                    local v71 = math.max(Hitbox.Size.X, Hitbox.Size.Y, Hitbox.Size.Z) * 0.5
                    local SourceRadius = v70:GetAttribute("SourceRadius")

                    if type(SourceRadius) ~= "number" or not (SourceRadius > 0) then
                        SourceRadius = 10.7
                    end

                    local v73 = math.clamp(v71 / SourceRadius, 0.12, 1)
                    local v74 = 40 / n1
                    local t11 = {}

                    for _, v75 in t10 do
                        local clone = v75:Clone()

                        clone.Enabled = false
                        clone.Size = scaleSequence(v75.Size, v73)
                        clone.Speed = NumberRange.new(v75.Speed.Min * v73, v75.Speed.Max * v73)
                        clone.Name = "Afterglow_" .. v75.Name
                        clone.Acceleration = v75.Acceleration * v73
                        clone.Rate = v75.Rate * v74
                        clone.Shape = Enum.ParticleEmitterShape.Sphere
                        clone.ShapeStyle = Enum.ParticleEmitterShapeStyle.Surface
                        clone.LockedToPart = true
                        clone.Parent = Hitbox
                        table.insert(t11, clone)
                    end

                    holdAfterglowLift(Hitbox, t11)

                    for _, v76 in t11 do
                        v76.Enabled = true
                    end
                end
            end
        end
    end
end

function t3.ClearAfterglow(p61) -- line: 917
    -- upvalues: removeAfterglow (copy)
    local Hitbox = p61:FindFirstChild("Hitbox")

    if Hitbox == nil or not Hitbox:IsA("BasePart") then
        Hitbox = nil
    end

    if Hitbox ~= nil then
        removeAfterglow(Hitbox)
    end
end

function t3.PlaySuccess(p62) -- line: 924
    -- upvalues: RunService (copy), TweenService (copy), Workspace (copy), Audio (copy), BossMastery (copy), Shake (copy), EggActionMovement (copy), Mutations (copy), t1 (copy), v1 (copy), v2 (copy), v5 (copy), t2 (ref), easeInOutSine (copy), openScene (copy), findNamedSound (copy), emitImpactVfx (copy), emitMutationVfx (copy), shakeOffset (copy), createSuccessEmitters (copy)
    assert(type(p62) == "table", "PlaySuccess expects a params table")
    assert(typeof(p62.Pivot) == "CFrame", "PlaySuccess expects the egg's base pivot")
    assert(type(p62.GetModel) == "function", "PlaySuccess expects a model getter")
    assert(p62.OnReveal == nil or type(p62.OnReveal) == "function", "PlaySuccess reveal callback must be a function")
    assert(p62.OnFinished == nil or type(p62.OnFinished) == "function", "PlaySuccess finished callback must be a function")

    local Pivot2, OnReveal, OnFinished, MutationId = p62.Pivot, p62.OnReveal, p62.OnFinished, p62.MutationId
    local v82 = Mutations.Get(MutationId or BossMastery.MutationId)
    local v83 = if v82 == nil then v1 else v82.Tint
    local v84 = v83:Lerp(v5, 0.35)
    local v85 = openScene(Pivot2, p62.GetModel, v84, v2)

    if OnFinished ~= nil then
        v85.Trove:Add(function() -- line: 950
            -- upvalues: OnFinished (copy)
            task.spawn(OnFinished)
        end)
    end

    local v86 = createSuccessEmitters(v85, v83, v84)
    local v88 = math.min(v85.Radius * 0.25, 0.8)

    local function spinOffset(p63) -- line: 974
        -- upvalues: v85 (copy)
        if not v85.Motion then
            return CFrame.identity
        end

        local v89

        if p63 <= 0 then
            v89 = 0
        elseif p63 < 5.25 then
            v89 = 49.480084294039244 * (p63 / 5.25) ^ 4
        elseif p63 >= 5.95 then
            v89 = 62.83185307179586
        else
            local v90 = (p63 - 5.25) / 0.7

            v89 = 49.480084294039244 + 13.351768777756618 * v90 * (2 - v90)
        end

        return CFrame.Angles(0, v89, 0)
    end

    local v91 = false

    local function performFracture() -- line: 995
        -- upvalues: p62 (copy), v85 (copy), v91 (ref), BossMastery (copy), t1 (copy), emitMutationVfx (copy)
        if v91 then
            return
        end

        v91 = true
        emitMutationVfx(v85, t1[p62.MutationId or BossMastery.MutationId] or t1[BossMastery.MutationId])
    end

    local v93 = {
        TimePosition = 0.1200000000000001
    } or {}

    v93.MaxDistance = v93.MaxDistance or 70
    Audio.Play(128148316301690, v85.Host.CFrame, v93)
    v86.Twinkle.Enabled = true

    local v94 = false
    local v95 = false
    local v96 = false

    local function v97(p64) -- line: 1011
        -- upvalues: p62 (copy), OnReveal (copy), v84 (copy), v85 (copy), v86 (copy), v88 (copy), spinOffset (copy), v91 (ref), v94 (ref), v95 (ref), v96 (ref), TweenService (copy), Workspace (copy), Audio (copy), BossMastery (copy), Shake (copy), EggActionMovement (copy), t1 (copy), v2 (copy), t2 (ref), easeInOutSine (copy), findNamedSound (copy), emitImpactVfx (copy), emitMutationVfx (copy), shakeOffset (copy)
        local Highlight = v85.Highlight

        if p64 < 6.11 then
            local v99 = math.min(p64 / 5.95, 1)
            local v100 = v99 * v99
            local v102 = math.sin(p64 * (v99 * 46 + 14)) * 0.2 + 0.8

            Highlight.FillTransparency = 1 - v100 * 0.55 * v102
            Highlight.OutlineTransparency = 1 - v100 * v102

            local v103 = v100 * 0.4 * v102
            local v104 = v84:Lerp(v2, v99)
            local v105 = 1 - math.clamp(v103, 0, 1)

            for _, v106 in v85.ScreenEdges do
                v106.BackgroundTransparency = v105

                if v104 ~= nil then
                    v106.BackgroundColor3 = v104
                end
            end

            if p64 < 0.9 then
                local v108 = TweenService:GetValue(p64 / 0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut) * 3
                local v109 = if v85.Motion then v108 else 0

                v85.Host.CFrame = CFrame.new(v85.Pivot.Position + v85.CenterOffset + Vector3.new(0, 1, 0) * v109)

                local v110 = CFrame.new(0, v108, 0) * spinOffset(p64)

                if not v85.Motion then
                    return
                end

                local v111 = v85.GetModel()

                if v111 ~= nil and not v111:IsDescendantOf(Workspace) then
                    v111 = nil
                end

                if v111 ~= nil and v111.PrimaryPart ~= nil then
                    v85.Moved = true
                    EggActionMovement.SetPivot(v111, v85.Pivot * v110)
                end
            elseif p64 < 5.25 then
                local v112 = (p64 - 0.9) / 4.35

                if not v96 and v112 >= 0.45 then
                    v96 = true
                    v86.Embers.Rate = 10
                    v86.Embers.Enabled = true
                end

                local Value = TweenService:GetValue(math.min(v112 / 1, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                local v114 = v85.Motion and 3 or 0

                v85.Host.CFrame = CFrame.new(v85.Pivot.Position + v85.CenterOffset + Vector3.new(0, 1, 0) * v114)

                local v115 = shakeOffset(v85, 3, Value) * spinOffset(p64)

                if not v85.Motion then
                    return
                end

                local v116 = v85.GetModel()

                if v116 ~= nil and not v116:IsDescendantOf(Workspace) then
                    v116 = nil
                end

                if v116 ~= nil and v116.PrimaryPart ~= nil then
                    v85.Moved = true
                    EggActionMovement.SetPivot(v116, v85.Pivot * v115)
                end
            elseif p64 < 5.95 then
                if not v95 then
                    v95 = true

                    if not v91 then
                        v91 = true

                        local v118 = t1[p62.MutationId or BossMastery.MutationId]

                        v118 = v118 or t1[BossMastery.MutationId]
                        emitMutationVfx(v85, v118)
                    end

                    v86.Twinkle.Rate = 40
                    v86.Embers.Enabled = false
                    v86.Flare:Emit(1)
                    v86.Sparks:Emit(18)
                end

                local v119 = (p64 - 5.25) / 0.7
                local v120 = 3 + 1.25 * TweenService:GetValue(v119, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                local v121 = (1 - v119) * 0.35
                local v122 = if v85.Motion then v120 else 0

                v85.Host.CFrame = CFrame.new(v85.Pivot.Position + v85.CenterOffset + Vector3.new(0, 1, 0) * v122)

                local v123 = shakeOffset(v85, v120, v121) * spinOffset(p64)

                if not v85.Motion then
                    return
                end

                local v124 = v85.GetModel()

                if v124 ~= nil and not v124:IsDescendantOf(Workspace) then
                    v124 = nil
                end

                if v124 ~= nil and v124.PrimaryPart ~= nil then
                    v85.Moved = true
                    EggActionMovement.SetPivot(v124, v85.Pivot * v123)
                end
            else
                if not v91 then
                    v91 = true
                    emitMutationVfx(v85, t1[p62.MutationId or BossMastery.MutationId] or t1[BossMastery.MutationId])
                end

                local v126 = math.lerp(4.25, 0, (TweenService:GetValue((p64 - 5.95) / 0.16, Enum.EasingStyle.Quint, Enum.EasingDirection.In)))
                local v127 = if v85.Motion then v126 else 0

                v85.Host.CFrame = CFrame.new(v85.Pivot.Position + v85.CenterOffset + Vector3.new(0, 1, 0) * v127)

                local v128 = CFrame.new(0, v126, 0) * spinOffset(p64)

                if not v85.Motion then
                    return
                end

                local v129 = v85.GetModel()

                if v129 ~= nil and not v129:IsDescendantOf(Workspace) then
                    v129 = nil
                end

                if v129 ~= nil then
                    if v129.PrimaryPart == nil then
                        return
                    end

                    v85.Moved = true
                    EggActionMovement.SetPivot(v129, v85.Pivot * v128)
                end
            end
        else
            if not v94 then
                v94 = true

                if not v91 then
                    v91 = true

                    local v131 = t1[p62.MutationId or BossMastery.MutationId]

                    v131 = v131 or t1[BossMastery.MutationId]
                    emitMutationVfx(v85, v131)
                end

                if v85.Motion then
                end

                v85.Host.CFrame = CFrame.new(v85.Pivot.Position + v85.CenterOffset + Vector3.new(0, 1, 0) * 0)

                local MechaHatch = findNamedSound("MechaHatch")

                if MechaHatch ~= nil then
                    local t12 = {}

                    t12.MaxDistance = t12.MaxDistance or 70
                    Audio.Play(MechaHatch, v85.Host.CFrame, t12)
                end

                task.delay(0.18, function() -- line: 1100
                    -- upvalues: v85 (copy), Audio (copy), t2 (ref)
                    if t2 ~= v85 then
                        return
                    end

                    local t13 = {}

                    t13.MaxDistance = t13.MaxDistance or 70
                    Audio.Play(87821961053710, v85.Host.CFrame, t13)
                end)
                emitImpactVfx(v85)

                if v85.Motion then
                    Shake.Play({
                        Seconds = 0.45,
                        Magnitude = 1
                    })
                end

                v86.Twinkle.Rate = 8
                v86.Flare:Emit(1)
                v86.Ring:Emit(1)
                v86.Sparks:Emit(36)
                v86.Streaks:Emit(16)
                v86.Embers.Rate = 22
                v86.Embers:Emit(18)
                v86.Embers.Enabled = true

                if OnReveal ~= nil then
                    task.spawn(OnReveal)
                end
            end

            local v132 = p64 - 6.11

            Highlight.FillTransparency = math.lerp(0.1, 1, TweenService:GetValue(math.clamp(v132 / 1.2, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
            Highlight.OutlineTransparency = math.lerp(0.05, 1, easeInOutSine((math.clamp(v132 / 1.6, 0, 1))))

            local Value = TweenService:GetValue(math.clamp(v132 / 0.12, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local v139 = math.clamp(v132 / 3, 0, 1)
            local v140 = 1 - TweenService:GetValue(v139, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local v141 = math.lerp(0.4, 1, Value) * v140
            local v142 = v2:Lerp(v84, v139)
            local v143 = 1 - math.clamp(v141, 0, 1)

            for _, v144 in v85.ScreenEdges do
                v144.BackgroundTransparency = v143

                if v142 ~= nil then
                    v144.BackgroundColor3 = v142
                end
            end

            if v132 >= 1.2 then
                v86.Embers.Enabled = false
            end

            if v132 >= 1.6 then
                v86.Twinkle.Enabled = false
            end

            if v132 < 0.36 then
                local v145 = v132 / 0.36
                local v146 = (1 - v145) * (1 - v145)
                local v149 = v88 * math.abs((math.sin(6.283185307179586 * v145))) * v146
                local v150 = CFrame.new(0, v149, 0)

                if not v85.Motion then
                    return
                end

                local v151 = v85.GetModel()

                if v151 ~= nil and not v151:IsDescendantOf(Workspace) then
                    v151 = nil
                end

                if v151 ~= nil and v151.PrimaryPart ~= nil then
                    v85.Moved = true
                    EggActionMovement.SetPivot(v151, v85.Pivot * v150)
                end
            else
                if not v85.Moved then
                    return
                end

                v85.Moved = false

                local v152 = v85.GetModel()

                if v152 ~= nil and not v152:IsDescendantOf(Workspace) then
                    v152 = nil
                end

                if v152 ~= nil then
                    if v152.PrimaryPart == nil then
                        return
                    end

                    EggActionMovement.SetPivot(v152, v85.Pivot)
                end
            end
        end
    end

    local n2 = 0
    local connection
    local PreRender = RunService.PreRender
    local n3 = 7.91

    connection = PreRender:Connect(function(p65) -- line: 541
        -- upvalues: v85 (copy), v97 (copy), n2 (ref), connection (ref), n3 (copy), Workspace (copy), t2 (ref)
        n2 = math.min(n2 + p65, n3)

        local v154 = v85.GetModel()

        if v154 == nil or not v154:IsDescendantOf(Workspace) then
            v154 = nil
        end

        if v85.Highlight.Adornee ~= v154 then
            v85.Highlight.Adornee = v154
        end

        v97(n2)

        if n2 < n3 then
            return
        end

        connection:Disconnect()

        if t2 == v85 then
            t2 = nil
            v85.Trove:Destroy()
        end
    end)
    v85.Trove:Add(connection)
end

function t3.PlayFailure(p66) -- line: 1182
    -- upvalues: RunService (copy), TweenService (copy), Workspace (copy), Audio (copy), BossMastery (copy), Shake (copy), EggActionMovement (copy), Mutations (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), t2 (ref), createEmitter (copy), openScene (copy), findNamedSound (copy), shakeOffset (copy), createSuccessEmitters (copy)
    assert(type(p66) == "table", "PlayFailure expects a params table")
    assert(typeof(p66.Pivot) == "CFrame", "PlayFailure expects the egg's base pivot")
    assert(type(p66.GetModel) == "function", "PlayFailure expects a model getter")
    assert(p66.OnVerdict == nil or type(p66.OnVerdict) == "function", "PlayFailure verdict callback must be a function")
    assert(p66.OnFinished == nil or type(p66.OnFinished) == "function", "PlayFailure finished callback must be a function")

    local OnVerdict, OnFinished, MutationId = p66.OnVerdict, p66.OnFinished, p66.MutationId
    local v160 = Mutations.Get(MutationId or BossMastery.MutationId)
    local v161 = if v160 == nil then v1 else v160.Tint
    local v162 = v161:Lerp(v5, 0.35)
    local v163 = openScene(p66.Pivot, p66.GetModel, v162, v2)
    local Radius = v163.Radius

    if OnFinished ~= nil then
        v163.Trove:Add(function() -- line: 1208
            -- upvalues: OnFinished (copy)
            task.spawn(OnFinished)
        end)
    end

    local v164 = createSuccessEmitters(v163, v161, v162)
    local v165 = createEmitter(v163.Host, {
        Name = "FailSparks",
        Texture = "rbxassetid://78284231250884",
        Acceleration = Vector3.new(0, -25, 0),
        Drag = 2,
        LightEmission = 1,
        Color = ColorSequence.new(v3, v4),
        Size = NumberSequence.new(0.3, 0),
        Transparency = NumberSequence.new(0, 1),
        Lifetime = NumberRange.new(0.4, 0.8),
        Speed = NumberRange.new(Radius * 3, Radius * 5),
        SpreadAngle = Vector2.new(40, 40)
    })
    local v167 = createEmitter(v163.Host, {
        Name = "Smoke",
        Texture = "rbxasset://textures/particles/smoke_main.dds",
        Acceleration = Vector3.new(0, 1.2, 0),
        Drag = 1,
        LightInfluence = 1,
        Rate = 10,
        Color = ColorSequence.new(v4, v4:Lerp(Color3.new(0, 0, 0), 0.3)),
        Size = NumberSequence.new(Radius * 0.5, Radius * 1.1),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.15, 0.55),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Lifetime = NumberRange.new(1.4, 2.2),
        Speed = NumberRange.new(1, 2),
        RotSpeed = NumberRange.new(-20, 20),
        Rotation = NumberRange.new(-180, 180)
    })
    local v169 = createEmitter(v163.Base, {
        Name = "Dust",
        Texture = "rbxassetid://109600784699514",
        LightInfluence = 1,
        Color = ColorSequence.new(v4),
        Size = NumberSequence.new(0, (math.min(Radius * 5, 10))),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.35),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Lifetime = NumberRange.new(0.55),
        Speed = NumberRange.new(0.4),
        SpreadAngle = Vector2.zero,
        Orientation = Enum.ParticleOrientation.VelocityPerpendicular
    })
    local v171 = math.min(Radius * 0.12, 0.45)
    local v172 = Audio.Play(128148316301690, v163.Host.CFrame, {
        MaxDistance = 70,
        TimePosition = 0.1200000000000001
    })

    v164.Twinkle.Enabled = true

    local n4 = 0
    local n5 = 0
    local n6 = 0
    local v173 = false
    local v174 = false
    local v175 = false
    local n7 = 0
    local n8 = 0

    local function v176(p67) -- line: 1299
        -- upvalues: OnVerdict (copy), v162 (copy), v163 (copy), v164 (copy), v165 (copy), v167 (copy), v169 (copy), v171 (copy), v172 (copy), n4 (ref), n5 (ref), n6 (ref), v173 (ref), v174 (ref), v175 (ref), n7 (ref), n8 (ref), TweenService (copy), Workspace (copy), Audio (copy), Shake (copy), EggActionMovement (copy), v2 (copy), v4 (copy), findNamedSound (copy), shakeOffset (copy)
        local v177 = p67 - n4

        n4 = p67

        local Highlight = v163.Highlight

        if p67 < 3.45 then
            local v179 = math.clamp((p67 - 2.9) / 0.55, 0, 1)
            local v181 = v179 * (math.sin(p67 * 53) * 0.5 + 0.5)
            local v183 = math.min(p67 / 5.95, 1)
            local v184 = v183 * v183
            local v186 = (math.sin(p67 * (v183 * 46 + 14)) * 0.2 + 0.8) * (1 - v181 * 0.65)

            Highlight.FillTransparency = 1 - v184 * 0.55 * v186
            Highlight.OutlineTransparency = 1 - v184 * v186

            local v187 = v184 * 0.4 * v186
            local v188 = v162:Lerp(v2, v183)
            local v189 = 1 - math.clamp(v187, 0, 1)

            for _, v190 in v163.ScreenEdges do
                v190.BackgroundTransparency = v189

                if v188 ~= nil then
                    v190.BackgroundColor3 = v188
                end
            end

            n6 = 37.69911184307752 * (p67 / 5.25) ^ 3

            if p67 < 2.9 then
                n5 = 49.480084294039244 * (p67 / 5.25) ^ 4
            else
                local v191 = n6

                n6 = v191 * (1 - v181 * 0.65)

                local v192 = n5

                n5 = v192 + n6 * v177
            end

            if p67 < 0.9 then
                local v194 = TweenService:GetValue(p67 / 0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut) * 3
                local v195 = if v163.Motion then v194 else 0

                v163.Host.CFrame = CFrame.new(v163.Pivot.Position + v163.CenterOffset + Vector3.new(0, 1, 0) * v195)

                local v196 = CFrame.new(0, v194, 0) * CFrame.Angles(0, n5, 0)

                if not v163.Motion then
                    return
                end

                local v197 = v163.GetModel()

                if v197 ~= nil and not v197:IsDescendantOf(Workspace) then
                    v197 = nil
                end

                if v197 ~= nil and v197.PrimaryPart ~= nil then
                    v163.Moved = true
                    EggActionMovement.SetPivot(v197, v163.Pivot * v196)
                end
            else
                local v198 = (p67 - 0.9) / 4.35

                if not v173 and v198 >= 0.45 then
                    v173 = true
                    v164.Embers.Rate = 10
                    v164.Embers.Enabled = true
                end

                local v200 = TweenService:GetValue(math.min(v198 / 1, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.In) * (v179 * 0.3500000000000001 + 1)
                local v201 = 3 + 0.85 * TweenService:GetValue(v179, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
                local v202 = if v163.Motion then v201 else 0

                v163.Host.CFrame = CFrame.new(v163.Pivot.Position + v163.CenterOffset + Vector3.new(0, 1, 0) * v202)

                local v203 = shakeOffset(v163, v201, v200) * CFrame.Angles(0, n5, 0)

                if not v163.Motion then
                    return
                end

                local v204 = v163.GetModel()

                if v204 ~= nil and not v204:IsDescendantOf(Workspace) then
                    v204 = nil
                end

                if v204 ~= nil then
                    if v204.PrimaryPart == nil then
                        return
                    end

                    v163.Moved = true
                    EggActionMovement.SetPivot(v204, v163.Pivot * v203)
                end
            end
        else
            if not v174 then
                v174 = true

                if v172 ~= nil then
                    v172:Stop()
                end

                local t16 = {}

                t16.MaxDistance = t16.MaxDistance or 70
                Audio.Play(92093418106897, v163.Host.CFrame, t16)
                v164.Twinkle.Enabled = false
                v164.Embers.Enabled = false
                v165:Emit(9)
                v167.Enabled = true

                if OnVerdict ~= nil then
                    task.spawn(OnVerdict)
                end
            end

            local v205 = p67 - 3.45
            local v207 = math.clamp(v205 / 0.22, 0, 1)
            local v209 = 1 - math.clamp(v205 / 2.2, 0, 1)
            local v211 = math.sin(p67 * 24) * 0.3 + 0.7
            local v213 = math.lerp(0.18491278864486976, v211 * 0.5, v207) * v209 * v209
            local v215 = math.lerp(0.3362050702633995, v211 * 0.7, v207) * v209 * v209

            Highlight.FillTransparency = 1 - v213
            Highlight.OutlineTransparency = 1 - v215
            Highlight.FillColor = v162:Lerp(v4, v207)
            Highlight.OutlineColor = v2:Lerp(v4, v207)

            if p67 < 3.8000000000000003 then
                local v216 = (1 - v207) * 0.1344820281053598
                local FillColor = Highlight.FillColor
                local v217 = 1 - math.clamp(v216, 0, 1)

                for _, v218 in v163.ScreenEdges do
                    v218.BackgroundTransparency = v217

                    if FillColor ~= nil then
                        v218.BackgroundColor3 = FillColor
                    end
                end
            else
                local v221 = 1 - math.clamp(math.clamp(1 - (p67 - 3.8000000000000003) / 0.35, 0, 1) * 0.3, 0, 1)

                for _, v222 in v163.ScreenEdges do
                    v222.BackgroundTransparency = v221

                    if v4 ~= nil then
                        v222.BackgroundColor3 = v4
                    end
                end
            end

            if v167.Enabled and p67 >= 4.800000000000001 then
                v167.Enabled = false
            end

            if p67 < 3.8000000000000003 then
                local v223 = n6

                n6 = v223 * math.max(1 - v177 * 6, 0)

                local v225 = n5

                n5 = v225 + n6 * v177

                local v226 = 3.85

                if p67 >= 3.5700000000000003 then
                    local v227 = (p67 - 3.5700000000000003) / 0.23

                    v226 = (1 - v227 * v227) * 3.85
                end

                local v228 = if v163.Motion then v226 else 0

                v163.Host.CFrame = CFrame.new(v163.Pivot.Position + v163.CenterOffset + Vector3.new(0, 1, 0) * v228)

                local v229 = CFrame.new(0, v226, 0) * CFrame.Angles(0, n5, 0)

                if v163.Motion then
                    local v230 = v163.GetModel()

                    if v230 == nil or not v230:IsDescendantOf(Workspace) then
                        v230 = nil
                    end

                    if v230 ~= nil then
                        if v230.PrimaryPart == nil then
                            return
                        end

                        v163.Moved = true
                        EggActionMovement.SetPivot(v230, v163.Pivot * v229)
                    end
                end
            else
                if not v175 then
                    v175 = true

                    if v163.Motion then
                    end

                    v163.Host.CFrame = CFrame.new(v163.Pivot.Position + v163.CenterOffset + Vector3.new(0, 1, 0) * 0)
                    n7 = n5
                    n8 = math.ceil(n7 / 6.283185307179586) * 6.283185307179586

                    local ImpactBoom = findNamedSound("ImpactBoom")

                    if ImpactBoom ~= nil then
                        local v232 = {
                            Volume = 0.7
                        } or {}

                        v232.MaxDistance = v232.MaxDistance or 70
                        Audio.Play(ImpactBoom, v163.Host.CFrame, v232)
                    end

                    if v163.Motion then
                        Shake.Play({
                            Seconds = 0.28,
                            Magnitude = 0.5
                        })
                    end

                    v169:Emit(1)
                    v167:Emit(9)
                    v165:Emit(6)
                end

                local v233 = p67 - 3.8000000000000003
                local Value = TweenService:GetValue(math.clamp(v233 / 1, 0, 1), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                local v238 = math.lerp(n7, n8, Value)

                if v233 < 0.42 then
                    local v239 = v233 / 0.42
                    local v240 = (1 - v239) * (1 - v239)
                    local v242 = math.sin(6.283185307179586 * v239)
                    local v243 = CFrame.new(0, v171 * math.abs(v242) * v240, 0) * CFrame.Angles(0, v238, 0) * CFrame.Angles(0, 0, v242 * 0.08726646259971647 * v240)

                    if not v163.Motion then
                        return
                    end

                    local v244 = v163.GetModel()

                    if v244 ~= nil and not v244:IsDescendantOf(Workspace) then
                        v244 = nil
                    end

                    if v244 ~= nil and v244.PrimaryPart ~= nil then
                        v163.Moved = true
                        EggActionMovement.SetPivot(v244, v163.Pivot * v243)
                    end
                elseif v233 < 1.6199999999999999 then
                    local v246 = math.sin((v233 - 0.42) / 1.2 * 3.141592653589793) * 0.06981317007977318
                    local v247 = CFrame.Angles(0, v238, 0) * CFrame.Angles(v246, 0, 0)

                    if not v163.Motion then
                        return
                    end

                    local v248 = v163.GetModel()

                    if v248 ~= nil and not v248:IsDescendantOf(Workspace) then
                        v248 = nil
                    end

                    if v248 ~= nil and v248.PrimaryPart ~= nil then
                        v163.Moved = true
                        EggActionMovement.SetPivot(v248, v163.Pivot * v247)
                    end
                else
                    if not v163.Moved then
                        return
                    end

                    v163.Moved = false

                    local v249 = v163.GetModel()

                    if v249 ~= nil and not v249:IsDescendantOf(Workspace) then
                        v249 = nil
                    end

                    if v249 ~= nil then
                        if v249.PrimaryPart == nil then
                            return
                        end

                        EggActionMovement.SetPivot(v249, v163.Pivot)
                    end
                end
            end
        end
    end

    local n9 = 0
    local connection
    local PreRender = RunService.PreRender
    local n10 = 5.65

    connection = PreRender:Connect(function(p68) -- line: 541
        -- upvalues: v163 (copy), v176 (copy), n9 (ref), connection (ref), n10 (copy), Workspace (copy), t2 (ref)
        n9 = math.min(n9 + p68, n10)

        local v251 = v163.GetModel()

        if v251 == nil or not v251:IsDescendantOf(Workspace) then
            v251 = nil
        end

        if v163.Highlight.Adornee ~= v251 then
            v163.Highlight.Adornee = v251
        end

        v176(n9)

        if n9 < n10 then
            return
        end

        connection:Disconnect()

        if t2 == v163 then
            t2 = nil
            v163.Trove:Destroy()
        end
    end)
    v163.Trove:Add(connection)
end

return table.freeze(t3)
