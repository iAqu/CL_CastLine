-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Workspace = game:GetService("Workspace")
local v1 = Color3.fromRGB(255, 40, 40)
local t1 = {
    AwayYaw = 3.141592653589793
}

local function newSpring(p1, p2, p3) -- line: 51
    return {
        Velocity = 0,
        Value = p1,
        Target = p1,
        Speed = p2,
        Damping = p3
    }
end

local function stepSpring(p4, p5) -- line: 61
    local Speed = p4.Speed
    local v2 = p4.Value - p4.Target
    local v3 = -Speed * Speed * v2 - p4.Damping * 2 * Speed * p4.Velocity

    p4.Velocity += v3 * p5
    p4.Value += p4.Velocity * p5
end

local function stepSprings(p6, p7) -- line: 70
    local v6 = math.max(math.ceil(p7 / 0.008333333333333333), 1)
    local v7 = p7 / v6

    for _ = 1, v6 do
        for _, v8 in p6 do
            local Speed = v8.Speed
            local v9 = v8.Value - v8.Target
            local v10 = -Speed * Speed * v9 - v8.Damping * 2 * Speed * v8.Velocity

            v8.Velocity += v10 * v7
            v8.Value += v8.Velocity * v7
        end
    end
end

local function stripRig(p8, p9) -- line: 81
    for _, descendant in p8:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = descendant == p9
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
            descendant.CastShadow = true
            descendant.Massless = descendant ~= p9
        elseif descendant:IsA("Script") then
            descendant:Destroy()
        elseif descendant:IsA("LocalScript") then
            descendant:Destroy()
        elseif descendant:IsA("Animator") then
            descendant:Destroy()
        elseif descendant:IsA("ForceField") then
            descendant:Destroy()
        end
    end

    local Humanoid = p8:FindFirstChildOfClass("Humanoid")

    if Humanoid == nil then
        return
    end

    Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
    Humanoid.BreakJointsOnDeath = false
    Humanoid.AutoRotate = false
    Humanoid.PlatformStand = true
end

local function standingHeight(p10, p11, p12) -- line: 111
    local Humanoid = p10:FindFirstChildOfClass("Humanoid")
    local v11 = if Humanoid == nil then 2 else Humanoid.HipHeight
    local v12 = p11.Position.Y - p11.Size.Y * 0.5 - v11

    return math.max(p12.Position.Y + p12.Size.Y * 0.5 - v12, 1), p11.Position.Y - v12
end

local function makeEye(p13, p14, p15) -- line: 120
    -- upvalues: v1 (copy)
    local Part = Instance.new("Part")

    Part.Name = p15
    Part.Shape = Enum.PartType.Ball
    Part.Material = Enum.Material.Neon
    Part.Color = v1
    Part.Size = Vector3.new(1, 1, 1) * p13.Size.X * 0.16
    Part.Transparency = 1
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Massless = true
    Part.Anchored = false

    local v17 = Vector3.new(p13.Size.X * 0.17 * p14, p13.Size.Y * 0.08, -p13.Size.Z * 0.5)

    Part.CFrame = p13.CFrame * CFrame.new(v17)

    local WeldConstraint = Instance.new("WeldConstraint")

    WeldConstraint.Part0 = p13
    WeldConstraint.Part1 = Part
    WeldConstraint.Parent = Part

    local PointLight = Instance.new("PointLight")

    PointLight.Color = v1
    PointLight.Range = 0
    PointLight.Brightness = 6
    PointLight.Parent = Part
    Part.Parent = p13

    return Part
end

function t1.new(p16, p17, p18) -- line: 162
    -- upvalues: Workspace (copy), t1 (copy), stripRig (copy), standingHeight (copy), makeEye (copy)
    p16.Archivable = true

    local clone = p16:Clone()
    local v18 = clone:FindFirstChild("HumanoidRootPart", true)
    local Head = clone:FindFirstChild("Head")
    local v19, Neck, Waist

    if v18 ~= nil and v18:IsA("BasePart") and Head ~= nil and Head:IsA("BasePart") then
        clone.PrimaryPart = v18
        stripRig(clone, v18)

        local v20, v21 = standingHeight(clone, v18, Head)
        local v22 = p18 / v20

        v19 = v21 * v22
        clone:ScaleTo(clone:GetScale() * v22)
        Neck = Head:FindFirstChild("Neck")

        local UpperTorso = clone:FindFirstChild("UpperTorso")

        if UpperTorso ~= nil then
            Waist = UpperTorso:FindFirstChild("Waist")
        end

        local t2 = {
            Rise = 1,
            EyeGlow = 0,
            EyeTarget = 0,
            Clock = 0,
            Model = clone,
            Root = v18,
            Head = Head
        }

        if Neck == nil or not Neck:IsA("Motor6D") then
            Neck = nil
        end

        t2.Neck = Neck

        if Waist == nil or not Waist:IsA("Motor6D") then
            Waist = nil
        end

        t2.Waist = Waist
        t2.Ground = p17
        t2.Height = p18
        t2.RootLift = v19
        t2.Body = {
            Value = 0,
            Velocity = 0,
            Target = 0,
            Speed = 6,
            Damping = 0.9
        }
        t2.Look = {
            Value = 0,
            Velocity = 0,
            Target = 0,
            Speed = 24,
            Damping = 0.42
        }
        t2.Twitch = {
            Value = 0,
            Velocity = 0,
            Target = 0,
            Speed = 26,
            Damping = 0.35
        }
        t2.Eyes = {}
        t2.Eyes = {
            makeEye(Head, -1, "EyeL"),
            (makeEye(Head, 1, "EyeR"))
        }

        local Highlight = Instance.new("Highlight")

        Highlight.Name = "SeeThrough"
        Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        Highlight.FillColor = Color3.fromRGB(255, 255, 255)
        Highlight.FillTransparency = 0.94
        Highlight.OutlineColor = Color3.fromRGB(255, 235, 235)
        Highlight.OutlineTransparency = 0.55
        Highlight.Adornee = clone
        Highlight.Parent = clone
        clone.Name = "RedLightGreenLightGiant"
        t1.Update(t2, 0)
        clone.Parent = Workspace

        return t2
    end

    clone:Destroy()

    return nil
end

function t1.Face(p19, p20, p21) -- line: 233
    local v23 = if p20 then 0 else 3.141592653589793

    p19.Body.Target = v23
    p19.Look.Target = v23

    if p20 then
        p19.Look.Speed = 26
        p19.Look.Damping = 0.38
        p19.Body.Speed = 7
    else
        p19.Look.Speed = 9
        p19.Look.Damping = 0.8
        p19.Body.Speed = 4.5
    end

    if not p21 then
        return
    end

    p19.Body.Value = v23
    p19.Body.Velocity = 0
    p19.Look.Value = v23
    p19.Look.Velocity = 0
end

function t1.TwitchHead(p22, p23) -- line: 257
    p22.Twitch.Velocity += p23 * 17.243853009703976
end

function t1.SetEyes(p24, p25, p26) -- line: 261
    p24.EyeTarget = p25

    if p26 then
        p24.EyeGlow = p25
    end
end

function t1.FacingAmount(p27) -- line: 269
    return (math.cos(p27.Look.Value + p27.Twitch.Value) + 1) * 0.5
end

function t1.HeadYaw(p28) -- line: 273
    return p28.Look.Value + p28.Twitch.Value
end

function t1.BodyYaw(p29) -- line: 277
    return p29.Body.Value
end

function t1.EyePositions(p30) -- line: 281
    local t3 = {}

    for _, v25 in p30.Eyes do
        table.insert(t3, v25.Position)
    end

    return t3
end

function t1.HeadPosition(p31) -- line: 291
    return p31.Head.Position
end

function t1.Update(p32, p33) -- line: 295
    -- upvalues: stepSprings (copy)
    p32.Clock += p33
    stepSprings({
        p32.Body,
        p32.Look,
        p32.Twitch
    }, p33)
    p32.Twitch.Target = 0

    local v26 = (1 - p32.Rise) * (p32.Height + p32.RootLift)
    local v28 = math.sin(p32.Clock * 3.141592653589793 * 2 * 0.35)
    local v29 = p32.Ground * CFrame.new(0, p32.RootLift - v26, 0) * CFrame.Angles(0, p32.Body.Value, 0)

    p32.Root.CFrame = v29

    local Neck = p32.Neck

    if Neck ~= nil then
        local v30 = p32.Look.Value + p32.Twitch.Value - p32.Body.Value

        Neck.Transform = CFrame.Angles(0, v30, 0)
    end

    local Waist = p32.Waist

    if Waist ~= nil then
        Waist.Transform = CFrame.Angles(v28 * 0.027925268031909273, 0, 0)
    end

    p32.EyeGlow = p32.EyeGlow + (p32.EyeTarget - p32.EyeGlow) * math.min(p33 * 14, 1)

    for _, v33 in p32.Eyes do
        v33.Transparency = 1 - math.clamp(p32.EyeGlow, 0, 1)

        local PointLight = v33:FindFirstChildOfClass("PointLight")

        if PointLight ~= nil then
            PointLight.Range = math.clamp(p32.EyeGlow, 0, 1.5) * 40
        end
    end
end

function t1.Destroy(p34) -- line: 335
    p34.Model:Destroy()
end

return t1
