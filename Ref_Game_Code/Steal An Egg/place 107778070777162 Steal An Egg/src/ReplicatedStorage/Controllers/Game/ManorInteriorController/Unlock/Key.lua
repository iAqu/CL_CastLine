-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

require(ReplicatedStorage.Packages.Trove)

local v1 = Color3.fromRGB(255, 196, 110)
local v2 = Color3.fromRGB(255, 214, 150)
local v3 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local t1 = {}

local function template() -- line: 35
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local ManorInterior = Assets and Assets:FindFirstChild("ManorInterior")
    local Key = ManorInterior and ManorInterior:FindFirstChild("Key")

    return if Key ~= nil and Key:IsA("Model") then Key else nil
end

function t1.Build(p1, p2) -- line: 46
    -- upvalues: ReplicatedStorage (copy), v1 (copy), v2 (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local ManorInterior = Assets and Assets:FindFirstChild("ManorInterior")
    local Key = ManorInterior and ManorInterior:FindFirstChild("Key")

    if Key == nil or not Key:IsA("Model") then
        Key = nil
    end

    if Key == nil then
        return nil
    end

    local v4 = p1:Add(Key:Clone())

    v4.Name = "ManorKeyProp"
    v4.WorldPivot = v4:GetBoundingBox()
    v4:ScaleTo(Key:GetScale() * 0.58)

    local t2 = {}
    local t3 = {}
    local descendant

    for _, descendant2 in v4:GetDescendants() do
        if descendant2:IsA("BasePart") then
            descendant2.Anchored = true
            descendant2.CanCollide = false
            descendant2.CanQuery = false
            descendant2.CanTouch = false
            descendant2.CastShadow = false
            descendant2.Massless = true
            t3[descendant2] = descendant2.Transparency
            descendant2.Transparency = 1
            table.insert(t2, descendant2)

            if descendant == nil or descendant2.Size.Magnitude > descendant.Size.Magnitude then
                descendant = descendant2
            end
        end
    end

    local _, BoundingBox = v4:GetBoundingBox()
    local Attachment = Instance.new("Attachment")

    Attachment.Name = "Glint"
    Attachment.Parent = descendant or v4.PrimaryPart

    local PointLight = Instance.new("PointLight")

    PointLight.Color = v2
    PointLight.Range = 8
    PointLight.Brightness = 0
    PointLight.Shadows = false
    PointLight.Parent = Attachment

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Name = "Sparkle"
    ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    ParticleEmitter.Rate = 0
    ParticleEmitter.LightEmission = 1
    ParticleEmitter.LightInfluence = 0
    ParticleEmitter.Color = ColorSequence.new(Color3.new(1, 1, 1), v2)
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.6),
        NumberSequenceKeypoint.new(1, 0)
    })
    ParticleEmitter.Lifetime = NumberRange.new(0.25, 0.45)
    ParticleEmitter.Speed = NumberRange.new(4, 9)
    ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
    ParticleEmitter.Drag = 6
    ParticleEmitter.Parent = Attachment

    local Highlight = Instance.new("Highlight")

    Highlight.Name = "Rim"
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight.FillColor = v1
    Highlight.FillTransparency = 0.88
    Highlight.OutlineColor = v1
    Highlight.OutlineTransparency = 0.2
    Highlight.Adornee = v4
    Highlight.Parent = v4
    v4.Parent = p2

    return {
        Model = v4,
        Length = BoundingBox.Y,
        Parts = t2,
        Rest = t3,
        Sparkle = ParticleEmitter,
        Light = PointLight
    }
end

function t1.Seat(p3, p4, p5, p6) -- line: 120
    local v5 = -p5
    local v6 = v5 * 1
    local v7 = p4 + v5 * (p3.Length / 2 - p3.Length * p6)

    return CFrame.fromMatrix(v7, v6:Cross((Vector3.new(0, 1, 0))), v6, (Vector3.new(0, 1, 0)))
end

function t1.Place(p7, p8) -- line: 127
    p7.Model:PivotTo(p8)
end

function t1.Show(p9, p10) -- line: 131
    for v8, v9 in p9.Rest do
        v8.Transparency = math.lerp(1, v9, (math.clamp(p10, 0, 1)))
    end

    p9.Light.Brightness = math.clamp(p10, 0, 1) * 1.5
end

function t1.Weld(p11, p12) -- line: 138
    for _, v11 in p11.Parts do
        local WeldConstraint = Instance.new("WeldConstraint")

        WeldConstraint.Part0 = p12
        WeldConstraint.Part1 = v11
        WeldConstraint.Parent = v11
        v11.Anchored = false
    end
end

function t1.Fade(p13) -- line: 148
    -- upvalues: TweenService (copy), v3 (copy)
    local Rim = p13.Model:FindFirstChild("Rim")

    if Rim ~= nil and Rim:IsA("Highlight") then
        Rim.Enabled = false
    end

    for _, v12 in p13.Parts do
        TweenService:Create(v12, v3, {
            Transparency = 1
        }):Play()
    end

    TweenService:Create(p13.Light, v3, {
        Brightness = 0
    }):Play()
end

return table.freeze(t1)
