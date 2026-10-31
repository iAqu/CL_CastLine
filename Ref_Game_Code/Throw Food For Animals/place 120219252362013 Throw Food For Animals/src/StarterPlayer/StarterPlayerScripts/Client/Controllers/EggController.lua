-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EggsConfig = require(ReplicatedStorage.Config.EggsConfig)
local UITheme = require(ReplicatedStorage.Config.UITheme)
local RarityConfig = require(ReplicatedStorage.Config.RarityConfig)

require(ReplicatedStorage.Shared.Mutations)

local AnimalUtil = require(ReplicatedStorage.Shared.AnimalUtil)
local Boosts = require(ReplicatedStorage.Shared.Boosts)
local Parent = script.Parent
local UIKit = require(Parent.UIKit)
local Sounds = require(Parent.Sounds)
local CameraRig = require(Parent.CameraRig)
local ScreenFX = require(Parent.ScreenFX)
local RevealCard = require(Parent.RevealCard)
local HUDController = require(Parent.HUDController)
local ClientState = require(Parent.ClientState)
local Movement = require(Parent.Movement)
local AnimalVisuals = require(Parent.AnimalVisuals)
local t1 = {}
local _ = UITheme.Colors
local LocalPlayer = Players.LocalPlayer

LocalPlayer:WaitForChild("PlayerGui")

local t2 = {}
local t3 = {}
local v1 = false
local t4 = {
    Color3.fromRGB(255, 70, 70),
    Color3.fromRGB(255, 160, 40),
    Color3.fromRGB(255, 235, 60),
    Color3.fromRGB(80, 230, 90),
    Color3.fromRGB(60, 200, 255),
    Color3.fromRGB(120, 110, 255),
    Color3.fromRGB(220, 90, 255)
}
local t5 = {
    0.14, 0.27, 0.38, 0.47, 0.55, 0.62, 0.68, 0.73,
    0.775, 0.81, 0.84, 0.865, 0.885
}
local t6 = {
    [4] = true,
    [7] = true,
    [9] = true,
    [11] = true,
    [13] = true
}

local function now() -- line: 71
    return workspace:GetServerTimeNow()
end

local function rainbowAt(p1) -- line: 75
    -- upvalues: t4 (copy)
    local v2 = #t4
    local v3 = p1 * 2.2 % v2
    local v4 = math.floor(v3) + 1
    local v5 = v4 % v2 + 1

    return t4[v4]:Lerp(t4[v5], v3 - math.floor(v3))
end

local function eggColor(p2, p3) -- line: 83
    -- upvalues: rainbowAt (copy)
    if p2.Cfg.Rainbow then
        return rainbowAt(p3)
    end

    return p2.Cfg.Color or Color3.new(1, 1, 1)
end

local function tempPart(p4, p5) -- line: 88
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = p5 or Vector3.new(1, 1, 1)
    Part.Position = p4
    Part.Parent = workspace

    return Part
end

local function emitBurst(p6, p7) -- line: 101
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(1, 1, 1)
    Part.Position = p6
    Part.Parent = workspace

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Texture = p7.Texture or "rbxasset://textures/particles/sparkles_main.dds"

    local Color = p7.Color
    local new, Color2, v6, v7

    if typeof(Color) == "ColorSequence" then
        local Color = p7.Color

        if Color then
            v6 = Color
            v7 = true
        else
            new = ColorSequence.new
            Color2 = p7.Color or Color3.new(1, 1, 1)
            v7 = false
        end
    else
        new = ColorSequence.new
        Color2 = p7.Color or Color3.new(1, 1, 1)
        v7 = false
    end

    ParticleEmitter.Color = if not v7 then new(Color2) else v6
    ParticleEmitter.Size = p7.Size or NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.2, 1.2),
        NumberSequenceKeypoint.new(1, 0)
    })
    ParticleEmitter.Transparency = p7.Transparency or NumberSequence.new(0.1)
    ParticleEmitter.Lifetime = p7.Lifetime or NumberRange.new(0.6, 1.2)
    ParticleEmitter.Speed = p7.Speed or NumberRange.new(8, 16)
    ParticleEmitter.SpreadAngle = p7.Spread or Vector2.new(180, 180)
    ParticleEmitter.Acceleration = p7.Acceleration or Vector3.new(0, 0, 0)
    ParticleEmitter.LightEmission = p7.LightEmission or 1
    ParticleEmitter.Rotation = NumberRange.new(0, 360)
    ParticleEmitter.RotSpeed = NumberRange.new(-120, 120)
    ParticleEmitter.Rate = 0
    ParticleEmitter.Parent = Part
    ParticleEmitter:Emit(p7.Count or 30)
    task.delay(3, function() -- line: 118
        -- upvalues: Part (copy)
        Part:Destroy()
    end)
end

local function playAt(p8, p9, p10) -- line: 121
    -- upvalues: Sounds (copy)
    p10 = p10 or {}

    if not p8.IsOwner then
        p10.Parent = p8.Anchor
        p10.Volume = (p10.Volume or 0.6) * 0.8
    end

    return Sounds.Play(p9, p10)
end

local function shard(p11, p12, p13, p14) -- line: 134
    -- upvalues: TweenService (copy), t4 (copy)
    local Egg = p11.Egg
    local v9 = p11.Height * (0.08 + math.random() * 0.07)
    local Part = Instance.new("Part")

    Part.Size = Vector3.new(v9, v9 * 0.35, v9 * (0.7 + math.random() * 0.5))
    Part.Material = Enum.Material.SmoothPlastic

    local Color, v12, v13

    if p11.Cfg.Rainbow then
        local v14 = t4[math.random(1, #t4)]

        if v14 then
            v12 = v14
            v13 = true
        else
            Color = Egg and Egg.Color or Color3.new(1, 1, 1)
            v13 = false
        end
    else
        Color = Egg and Egg.Color or Color3.new(1, 1, 1)
        v13 = false
    end

    Part.Color = if not v13 then Color:Lerp(p11.Cfg.Color or Color3.new(1, 1, 1), math.random() * 0.5) else v12
    Part.CanCollide = true
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.CFrame = CFrame.new(p12) * CFrame.Angles(math.random() * 6, math.random() * 6, math.random() * 6)
    Part.Parent = workspace
    Part.AssemblyLinearVelocity = Vector3.new(math.random() - 0.5, 0.6 + math.random() * 0.8, math.random() - 0.5).Unit * p13
    Part.AssemblyAngularVelocity = Vector3.new(math.random(-20, 20), math.random(-20, 20), math.random(-20, 20))
    task.delay(p14, function() -- line: 150
        -- upvalues: Part (copy), TweenService (copy)
        if Part.Parent then
            TweenService:Create(Part, TweenInfo.new(0.5), {
                Transparency = 1,
                Size = Part.Size * 0.3
            }):Play()
            task.delay(0.55, function() -- line: 153
                -- upvalues: Part (copy)
                Part:Destroy()
            end)
        end
    end)
end

local function crack(p15, p16) -- line: 158
    -- upvalues: Sounds (copy), t4 (copy), emitBurst (copy), shard (copy)
    local v21 = p15.Center + Vector3.new(0, p15.Height * 0.1, 0)

    for _ = 1, 2 do
        shard(p15, v21 + Vector3.new((math.random() - 0.5) * p15.Height * 0.4, p15.Height * 0.2, (math.random() - 0.5) * p15.Height * 0.4), 10 + math.random() * 6, 1.2)
    end

    local t7 = {
        Count = 10
    }

    if p15.Cfg.Rainbow then
        local v25 = #t4
        local v26 = p16 * 2.2 % v25
        local v27 = math.floor(v26) + 1
        local v28 = v27 % v25 + 1

        t7.Color = t4[v27]:Lerp(t4[v28], v26 - math.floor(v26))
    else
        t7.Color = p15.Cfg.Color or Color3.new(1, 1, 1)
    end

    t7.Speed = NumberRange.new(4, 9)
    t7.Lifetime = NumberRange.new(0.4, 0.8)
    emitBurst(v21, t7)

    local v29 = {
        Volume = 0.55
    } or {}

    if not p15.IsOwner then
        v29.Parent = p15.Anchor
        v29.Volume = (v29.Volume or 0.6) * 0.8
    end

    Sounds.Play("EggCrack", v29)
end

local function landing(p17) -- line: 167
    -- upvalues: TweenService (copy), Sounds (copy), t4 (copy), emitBurst (copy)
    local Spot = p17.Spot

    emitBurst(Spot + Vector3.new(0, 0.3, 0), {
        Texture = "rbxasset://textures/particles/smoke_main.dds",
        Count = 16,
        LightEmission = 0,
        Color = Color3.fromRGB(235, 230, 220),
        Speed = NumberRange.new(6, 12),
        Spread = Vector2.new(10, 180),
        Lifetime = NumberRange.new(0.5, 0.9),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.4),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 3)
        })
    })

    local Part = Instance.new("Part")

    Part.Shape = Enum.PartType.Cylinder
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Material = Enum.Material.Neon

    local v30

    if p17.Cfg.Rainbow then
        local v31 = #t4
        local v32 = 0 % v31
        local v33 = math.floor(v32) + 1
        local v34 = v33 % v31 + 1

        v30 = t4[v33]:Lerp(t4[v34], v32 - math.floor(v32))
    else
        v30 = p17.Cfg.Color or Color3.new(1, 1, 1)
    end

    Part.Color = v30
    Part.Transparency = 0.3
    Part.Size = Vector3.new(0.15, 1, 1)
    Part.CFrame = CFrame.new(Spot + Vector3.new(0, 0.08, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
    Part.Parent = workspace
    TweenService:Create(Part, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Transparency = 1,
        Size = Vector3.new(0.15, p17.Height * 3, p17.Height * 3)
    }):Play()
    task.delay(0.7, function() -- line: 183
        -- upvalues: Part (copy)
        Part:Destroy()
    end)

    local v38 = {
        Volume = 0.7
    } or {}

    if not p17.IsOwner then
        v38.Parent = p17.Anchor
        v38.Volume = (v38.Volume or 0.6) * 0.8
    end

    Sounds.Play("EggLand", v38)
end

local function explode(p18) -- line: 187
    -- upvalues: TweenService (copy), Sounds (copy), t4 (copy), emitBurst (copy), shard (copy)
    local Center, Duration = p18.Center, p18.Duration
    local v39

    if p18.Cfg.Rainbow then
        local v40 = #t4
        local v41 = Duration * 2.2 % v40
        local v42 = math.floor(v41) + 1
        local v43 = v42 % v40 + 1

        v39 = t4[v42]:Lerp(t4[v43], v41 - math.floor(v41))
    else
        v39 = p18.Cfg.Color or Color3.new(1, 1, 1)
    end

    for _, descendant in ipairs(p18.Model:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.LocalTransparencyModifier = 1
        elseif descendant:IsA("Texture") or descendant:IsA("Decal") then
            descendant.Transparency = 1
        end
    end

    for _ = 1, 16 do
        shard(p18, Center + Vector3.new((math.random() - 0.5) * p18.Height * 0.5, (math.random() - 0.3) * p18.Height * 0.5, (math.random() - 0.5) * p18.Height * 0.5), 18 + math.random() * 16, 1.6 + math.random() * 0.6)
    end

    emitBurst(Center, {
        Count = 70,
        Color = ColorSequence.new(v39, Color3.new(1, 1, 1)),
        Speed = NumberRange.new(14, 30),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.15, 1.8),
            NumberSequenceKeypoint.new(1, 0)
        })
    })
    emitBurst(Center, {
        Texture = "rbxasset://textures/particles/smoke_main.dds",
        Count = 20,
        LightEmission = 0.3,
        Color = Color3.fromRGB(255, 250, 240),
        Speed = NumberRange.new(6, 14),
        Lifetime = NumberRange.new(0.7, 1.3),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.3),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 2),
            NumberSequenceKeypoint.new(1, 6)
        })
    })

    local Part = Instance.new("Part")

    Part.Shape = Enum.PartType.Ball
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Material = Enum.Material.Neon
    Part.Color = Color3.new(1, 1, 1):Lerp(v39, 0.3)
    Part.Size = Vector3.new(1, 1, 1) * p18.Height
    Part.Position = Center
    Part.Parent = workspace
    TweenService:Create(Part, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Transparency = 1,
        Size = Vector3.new(1, 1, 1) * p18.Height * 3.2
    }):Play()

    local Part2 = Instance.new("Part")

    Part2.Shape = Enum.PartType.Cylinder
    Part2.Anchored = true
    Part2.CanCollide = false
    Part2.CanQuery = false
    Part2.CanTouch = false
    Part2.Material = Enum.Material.Neon
    Part2.Color = v39
    Part2.Transparency = 0.1
    Part2.Size = Vector3.new(0.2, p18.Height, p18.Height)
    Part2.CFrame = CFrame.new(p18.Spot + Vector3.new(0, 0.1, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
    Part2.Parent = workspace
    TweenService:Create(Part2, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Transparency = 1,
        Size = Vector3.new(0.2, p18.Height * 8, p18.Height * 8)
    }):Play()

    local PointLight = Instance.new("PointLight")

    PointLight.Color = v39
    PointLight.Range = p18.Height * 6
    PointLight.Brightness = 10
    PointLight.Parent = Part
    TweenService:Create(PointLight, TweenInfo.new(1, Enum.EasingStyle.Quad), {
        Brightness = 0
    }):Play()
    task.delay(1.2, function() -- line: 235
        -- upvalues: Part (copy), Part2 (copy)
        Part:Destroy()
        Part2:Destroy()
    end)

    local v50 = {
        Volume = 1
    } or {}

    if not p18.IsOwner then
        v50.Parent = p18.Anchor
        v50.Volume = (v50.Volume or 0.6) * 0.8
    end

    Sounds.Play("EggBurst", v50)

    local v51 = {
        Volume = 0.8
    } or {}

    if not p18.IsOwner then
        v51.Parent = p18.Anchor
        v51.Volume = (v51.Volume or 0.6) * 0.8
    end

    Sounds.Play("EggPop", v51)

    if p18.Light then
        p18.Light:Destroy()
    end

    if p18.Sparkles then
        p18.Sparkles.Enabled = false
    end

    if p18.Glow then
        p18.Glow:Destroy()
    end
end

local function stepHatch(p19, _) -- line: 246
    -- upvalues: Sounds (copy), t4 (copy), t5 (copy), t6 (copy), crack (copy), landing (copy), explode (copy)
    local Model = p19.Model

    if not Model.Parent then
        return false
    end

    local v52 = workspace:GetServerTimeNow() - p19.Start
    local Duration = p19.Duration
    local v54 = math.clamp(v52 / Duration, 0, 1)
    local v55

    if p19.Cfg.Rainbow then
        local v56 = #t4
        local v57 = v52 * 2.2 % v56
        local v58 = math.floor(v57) + 1
        local v59 = v58 % v56 + 1

        v55 = t4[v58]:Lerp(t4[v59], v57 - math.floor(v57))
    else
        v55 = p19.Cfg.Color or Color3.new(1, 1, 1)
    end

    local n1 = 0

    if v52 < 0.35 then
        local v61 = math.clamp(v52 / 0.35, 0, 1)

        n1 = p19.Height * 1.4 * (1 - v61 * v61)
    elseif v52 < 0.6 then
        n1 = math.sin((v52 - 0.35) / 0.25 * 3.141592653589793) * p19.Height * 0.12
    end

    if v52 >= 0.35 and not p19.Landed then
        p19.Landed = true
        landing(p19)
    end

    local v63 = 0
    local Axis = p19.Axis

    for v64, v65 in ipairs(t5) do
        local v66 = (v52 - v65 * Duration) / 0.3

        if v66 >= 0 and v66 <= 1 then
            if p19.LastBurst ~= v64 then
                p19.LastBurst = v64
                p19.Axis = CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0):VectorToWorldSpace((Vector3.new(1, 0, 0)))
                Axis = p19.Axis

                local v67 = {
                    Pitch = v54 * 1.1 + 0.9,
                    Volume = v54 * 0.3 + 0.3
                } or {}

                if not p19.IsOwner then
                    v67.Parent = p19.Anchor
                    v67.Volume = (v67.Volume or 0.6) * 0.8
                end

                Sounds.Play("EggWobble", v67)

                if t6[v64] then
                    crack(p19, v52)
                end

                if p19.OnBurst then
                    p19.OnBurst(v64, v54)
                end
            end

            local v69 = math.rad(v54 * 17 + 5)

            v63 = math.sin(v66 * 3.141592653589793 * 3) * v69 * (1 - v66)
        end
    end

    if v54 >= 0.9 and v54 < 1 then
        local v71 = (v54 - 0.9) / 0.09999999999999998

        v63 = math.sin(v52 * 55) * math.rad(v71 * 10 + 4)
        Axis = Vector3.new(math.sin(v52 * 7), 0, (math.cos(v52 * 7))).Unit
        n1 += v71 * p19.Height * 0.08
    end

    local Spot = p19.Spot
    local v79 = CFrame.fromAxisAngle(Axis or Vector3.new(1, 0, 0), v63)

    Model:PivotTo(CFrame.new(Spot + Vector3.new(0, n1, 0)) * v79 * CFrame.new(-Spot) * p19.BasePivot)

    if p19.Light then
        p19.Light.Color = v55
        p19.Light.Brightness = v54 * 6 * v54 + 0.5
        p19.Light.Range = p19.Height * (v54 * 2.5 + 1.5)
    end

    if p19.Sparkles then
        p19.Sparkles.Color = ColorSequence.new(v55, Color3.new(1, 1, 1))
        p19.Sparkles.Rate = v54 * 50 * v54 + 2
    end

    if p19.Glow then
        p19.Glow.FillColor = Color3.new(1, 1, 1):Lerp(v55, 0.35)
        p19.Glow.OutlineColor = v55
        p19.Glow.FillTransparency = 1 - math.clamp((v54 - 0.6) / 0.4, 0, 1) * 0.8
        p19.Glow.OutlineTransparency = 1 - math.clamp((v54 - 0.3) / 0.7, 0, 1)
    end

    if not (Duration - 0.03 <= v52) or p19.Exploded then
        return true
    end

    p19.Exploded = true
    explode(p19)

    if p19.OnExplode then
        p19.OnExplode()
    end

    return false
end

local function startHatch(p21) -- line: 322
    -- upvalues: EggsConfig (copy), t1 (copy), LocalPlayer (copy), t2 (copy), t3 (copy), explode (copy)
    if t2[p21] then
        return
    end

    local v82 = os.clock() + 5

    while p21.Parent and not (p21:GetAttribute("HatchStart") and p21.PrimaryPart) and os.clock() < v82 do
        task.wait()
    end

    if p21.Parent and p21:GetAttribute("HatchStart") then
        local EggKey = p21:GetAttribute("EggKey")
        local v83 = EggsConfig.Get(EggKey) or {}
        local BoundingBox, BoundingBox2 = p21:GetBoundingBox()
        local Spot = p21:GetAttribute("Spot")

        if not Spot then
            Spot = BoundingBox.Position - Vector3.new(0, BoundingBox2.Y / 2, 0)
        end

        local BoundingBoxPosition = BoundingBox.Position
        local Part = Instance.new("Part")

        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.Transparency = 1
        Part.Size = Vector3.new(1, 1, 1)
        Part.Position = BoundingBoxPosition
        Part.Parent = workspace
        Part.Name = "HatchSoundAnchor"

        local t10 = {
            Model = p21,
            Egg = p21.PrimaryPart,
            Cfg = v83,
            Key = EggKey,
            Start = p21:GetAttribute("HatchStart"),
            Duration = p21:GetAttribute("HatchDuration") or 6,
            Spot = Spot,
            Center = BoundingBox.Position,
            Height = BoundingBox2.Y,
            BasePivot = p21:GetPivot(),
            Anchor = Part,
            IsOwner = p21:GetAttribute("OwnerUserId") == LocalPlayer.UserId,
            AnimalId = p21:GetAttribute("AnimalId")
        }
        local PointLight = Instance.new("PointLight")

        PointLight.Brightness = 0
        PointLight.Range = BoundingBox2.Y * 2
        PointLight.Shadows = false
        PointLight.Parent = t10.Egg
        t10.Light = PointLight

        local ParticleEmitter = Instance.new("ParticleEmitter")

        ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
        ParticleEmitter.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.3, BoundingBox2.Y * 0.09),
            NumberSequenceKeypoint.new(1, 0)
        })
        ParticleEmitter.Lifetime = NumberRange.new(0.6, 1.1)
        ParticleEmitter.Speed = NumberRange.new(1, 3)
        ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
        ParticleEmitter.LightEmission = 1
        ParticleEmitter.Rate = 0
        ParticleEmitter.Parent = t10.Egg
        t10.Sparkles = ParticleEmitter

        local Highlight = Instance.new("Highlight")

        Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
        Highlight.FillTransparency = 1
        Highlight.OutlineTransparency = 1
        Highlight.Adornee = p21
        Highlight.Parent = p21
        t10.Glow = Highlight
        t2[p21] = t10

        if t10.IsOwner then
            table.insert(t3, t10)
            t1.RunCinematics()
        end

        p21.Destroying:Connect(function() -- line: 379
            -- upvalues: p21 (copy), Part (copy), t10 (copy), t2 (copy), explode (copy)
            if not t10.Exploded then
                t10.Exploded = true
                explode(t10)

                if t10.OnExplode then
                    t10.OnExplode()
                end
            end

            t2[p21] = nil
            task.delay(3, function() -- line: 386
                -- upvalues: Part (copy)
                Part:Destroy()
            end)
        end)
    end
end

local function plotAnimalOf(p22) -- line: 395
    -- upvalues: CollectionService (copy)
    while true do
        if not p22 or p22 == workspace then
            return nil
        end

        if CollectionService:HasTag(p22, "PlotAnimal") then
            break
        end

        p22 = p22.Parent
    end

    return p22
end

local function blockersBetween(p23, p24, p25) -- line: 404
    -- upvalues: plotAnimalOf (copy)
    local t11 = {}
    local v86 = table.clone(p25)
    local v87 = RaycastParams.new()

    v87.FilterType = Enum.RaycastFilterType.Exclude

    for _ = 1, 6 do
        v87.FilterDescendantsInstances = v86

        local v88 = workspace:Raycast(p23, p24 - p23, v87)

        if not v88 then
            break
        end

        local v89 = plotAnimalOf(v88.Instance)

        if v89 then
            t11[v89] = true
            table.insert(v86, v89)
        else
            table.insert(v86, v88.Instance)
        end
    end

    return t11
end

local function newOcclusion(p26) -- line: 425
    -- upvalues: blockersBetween (copy)
    local t12 = {}
    local t13 = {}

    local function apply(p27, p28) -- line: 428
        for _, descendant in ipairs(p27:GetDescendants()) do
            if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                descendant.LocalTransparencyModifier = p28
            end
        end
    end

    function t13.Update(p29, p30) -- line: 435
        -- upvalues: p26 (copy), t12 (ref), apply (copy), blockersBetween (copy)
        local CFramePosition = workspace.CurrentCamera.CFrame.Position
        local t14 = {}

        for _, v90 in ipairs(p29) do
            for v91 in pairs((blockersBetween(v90, CFramePosition, p26))) do
                t14[v91] = true
            end
        end

        for v92 in pairs(t14) do
            if not t12[v92] then
                local Outline = v92:FindFirstChild("Outline")

                t12[v92] = {
                    Alpha = 0,
                    Outline = Outline and Outline.Enabled
                }

                if Outline then
                    Outline.Enabled = false
                end
            end
        end

        for v93, v94 in pairs(t12) do
            if v93.Parent then
                local v95 = if t14[v93] then 0.88 else 0

                v94.Alpha = v94.Alpha + (v95 - v94.Alpha) * math.min(1, p30 * 10)
                apply(v93, v94.Alpha)

                if not t14[v93] and v94.Alpha < 0.02 then
                    apply(v93, 0)

                    local Outline = v93:FindFirstChild("Outline")

                    if Outline and v94.Outline then
                        Outline.Enabled = true
                    end

                    t12[v93] = nil
                end

                continue
            end

            t12[v93] = nil
        end
    end

    function t13.Restore() -- line: 464
        -- upvalues: t12 (ref), apply (copy)
        for v98, v99 in pairs(t12) do
            if v98.Parent then
                apply(v98, 0)

                local Outline = v98:FindFirstChild("Outline")

                if Outline and v99.Outline then
                    Outline.Enabled = true
                end
            end
        end

        t12 = {}
    end

    return t13
end

local function bestAngle(p31, p32, p33, p34) -- line: 479
    -- upvalues: blockersBetween (copy)
    local v100 = p33
    local n2 = 1e999

    for i = 0, 11 do
        local v101 = p33 + i * 0.5235987755982988
        local v102 = p32 * 2.4
        local v106 = p31 + Vector3.new(math.sin(v101) * v102, p32 * 0.8, math.cos(v101) * v102)
        local n3 = 0

        for _ in pairs((blockersBetween(p31, v106, p34))) do
            n3 += 1
        end

        local v108 = math.abs((v101 - p33 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793)
        local v109 = n3 * 10 + v108

        if v109 < n2 then
            n2 = v109
            v100 = v101
        end
    end

    return v100
end

local function makeFillIn(p35) -- line: 494
    local t19 = {}
    local t20 = {}

    for i = 1, #p35 do
        local v110 = p35:sub(i, i)

        t19[i] = v110

        if v110:match("%w") then
            table.insert(t20, i)
        end
    end

    for i = #t20, 2, -1 do
        local v111 = math.random(1, i)
        local v112 = t20[v111]
        local v113 = t20[i]

        t20[i] = v112
        t20[v111] = v113
    end

    local n4 = -1

    return function(p36) -- line: 506
        -- upvalues: t19 (copy), t20 (copy), n4 (ref)
        local v115 = math.floor(math.clamp(p36, 0, 1) * #t20 + 1E-06)

        if v115 == n4 then
            return nil
        end

        n4 = v115

        local t21 = {}

        for i = 1, v115 do
            t21[t20[i]] = true
        end

        local t22 = {}

        for v116, v117 in ipairs(t19) do
            if not v117:match("%w") or t21[v116] then
                t22[v116] = v117
            else
                t22[v116] = "_"
            end
        end

        return table.concat(t22)
    end
end

local function waitForTap(p37, p38) -- line: 520
    -- upvalues: UserInputService (copy)
    local elapsed = os.clock()
    local v118 = false
    local connection = UserInputService.InputBegan:Connect(function(p39) -- line: 523
        -- upvalues: p38 (copy), elapsed (copy), v118 (ref)
        local UserInputType = p39.UserInputType

        if (UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch or UserInputType == Enum.UserInputType.Keyboard and (p39.KeyCode == Enum.KeyCode.Space or p39.KeyCode == Enum.KeyCode.Return) or UserInputType == Enum.UserInputType.Gamepad1 and p39.KeyCode == Enum.KeyCode.ButtonA) and os.clock() - elapsed >= (p38 or 0) then
            v118 = true
        end
    end)

    while not v118 and os.clock() - elapsed < p37 do
        task.wait()
    end

    connection:Disconnect()
end

local function findAnimal(p40, p41) -- line: 535
    -- upvalues: LocalPlayer (copy)
    local PlotIndex = LocalPlayer:GetAttribute("PlotIndex")

    PlotIndex = PlotIndex and workspace:FindFirstChild("Plots") and workspace.Plots:FindFirstChild((tostring(PlotIndex)))

    local Animals = PlotIndex and PlotIndex:FindFirstChild("Animals")
    local v119 = os.clock() + (p41 or 2.5)

    while true do
        if not (os.clock() < v119) then
            return nil
        end

        if Animals then
            for _, child in ipairs(Animals:GetChildren()) do
                if child:GetAttribute("AnimalId") == p40.AnimalId and child.PrimaryPart then
                    return child
                end
            end
        end

        task.wait()
    end
end

local function runCinematic(p42) -- line: 551
    -- upvalues: RunService (copy), TweenService (copy), CollectionService (copy), ReplicatedStorage (copy), EggsConfig (copy), RarityConfig (copy), AnimalUtil (copy), Boosts (copy), UIKit (copy), Sounds (copy), CameraRig (copy), ScreenFX (copy), RevealCard (copy), HUDController (copy), ClientState (copy), Movement (copy), AnimalVisuals (copy), LocalPlayer (copy), t4 (copy), emitBurst (copy), newOcclusion (copy), bestAngle (copy), makeFillIn (copy), waitForTap (copy), findAnimal (copy)
    local Model = p42.Model
    local cleanup

    if not Model.Parent or p42.Exploded then
        return
    else
        ClientState.Busy = "Hatch"
        Movement.Lock()
        HUDController.SetGameplayVisible(false)

        local v121 = UIKit.ScreenGui("EggHatch", 150, true)
        local t23 = {}

        function cleanup() -- line: 559
            -- upvalues: v121 (copy), t23 (copy), CameraRig (copy), ScreenFX (copy), HUDController (copy), ClientState (copy), Movement (copy)
            for _, v122 in ipairs(t23) do
                pcall(v122)
            end

            v121:Destroy()
            ScreenFX.HideBars(0.35)
            ScreenFX.SetVignetteStyle(nil)
            ScreenFX.SetVignette(0, 0.4, Color3.new(0, 0, 0))
            CameraRig.Release()
            Movement.Unlock()
            HUDController.SetGameplayVisible(true)
            ClientState.Busy = nil
        end

        local function v123() -- line: 570
            -- upvalues: p42 (copy), Model (copy), v121 (copy), t23 (copy), RunService (copy), TweenService (copy), CollectionService (copy), ReplicatedStorage (copy), EggsConfig (copy), RarityConfig (copy), AnimalUtil (copy), Boosts (copy), UIKit (copy), Sounds (copy), CameraRig (copy), ScreenFX (copy), RevealCard (copy), AnimalVisuals (copy), LocalPlayer (copy), t4 (copy), emitBurst (copy), newOcclusion (copy), bestAngle (copy), makeFillIn (copy), waitForTap (copy), findAnimal (copy)
            local Duration, Center, Height = p42.Duration, p42.Center, p42.Height
            local v124 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local v125 = if v124 then Vector3.new(v124.Position.X - Center.X, 0, v124.Position.Z - Center.Z) or Vector3.new(0, 0, -1) else Vector3.new(0, 0, -1)

            if v125.Magnitude < 0.1 then
                v125 = Vector3.new(0, 0, -1)
            end

            local t24 = {
                Model
            }

            if LocalPlayer.Character then
                table.insert(t24, LocalPlayer.Character)
            end

            local t25 = {}

            for _, v128 in ipairs(CollectionService:GetTagged("PlotAnimal")) do
                for _, descendant in ipairs(AnimalVisuals.ShownModel(v128):GetDescendants()) do
                    if descendant:IsA("BillboardGui") and descendant.Name == "InfoBillboard" and descendant.Enabled then
                        descendant.Enabled = false
                        table.insert(t25, descendant)
                    end
                end
            end

            table.insert(t23, function() -- line: 591
                -- upvalues: t25 (copy)
                for _, v130 in ipairs(t25) do
                    if v130.Parent then
                        v130.Enabled = true
                    end
                end
            end)

            local v131 = bestAngle(Center, Height, math.atan2(v125.X, v125.Z), t24)
            local v132 = newOcclusion(t24)
            local t26 = {
                Center,
                Center + Vector3.new(0, Height * 0.4, 0)
            }
            local connection = RunService.RenderStepped:Connect(function(p43) -- line: 599
                -- upvalues: v132 (copy), t26 (copy)
                v132.Update(t26, p43)
            end)

            table.insert(t23, function() -- line: 602
                -- upvalues: v132 (copy), connection (copy)
                connection:Disconnect()
                v132.Restore()
            end)

            local _CFrame = workspace.CurrentCamera.CFrame

            CameraRig.Take()
            CameraRig.SetHandheld(0.5)
            CameraRig.SetShot(function() -- line: 609
                -- upvalues: _CFrame (copy)
                return _CFrame, 70
            end)

            local function v135() -- line: 610
                -- upvalues: Duration (copy), Center (copy), Height (copy), v131 (copy), p42 (copy), TweenService (copy)
                local Value = TweenService:GetValue(math.clamp((workspace:GetServerTimeNow() - p42.Start) / Duration, 0, 1), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                local v139 = v131 + math.rad(-20 + 40 * Value)
                local v140 = Height * (3.1 - 1.3 * Value)
                local v141 = Height * (0.95 - 0.35 * Value)
                local v143 = Center + Vector3.new(0, Height * 0.05, 0)
                local v146 = v143 + Vector3.new(math.sin(v139) * v140, v141, math.cos(v139) * v140)

                return CFrame.lookAt(v146, v143), 62 - 12 * Value
            end

            CameraRig.BlendTo(v135, 0.9, Enum.EasingStyle.Sine)
            ScreenFX.ShowBars(0.5)
            ScreenFX.SetVignette(0.45, 0.8, Color3.new(0, 0, 0))

            local v147 = UIKit.Text({
                ZIndex = 10,
                Stroke = 4,
                Parent = v121,
                Text = string.upper(p42.Cfg.Name or "EGG"),
                Size = UDim2.fromScale(0.5, 0.06),
                Position = UDim2.fromScale(0.5, 0.16),
                AnchorPoint = Vector2.new(0.5, 0.5)
            })

            if p42.Cfg.Rainbow then
                local v148 = UIKit.Gradient(v147, ColorSequence.new({
                    ColorSequenceKeypoint.new(0, t4[1]),
                    ColorSequenceKeypoint.new(0.33, t4[3]),
                    ColorSequenceKeypoint.new(0.66, t4[5]),
                    ColorSequenceKeypoint.new(1, t4[7])
                }), 0)
                local connection = RunService.RenderStepped:Connect(function() -- line: 632
                    -- upvalues: v148 (copy)
                    v148.Offset = Vector2.new(math.sin(os.clock() * 2) * 0.3, 0)
                end)

                table.insert(t23, function() -- line: 635
                    -- upvalues: connection (copy)
                    connection:Disconnect()
                end)
            else
                v147.TextColor3 = p42.Cfg.Color or Color3.new(1, 1, 1)
            end

            local v152 = UIKit.Text({
                Text = "HATCHING",
                ZIndex = 10,
                Stroke = 3,
                TextTransparency = 0.1,
                Parent = v121,
                Size = UDim2.fromScale(0.3, 0.04),
                Position = UDim2.fromScale(0.5, 0.215),
                AnchorPoint = Vector2.new(0.5, 0.5)
            })

            UIKit.PopIn(v147, 0.4, 0.4)

            local connection2 = RunService.RenderStepped:Connect(function() -- line: 641
                -- upvalues: v152 (copy)
                local v154 = math.floor(os.clock() * 3) % 4

                v152.Text = "HATCHING" .. string.rep(".", v154)
            end)

            table.insert(t23, function() -- line: 645
                -- upvalues: connection2 (copy)
                connection2:Disconnect()
            end)

            p42.OnBurst = function(_, p45) -- line: 648
                -- upvalues: v147 (copy), p42 (copy), UIKit (copy), CameraRig (copy), ScreenFX (copy), t4 (copy)
                CameraRig.Shake(0.25 + p45 * 0.9, 0.3, 22)

                local PulseVignette = ScreenFX.PulseVignette
                local v156 = 0.55 + p45 * 0.3
                local v157

                if p42.Cfg.Rainbow then
                    local elapsed = os.clock()
                    local v158 = #t4
                    local v159 = elapsed * 2.2 % v158
                    local v160 = math.floor(v159) + 1
                    local v161 = v160 % v158 + 1

                    v157 = t4[v160]:Lerp(t4[v161], v159 - math.floor(v159)) or p42.Cfg.Color
                else
                    v157 = p42.Cfg.Color
                end

                PulseVignette(v156, 0.35, v157)
                UIKit.Punch(v147, 0.08 + p45 * 0.12, 0.3)
            end

            local v162 = p42.Start + Duration - workspace:GetServerTimeNow() - 2.2

            task.delay(math.max(0, v162), function() -- line: 656
                -- upvalues: v162 (copy), p42 (copy), Sounds (copy)
                if p42.Exploded then
                    return
                end

                Sounds.Play("EggRiser", {
                    Start = math.max(0, 1.8 - math.max(0, -v162))
                })
            end)

            local v165 = false

            p42.OnExplode = function() -- line: 662
                -- upvalues: v165 (ref)
                v165 = true
            end

            local elapsed = os.clock()

            while not v165 do
                local v166 = true

                if p42.Exploded then
                elseif os.clock() - elapsed < Duration + 3 then
                    local v168 = math.clamp((workspace:GetServerTimeNow() - p42.Start) / Duration, 0, 1)

                    if v168 > 0.9 then
                        CameraRig.SetHandheld((v168 - 0.9) * 14 + 0.5)
                    end

                    v166 = false
                end

                if v166 then
                    break
                end

                task.wait()
            end

            connection2:Disconnect()
            CameraRig.SetHandheld(0.5)

            local v169

            if p42.Cfg.Rainbow then
                local elapsed = os.clock()
                local v170 = #t4
                local v171 = elapsed * 2.2 % v170
                local v172 = math.floor(v171) + 1
                local v173 = v172 % v170 + 1

                v169 = t4[v172]:Lerp(t4[v173], v171 - math.floor(v171)) or p42.Cfg.Color or Color3.new(1, 1, 1)
            else
                v169 = p42.Cfg.Color or Color3.new(1, 1, 1)
            end

            ScreenFX.Flash(Color3.new(1, 1, 1), 0.92, 0.8)
            ScreenFX.HideBars(0.5)
            ScreenFX.Ring(v169, 0.8, 60)
            task.delay(0.12, function() -- line: 678
                -- upvalues: ScreenFX (copy)
                ScreenFX.Ring(Color3.new(1, 1, 1), 0.9, 40)
            end)
            CameraRig.Shake(1.4, 0.7, 16)
            CameraRig.PunchFOV(14, 0.05, 0.6)
            Sounds.Play("RareReveal")
            UIKit.PopOut(v147, 0.2)
            v152.Visible = false

            local v174 = findAnimal(p42, 2.5)

            v174 = v174 and AnimalVisuals.ShownModel(v174, 1)

            local ResultModel = Model:GetAttribute("ResultModel")
            local v175 = Model:GetAttribute("ResultName") or ResultModel or "???"
            local v176 = Model:GetAttribute("ResultRarity") or "Common"
            local v177 = RarityConfig.Get(v176)
            local ResultMutation = Model:GetAttribute("ResultMutation")
            local v178 = Model:GetAttribute("ResultSize") or 1
            local v179 = Model:GetAttribute("ResultIncome") or 0
            local v180 = Model:GetAttribute("ResultIsNew") == true

            if v174 then
                local v181, v182 = AnimalUtil.GetBoundingBox(v174)

                table.insert(t24, v174)
                t26[1] = v181.Position
                t26[2] = v181.Position + Vector3.new(0, v182.Y * 0.3, 0)

                local LookVector = v174:GetPivot().LookVector
                local v185 = Vector3.new(-LookVector.Z, 0, LookVector.X)
                local Unit = (Vector3.new(LookVector.X, 0, LookVector.Z).Unit * 0.8 + v185 * 0.45).Unit
                local CurrentCamera = workspace.CurrentCamera
                local v188 = math.atan(math.max(CurrentCamera.ViewportSize.X / math.max(CurrentCamera.ViewportSize.Y, 1), 0.3) * 0.5205670505517462) * 2
                local v189 = v182.Magnitude / 2
                local v191 = v189 / math.tan(math.min(0.9599310885968813, v188) / 2) * 1.25
                local v193 = v181.Position - Vector3.new(0, v189 * 0.15, 0)

                local function v194(p46) -- line: 716
                    -- upvalues: v174 (ref), Unit (copy), v189 (copy), v191 (copy), v193 (ref), AnimalUtil (copy)
                    if v174.Parent then
                        local v196 = AnimalUtil.GetBoundingBox(v174).Position - Vector3.new(0, v189 * 0.15, 0)

                        v193 = v193:Lerp(v196, 0.15)
                    end

                    local v201 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), math.sin(p46 * 0.3) * 0.12):VectorToWorldSpace(Unit * v191 + Vector3.new(0, v191 * 0.28, 0))

                    return CFrame.lookAt(v193 + v201, v193), 55
                end

                local function setTag(p47) -- line: 726
                    -- upvalues: v174 (ref)
                    for _, descendant in ipairs(v174:GetDescendants()) do
                        if descendant:IsA("BillboardGui") and descendant.Name == "InfoBillboard" then
                            descendant.Enabled = p47
                        end
                    end
                end

                setTag(false)
                task.delay(0.3, function() -- line: 732
                    -- upvalues: setTag (copy)
                    setTag(false)
                end)
                table.insert(t23, function() -- line: 733
                    -- upvalues: v174 (ref), setTag (copy)
                    if v174.Parent then
                        setTag(true)
                    end
                end)
                CameraRig.BlendTo(v194, 1.1, Enum.EasingStyle.Quart)
                AnimalUtil.SetOutline(v174, v177.Color)
                task.delay(1.6, function() -- line: 736
                    -- upvalues: v174 (ref), AnimalUtil (copy)
                    if v174.Parent then
                        AnimalUtil.SetOutline(v174, Color3.new(0, 0, 0))
                    end
                end)
            end

            local v203 = RevealCard.new(v121, {
                Mutation = ResultMutation,
                Size = v178
            })
            local v204 = makeFillIn(string.upper(v175))

            v203:SetName(v204(0) or "")

            local elapsed2 = os.clock()

            while os.clock() - elapsed2 < 1.1 do
                local v205 = (os.clock() - elapsed2) / 1.1
                local v206 = v204(v205)

                if v206 then
                    v203:SetName(v206)
                    Sounds.Play("LetterTick", {
                        Volume = 0.22,
                        Pitch = 1 + v205 * 0.5
                    })
                end

                task.wait()
            end

            if v203:LockIn({
                Name = v175,
                Mutation = ResultMutation,
                Size = v178,
                Rarity = v176,
                IncomeText = Boosts.AnimalIncomeText(v179, LocalPlayer, Model:GetAttribute("ResultOfBest")),
                IsNew = v180
            }) then
                Sounds.Play("LevelUp", {
                    Volume = 0.6,
                    Pitch = 1.15,
                    Delay = 0.1
                })
            end

            Sounds.Play("BassHit")
            Sounds.Play("Reveal")
            ScreenFX.Flash(v177.Color, 0.35, 0.6)
            ScreenFX.Ring(v177.Color, 0.8, 60)
            ScreenFX.PulseVignette(0.75, 0.8, v177.Color)

            if ResultMutation then
                local v207 = require(ReplicatedStorage.Config.MutationsConfig).Get(ResultMutation)

                if v207 and v207.Vignette then
                    task.delay(0.8, function() -- line: 775
                        -- upvalues: v207 (copy), v121 (copy), ScreenFX (copy)
                        if v121.Parent then
                            ScreenFX.SetVignetteStyle(v207.Vignette)
                            ScreenFX.SetVignette(0.5, 0.5)
                        end
                    end)
                end
            end

            CameraRig.PunchFOV(8, 0.06, 0.5)

            if v174 then
                local v208, v209 = AnimalUtil.GetBoundingBox(v174)

                emitBurst(v208.Position, {
                    Count = 70,
                    Color = v177.Color,
                    Speed = NumberRange.new(10, 22),
                    Size = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 0),
                        NumberSequenceKeypoint.new(0.2, (math.clamp(v209.Magnitude * 0.1, 0.8, 5))),
                        NumberSequenceKeypoint.new(1, 0)
                    })
                })
            end

            local v212 = UIKit.Text({
                Text = "tap to continue",
                ZIndex = 20,
                Stroke = 2,
                TextTransparency = 1,
                Parent = v121,
                Size = UDim2.fromScale(0.2, 0.035),
                Position = UDim2.fromScale(0.5, 0.975),
                AnchorPoint = Vector2.new(0.5, 0.5)
            })

            task.delay(EggsConfig.Hatch.SkipDelay, function() -- line: 790
                -- upvalues: v212 (copy), UIKit (copy)
                if v212.Parent then
                    UIKit.Tween(v212, {
                        TextTransparency = 0.3
                    }, 0.4)
                end
            end)
            waitForTap(EggsConfig.Hatch.ShowTime, EggsConfig.Hatch.SkipDelay)
            Sounds.Play("CameraWhoosh", {
                Volume = 0.35,
                Pitch = 1.1
            })
            ScreenFX.FadeOut(Color3.new(0, 0, 0), 0.25)
        end

        local ok, result = pcall(v123)

        if not ok then
            warn("[EggController] " .. tostring(result))
        end
    end

    cleanup()

    local CurrentCamera = workspace.CurrentCamera
    local v213 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    if v213 then
        CurrentCamera.CFrame = CFrame.lookAt(v213.Position - v213.CFrame.LookVector * 12 + Vector3.new(0, 7, 0), v213.Position)
    end

    ScreenFX.FadeIn(0.35)
end

function t1.RunCinematics() -- line: 808
    -- upvalues: ClientState (copy), t3 (copy), v1 (ref), runCinematic (copy)
    if not v1 then
        v1 = true
        task.spawn(function() -- line: 811
            -- upvalues: ClientState (copy), t3 (copy), v1 (ref), runCinematic (copy)
            while #t3 > 0 do
                local v214 = table.remove(t3, 1)
                local n5 = 0

                while ClientState.Busy and ClientState.Busy ~= "Hatch" and n5 < 3 do
                    task.wait(0.1)
                    n5 += 0.1
                end

                if v214.Model.Parent and not v214.Exploded and not ClientState.Busy then
                    runCinematic(v214)
                end
            end

            v1 = false
        end)
    end
end

function t1.Init() -- line: 828
    -- upvalues: RunService (copy), CollectionService (copy), t2 (copy), stepHatch (copy), startHatch (copy)
    for _, v215 in ipairs(CollectionService:GetTagged("HatchingEgg")) do
        task.spawn(startHatch, v215)
    end

    CollectionService:GetInstanceAddedSignal("HatchingEgg"):Connect(function(p48) -- line: 832
        -- upvalues: startHatch (copy)
        task.spawn(startHatch, p48)
    end)
    RunService.RenderStepped:Connect(function(p49) -- line: 835
        -- upvalues: t2 (copy), stepHatch (copy)
        for _, v216 in pairs(t2) do
            if not v216.Exploded then
                local ok, result = pcall(stepHatch, v216, p49)

                if not ok then
                    warn("[EggController] " .. tostring(result))
                    v216.Exploded = true
                end
            end
        end
    end)
end

return t1
