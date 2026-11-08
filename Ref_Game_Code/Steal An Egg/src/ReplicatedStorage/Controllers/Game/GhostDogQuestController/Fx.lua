-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local Flash = require(ReplicatedStorage.Client.UI.VFX.Flash)
local Shake = require(ReplicatedStorage.Client.Shake)
local v1 = Color3.fromRGB(120, 255, 175)
local t1 = {}
local n1 = 0
local t2 = {
    Ghost = v1,
    Sparkle = "rbxasset://textures/particles/sparkles_main.dds",
    Smoke = "rbxasset://textures/particles/smoke_main.dds"
}

function t2.ReducedMotion() -- line: 37
    -- upvalues: GuiService (copy)
    return GuiService.ReducedMotionEnabled
end

function t2.Tween(p1, p2, p3, p4, p5) -- line: 41
    -- upvalues: TweenService (copy)
    local tween = TweenService:Create(p1, TweenInfo.new(p2, p4 or Enum.EasingStyle.Quad, p5 or Enum.EasingDirection.Out), p3)

    tween:Play()

    return tween
end

function t2.Ease(p6, p7, p8) -- line: 61
    -- upvalues: TweenService (copy)
    return TweenService:GetValue(math.clamp(p6, 0, 1), p7 or Enum.EasingStyle.Quad, p8 or Enum.EasingDirection.Out)
end

local function resolve(p9) -- line: 69
    -- upvalues: t1 (copy)
    if type(p9) ~= "string" or string.sub(p9, 1, 12) ~= "rbxasset://s" and string.sub(p9, 1, 13) ~= "rbxassetid://" then
        return p9
    end

    local v2 = t1[p9]

    if v2 == nil then
        v2 = Instance.new("Sound")
        v2.SoundId = p9
        t1[p9] = v2
    end

    return v2
end

function t2.Play(p10, p11) -- line: 88
    -- upvalues: SoundService (copy), Audio (copy), t1 (copy)
    local v3 = p10

    if type(p10) == "string" and (string.sub(p10, 1, 12) == "rbxasset://s" or string.sub(p10, 1, 13) == "rbxassetid://") then
        v3 = t1[p10]

        if v3 == nil then
            v3 = Instance.new("Sound")
            v3.SoundId = p10
            t1[p10] = v3
        end
    end

    local v4 = table.clone(p11 or {})

    if v4.SoundGroup == nil then
        v4.SoundGroup = "SFX"
    end

    return Audio.Play(v3, SoundService, v4)
end

function t2.PlayAt(p12, p13, p14) -- line: 97
    -- upvalues: Audio (copy), t1 (copy)
    local v5 = p12

    if type(p12) == "string" and (string.sub(p12, 1, 12) == "rbxasset://s" or string.sub(p12, 1, 13) == "rbxassetid://") then
        v5 = t1[p12]

        if v5 == nil then
            v5 = Instance.new("Sound")
            v5.SoundId = p12
            t1[p12] = v5
        end
    end

    local v6 = table.clone(p14 or {})

    if v6.SoundGroup == nil then
        v6.SoundGroup = "SFX"
    end

    if v6.MaxDistance == nil then
        v6.MaxDistance = 200
    end

    return Audio.Play(v5, p13, v6)
end

local function cineShake(p15, p16) -- line: 109
    -- upvalues: RunService (copy), Workspace (copy), n1 (ref)
    n1 += 1

    local v7 = n1
    local v8 = math.random() * 1000
    local elapsed = os.clock()
    local v9 = CFrame.identity
    local v10

    RunService:UnbindFromRenderStep("GhostDogCineShake")
    RunService:BindToRenderStep("GhostDogCineShake", Enum.RenderPriority.Camera.Value + 2, function() -- line: 117
        -- upvalues: p15 (copy), p16 (copy), v7 (copy), v8 (copy), elapsed (copy), v9 (ref), v10 (ref), RunService (copy), Workspace (copy), n1 (ref)
        local CurrentCamera = Workspace.CurrentCamera
        local v12 = os.clock() - elapsed
        local _CFrame = CurrentCamera.CFrame

        if v10 and _CFrame:FuzzyEq(v10, 1E-04) then
            _CFrame *= v9:Inverse()
        end

        if v7 ~= n1 or p16 <= v12 then
            if v7 == n1 then
                CurrentCamera.CFrame = _CFrame
                RunService:UnbindFromRenderStep("GhostDogCineShake")
            end
        else
            local v13 = p15 * 0.5 * (1 - v12 / p16) ^ 2
            local v14 = v12 * 18 + v8

            v9 = CFrame.new(math.noise(v14, 1.3) * v13, math.noise(v14, 7.1) * v13, 0) * CFrame.Angles(math.noise(v14, 2.9) * v13 * 0.06, math.noise(v14, 5.3) * v13 * 0.06, math.noise(v14, 4.7) * v13 * 0.06 * 1.6)
            v10 = _CFrame * v9
            CurrentCamera.CFrame = v10
        end
    end)
end

function t2.Shake(p17, p18) -- line: 147
    -- upvalues: Workspace (copy), Shake (copy), t2 (copy), cineShake (copy)
    if not t2.ReducedMotion() then
        local CurrentCamera = Workspace.CurrentCamera

        if not CurrentCamera or CurrentCamera.CameraType ~= Enum.CameraType.Scriptable then
            Shake.Play({
                Shape = "Fade",
                Magnitude = p17,
                Seconds = p18 or 0.35
            })
        else
            cineShake(p17, p18 or 0.35)
        end
    end
end

function t2.Flash(p19, p20, p21, p22) -- line: 159
    -- upvalues: Flash (copy)
    Flash.Play({
        Attack = p21 or 0.03,
        Decay = p22 or 0.35,
        Tint = p19,
        Opacity = p20
    })
end

function t2.Burst(p23, p24, p25, p26, p27, p28) -- line: 168
    -- upvalues: Debris (copy), Workspace (copy)
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(1, 1, 1)
    Part.CFrame = CFrame.new(p23)

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Texture = p28 or "rbxasset://textures/particles/sparkles_main.dds"
    ParticleEmitter.Color = ColorSequence.new(p24)
    ParticleEmitter.LightEmission = 1
    ParticleEmitter.Rate = 0
    ParticleEmitter.Lifetime = NumberRange.new(0.4, 0.9)
    ParticleEmitter.Speed = NumberRange.new(p26 * 0.5, p26)
    ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
    ParticleEmitter.Drag = 4
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, p27),
        NumberSequenceKeypoint.new(1, 0)
    })
    ParticleEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter.Parent = Part
    Part.Parent = Workspace
    ParticleEmitter:Emit(p25)
    Debris:AddItem(Part, 1.5)
end

function t2.Ring(p29, p30, p31, p32, p33) -- line: 207
    -- upvalues: Debris (copy), Workspace (copy), t2 (copy)
    local Part = Instance.new("Part")

    Part.Shape = Enum.PartType.Cylinder
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Material = Enum.Material.Neon
    Part.Color = p30
    Part.Transparency = 0.2
    Part.Size = Vector3.new(0.15, p31, p31)
    Part.CFrame = p29 * CFrame.Angles(0, 0, 1.5707963267948966)
    Part.Parent = Workspace
    t2.Tween(Part, p33, {
        Transparency = 1,
        Size = Vector3.new(0.15, p32, p32)
    })
    Debris:AddItem(Part, p33 + 0.1)
end

local function emitter(p34, p35) -- line: 229
    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Rate = 0
    ParticleEmitter.LightEmission = 0.3
    ParticleEmitter.LockedToPart = false

    for v15, v16 in p35 do
        ParticleEmitter[v15] = v16
    end

    ParticleEmitter.Parent = p34

    return ParticleEmitter
end

function t2.Splash(p36, p37) -- line: 241
    -- upvalues: Debris (copy), Workspace (copy)
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(1, 1, 1)
    Part.CFrame = CFrame.new(p36)

    local Attachment = Instance.new("Attachment")

    Attachment.Parent = Part

    local v17 = Color3.fromRGB(165, 255, 225)
    local t3 = {
        Texture = "rbxassetid://14431663347",
        Brightness = 2,
        ZOffset = 0.5,
        FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4,
        FlipbookMode = Enum.ParticleFlipbookMode.OneShot,
        Orientation = Enum.ParticleOrientation.FacingCameraWorldUp,
        Color = ColorSequence.new(v17),
        Size = NumberSequence.new(p37 * 5.5, p37 * 7),
        Lifetime = NumberRange.new(0.45, 0.6),
        Speed = NumberRange.new(0, 0),
        Rotation = NumberRange.new(-12, 12)
    }
    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Rate = 0
    ParticleEmitter.LightEmission = 0.3
    ParticleEmitter.LockedToPart = false

    for v18, v19 in t3 do
        ParticleEmitter[v18] = v19
    end

    ParticleEmitter.Parent = Attachment

    local t4 = {
        Texture = "rbxassetid://85239189459475",
        Brightness = 2.5,
        FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4,
        FlipbookMode = Enum.ParticleFlipbookMode.OneShot,
        Orientation = Enum.ParticleOrientation.VelocityParallel,
        EmissionDirection = Enum.NormalId.Top,
        Color = ColorSequence.new(v17),
        Size = NumberSequence.new(p37 * 2.4, p37 * 1.2),
        Lifetime = NumberRange.new(0.5, 0.9),
        Speed = NumberRange.new(p37 * 16, p37 * 30),
        SpreadAngle = Vector2.new(28, 28),
        Acceleration = Vector3.new(0, p37 * -70, 0)
    }
    local ParticleEmitter2 = Instance.new("ParticleEmitter")

    ParticleEmitter2.Rate = 0
    ParticleEmitter2.LightEmission = 0.3
    ParticleEmitter2.LockedToPart = false

    for v21, v22 in t4 do
        ParticleEmitter2[v21] = v22
    end

    ParticleEmitter2.Parent = Attachment

    local t5 = {
        Texture = "rbxasset://textures/particles/sparkles_main.dds",
        LightEmission = 1,
        Drag = 1,
        EmissionDirection = Enum.NormalId.Top,
        Color = ColorSequence.new(Color3.fromRGB(220, 255, 245)),
        Size = NumberSequence.new(p37 * 0.5, 0),
        Lifetime = NumberRange.new(0.6, 1.1),
        Speed = NumberRange.new(p37 * 14, p37 * 26),
        SpreadAngle = Vector2.new(55, 55),
        Acceleration = Vector3.new(0, p37 * -60, 0)
    }
    local ParticleEmitter3 = Instance.new("ParticleEmitter")

    ParticleEmitter3.Rate = 0
    ParticleEmitter3.LightEmission = 0.3
    ParticleEmitter3.LockedToPart = false

    for v24, v25 in t5 do
        ParticleEmitter3[v24] = v25
    end

    ParticleEmitter3.Parent = Attachment

    local t6 = {
        Texture = "rbxassetid://90951481407921",
        LightEmission = 0.8,
        Orientation = Enum.ParticleOrientation.VelocityPerpendicular,
        EmissionDirection = Enum.NormalId.Top,
        Color = ColorSequence.new(v17),
        Size = NumberSequence.new(p37 * 2, p37 * 18),
        Transparency = NumberSequence.new(0.1, 1),
        Lifetime = NumberRange.new(0.7, 0.9),
        Speed = NumberRange.new(0.01, 0.01),
        Rotation = NumberRange.new(0, 360)
    }
    local ParticleEmitter4 = Instance.new("ParticleEmitter")

    ParticleEmitter4.Rate = 0
    ParticleEmitter4.LightEmission = 0.3
    ParticleEmitter4.LockedToPart = false

    for v26, v27 in t6 do
        ParticleEmitter4[v26] = v27
    end

    ParticleEmitter4.Parent = Attachment

    local t7 = {
        Texture = "rbxasset://textures/particles/smoke_main.dds",
        Color = ColorSequence.new(Color3.fromRGB(200, 255, 240)),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.5),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Size = NumberSequence.new(p37 * 3, p37 * 8),
        Lifetime = NumberRange.new(0.8, 1.2),
        Speed = NumberRange.new(2, 5),
        SpreadAngle = Vector2.new(70, 70),
        EmissionDirection = Enum.NormalId.Top,
        Rotation = NumberRange.new(0, 360)
    }
    local ParticleEmitter5 = Instance.new("ParticleEmitter")

    ParticleEmitter5.Rate = 0
    ParticleEmitter5.LightEmission = 0.3
    ParticleEmitter5.LockedToPart = false

    for v28, v29 in t7 do
        ParticleEmitter5[v28] = v29
    end

    ParticleEmitter5.Parent = Attachment
    Part.Parent = Workspace
    ParticleEmitter:Emit((math.max(1, (math.floor(p37 * 2)))))
    ParticleEmitter2:Emit(math.floor(p37 * 8) + 2)
    ParticleEmitter3:Emit(math.floor(p37 * 22) + 4)
    ParticleEmitter4:Emit(1)
    ParticleEmitter5:Emit(math.floor(p37 * 4) + 1)
    task.delay(0.18, function() -- line: 324
        -- upvalues: Part (copy), ParticleEmitter4 (copy)
        if Part.Parent then
            ParticleEmitter4:Emit(1)
        end
    end)
    task.delay(0.36, function() -- line: 329
        -- upvalues: Part (copy), ParticleEmitter4 (copy)
        if Part.Parent then
            ParticleEmitter4:Emit(1)
        end
    end)
    Debris:AddItem(Part, 2.5)
end

function t2.Ripple(p38, p39) -- line: 337
    -- upvalues: Debris (copy), Workspace (copy)
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(1, 1, 1)
    Part.CFrame = CFrame.new(p38)

    local Attachment = Instance.new("Attachment")

    Attachment.Parent = Part

    local t8 = {
        Texture = "rbxassetid://90951481407921",
        LightEmission = 0.8,
        Orientation = Enum.ParticleOrientation.VelocityPerpendicular,
        EmissionDirection = Enum.NormalId.Top,
        Color = ColorSequence.new(Color3.fromRGB(165, 255, 225)),
        Size = NumberSequence.new(p39 * 1.5, p39 * 12),
        Transparency = NumberSequence.new(0.15, 1),
        Lifetime = NumberRange.new(0.6, 0.8),
        Speed = NumberRange.new(0.01, 0.01),
        Rotation = NumberRange.new(0, 360)
    }
    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Rate = 0
    ParticleEmitter.LightEmission = 0.3
    ParticleEmitter.LockedToPart = false

    for v35, v36 in t8 do
        ParticleEmitter[v35] = v36
    end

    ParticleEmitter.Parent = Attachment

    local t9 = {
        Texture = "rbxasset://textures/particles/sparkles_main.dds",
        LightEmission = 1,
        Acceleration = Vector3.new(0, -40, 0),
        EmissionDirection = Enum.NormalId.Top,
        Color = ColorSequence.new(Color3.fromRGB(220, 255, 245)),
        Size = NumberSequence.new(p39 * 0.35, 0),
        Lifetime = NumberRange.new(0.4, 0.7),
        Speed = NumberRange.new(p39 * 6, p39 * 12),
        SpreadAngle = Vector2.new(40, 40)
    }
    local ParticleEmitter2 = Instance.new("ParticleEmitter")

    ParticleEmitter2.Rate = 0
    ParticleEmitter2.LightEmission = 0.3
    ParticleEmitter2.LockedToPart = false

    for v37, v38 in t9 do
        ParticleEmitter2[v37] = v38
    end

    ParticleEmitter2.Parent = Attachment
    Part.Parent = Workspace
    ParticleEmitter:Emit(1)
    ParticleEmitter2:Emit(math.floor(p39 * 8) + 2)
    Debris:AddItem(Part, 1.5)
end

function t2.RippleEmitter(p40, p41, p42) -- line: 377
    -- upvalues: v1 (copy)
    local t10 = {
        Texture = "rbxassetid://90951481407921",
        LightEmission = 1,
        Orientation = Enum.ParticleOrientation.VelocityPerpendicular,
        EmissionDirection = Enum.NormalId.Top,
        Color = ColorSequence.new(v1),
        Size = NumberSequence.new(p42 * 1.5, p42 * 11),
        Transparency = NumberSequence.new(0.2, 1),
        Lifetime = NumberRange.new(1.1, 1.3),
        Speed = NumberRange.new(0.01, 0.01),
        Rotation = NumberRange.new(0, 360),
        Rate = p41
    }
    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Rate = 0
    ParticleEmitter.LightEmission = 0.3
    ParticleEmitter.LockedToPart = false

    for v40, v41 in t10 do
        ParticleEmitter[v40] = v41
    end

    ParticleEmitter.Parent = p40

    return ParticleEmitter
end

function t2.Punch(p43, p44, p45) -- line: 393
    -- upvalues: t2 (copy)
    p43.Scale = p44
    t2.Tween(p43, p45, {
        Scale = 1
    }, Enum.EasingStyle.Back)
end

return table.freeze(t2)
