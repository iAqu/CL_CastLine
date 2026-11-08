-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local BanjoCricket = require(ReplicatedStorage.Data.BanjoCricket)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Score = require(script.Score)
local Shapes = require(script.Shapes)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Tunnel = require(script.Tunnel)
local Vortex = require(script.Vortex)
local v1 = Enum.RenderPriority.Camera.Value + 1
local v2 = CFrame.new(6200, 30000, 16900)
local v3 = Color3.new(1, 1, 1)
local t1 = {
    Brightness = 0,
    Contrast = 0,
    Saturation = 0,
    Bloom = 0,
    Blur = 0,
    Tint = v3
}
local t2 = {
    Brightness = 0.04,
    Contrast = 0.2,
    Saturation = 0.75,
    Bloom = 1.4,
    Blur = 0,
    Tint = Color3.fromRGB(255, 200, 245)
}
local t3 = {
    Brightness = 0.5,
    Contrast = 0.05,
    Saturation = 0.4,
    Bloom = 3,
    Blur = 14,
    Tint = Color3.fromRGB(255, 232, 250)
}
local t4 = {
    Brightness = 0.03,
    Contrast = 0.22,
    Saturation = 0.6,
    Bloom = 1.2,
    Blur = 1,
    Tint = v3
}
local t5 = {
    Brightness = 0.85,
    Contrast = -0.1,
    Saturation = 0.3,
    Bloom = 3.5,
    Blur = 22,
    Tint = Color3.fromRGB(255, 240, 252)
}
local t6 = {
    Brightness = 0.12,
    Contrast = 0.15,
    Saturation = 0.7,
    Bloom = 1,
    Blur = 0,
    Tint = Color3.fromRGB(255, 215, 245)
}
local t7 = {
    Brightness = 0.7,
    Contrast = -0.4,
    Saturation = 0.25,
    Bloom = 1.5,
    Blur = 40,
    Tint = Color3.fromRGB(255, 225, 248)
}
local t8 = {
    Brightness = 0.2,
    Contrast = 0,
    Saturation = 0.35,
    Bloom = 0.8,
    Blur = 6,
    Tint = Color3.fromRGB(255, 232, 250)
}
local LocalPlayer = Players.LocalPlayer
local result
local t9 = {}

local function ease(p1, p2, p3) -- line: 232
    -- upvalues: TweenService (copy)
    return TweenService:GetValue(math.clamp(p1, 0, 1), p2, p3)
end

local function mix(p4, p5, p6, p7) -- line: 240
    local v4 = math.clamp(p7, 0, 1)

    p4.Brightness = math.lerp(p5.Brightness, p6.Brightness, v4)
    p4.Contrast = math.lerp(p5.Contrast, p6.Contrast, v4)
    p4.Saturation = math.lerp(p5.Saturation, p6.Saturation, v4)
    p4.Tint = p5.Tint:Lerp(p6.Tint, v4)
    p4.Bloom = math.lerp(p5.Bloom, p6.Bloom, v4)
    p4.Blur = math.lerp(p5.Blur, p6.Blur, v4)
end

local function dreamTint(p8) -- line: 251
    return Color3.fromHSV(p8 * 0.12 % 1, 0.22, 1)
end

local function grade(p9, p10) -- line: 255
    local v5 = p9:Add(Instance.new("ColorCorrectionEffect"))

    v5.Name = "BanjoDream"
    v5.Parent = p10

    local v6 = p9:Add(Instance.new("BloomEffect"))

    v6.Name = "BanjoDream"
    v6.Intensity = 0
    v6.Size = 40
    v6.Threshold = 0.9
    v6.Parent = p10

    local v7 = p9:Add(Instance.new("BlurEffect"))

    v7.Name = "BanjoDream"
    v7.Size = 0
    v7.Parent = p10

    return {
        Color = v5,
        Bloom = v6,
        Blur = v7
    }
end

local function applyLook(p11, p12) -- line: 272
    local Look, Grade = p11.Look, p11.Grade

    Grade.Color.Brightness = Look.Brightness + p12 * 0.04
    Grade.Color.Contrast = Look.Contrast
    Grade.Color.Saturation = Look.Saturation
    Grade.Color.TintColor = Look.Tint
    Grade.Bloom.Intensity = Look.Bloom + p12 * 0.3
    Grade.Blur.Size = Look.Blur
end

local function burst(p13, p14) -- line: 283
    -- upvalues: Workspace (copy), BanjoCricket (copy), Shapes (copy)
    local v8 = p13:Add(Instance.new("Attachment"))

    v8.Name = "BanjoDream"
    v8.Parent = Workspace.Terrain

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Name = "Spores"
    ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    ParticleEmitter.Rate = 0
    ParticleEmitter.Speed = NumberRange.new(16, 30)
    ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
    ParticleEmitter.Lifetime = NumberRange.new(0.8, 1.4)
    ParticleEmitter.Drag = 3
    ParticleEmitter.Size = NumberSequence.new(0.7, 0)
    ParticleEmitter.LightEmission = 1
    ParticleEmitter.Brightness = 2
    ParticleEmitter.Rotation = NumberRange.new(0, 360)
    ParticleEmitter.RotSpeed = NumberRange.new(-200, 200)
    ParticleEmitter.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 90, 220)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(90, 200, 255)),
        ColorSequenceKeypoint.new(0.66, Color3.fromRGB(255, 230, 90)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 255, 140))
    })
    ParticleEmitter.Parent = v8

    local ParticleEmitter2 = Instance.new("ParticleEmitter")

    ParticleEmitter2.Name = "Notes"
    ParticleEmitter2.Texture = "rbxassetid://243331916"
    ParticleEmitter2.Rate = 0
    ParticleEmitter2.Speed = NumberRange.new(7, 13)
    ParticleEmitter2.SpreadAngle = Vector2.new(70, 70)
    ParticleEmitter2.EmissionDirection = Enum.NormalId.Top
    ParticleEmitter2.Lifetime = NumberRange.new(1.2, 1.8)
    ParticleEmitter2.Drag = 1.5
    ParticleEmitter2.Acceleration = Vector3.new(0, 2, 0)
    ParticleEmitter2.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.9),
        NumberSequenceKeypoint.new(0.2, 1.4),
        NumberSequenceKeypoint.new(1, 1.1)
    })
    ParticleEmitter2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.7, 0.1),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter2.LightEmission = 0.5
    ParticleEmitter2.Rotation = NumberRange.new(-20, 20)

    local t10 = {}

    for v9, v10 in BanjoCricket.Mushrooms do
        local v13 = (v9 - 1) / math.max(#BanjoCricket.Mushrooms - 1, 1)

        table.insert(t10, ColorSequenceKeypoint.new(v13, v10.Color))
    end

    ParticleEmitter2.Color = ColorSequence.new(t10)
    ParticleEmitter2.Parent = v8

    local v14 = Shapes.Circle("Shockwave", 0.1)

    Shapes.Paint(v14, 0.8, 1)
    p13:Add(v14.Hub)
    v14.Hub.Parent = p14

    return {
        Anchor = v8,
        Spores = ParticleEmitter,
        Notes = ParticleEmitter2,
        Wave = v14
    }
end

local function headingOf(p15, p16) -- line: 343
    local AssemblyLinearVelocity = p15.AssemblyLinearVelocity
    local v15 = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z)

    if v15.Magnitude > 2 then
        return v15.Unit
    end

    local LookVector = p16.CFrame.LookVector
    local v16 = Vector3.new(LookVector.X, 0, LookVector.Z)

    if v16.Magnitude > 0.01 then
        return v16.Unit
    end

    return (Vector3.new(-0, -0, -1, -0))
end

local function floorBelow(p17, p18) -- line: 359
    -- upvalues: Workspace (copy)
    local v17 = RaycastParams.new()

    v17.FilterType = Enum.RaycastFilterType.Exclude
    v17.FilterDescendantsInstances = p18
    v17.RespectCanCollide = true

    local v18 = Workspace:Raycast(p17.Position, Vector3.new(0, -160, 0), v17)

    if v18 then
        return v18.Position.Y
    end

    return p17.Position.Y - 50
end

local function mushroomTemplate() -- line: 372
    -- upvalues: ReplicatedStorage (copy)
    local Dream = ReplicatedStorage.Assets.VFX.BanjoCricket:FindFirstChild("Dream")
    local Mushroom = Dream and Dream:FindFirstChild("Mushroom")

    return if Mushroom and Mushroom:IsA("Model") then Mushroom else nil
end

local function restoreCamera(p19) -- line: 379
    if p19.OwnsCamera then
        local Camera = p19.Camera

        Camera.FieldOfView = p19.FieldOfView

        local HandBack = p19.HandBack

        if HandBack then
            Camera.CFrame = HandBack
        end

        Camera.CameraType = Enum.CameraType.Custom
    end
end

local function report(p20) -- line: 392
    warn((("BanjoDream stopped: %*"):format((debug.traceback((tostring(p20)))))))
end

local function finish(p21) -- line: 396
    -- upvalues: result (ref)
    if result == p21 then
        result = nil
    end

    p21.Trove:Destroy()
end

local function landingFrame(p22, p23) -- line: 405
    local v19 = p22.Root.Position + p22.SubjectOffset

    return CFrame.lookAt(v19 - p22.Landing * p23, v19)
end

local function reachOf(p24, p25) -- line: 410
    -- upvalues: Workspace (copy)
    local v20 = RaycastParams.new()

    v20.FilterType = Enum.RaycastFilterType.Exclude
    v20.FilterDescendantsInstances = p25
    v20.RespectCanCollide = true

    local v21 = p24.Root.Position + p24.SubjectOffset
    local v22 = Workspace:Raycast(v21, -p24.Landing * p24.Zoom, v20)

    if v22 == nil then
        return p24.Zoom
    end

    return (math.max((v22.Position - v21).Magnitude - 0.6, 0.5))
end

local function pulseOf(p26, p27) -- line: 425
    if p26.Calm then
        return 0
    end

    return (math.exp(-(p27 - p26.LubAt) * 9))
end

local function heartbeat(p28, p29) -- line: 433
    -- upvalues: Score (copy)
    if p28.Born then
        return
    end

    local DubAt = p28.DubAt

    if DubAt and DubAt <= p29 then
        p28.DubAt = nil
        Score.Thump(p28.Score, false)
    end

    if p29 < p28.NextBeat then
        return
    end

    Score.Thump(p28.Score, true)
    p28.LubAt = p29
    p28.DubAt = p29 + 0.16

    local n1 = 0.36

    if p28.Phase == "Intro" then
        n1 = math.lerp(0.62, 0.4, p29 / p28.CutAt)
    elseif p28.Phase == "Ride" then
        n1 = 0.4
    end

    p28.NextBeat = p29 + n1
end

local function intro(p30, p31, p32) -- line: 455
    -- upvalues: TweenService (copy), Vortex (copy), t1 (copy), t2 (copy), t3 (copy), t7 (copy), mix (copy)
    local CutAt = p30.CutAt
    local v27 = math.clamp(p31 / CutAt, 0, 1)
    local v28 = (p31 - CutAt * 0.6) / (CutAt * 0.4)
    local Quad = Enum.EasingStyle.Quad
    local In = Enum.EasingDirection.In
    local Value = TweenService:GetValue(math.clamp(v28, 0, 1), Quad, In)
    local v29 = p31 / 0.35
    local Sine = Enum.EasingStyle.Sine
    local Out = Enum.EasingDirection.Out
    local Value2 = TweenService:GetValue(math.clamp(v29, 0, 1), Sine, Out)
    local RootPosition = p30.Root.Position

    if not p30.Swallowed then
        local v31 = math.min(p32 * 6, 1)
        local Center = p30.Center

        p30.Center = Vector3.new(math.lerp(Center.X, RootPosition.X, v31), Center.Y, (math.lerp(Center.Z, RootPosition.Z, v31)))
        p30.Swallowed = RootPosition.Y < p30.Center.Y + 1
    end

    local v34 = if p30.Calm then p31 * 0.35 else p31

    Vortex.Step(p30.Vortex, p30.Center, v34, Value2, if p30.Calm then 0 else Value)
    p30.Glow.FillTransparency = math.lerp(1, 0.35, v27)
    p30.Glow.OutlineTransparency = math.lerp(1, 0.2, v27)
    p30.Glow.FillColor = Color3.fromHSV(p31 * 0.8 % 1, 0.6, 1)

    local v35 = v27 / 0.8
    local Sine2 = Enum.EasingStyle.Sine
    local In2 = Enum.EasingDirection.In
    local Value3 = TweenService:GetValue(math.clamp(v35, 0, 1), Sine2, In2)

    mix(p30.Look, t1, if p30.Calm then t7 else t2, Value3)

    if not p30.Calm then
        mix(p30.Look, p30.Look, t3, Value)
    end

    local Camera, _CFrame, LookVector

    if not p30.OwnsCamera or p30.Calm then
        return
    else
        Camera = p30.Camera
        _CFrame = Camera.CFrame

        local v38 = p30.Center - Vector3.new(0, 6, 0) - _CFrame.Position

        LookVector = _CFrame.LookVector

        if v38.Magnitude > 0.01 then
            local v40 = 1 - math.exp(p32 * -8)

            LookVector = LookVector:Lerp(v38.Unit, v40).Unit
        end
    end

    local v42 = p30.Heading:Lerp(Vector3.new(0, 1, 0), 1 - math.clamp(-LookVector.Y, 0, 1))

    p30.Roll += Value * 7.3303828583761845 * Value * p32

    local v46 = math.sin(p31 * 6) * 0.12217304763960307 * math.min(p31 / 0.4, 1)

    Camera.CFrame = CFrame.lookAt(_CFrame.Position, _CFrame.Position + LookVector, v42) * CFrame.Angles(0, 0, v46 + p30.Roll)
    Camera.FieldOfView = math.lerp(p30.FieldOfView + math.sin(3.141592653589793 * math.clamp(p31 / (CutAt * 0.6), 0, 1)) * 16, 7, Value)
end

local function ride(p33, p34, p35, p36, p37) -- line: 521
    -- upvalues: TweenService (copy), Tunnel (copy), t3 (copy), t4 (copy), t7 (copy), t8 (copy), mix (copy)
    local v50 = p34 / 0.35
    local Quart = Enum.EasingStyle.Quart
    local Out = Enum.EasingDirection.Out
    local Value = TweenService:GetValue(math.clamp(v50, 0, 1), Quart, Out)
    local v51 = if p33.Calm then 10 else math.lerp(38, 95, Value)

    p33.Travel += v51 * p35

    local v52 = if p33.Calm then p36 * 0.35 else p36

    Tunnel.Step(p33.Tunnel, v52, p33.Travel, 0)

    if p33.Calm then
        mix(p33.Look, t7, t8, Value)
    else
        mix(p33.Look, t3, t4, Value)
        p33.Look.Tint = p33.Look.Tint:Lerp(Color3.fromHSV(v52 * 0.12 % 1, 0.22, 1), Value)
    end

    if p33.OwnsCamera then
        local Camera = p33.Camera

        if p33.Calm then
            Camera.CFrame = p33.Tunnel.Origin
        else
            p33.Roll += math.lerp(7.3303828583761845, 0.9599310885968813, Value) * p35
            Camera.CFrame = p33.Tunnel.Origin * CFrame.Angles(0, 0, p33.Roll)
            Camera.FieldOfView = math.lerp(7, 100, Value) + p37 * 4
        end
    end
end

local function birth(p38) -- line: 559
    -- upvalues: Score (copy), reachOf (copy)
    p38.Born = true
    p38.TunnelTrove:Destroy()
    Score.Birth(p38.Score)

    local Root = p38.Root
    local LookVector = Root.CFrame.LookVector
    local v53 = Vector3.new(LookVector.X, 0, LookVector.Z)

    p38.Landing = (if v53.Magnitude > 0.01 then v53.Unit else p38.Heading) * 0.9781476007338057 + Vector3.new(-0, -0.20791169, -0, -0)

    local RootParent = Root.Parent
    local t11 = {
        p38.Burst.Wave.Hub
    }

    if RootParent then
        table.insert(t11, RootParent)
    end

    p38.Reach = reachOf(p38, t11)

    local Burst = p38.Burst

    Burst.Anchor.WorldPosition = Root.Position
    Burst.Spores:Emit(60)
    Burst.Notes:Emit(10)
end

local function handBack(p39) -- line: 581
    -- upvalues: Score (copy), finish (copy)
    local Reach = p39.Reach
    local v54 = p39.Root.Position + p39.SubjectOffset

    p39.HandBack = CFrame.lookAt(v54 - p39.Landing * Reach, v54)
    p39.Scenery:Destroy()
    Score.Release(p39.Score)
    p39.Trove:Add(task.delay(2.6, finish, p39))
end

local function outro(p40, p41, p42, p43) -- line: 588
    -- upvalues: TweenService (copy), Shapes (copy), Tunnel (copy), t1 (copy), t4 (copy), t5 (copy), t6 (copy), t7 (copy), t8 (copy), ease (copy), mix (copy), birth (copy), handBack (copy)
    local Camera = p40.Camera

    if p41 < 0.5 then
        local v55 = p41 / 0.5
        local Quad = Enum.EasingStyle.Quad
        local In = Enum.EasingDirection.In
        local Value = TweenService:GetValue(math.clamp(v55, 0, 1), Quad, In)
        local v56 = if p40.Calm then 10 else math.lerp(95, 210, Value)

        p40.Travel += v56 * p42

        local v57 = if p40.Calm then p43 * 0.35 else p43

        Tunnel.Step(p40.Tunnel, v57, p40.Travel, if p40.Calm then 0 else Value)

        if p40.Calm then
            mix(p40.Look, t8, t7, Value)
        else
            mix(p40.Look, t4, t5, Value)
            p40.Look.Tint = Color3.fromHSV(v57 * 0.12 % 1, 0.22, 1):Lerp(t5.Tint, Value)
        end

        if p40.OwnsCamera and not p40.Calm then
            p40.Roll += (Value * 3 + 1) * 0.9599310885968813 * p42
            Camera.CFrame = p40.Tunnel.Origin * CFrame.Angles(0, 0, p40.Roll)
            Camera.FieldOfView = math.lerp(100, 118, Value)
        end
    else
        if not p40.Born then
            birth(p40)
        end

        local v58 = (p41 - 0.5) / 1.7

        if v58 >= 1 then
            handBack(p40)
        else
            if p40.Calm then
                mix(p40.Look, t7, t1, ease(v58, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut))
            elseif v58 < 0.4 then
                mix(p40.Look, t5, t6, ease(v58 / 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
            else
                mix(p40.Look, t6, t1, ease((v58 - 0.4) / 0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut))
            end

            p40.Glow.FillTransparency = math.lerp(0.25, 1, (math.min(v58 / 0.6, 1)))
            p40.Glow.OutlineTransparency = math.lerp(0, 1, (math.min(v58 / 0.6, 1)))
            p40.Glow.FillColor = Color3.fromHSV(p43 * 0.8 % 1, 0.6, 1)

            local Wave = p40.Burst.Wave
            local v63 = v58 * 1.7 / 0.8
            local Quad = Enum.EasingStyle.Quad
            local Out = Enum.EasingDirection.Out
            local Value = TweenService:GetValue(math.clamp(v63, 0, 1), Quad, Out)

            Shapes.Resize(Wave, (math.lerp(1, 24, Value)))
            Shapes.SetWidth(Wave, (1 - Value) * 1.6)
            Wave.Hub.CFrame = CFrame.new(p40.Root.Position - Vector3.new(0, 1, 0) * p40.Stance) * CFrame.Angles(-1.5707963267948966, 0, 0)

            if p40.OwnsCamera then
                if p40.Calm then
                    local Reach = p40.Reach
                    local v64 = p40.Root.Position + p40.SubjectOffset

                    Camera.CFrame = CFrame.lookAt(v64 - p40.Landing * Reach, v64)
                else
                    local Back = Enum.EasingStyle.Back
                    local Out = Enum.EasingDirection.Out
                    local Value = TweenService:GetValue(math.clamp(v58, 0, 1), Back, Out)
                    local Quint = Enum.EasingStyle.Quint
                    local Out2 = Enum.EasingDirection.Out
                    local Value2 = TweenService:GetValue(math.clamp(v58, 0, 1), Quint, Out2)
                    local v65 = math.lerp(2.5, p40.Reach, Value2)
                    local v66 = p40.Root.Position + p40.SubjectOffset

                    Camera.CFrame = CFrame.lookAt(v66 - p40.Landing * v65, v66) * CFrame.Angles(0, 0, (1 - Value) * 0.4886921905584123)
                    Camera.FieldOfView = math.lerp(112, p40.FieldOfView, Value)
                end
            end
        end
    end
end

local function canWake(p44, p45, p46) -- line: 679
    if p45 - p44.PhaseAt < 0.7 then
        return false
    end

    if p46 >= 6 then
        return true
    end

    local RevealedAt = p44.RevealedAt

    return RevealedAt ~= nil and (p44.Moved or p45 - RevealedAt >= 2.5)
end

local function step(p47, p48) -- line: 693
    -- upvalues: Score (copy), heartbeat (copy), intro (copy), ride (copy), outro (copy)
    local elapsed = os.clock()
    local v67 = elapsed - p47.StartedAt
    local RootPosition = p47.Root.Position

    if p47.Phase ~= "Intro" and (RootPosition - p47.LastRoot).Magnitude > 12 then
        p47.Moved = true
    end

    p47.LastRoot = RootPosition

    if p47.Phase ~= "Intro" or not (p47.CutAt <= v67) then
        if p47.Phase == "Ride" then
            local v68

            if elapsed - p47.PhaseAt < 0.7 then
                v68 = false
            elseif v67 >= 6 then
                v68 = true
            else
                local RevealedAt = p47.RevealedAt

                v68 = RevealedAt ~= nil and (p47.Moved or elapsed - RevealedAt >= 2.5)
            end

            if v68 then
                p47.Phase = "Outro"
                p47.PhaseAt = elapsed
                Score.Wake(p47.Score)
            end
        end
    else
        p47.Phase = "Ride"
        p47.PhaseAt = elapsed
        p47.VortexTrove:Destroy()
        Score.Plunge(p47.Score)

        if p47.OwnsCamera then
            p47.Camera.CameraType = Enum.CameraType.Scriptable
        end
    end

    heartbeat(p47, v67)

    local v69 = if p47.Calm then 0 else math.exp(-(v67 - p47.LubAt) * 9)
    local v71 = elapsed - p47.PhaseAt
    local Moment = p47.Moment

    Moment.Phase = p47.Phase
    Moment.Time = v71

    if p47.Phase == "Intro" then
        Moment.Length = p47.CutAt
    else
        Moment.Length = 0.5
    end

    Score.Step(p47.Score, Moment)

    if p47.Phase == "Intro" then
        intro(p47, v71, p48)
    elseif p47.Phase == "Ride" then
        ride(p47, v71, p48, v67, v69)
    else
        outro(p47, v71, p48, v67)
    end

    if p47.HandBack ~= nil then
        return
    end

    local Look, Grade = p47.Look, p47.Grade

    Grade.Color.Brightness = Look.Brightness + v69 * 0.04
    Grade.Color.Contrast = Look.Contrast
    Grade.Color.Saturation = Look.Saturation
    Grade.Color.TintColor = Look.Tint
    Grade.Bloom.Intensity = Look.Bloom + v69 * 0.3
    Grade.Blur.Size = Look.Blur
end

local function build(p49, p50, p51) -- line: 737
    -- upvalues: GuiService (copy), ReplicatedStorage (copy), Workspace (copy), BanjoCricket (copy), Score (copy), Tunnel (copy), Vortex (copy), v2 (copy), v3 (copy), t1 (copy), grade (copy), burst (copy)
    local CurrentCamera = Workspace.CurrentCamera
    local Humanoid = p50:FindFirstChildOfClass("Humanoid")
    local HumanoidRootPart = p50:FindFirstChild("HumanoidRootPart")

    assert(CurrentCamera, "no camera to dream through")
    assert(Humanoid, "the dreamer has no humanoid")
    assert(HumanoidRootPart and HumanoidRootPart:IsA("BasePart"), "the dreamer has no root part")

    local elapsed = os.clock()
    local v73 = p49:Extend()
    local v74 = v73:Add(Instance.new("Folder"))

    v74.Name = "BanjoDream"
    v74.Parent = CurrentCamera

    local v75 = v73:Extend()
    local v76 = v73:Extend()
    local t12 = {}

    for _, v77 in BanjoCricket.Mushrooms do
        table.insert(t12, v77.Color)
    end

    local v78 = CurrentCamera.Focus.Position - HumanoidRootPart.Position
    local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity
    local v79 = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z)
    local v80

    if v79.Magnitude > 2 then
        v80 = v79.Unit
    else
        local LookVector = CurrentCamera.CFrame.LookVector
        local v81 = Vector3.new(LookVector.X, 0, LookVector.Z)

        v80 = if v81.Magnitude > 0.01 then v81.Unit else Vector3.new(-0, -0, -1, -0)
    end

    local t13 = {
        p50,
        v74
    }
    local v82 = RaycastParams.new()

    v82.FilterType = Enum.RaycastFilterType.Exclude
    v82.FilterDescendantsInstances = t13
    v82.RespectCanCollide = true

    local v83 = Workspace:Raycast(HumanoidRootPart.Position, Vector3.new(0, -160, 0), v82)
    local v84 = if v83 then v83.Position.Y else HumanoidRootPart.Position.Y - 50
    local v86 = math.clamp(p51 * 0.5, 0.8, 1.3)
    local v87 = v73:Add(Instance.new("Highlight"))

    v87.Name = "BanjoDream"
    v87.DepthMode = Enum.HighlightDepthMode.Occluded
    v87.FillTransparency = 1
    v87.OutlineTransparency = 1
    v87.OutlineColor = v3
    v87.Adornee = p50
    v87.Parent = v74

    local t14 = {
        Trove = p49,
        Scenery = v73,
        VortexTrove = v75,
        TunnelTrove = v76,
        Camera = CurrentCamera,
        Root = HumanoidRootPart,
        Calm = GuiService.ReducedMotionEnabled,
        OwnsCamera = CurrentCamera.CameraType == Enum.CameraType.Custom,
        StartedAt = elapsed,
        CutAt = v86,
        Phase = "Intro",
        PhaseAt = elapsed,
        Moment = {
            Phase = "Intro",
            Time = 0,
            Length = v86
        },
        LastRoot = HumanoidRootPart.Position,
        Moved = false,
        FieldOfView = CurrentCamera.FieldOfView,
        Zoom = math.max((CurrentCamera.CFrame.Position - CurrentCamera.Focus.Position).Magnitude, 0.5),
        SubjectOffset = if not (v78.Magnitude < 4) then Vector3.new(0, 1.5, 0) else v78,
        Heading = v80,
        Center = Vector3.new(HumanoidRootPart.Position.X, v84 + 6, HumanoidRootPart.Position.Z),
        Swallowed = false,
        Roll = 0,
        Travel = 0,
        NextBeat = 0.3,
        LubAt = (-1e999),
        Stance = if Humanoid.RigType == Enum.HumanoidRigType.R6 then 3 else Humanoid.HipHeight + HumanoidRootPart.Size.Y / 2,
        Born = false,
        Landing = v80,
        Reach = 0,
        Look = table.clone(t1),
        Grade = grade(v73, CurrentCamera),
        Glow = v87,
        Vortex = Vortex.Build(v75, v74, t12)
    }
    local Build = Tunnel.Build
    local t15 = {
        Origin = v2,
        Palette = t12
    }
    local Dream = ReplicatedStorage.Assets.VFX.BanjoCricket:FindFirstChild("Dream")
    local Mushroom = Dream and Dream:FindFirstChild("Mushroom")

    t15.Mushroom = if not (Mushroom and Mushroom:IsA("Model")) then nil else Mushroom
    t14.Tunnel = Build(v76, v74, t15)
    t14.Score = Score.Build(p49)
    t14.Burst = burst(v73, v74)
    v73:Add(function() -- line: 825
        -- upvalues: t14 (copy)
        if t14.OwnsCamera then
            local Camera = t14.Camera

            Camera.FieldOfView = t14.FieldOfView

            local HandBack = t14.HandBack

            if HandBack then
                Camera.CFrame = HandBack
            end

            Camera.CameraType = Enum.CameraType.Custom
        end
    end)

    return t14
end

local function begin(p52) -- line: 831
    -- upvalues: Workspace (copy), Score (copy), Trove (copy), v1 (copy), LocalPlayer (copy), result (ref), report (copy), step (copy), build (copy)
    local result2 = result

    if result2 then
        if result == result2 then
            result = nil
        end

        result2.Trove:Destroy()
    end

    local CurrentCamera = Workspace.CurrentCamera
    local Character = LocalPlayer.Character
    local v90, v91

    if Character then
        v90 = Character:FindFirstChildOfClass("Humanoid")
        v91 = Character:FindFirstChild("HumanoidRootPart")
    else
        v91 = Character
        v90 = Character
    end

    if CurrentCamera ~= nil and Character ~= nil and v90 ~= nil and not (v90.Health <= 0) and v91 ~= nil and v91:IsA("BasePart") then
        local v92 = Trove.new()
        local ok, result3 = pcall(build, v92, Character, p52)

        if not ok then
            warn((("BanjoDream could not start: %*"):format(result3)))
            v92:Destroy()

            return
        end

        result = result3
        v92:Connect(v90.Died, function() -- line: 859
            -- upvalues: result3 (copy), result (ref)
            if result == result3 then
                result = nil
            end

            result3.Trove:Destroy()
        end)
        v92:Connect(LocalPlayer.CharacterAdded, function() -- line: 862
            -- upvalues: result3 (copy), result (ref)
            if result == result3 then
                result = nil
            end

            result3.Trove:Destroy()
        end)
        Score.Fall(result3.Score, result3.CutAt)
        result3.Scenery:BindToRenderStep("BanjoDream", v1, function(p53) -- line: 869
            -- upvalues: result3 (copy), result (ref), report (copy), step (copy)
            if not xpcall(step, report, result3, p53) then
                if result == result3 then
                    result = nil
                end

                result3.Trove:Destroy()
            end
        end)
    end
end

local function reveal() -- line: 877
    -- upvalues: result (ref)
    local result2 = result

    if result2 and result2.RevealedAt == nil then
        result2.RevealedAt = os.clock()
    end
end

function t9.Start() -- line: 884
    -- upvalues: BanjoCricket (copy), Remotes (copy), Score (copy), result (ref), begin (copy)
    Score.Warm()
    Remotes.EnchantedTree.Transition.OnClientEvent:Connect(function(p54, _, p56, p57) -- line: 887
        -- upvalues: BanjoCricket (copy), result (ref), begin (copy)
        if p56 == BanjoCricket.DreamTransition then
            if p54 == "Cover" then
                begin(if typeof(p57) == "number" then p57 else 1.6)
            elseif p54 == "Reveal" then
                local result2 = result

                if result2 and result2.RevealedAt == nil then
                    result2.RevealedAt = os.clock()
                end
            end
        end
    end)
end

return table.freeze(t9)
