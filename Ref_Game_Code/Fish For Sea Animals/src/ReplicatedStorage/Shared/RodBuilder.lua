-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Config = require(script.Parent.Config)
local t1 = {}
local v1 = CFrame.Angles(0, 1.5707963267948966, 0)

local function part(p1, p2, p3, p4, p5, p6, p7) -- line: 13
    local Part = Instance.new("Part")

    Part.Name = p2
    Part.Shape = p3
    Part.Size = p4
    Part.CFrame = p5
    Part.Color = p6
    Part.Material = p7 or Enum.Material.SmoothPlastic
    Part.TopSurface = Enum.SurfaceType.Smooth
    Part.BottomSurface = Enum.SurfaceType.Smooth
    Part.Anchored = false
    Part.CanCollide = false
    Part.CanTouch = false
    Part.CanQuery = false
    Part.Massless = true
    Part.CastShadow = false
    Part.Parent = p1

    return Part
end

local t2 = {
    Color3.fromRGB(255, 70, 90),
    Color3.fromRGB(255, 170, 50),
    Color3.fromRGB(255, 240, 80),
    Color3.fromRGB(80, 235, 120),
    Color3.fromRGB(70, 170, 255),
    Color3.fromRGB(180, 90, 255)
}

local function rainbowSkin(p8) -- line: 47
    -- upvalues: CollectionService (copy), t2 (copy)
    local n1 = 0

    for _, child in p8:GetChildren() do
        if child:IsA("BasePart") then
            local v2 = tonumber(child.Name:match("%d+$"))

            if child.Name:find("^Pole") then
                child.Color = t2[(v2 * 2 - 1) % #t2 + 1]
                child.Material = Enum.Material.SmoothPlastic
                child:SetAttribute("Hue", (child.Color:ToHSV()))
                CollectionService:AddTag(child, "RgbRod")
            elseif child.Name:find("^Band") or child.Name:find("^Guide") or child.Name == "Tip" or child.Name == "Butt" or child.Name == "Reel" then
                n1 += 1
                child.Color = t2[n1 % #t2 + 1]
                child.Material = Enum.Material.Neon
                child:SetAttribute("Hue", (child.Color:ToHSV()))
                CollectionService:AddTag(child, "RgbRod")
            end
        end
    end

    local t3 = {}

    for v3, v4 in t2 do
        table.insert(t3, ColorSequenceKeypoint.new((v3 - 1) / (#t2 - 1), v4))
    end

    for _, v6 in { "Tip", "Pole2", "Grip" } do
        local v7 = p8:FindFirstChild(v6)

        if v7 then
            local ParticleEmitter = Instance.new("ParticleEmitter")

            ParticleEmitter.Name = "RainbowAura"
            ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
            ParticleEmitter.Color = ColorSequence.new(t3)
            ParticleEmitter.LightEmission = 1
            ParticleEmitter.Size = NumberSequence.new(0.35, 0)
            ParticleEmitter.Transparency = NumberSequence.new(0.1, 1)
            ParticleEmitter.Lifetime = NumberRange.new(0.5, 1)
            ParticleEmitter.Speed = NumberRange.new(0.5, 2)
            ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
            ParticleEmitter.Rate = v6 == "Tip" and 18 or 10
            ParticleEmitter.Parent = v7
        end
    end
end

local function rodLength(p9) -- line: 92
    return p9 * 0.35 + 6
end

local function weldAll(p10, p11) -- line: 96
    for _, descendant in p10:GetDescendants() do
        if descendant:IsA("BasePart") and descendant ~= p11 then
            local Weld = Instance.new("Weld")

            Weld.Part0 = p11
            Weld.Part1 = descendant
            Weld.C0 = p11.CFrame:ToObjectSpace(descendant.CFrame)
            Weld.Parent = descendant
        end
    end
end

local function fromMesh(p12, p13) -- line: 113
    -- upvalues: v1 (copy), part (copy), weldAll (copy)
    local Butt = p12:GetAttribute("Butt")
    local Tip = p12:GetAttribute("Tip")
    local v8 = p13 * 0.35 + 6
    local clone = p12:Clone()

    clone.Name = "RodModel"

    local v9 = (v8 + 1.3) / (Tip.Z - Butt.Z)

    clone:ScaleTo(clone:GetScale() * v9)
    clone:PivotTo(CFrame.new(0, 0, 1.3) * CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(-Butt * v9))

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = false
            descendant.CanCollide = false
            descendant.CanTouch = false
            descendant.CanQuery = false
            descendant.Massless = true
            descendant.CastShadow = false
        end
    end

    local v10 = part(clone, "Grip", Enum.PartType.Block, Vector3.new(1.9, 0.42, 0.42), CFrame.new(0, 0, 0.35) * v1, Color3.new(), nil)

    v10.Transparency = 1

    local v11 = part(clone, "Tip", Enum.PartType.Ball, Vector3.new(0.2, 0.2, 0.2), CFrame.new(0, 0, -v8), Color3.new(), nil)

    v11.Transparency = 1

    local Attachment = Instance.new("Attachment")

    Attachment.Name = "RodTip"
    Attachment.Parent = v11
    weldAll(clone, v10)
    clone.PrimaryPart = v10
    clone.WorldPivot = CFrame.new()

    return clone
end

function t1.build(p14, p15) -- line: 147
    -- upvalues: ReplicatedStorage (copy), Config (copy), v1 (copy), part (copy), rainbowSkin (copy), weldAll (copy), fromMesh (copy)
    local v12 = Config.Rods[p14] or Config.Rods[1]
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local Rods = Assets and Assets:FindFirstChild("Rods")
    local v13 = Rods and Rods:FindFirstChild(v12.Name)

    if v13 and not p15 and v13:GetAttribute("Butt") then
        return (fromMesh(v13, (math.clamp(p14, 1, #Config.Rods))))
    end

    local Model = Instance.new("Model")

    Model.Name = "RodModel"

    local v15 = p14 * 0.35 + 6
    local v16 = if v12.Neon then Enum.Material.Neon else Enum.Material.SmoothPlastic
    local Cylinder = Enum.PartType.Cylinder
    local v17 = part(Model, "Grip", Cylinder, Vector3.new(1.9, 0.42, 0.42), CFrame.new(0, 0, 0.35) * v1, Color3.fromRGB(38, 36, 42), Enum.Material.Fabric)

    part(Model, "Butt", Enum.PartType.Ball, Vector3.new(0.52, 0.52, 0.52), CFrame.new(0, 0, 1.3), v12.Accent, v16)
    part(Model, "ReelArm", Enum.PartType.Block, Vector3.new(0.16, 0.42, 0.22), CFrame.new(0, -0.3, -0.75), Color3.fromRGB(70, 70, 80), Enum.Material.Metal)
    part(Model, "Reel", Cylinder, Vector3.new(0.32, 0.95, 0.95), CFrame.new(0, -0.62, -0.75), v12.Accent, Enum.Material.Metal)
    part(Model, "ReelKnob", Enum.PartType.Block, Vector3.new(0.3, 0.14, 0.14), CFrame.new(0.3, -0.62, -0.55), Color3.fromRGB(30, 30, 34))

    local v18 = (v15 - 0.6) / 3

    for i = 1, 3 do
        local v19 = -0.6 - (i - 1) * v18
        local v20 = 0.32 - (i - 0.5) / 3 * 0.2

        part(Model, "Pole" .. i, Cylinder, Vector3.new(v18 + 0.04, v20, v20), CFrame.new(0, 0, v19 - v18 / 2) * v1, v12.Color)
        part(Model, "Band" .. i, Cylinder, Vector3.new(0.16, v20 + 0.1, v20 + 0.1), CFrame.new(0, 0, v19) * v1, v12.Accent, v16)
        part(Model, "Guide" .. i, Enum.PartType.Ball, Vector3.new(0.2, 0.2, 0.2), CFrame.new(0, -v20 / 2 - 0.08, v19 - v18 * 0.6), v12.Accent, v16)
    end

    local v26 = part(Model, "Tip", Enum.PartType.Ball, Vector3.new(0.24, 0.24, 0.24), CFrame.new(0, 0, -v15), v12.Accent, v16)
    local Attachment = Instance.new("Attachment")

    Attachment.Name = "RodTip"
    Attachment.Parent = v26
    weldAll(Model, v17)

    if p15 then
        rainbowSkin(Model)
    end

    Model.PrimaryPart = v17
    Model.WorldPivot = CFrame.new()

    return Model
end

function t1.animateRgb() -- line: 195
    -- upvalues: CollectionService (copy), RunService (copy)
    RunService.RenderStepped:Connect(function() -- line: 196
        -- upvalues: CollectionService (copy)
        local v27 = os.clock() * 0.35

        for _, v28 in CollectionService:GetTagged("RgbRod") do
            local Hue = v28:GetAttribute("Hue")

            if Hue then
                v28.Color = Color3.fromHSV((Hue + v27) % 1, 0.8, 1)
            end
        end
    end)
end

return t1
