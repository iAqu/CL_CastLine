-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local EggEnergyOrbField = require(ReplicatedStorage.Shared.Eggs.EggEnergyOrbField)
local Flash = require(ReplicatedStorage.Client.UI.VFX.Flash)
local Shake = require(ReplicatedStorage.Client.Shake)
local Trove = require(ReplicatedStorage.Packages.Trove)
local VFX = require(ReplicatedStorage.Shared.Utils.VFX)
local Particles = ReplicatedStorage.Assets.Particles
local Eggs = ReplicatedStorage.Assets.Models.Eggs
local RiftTradeIn = ReplicatedStorage.Assets.VFX.RiftTradeIn
local t1 = {
    Light = Color3.fromRGB(255, 209, 74),
    Dark = Color3.fromRGB(168, 26, 22)
}
local t2 = {
    Light = {
        Color3.fromRGB(255, 250, 214),
        Color3.fromRGB(255, 198, 44)
    },
    Dark = {
        Color3.fromRGB(196, 40, 30),
        Color3.fromRGB(84, 6, 12)
    }
}
local v2 = Color3.new(1, 1, 1)
local t3 = {}
local v3 = Random.new()
local t4

local function fuseTrack(p1) -- line: 121
    -- upvalues: Audio (copy)
    local Play = Audio.Play
    local Center = p1.Center
    local t5 = {
        Volume = 1
    }
    local ok, result = pcall(Play, "rbxassetid://77717392679794", Center, t5)

    if ok and typeof(result) == "Instance" then
        p1.Trove:Add(function() -- line: 126
            -- upvalues: result (copy)
            result:Stop()
        end)
    end
end

local function debris() -- line: 131
    -- upvalues: Workspace (copy)
    return Workspace:FindFirstChild("Transient") or Workspace
end

local function bezier(p2, p3, p4, p5) -- line: 135
    local v4 = 1 - p5

    return p2 * (v4 * v4) + p3 * (v4 * 2 * p5) + p4 * (p5 * p5)
end

local function lerp(p6, p7, p8) -- line: 140
    return p6 + (p7 - p6) * p8
end

local function backOut(p9) -- line: 144
    local v5 = p9 - 1

    return v5 * 2.70158 * v5 * v5 + 1 + v5 * 1.70158 * v5
end

local function quadIn(p10) -- line: 151
    -- upvalues: TweenService (copy)
    return TweenService:GetValue(p10, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
end

local function quadInOut(p11) -- line: 155
    -- upvalues: TweenService (copy)
    return TweenService:GetValue(p11, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
end

local function cubicIn(p12) -- line: 159
    -- upvalues: TweenService (copy)
    return TweenService:GetValue(p12, Enum.EasingStyle.Cubic, Enum.EasingDirection.In)
end

local function freeze(p13) -- line: 163
    for _, descendant in p13:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
            descendant.Massless = true
            descendant.LocalTransparencyModifier = 0
        end
    end
end

local function detach(p14) -- line: 176
    for _, descendant in p14:GetDescendants() do
        if descendant:IsA("JointInstance") or descendant:IsA("WeldConstraint") or descendant:IsA("NoCollisionConstraint") or descendant:IsA("Constraint") then
            descendant:Destroy()
        elseif descendant:IsA("BillboardGui") or descendant:IsA("SurfaceGui") or descendant:IsA("ProximityPrompt") then
            descendant.Enabled = false
        end
    end
end

local function normalizeProp(p15, p16) -- line: 193
    p15.PrimaryPart = nil

    local BoundingBox, BoundingBox2 = p15:GetBoundingBox()

    p15.WorldPivot = BoundingBox

    local v6 = math.max(BoundingBox2.X, BoundingBox2.Y, BoundingBox2.Z)

    if v6 > 0.01 then
        p15:ScaleTo((math.clamp(p15:GetScale() * (p16 / v6), 0.01, 50)))
    end
end

local self = setmetatable({}, {
    __mode = "k"
})
local self2 = setmetatable({}, {
    __mode = "k"
})
local self3 = setmetatable({}, {
    __mode = "k"
})
local self4 = setmetatable({}, {
    __mode = "k"
})

local function switchable(p17) -- line: 208
    return p17:IsA("ParticleEmitter")
        or p17:IsA("Beam")
        or p17:IsA("Trail")
        or p17:IsA("Light")
        or p17:IsA("Highlight")
        or p17:IsA("Fire")
        or p17:IsA("Smoke")
        or p17:IsA("Sparkles")
end

local function hideItem(p18) -- line: 219
    -- upvalues: self (copy), self2 (copy), self3 (copy), self4 (copy), switchable (copy)
    if p18:IsA("BasePart") then
        self4[p18] = true
        p18.LocalTransparencyModifier = 1
    elseif p18:IsA("BillboardGui") or p18:IsA("SurfaceGui") then
        if self[p18] == nil then
            self[p18] = p18.Enabled
        end

        p18.Enabled = false
    elseif p18:IsA("Decal") then
        if self3[p18] == nil then
            self3[p18] = p18.Transparency
        end

        p18.Transparency = 1
    elseif switchable(p18) then
        if self2[p18] == nil then
            self2[p18] = p18.Enabled
        end

        p18.Enabled = false

        if p18:IsA("ParticleEmitter") then
            p18:Clear()
        end
    end
end

local function showItem(p19) -- line: 245
    -- upvalues: self (copy), self2 (copy), self3 (copy), self4 (copy), switchable (copy)
    if p19:IsA("BasePart") then
        self4[p19] = nil
        p19.LocalTransparencyModifier = 0
    elseif p19:IsA("BillboardGui") or p19:IsA("SurfaceGui") then
        local v12 = self[p19]

        p19.Enabled = v12 == nil or v12
        self[p19] = nil
    elseif p19:IsA("Decal") then
        local v13 = self3[p19]

        p19.Transparency = if v13 == nil then 0 else v13
        self3[p19] = nil
    elseif switchable(p19) then
        local v14 = self2[p19]

        p19.Enabled = v14 == nil or v14
        self2[p19] = nil
    end
end

local function setToolVisibility(p20, p21) -- line: 265
    -- upvalues: hideItem (copy), showItem (copy)
    if not p20 then
        return
    end

    for _, descendant in p20:GetDescendants() do
        if p21 then
            hideItem(descendant)
        else
            showItem(descendant)
        end
    end
end

local function eggTemplate(p22, p23) -- line: 278
    -- upvalues: Eggs (copy)
    p22 = p22 or "Fused " .. p23

    local v16 = Eggs:FindFirstChild(p22)

    if v16 and v16:IsA("Model") then
        return v16
    end

    warn("[ShrineFusionSequence] missing fused egg model:", p22)

    return nil
end

local function fallbackProp(p24) -- line: 288
    local Model = Instance.new("Model")
    local Part = Instance.new("Part")

    Part.Shape = Enum.PartType.Ball
    Part.Material = Enum.Material.Neon
    Part.Color = p24
    Part.Size = Vector3.new(2.6, 2.6, 2.6)
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Parent = Model
    Model.WorldPivot = Part.CFrame

    return Model
end

local function tintEmitters(p25, p26, p27) -- line: 304
    local v17 = ColorSequence.new({
        ColorSequenceKeypoint.new(0, p26),
        ColorSequenceKeypoint.new(0.4, p26:Lerp(p27, 0.65)),
        ColorSequenceKeypoint.new(1, p27)
    })

    for _, descendant in p25:GetDescendants() do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") or descendant:IsA("Trail") then
            descendant.Color = v17
        end
    end
end

local function chargeHost(p28) -- line: 317
    -- upvalues: Particles (copy)
    local AssetAnimation = Particles:FindFirstChild("AssetAnimation")
    local Part = if AssetAnimation then AssetAnimation:FindFirstChild("Part") else nil
    local v18

    if not (Part and Part:IsA("BasePart")) then
        v18 = Instance.new("Part")
        v18.Size = Vector3.new(0.1, 0.1, 0.1)
        v18.Transparency = 1
    else
        v18 = Part:Clone()

        for _, descendant in v18:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                descendant.Color = ColorSequence.new(p28)
            end
        end
    end

    v18.Anchored = true
    v18.CanCollide = false
    v18.CanQuery = false
    v18.CanTouch = false
    v18.CastShadow = false

    local Enable = v18:FindFirstChild("Enable")

    if not Enable then
        Enable = Instance.new("Attachment")
        Enable.Name = "Enable"
        Enable.Parent = v18
    end

    local Emit = v18:FindFirstChild("Emit")

    if Emit and Emit:IsA("Attachment") then
        return v18, Enable, Emit
    end

    return v18, Enable, nil
end

local function rootOf(p29) -- line: 348
    if not p29 then
        return nil
    end

    local HumanoidRootPart = p29:FindFirstChild("HumanoidRootPart")

    return if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then HumanoidRootPart else nil
end

local function orbitOffset(p30, p31, p32, p33) -- line: 356
    local v19 = (p30.PlaneU * math.cos(p31) + p30.PlaneV * math.sin(p31)) * p32

    if p33 > 0.001 then
        v19 = CFrame.fromAxisAngle(p30.PlaneU, p33) * v19
    end

    return v19
end

local function hideNewTools(p34, p35, p36) -- line: 364
    -- upvalues: hideItem (copy)
    if not p36:IsA("Tool") or p36 == p35.Tool or p35.Arrived or p35.NewTools[p36] then
        return
    end

    if p36 then
        for _, descendant in p36:GetDescendants() do
            hideItem(descendant)
        end
    end

    local connection = p36.DescendantAdded:Connect(function(p37) -- line: 369
        -- upvalues: p35 (copy), hideItem (copy)
        if not p35.Arrived then
            hideItem(p37)
        end
    end)

    p35.NewTools[p36] = connection
    p34.Trove:Add(connection)
end

local function sweepTools(p38, p39) -- line: 378
    -- upvalues: hideItem (copy), hideNewTools (copy)
    local Character = p39.Character

    if Character and not p39.Arrived then
        for _, child in Character:GetChildren() do
            hideNewTools(p38, p39, child)
        end

        local Tool = p39.Tool

        if Tool then
            for _, descendant in Tool:GetDescendants() do
                hideItem(descendant)
            end
        end
    end
end

local function buildSide(p40, p41, p42) -- line: 389
    -- upvalues: Players (copy), EggEnergyOrbField (copy), Eggs (copy), t1 (copy), v2 (copy), v3 (copy), freeze (copy), detach (copy), hideItem (copy), fallbackProp (copy), chargeHost (copy), hideNewTools (copy)
    local Character = if Players.LocalPlayer then Players.LocalPlayer.Character else nil
    local t14 = {
        Arrived = false,
        Name = p41,
        Character = p42,
        Color = t1[p41],
        NewTools = {},
        Mine = p42 ~= nil and (p42 == Character or p42 == p40.TrackCharacter)
    }
    local v21 = p40.Pads[p41]
    local Model

    if p42 then
        local Tool = p42:FindFirstChildOfClass("Tool")
        local Model2

        if Tool then
            t14.Tool = Tool
            Model2 = Tool:FindFirstChildOfClass("Model")
            t14.ToolWatch = Tool.DescendantAdded:Connect(function(p43) -- line: 406
                -- upvalues: p40 (copy), hideItem (copy)
                if not p40.Dead then
                    hideItem(p43)
                end
            end)
            p40.Trove:Add(t14.ToolWatch)
        end

        Model = Model2
        p40.Trove:Connect(p42.ChildAdded, function(p44) -- line: 413
            -- upvalues: p40 (copy), t14 (copy), hideNewTools (copy)
            hideNewTools(p40, t14, p44)
        end)
    end

    local v22, v23

    if Model then
        v22 = Model:GetPivot()
        v23 = Model:Clone()
    else
        v22 = v21.CFrame * CFrame.new(0, 3, 0)

        local FusedCategory, Tier = p40.FusedCategory, p40.Tier
        local v24 = FusedCategory or "Fused " .. Tier
        local v25 = Eggs:FindFirstChild(v24)

        if not (v25 and v25:IsA("Model")) then
            v25 = nil
            warn("[ShrineFusionSequence] missing fused egg model:", v24)
        end

        v23 = if v25 then v25:Clone() else fallbackProp(t14.Color)
    end

    detach(v23)
    freeze(v23)
    v23.PrimaryPart = nil

    local BoundingBox, BoundingBox2 = v23:GetBoundingBox()

    v23.WorldPivot = BoundingBox

    local v26 = math.max(BoundingBox2.X, BoundingBox2.Y, BoundingBox2.Z)

    if v26 > 0.01 then
        v23:ScaleTo((math.clamp(v23:GetScale() * (6.2 / v26), 0.01, 50)))
    end

    v23:PivotTo(v22)
    v23.Parent = p40.Container
    t14.Prop = v23
    t14.Origin = v22.Position

    local Tool = t14.Tool

    if Tool then
        for _, descendant in Tool:GetDescendants() do
            hideItem(descendant)
        end
    end

    local v28, v29, v30 = chargeHost(t14.Color)

    v28.CFrame = CFrame.new(v22.Position)
    v28.Parent = p40.Container
    t14.Host = v28
    t14.HostEnable = v29
    t14.HostEmit = v30

    local Attachment = Instance.new("Attachment")

    Attachment.Position = Vector3.new(0, 3.1, 0)
    Attachment.Parent = v28

    local Attachment2 = Instance.new("Attachment")

    Attachment2.Position = Vector3.new(0, -3.1, 0)
    Attachment2.Parent = v28

    local Trail = Instance.new("Trail")

    Trail.Attachment0 = Attachment
    Trail.Attachment1 = Attachment2
    Trail.Color = ColorSequence.new(t14.Color)
    Trail.Transparency = NumberSequence.new(0.25, 1)
    Trail.WidthScale = NumberSequence.new(1, 0)
    Trail.Lifetime = 0.35
    Trail.LightEmission = 1
    Trail.LightInfluence = 0
    Trail.FaceCamera = true
    Trail.MinLength = 0
    Trail.Parent = v28
    t14.Trail = Trail

    local Beam = Instance.new("Beam")

    Beam.Attachment0 = v29
    Beam.Attachment1 = p40.CoreAttachment
    Beam.Color = ColorSequence.new(t14.Color, v2)
    Beam.Transparency = NumberSequence.new(0.5)
    Beam.Width0 = 0.05
    Beam.Width1 = 0.25
    Beam.LightEmission = 1
    Beam.LightInfluence = 0
    Beam.FaceCamera = true
    Beam.Segments = 12
    Beam.Parent = v28
    t14.Beam = Beam
    t14.BeamSign = p41 == "Light" and 1 or -1

    local v31 = EggEnergyOrbField.new(p40.Container, t14.Color)

    p40.Trove:Add(v31)
    t14.Field = v31
    t14.Theta = p41 == "Light" and 0 or 3.141592653589793
    t14.Roll = v3:NextNumber(0, 6.283185307179586)
    t14.BobPhase = p41 == "Light" and 0 or 2.199114857512855

    return t14
end

local function revealSide(p45) -- line: 488
    -- upvalues: showItem (copy)
    p45.Arrived = true

    if p45.ToolWatch then
        p45.ToolWatch:Disconnect()
    end

    local Tool = p45.Tool

    if Tool then
        for _, descendant in Tool:GetDescendants() do
            showItem(descendant)
        end
    end

    for v32, v33 in p45.NewTools do
        v33:Disconnect()

        if v32 then
            for _, descendant in v32:GetDescendants() do
                showItem(descendant)
            end
        end
    end

    table.clear(p45.NewTools)
end

local function finish(p46) -- line: 501
    -- upvalues: t4 (ref), revealSide (copy)
    if t4 ~= p46 then
        return
    end

    t4 = nil
    p46.Dead = true
    revealSide(p46.Sides.Light)
    revealSide(p46.Sides.Dark)
    p46.Trove:Clean()
end

local function propPivot(p47, p48, p49, p50) -- line: 512
    -- upvalues: v3 (copy)
    local v34 = CFrame.lookAt(p49, (Vector3.new(p47.Center.X, p49.Y, p47.Center.Z))) * CFrame.Angles(p48.Roll, 0, 0)

    if p50 > 0.001 then
        v34 = v34 * CFrame.new(v3:NextNumber(-1, 1) * 0.5 * p50, v3:NextNumber(-1, 1) * 0.5 * p50, v3:NextNumber(-1, 1) * 0.5 * p50) * CFrame.Angles(math.rad(v3:NextNumber(-1, 1) * 22 * p50), 0, (math.rad(v3:NextNumber(-1, 1) * 22 * p50)))
    end

    return v34
end

local function pushImpulse(p51, p52) -- line: 531
    -- upvalues: v3 (copy)
    local Impulses = p51.Impulses

    if not Impulses then
        return
    end

    local v39 = p51.ImpulseSlot or 1
    local v40 = Impulses[v39]

    if not v40 then
        v40 = {}
        Impulses[v39] = v40
    end

    v40.At = os.clock()
    v40.Life = 0.34 * v3:NextNumber(0.8, 1.3)
    v40.Power = p52
    v40.Dir = Vector3.new(v3:NextNumber(-1, 1), v3:NextNumber(-1, 1), v3:NextNumber(-0.4, 0.4))
    v40.Spin = Vector3.new(v3:NextNumber(-1, 1), v3:NextNumber(-1, 1), v3:NextNumber(-1, 1))
    p51.ImpulseSlot = v39 % 8 + 1
end

local function stepSession(p53, p54) -- line: 550
    -- upvalues: TweenService (copy), Workspace (copy), Shake (copy), t1 (copy), v2 (copy), t3 (copy), v3 (copy), propPivot (copy), pushImpulse (copy)
    if p53.Dead or p53.Resolving then
        p53.CamPunch = math.max((p53.CamPunch or 0) - p54 * 3, 0)
        p53.CamRumble = math.max((p53.CamRumble or 0) - p54 * 2, 0)
    elseif p53.Shrine:IsDescendantOf(Workspace) then
        local ServerTimeNow = Workspace:GetServerTimeNow()

        if p53.EndsAt + 6 < ServerTimeNow then
            t3.Cancel()
        else
            local elapsed = os.clock()
            local v48 = math.max(p53.EndsAt - p53.StartAt, 0.5)
            local v50 = math.clamp((ServerTimeNow - p53.StartAt) / v48, 0, 1)
            local v52 = math.clamp((ServerTimeNow - p53.StartAt) / p53.LiftSeconds, 0, 1)
            local v53 = p53.EndsAt - p53.ShakeLead
            local v57 = math.clamp((ServerTimeNow - p53.StartAt - p53.LiftSeconds) / math.max(v53 - p53.StartAt - p53.LiftSeconds, 0.1), 0, 1)
            local v59 = math.clamp((ServerTimeNow - v53) / p53.ShakeLead, 0, 1)
            local Value = TweenService:GetValue(v59, Enum.EasingStyle.Cubic, Enum.EasingDirection.In)

            p53.ShakeIntensity = Value
            p53.CamRumble = v52 * (TweenService:GetValue(v57, Enum.EasingStyle.Cubic, Enum.EasingDirection.In) * 0.42000000000000004 + 0.04)

            if Value > 0.02 then
                if (p53.NextImpulse or 0) <= elapsed then
                    pushImpulse(p53, Value * 0.75 + 0.3)
                    p53.NextImpulse = elapsed + (Value * -0.265 + 0.34) * v3:NextNumber(0.75, 1.3)
                end
            else
                p53.NextImpulse = elapsed
            end

            local Value2 = TweenService:GetValue(v57, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            local v60 = Value2 * 6.8 + 1.7

            p53.Theta += v60 * p54

            local v61 = Value2 * -3.3 + 5.6

            if v59 > 0 then
                local Value = TweenService:GetValue(math.min(v59 / 0.35, 1), Enum.EasingStyle.Quart, Enum.EasingDirection.In)

                v61 += (1.2 - v61) * Value
            end

            local v64 = Value2 * 0.24434609527920614
            local v66 = TweenService:GetValue(math.max(v57, v59), Enum.EasingStyle.Quad, Enum.EasingDirection.In) * 5.4 + 1.1

            if v59 > 0.12 and not p53.Absorbing then
                p53.Absorbing = true

                if not p53.Participant then
                    Shake.Play({
                        Magnitude = 0.8,
                        Seconds = p53.ShakeLead + 0.8,
                        Range = {
                            Near = 24,
                            Far = 90,
                            Center = p53.Center
                        }
                    })
                end

                for _, v67 in { "Light", "Dark" } do
                    local Field = p53.Sides[v67].Field

                    task.spawn(function() -- line: 612
                        -- upvalues: p53 (copy), Field (copy)
                        local function v68() -- line: 613
                            -- upvalues: p53 (copy), Field (copy)
                            Field:Absorb(p53.Center, p53.ShakeLead * 0.8)
                        end

                        pcall(v68)
                    end)
                end
            end

            for _, v69 in { "Light", "Dark" } do
                local v70 = p53.Sides[v69]
                local v71 = p53.Theta + (if v69 == "Light" then 0 else 3.141592653589793)
                local v73 = math.sin(elapsed * 2.6 + v70.BobPhase) * 0.55 * (1 - v57 * 0.6) * (1 - v59)
                local Center = p53.Center
                local v74 = (p53.PlaneU * math.cos(v71) + p53.PlaneV * math.sin(v71)) * v61

                if v64 > 0.001 then
                    v74 = CFrame.fromAxisAngle(p53.PlaneU, v64) * v74
                end

                local v75 = Center + v74 + Vector3.new(0, v73, 0)

                if v52 < 1 then
                    local Value = TweenService:GetValue(v52, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
                    local Origin = v70.Origin
                    local v76 = v70.Origin + Vector3.new(0, 3.2, 0)
                    local v77 = 1 - Value

                    v75 = Origin * (v77 * v77) + v76 * (v77 * 2 * Value) + v75 * (Value * Value)
                end

                v70.Roll += v66 * p54

                local v78 = propPivot(p53, v70, v75, Value)

                v70.Pivot = v78

                if v70.Prop.Parent then
                    v70.Prop:PivotTo(v78)
                end

                v70.Host.CFrame = CFrame.new(v75)
                v70.Beam.Width0 = v50 * 0.3 + 0.05
                v70.Beam.Width1 = v50 * 0.6000000000000001 + 0.2
                v70.Beam.CurveSize0 = math.sin(elapsed * 1.9 + v70.BobPhase) * 3 * v70.BeamSign
                v70.Beam.CurveSize1 = math.cos(elapsed * 1.6 + v70.BobPhase) * 3 * -v70.BeamSign

                if not p53.Absorbing then
                    v70.Field:Step(v75, v50, p54)
                end
            end

            local v82 = math.sin(elapsed * (v50 * 10 + 6)) * 0.07 + 1
            local v83 = (TweenService:GetValue(v50, Enum.EasingStyle.Quad, Enum.EasingDirection.In) * 0.95 + 0.55) * v82 + Value * 0.4

            p53.Core.Size = Vector3.new(1, 1, 1) * v83
            p53.Core.CFrame = CFrame.new(p53.Center)

            local v85 = t1.Light:Lerp(t1.Dark, math.sin(elapsed * 3) * 0.5 + 0.5)

            p53.Core.Color = v85:Lerp(v2, v50 * 0.14 + Value * 0.3)
        end
    else
        t3.Cancel()
    end
end

local function flight(p55, p56) -- line: 656
    -- upvalues: RunService (copy), VFX (copy), RiftTradeIn (copy), t2 (copy), freeze (copy), tintEmitters (copy), revealSide (copy)
    local Prop = p56.Prop

    if not (Prop and Prop.Parent) then
        revealSide(p56)
    else
        p56.Trail.Enabled = true

        local Position = Prop:GetPivot().Position
        local Scale = Prop:GetScale()
        local v86 = p56.EggScale or Scale
        local n1 = 0

        while n1 < 1.15 do
            n1 += RunService.RenderStepped:Wait()

            local v87, v88, HumanoidRootPart, v89

            if p55.Dead then
                v89 = true
            elseif Prop.Parent then
                v87 = math.min(n1 / 1.15, 1)
                v88 = v87 * v87

                local Character = p56.Character

                if Character then
                    HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

                    if not HumanoidRootPart or not HumanoidRootPart:IsA("BasePart") then
                        HumanoidRootPart = nil
                    end
                end

                v89 = false
            else
                v89 = true
            end

            if v89 then
                break
            end

            local v91 = if HumanoidRootPart then HumanoidRootPart.Position + Vector3.new(0, 1.5, 0) else Position
            local v92 = (Position + v91) * 0.5
            local Magnitude = ((Position - v91) * Vector3.new(1, 0, 1)).Magnitude
            local v94 = Vector3.new(v92.X, math.max(Position.Y, v91.Y) + Magnitude * 0.5 + 2.5, v92.Z)
            local v95 = 1 - v88
            local v96 = Position * (v95 * v95) + v94 * (v95 * 2 * v88) + v91 * (v88 * v88)
            local v97 = Vector3.new(v91.X, v96.Y, v91.Z)

            Prop:PivotTo((if (v96 - v97).Magnitude < 0.001 then CFrame.new(v96) else CFrame.lookAt(v96, v97)) * CFrame.Angles(v88 * 2 * 3.141592653589793 * 2, 0, 0))
            p56.Host.CFrame = CFrame.new(v96)
            p56.FlightAt = v96

            local v99 = math.min(v87 / 0.22, 1) - 1
            local v100 = v99 * 2.70158 * v99 * v99 + 1 + v99 * 1.70158 * v99
            local v101 = Scale + (v86 - Scale) * v100
            local v103 = math.clamp((v87 - 0.55) / 0.45, 0, 1)

            Prop:ScaleTo((math.max(v101 * (1 - v103 * v103 * v103), 0.01)))
        end

        p56.Trail.Enabled = false
        p56.FlightAt = nil
        revealSide(p56)

        if not p55.Dead then
            local Character = p56.Character
            local HumanoidRootPart

            if Character then
                HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

                if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
                    HumanoidRootPart = nil
                end
            end

            if HumanoidRootPart then
                Position = HumanoidRootPart.Position + Vector3.new(0, 1, 0)
            end

            local Aura = RiftTradeIn:FindFirstChild("Aura")

            if Aura and Aura:IsA("Model") then
                local clone = Aura:Clone()

                freeze(clone)
                clone:PivotTo(CFrame.new(Position))

                local v105 = t2[p56.Name] or t2.Light

                tintEmitters(clone, v105[1], v105[2])
                clone.Parent = p55.Container.Parent

                for _, descendant in clone:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        descendant.LocalTransparencyModifier = 1
                    end
                end

                VFX.EmitTree(clone, true)
                VFX.Discard(clone, 2.5)
            end

            if Prop.Parent then
                Prop:Destroy()
            end
        end
    end
end

local function resolvePayoff(p57, p58) -- line: 722
    -- upvalues: RunService (copy), TweenService (copy), Flash (copy), Shake (copy), VFX (copy), Particles (copy), Eggs (copy), v2 (copy), t4 (ref), quadInOut (copy), freeze (copy), fallbackProp (copy), sweepTools (copy), revealSide (copy), propPivot (copy), pushImpulse (copy), flight (copy)
    sweepTools(p57, p57.Sides.Light)
    sweepTools(p57, p57.Sides.Dark)

    local t15 = {}

    for _, v106 in { "Light", "Dark" } do
        local v107 = p57.Sides[v106]

        if v107.Pivot then
            t15[v106] = v107.Pivot
        else
            local new = CFrame.new
            local Center = p57.Center
            local v108 = if v106 == "Light" then 0 else 3.141592653589793

            t15[v106] = new(Center + (p57.PlaneU * math.cos(v108) + p57.PlaneV * math.sin(v108)) * 1.2)
        end
    end

    if p57.Participant then
        local Play = Flash.Play
        local t16 = {
            Attack = 0.06,
            Decay = 0.22
        }

        pcall(Play, t16)
    end

    p57.CamPunch = 1
    pushImpulse(p57, 1.4)
    pushImpulse(p57, 1)
    task.delay(0.08, pushImpulse, p57, 1.15)
    task.delay(0.19, pushImpulse, p57, 0.8)
    task.delay(0.33, pushImpulse, p57, 0.55)
    task.delay(0.52, pushImpulse, p57, 0.35)

    if not p57.Participant then
        Shake.Play({
            Seconds = 0.7,
            Magnitude = 1,
            Range = {
                Near = 24,
                Far = 90,
                Center = p57.Center
            }
        })
    end

    local Part = Instance.new("Part")

    Part.Shape = Enum.PartType.Ball
    Part.Material = Enum.Material.Neon
    Part.Color = v2
    Part.Size = Vector3.new(2, 2, 2)
    Part.Transparency = 0.45
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CFrame = CFrame.new(p57.Center)
    Part.Parent = p57.Container.Parent
    TweenService:Create(Part, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(13, 13, 13),
        Transparency = 1
    }):Play()
    VFX.Discard(Part, 0.7)

    local Part2 = Instance.new("Part")

    Part2.Shape = Enum.PartType.Cylinder
    Part2.Material = Enum.Material.Neon
    Part2.Color = v2
    Part2.Size = Vector3.new(36, 4.2, 4.2)
    Part2.Transparency = 0.3
    Part2.Anchored = true
    Part2.CanCollide = false
    Part2.CanQuery = false
    Part2.CanTouch = false
    Part2.CastShadow = false
    Part2.CFrame = CFrame.new(p57.Center) * CFrame.Angles(0, 0, 1.5707963267948966)
    Part2.Parent = p57.Container.Parent
    TweenService:Create(Part2, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(36, 0.3, 0.3),
        Transparency = 1
    }):Play()
    VFX.Discard(Part2, 0.75)

    local BigHitGroundAttach = Particles:FindFirstChild("BigHitGroundAttach")

    if BigHitGroundAttach then
        local Part = Instance.new("Part")

        Part.Size = Vector3.new(0.1, 0.1, 0.1)
        Part.Transparency = 1
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.CFrame = CFrame.new(p57.Center.X, p57.GroundY, p57.Center.Z)
        Part.Parent = p57.Container.Parent
        BigHitGroundAttach:Clone().Parent = Part
        VFX.EmitTree(Part, true)
        VFX.Discard(Part, 2)
    end

    TweenService:Create(p57.Core, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Size = Vector3.new(0.05, 0.05, 0.05),
        Transparency = 1
    }):Play()

    local FusedCategory, Tier = p57.FusedCategory, p57.Tier
    local v109 = FusedCategory or "Fused " .. Tier
    local v110 = Eggs:FindFirstChild(v109)

    if not (v110 and v110:IsA("Model")) then
        v110 = nil
        warn("[ShrineFusionSequence] missing fused egg model:", v109)
    end

    for _, v111 in { "Light", "Dark" } do
        local v112 = p57.Sides[v111]

        if v112.Prop.Parent then
            v112.Prop:Destroy()
        end

        local v113 = if v110 then v110:Clone() else fallbackProp(v112.Color)

        freeze(v113)
        v113.PrimaryPart = nil

        local BoundingBox, BoundingBox2 = v113:GetBoundingBox()

        v113.WorldPivot = BoundingBox

        local v114 = math.max(BoundingBox2.X, BoundingBox2.Y, BoundingBox2.Z)

        if v114 > 0.01 then
            v113:ScaleTo((math.clamp(v113:GetScale() * (3.6 / v114), 0.01, 50)))
        end

        v113:PivotTo(t15[v111])
        v113.Parent = p57.Container
        v112.Prop = v113
        v112.EggScale = v113:GetScale()
        v113:ScaleTo((math.max(v112.EggScale * 0.12, 0.01)))

        if v112.HostEmit then
            VFX.EmitTree(v112.HostEmit, true)
        end

        for _, descendant in v112.Host:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false
            end
        end

        v112.Beam.Enabled = false
        v112.Trail.Enabled = true
        v112.RollStart = v112.Roll
    end

    local Theta = p57.Theta
    local v118 = math.ceil((Theta + 7.853981633974483) / 6.283185307179586) * 6.283185307179586
    local t17 = {}

    for _, v119 in { "Light", "Dark" } do
        t17[v119] = math.ceil(p57.Sides[v119].Roll / 6.283185307179586) * 6.283185307179586
    end

    local v121 = p57.Center - Vector3.new(0, 1.4, 0)
    local n2 = 0

    while n2 < 1.8 do
        n2 += RunService.RenderStepped:Wait()

        if p57.Dead then
            break
        end

        local v123 = math.min(n2 / 1.8, 1)
        local Value = TweenService:GetValue(v123, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

        p57.Theta = Theta + (v118 - Theta) * Value

        local v124 = TweenService:GetValue(v123, Enum.EasingStyle.Quad, Enum.EasingDirection.Out) * 1.4000000000000001 + 1.2
        local v125 = 0.24434609527920614 * (1 - Value)
        local v126 = p57.Center:Lerp(v121, quadInOut(v123))
        local v128 = math.clamp(1 - v123 / 0.3, 0, 1)

        p57.ShakeIntensity = v128 * 0.7
        p57.CamRumble = v128 * 0.46

        local v130 = math.min(v123 / 0.4, 1) - 1
        local v131 = v130 * 2.70158 * v130 * v130 + 1 + v130 * 1.70158 * v130

        for _, v132 in { "Light", "Dark" } do
            local v133 = p57.Sides[v132]
            local v134 = p57.Theta + (if v132 == "Light" then 0 else 3.141592653589793)
            local v135 = (p57.PlaneU * math.cos(v134) + p57.PlaneV * math.sin(v134)) * v124

            if v125 > 0.001 then
                v135 = CFrame.fromAxisAngle(p57.PlaneU, v125) * v135
            end

            local v136 = v126 + v135
            local RollStart = v133.RollStart

            v133.Roll = RollStart + (t17[v132] - RollStart) * Value

            local v137 = propPivot(p57, v133, v136, v128 * 0.5)

            v133.Pivot = v137

            if v133.Prop.Parent then
                v133.Prop:PivotTo(v137)
                v133.Prop:ScaleTo((math.max(v133.EggScale * (v131 * 0.88 + 0.12), 0.01)))
            end

            v133.Host.CFrame = CFrame.new(v136)
        end
    end

    p57.ShakeIntensity = 0
    p57.CamRumble = 0

    local t18 = {}

    for _, v139 in { "Light", "Dark" } do
        local v140 = v139 == "Light" and 1 or -1

        t18[v139] = v121 + p57.PlaneU * (v140 * 2.6)
    end

    local n3 = 0

    while n3 < 1.9 do
        n3 += RunService.RenderStepped:Wait()

        if p57.Dead then
            break
        end

        local elapsed = os.clock()
        local Value = TweenService:GetValue(math.clamp((n3 - 1.5) / 0.4, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.In)

        for _, v143 in { "Light", "Dark" } do
            local v144 = p57.Sides[v143]
            local v146 = math.sin(elapsed * 2.3 + v144.BobPhase) * 0.24 * (1 - Value)
            local v149 = t18[v143] + Vector3.new(0, v146 - Value * 0.45, 0)
            local v150 = (1 - Value) * 0.12217304763960307
            local v155 = CFrame.lookAt(v149, (Vector3.new(p57.Center.X, v149.Y, p57.Center.Z))) * CFrame.Angles(math.sin(elapsed * 1.7 + v144.BobPhase) * v150, 0, math.cos(elapsed * 1.3 + v144.BobPhase) * v150)

            v144.Pivot = v155

            if v144.Prop.Parent then
                v144.Prop:PivotTo(v155)
                v144.Prop:ScaleTo((math.max(v144.EggScale * (Value * -0.14 + 1), 0.01)))
            end

            v144.Host.CFrame = CFrame.new(v149)
        end
    end

    p57.FlightStartAt = os.clock()

    for v157, v158 in { "Light", "Dark" } do
        local v159 = p57.Sides[v158]

        task.spawn(function() -- line: 899
            -- upvalues: p57 (copy), v159 (copy), v157 (copy), VFX (copy), flight (copy)
            if v157 > 1 then
                task.wait(0.15)
            end

            if v159.HostEmit then
                VFX.EmitTree(v159.HostEmit, true)
            end

            flight(p57, v159)
        end)
    end

    local n4 = 0

    while n4 < 2.8 do
        task.wait(0.05)
        n4 += 0.05

        if not (p57.Sides.Light.Arrived and p57.Sides.Dark.Arrived) then
            continue
        end

        break
    end

    if t4 == p57 then
        t4 = nil
        p57.Dead = true
        revealSide(p57.Sides.Light)
        revealSide(p57.Sides.Dark)
        p57.Trove:Clean()
    end

    if p58 then
        task.spawn(p58)
    end
end

function t3.IsPlaying() -- line: 923
    -- upvalues: t4 (ref)
    return t4 ~= nil
end

function t3.ActiveShrine() -- line: 927
    -- upvalues: t4 (ref)
    return if t4 then t4.Shrine else nil
end

function t3.IsResolving() -- line: 931
    -- upvalues: t4 (ref)
    return t4 ~= nil and t4.Resolving == true
end

function t3.FlightFocus() -- line: 935
    -- upvalues: t4 (ref)
    local t19 = t4

    if t19 and t19.FlightStartAt then
        local v160 = os.clock() - t19.FlightStartAt

        if v160 < 0.15 then
            return t19.Sides.Light.FlightAt
        end

        return if v160 < 0.3 then t19.Sides.Dark.FlightAt or t19.Sides.Light.FlightAt else nil
    end

    return nil
end

function t3.Begin(p59) -- line: 950
    -- upvalues: RunService (copy), Workspace (copy), Trove (copy), v2 (copy), t4 (ref), fuseTrack (copy), buildSide (copy), revealSide (copy), stepSession (copy)
    local Shrine = p59.Shrine

    if typeof(Shrine) ~= "Instance" or not Shrine:IsDescendantOf(Workspace) then
        return false
    end

    local LightPad = Shrine:FindFirstChild("LightPad")
    local DarkPad = Shrine:FindFirstChild("DarkPad")

    if not (LightPad and LightPad:IsA("BasePart") and DarkPad and DarkPad:IsA("BasePart")) then
        return false
    end

    if t4 then
        local t20 = t4

        t4 = nil
        t20.Dead = true
        t20.Trove:Clean()
    end

    local t21 = {
        Theta = 0,
        ShakeIntensity = 0,
        CamPunch = 0,
        CamRumble = 0,
        ImpulseSlot = 1,
        NextImpulse = 0,
        Dead = false,
        Resolving = false,
        Absorbing = false,
        Trove = Trove.new(),
        Shrine = Shrine,
        Tier = p59.Tier,
        FusedCategory = p59.FusedCategory,
        Participant = p59.Participant == true,
        TrackCharacter = p59.TrackCharacter,
        StartAt = Workspace:GetServerTimeNow(),
        EndsAt = p59.EndsAt,
        Pads = {
            Light = LightPad,
            Dark = DarkPad
        },
        Sides = {},
        Impulses = table.create(8)
    }
    local v162 = math.max(t21.EndsAt - t21.StartAt, 1)

    t21.LiftSeconds = math.clamp(v162 * 0.16, 0.35, 1.1)
    t21.ShakeLead = math.clamp(v162 * 0.24, 0.5, 1.3)

    local v165 = (LightPad.Position - DarkPad.Position) * Vector3.new(1, 0, 1)

    t21.PlaneU = if v165.Magnitude > 0.01 then v165.Unit else Vector3.new(1, 0, 0)
    t21.PlaneV = t21.PlaneU:Cross((Vector3.new(0, 1, 0)))
    t21.Center = (LightPad.Position + DarkPad.Position) * 0.5 + Vector3.new(0, 5.5, 0)
    t21.GroundY = math.max(LightPad.Position.Y + LightPad.Size.Y * 0.5, DarkPad.Position.Y + DarkPad.Size.Y * 0.5)

    local Folder = Instance.new("Folder")

    Folder.Name = "ShrineFusionSequence"
    Folder.Parent = p59.Parent or Workspace:FindFirstChild("Transient") or Workspace
    t21.Trove:Add(Folder)
    t21.Container = Folder

    local Part = Instance.new("Part")

    Part.Shape = Enum.PartType.Ball
    Part.Material = Enum.Material.Neon
    Part.Color = v2
    Part.Size = Vector3.new(0.55, 0.55, 0.55)
    Part.Transparency = 0.3
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.CFrame = CFrame.new(t21.Center)
    Part.Parent = Folder
    t21.Core = Part

    local Attachment = Instance.new("Attachment")

    Attachment.Parent = Part
    t21.CoreAttachment = Attachment
    t21.Sides.Light = buildSide(t21, "Light", p59.LightCharacter)
    t21.Sides.Dark = buildSide(t21, "Dark", p59.DarkCharacter)
    t21.Trove:Add(function() -- line: 1025
        -- upvalues: t21 (copy), revealSide (copy)
        revealSide(t21.Sides.Light)
        revealSide(t21.Sides.Dark)
    end)
    t4 = t21
    t21.Trove:Connect(RunService.RenderStepped, function(p60) -- line: 1031
        -- upvalues: t21 (copy), stepSession (copy)
        stepSession(t21, p60)
    end)
    fuseTrack(t21)

    return true
end

function t3.Payoff(p61) -- line: 1038
    -- upvalues: t4 (ref), revealSide (copy), resolvePayoff (copy)
    local t22 = t4

    if not t22 or t22.Resolving or t22.Dead then
        return false
    end

    t22.Resolving = true
    task.spawn(function() -- line: 1044
        -- upvalues: p61 (copy), t22 (copy), t4 (ref), revealSide (copy), resolvePayoff (copy)
        local ok, result = pcall(resolvePayoff, t22, p61)

        if ok then
            return
        end

        warn("ShrineFusionSequence payoff failed:", result)

        if t4 == t22 then
            t4 = nil
            t22.Dead = true
            revealSide(t22.Sides.Light)
            revealSide(t22.Sides.Dark)
            t22.Trove:Clean()
        end

        if p61 then
            task.spawn(p61)
        end
    end)

    return true
end

function t3.Cancel() -- line: 1057
    -- upvalues: RunService (copy), TweenService (copy), t4 (ref), revealSide (copy)
    local t23 = t4

    if not t23 or t23.Resolving then
        return
    end

    t23.Dead = true
    task.spawn(function() -- line: 1063
        -- upvalues: t23 (copy), RunService (copy), TweenService (copy), t4 (ref), revealSide (copy)
        local Scale = t23.Sides.Light.Prop:GetScale()
        local Scale2 = t23.Sides.Dark.Prop:GetScale()
        local n5 = 0

        while n5 < 0.3 do
            local v169 = RunService.RenderStepped:Wait()

            n5 += v169

            local v171 = math.min(n5 / 0.3, 1)
            local v173 = math.max(1 - TweenService:GetValue(v171, Enum.EasingStyle.Quad, Enum.EasingDirection.In), 0.01)

            for _, v174 in { "Light", "Dark" } do
                local v175 = t23.Sides[v174]

                if v175.Prop.Parent then
                    v175.Prop:ScaleTo((math.max((if v174 == "Light" then Scale else Scale2) * v173, 0.01)))
                    v175.Prop:PivotTo(v175.Prop:GetPivot() * CFrame.new(0, -v169 * 2, 0))
                end
            end

            t23.Core.Size = Vector3.new(1, 1, 1) * math.max((1 - v171) * 1.5, 0.05)
            t23.ShakeIntensity = 0
            t23.CamRumble = 0
        end

        if t4 ~= t23 then
            return
        end

        t4 = nil
        t23.Dead = true
        revealSide(t23.Sides.Light)
        revealSide(t23.Sides.Dark)
        t23.Trove:Clean()
    end)
end

local function v178() -- line: 1087
    -- upvalues: RunService (copy), self4 (copy)
    RunService:BindToRenderStep("ShrineFusionSequenceHold", Enum.RenderPriority.Last.Value, function() -- line: 1088
        -- upvalues: self4 (copy)
        for v179 in self4 do
            if v179.Parent then
                v179.LocalTransparencyModifier = 1
            else
                self4[v179] = nil
            end
        end
    end)
end

pcall(v178)

local function v180() -- line: 1100
    -- upvalues: GuiService (copy), RunService (copy), Workspace (copy), t4 (ref)
    RunService:BindToRenderStep("ShrineFusionSequenceShake", Enum.RenderPriority.Camera.Value + 1, function() -- line: 1101
        -- upvalues: GuiService (copy), Workspace (copy), t4 (ref)
        local t24 = t4

        if t24 and t24.Participant and not GuiService.ReducedMotionEnabled then
            local v184 = math.clamp(math.max((t24.ShakeIntensity or 0) * 0.75, (t24.CamRumble or 0) * 0.35) + (t24.CamPunch or 0), 0, 1.6)
            local v188 = math.clamp(math.max(t24.ShakeIntensity or 0, t24.CamRumble or 0), 0, 1)
            local Impulses = t24.Impulses
            local v189, v190

            if Impulses then
                local elapsed = os.clock()
                local v191 = Vector3.new(0, 0, 0)
                local v192 = Vector3.new(0, 0, 0)

                v189 = Vector3.new(0, 0, 0)
                v190 = Vector3.new(0, 0, 0)

                for _, v193 in Impulses do
                    local v194 = (elapsed - v193.At) / v193.Life

                    if v194 >= 0 and v194 < 1 then
                        local v197 = (1 - v194) * (1 - v194) * math.cos(v194 * 3.141592653589793 * 3)

                        v191 += v193.Dir * (v193.Power * v197)
                        v192 += v193.Spin * (v193.Power * v197)
                    end

                    v190 = v192
                    v189 = v191
                end
            else
                v189 = Vector3.new(0, 0, 0)
                v190 = Vector3.new(0, 0, 0)
            end

            local v198 = v189.Magnitude > 0.001 or v190.Magnitude > 0.001

            if v184 <= 0.005 and v188 <= 0.01 and not v198 then
                return
            end

            local CurrentCamera = Workspace.CurrentCamera

            if not CurrentCamera or CurrentCamera.CameraType ~= Enum.CameraType.Scriptable then
                return
            end

            local v199 = os.clock() * 9
            local v200 = v184 * 0.15
            local v202 = math.rad(v184 * 1.6)

            CurrentCamera.CFrame = CurrentCamera.CFrame * CFrame.new(math.noise(v199, 0, 37.4) * 2 * v200, math.noise(0, v199, 42.1) * 2 * v200, 0) * CFrame.Angles(math.noise(v199, 46.5, 0) * 2 * v202, math.noise(50.7, 0, v199) * 2 * v202, math.noise(v199 * 0.7, 0, 59) * v202)

            if v188 > 0.01 then
                local v203 = os.clock() * 31
                local v204 = v188 * 0.085
                local v206 = math.rad(v188 * 0.95)

                CurrentCamera.CFrame = CurrentCamera.CFrame * CFrame.new(math.noise(v203, 40.699999999999996, 0) * 2 * v204, math.noise(0, 45.3, v203) * 2 * v204, 0) * CFrame.Angles(math.noise(v203, 0, 48.599999999999994) * 2 * v206, math.noise(55.2, v203, 0) * 2 * v206, 0)
            end

            if v198 then
                CurrentCamera.CFrame = CurrentCamera.CFrame * CFrame.new(v189 * 0.44) * CFrame.Angles(math.rad(v190.X * 2.6), math.rad(v190.Y * 2.6), (math.rad(v190.Z * 2.6 * 0.7)))
            end
        end
    end)
end

pcall(v180)

return table.freeze(t3)
