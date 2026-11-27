-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local fromRGB, new = Color3.fromRGB, Vector3.new
local t1 = {}
local t2 = {
    SpiritLantern = {
        shell = {
            fromRGB(225, 60, 60),
            fromRGB(200, 45, 55)
        },
        band = fromRGB(255, 215, 70),
        gem = fromRGB(255, 240, 150)
    },
    CosmicEgg = {
        bandNeon = true,
        shell = {
            fromRGB(40, 30, 104),
            fromRGB(30, 22, 82),
            fromRGB(56, 34, 128)
        },
        band = fromRGB(90, 220, 255),
        gem = fromRGB(255, 150, 250),
        stars = {
            fromRGB(255, 255, 255),
            fromRGB(255, 240, 170),
            fromRGB(150, 220, 255)
        },
        ring = fromRGB(255, 196, 120),
        ring2 = fromRGB(200, 140, 255)
    },
    Default = {
        shell = {
            fromRGB(150, 110, 235),
            fromRGB(130, 90, 215)
        },
        band = fromRGB(255, 215, 70),
        gem = fromRGB(120, 235, 255)
    }
}
local t3 = {
    RainbowCrate = 7.5,
    GoldenHarvest = 7.5
}
local t4 = {
    1.3, 1.95, 2.35, 2.5, 2.4, 2.1, 1.7, 1.2,
    0.7
}
local t5 = {
    [3] = true,
    [6] = true
}

local function chest(p1) -- line: 23
    -- upvalues: ReplicatedStorage (copy), t3 (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local Shop = Assets and Assets:FindFirstChild("Shop")
    local v1 = Shop and Shop:FindFirstChild(p1)

    if not v1 then
        return nil
    end

    local clone = v1:Clone()
    local _, BoundingBox = clone:GetBoundingBox()

    clone:ScaleTo(clone:GetScale() * t3[p1] / math.max(BoundingBox.Y, 0.1))
    clone:PivotTo(clone:GetPivot() * CFrame.Angles(0, 3.141592653589793, 0))

    return clone
end

local function egg(p2, p3) -- line: 37
    -- upvalues: new (copy), t2 (copy), t4 (copy), t5 (copy)
    local v3 = t2[p2] or t2.Default
    local Model = Instance.new("Model")

    local function piece(p4, p5, p6, p7, p8) -- line: 40
        -- upvalues: Model (copy)
        local Part = Instance.new("Part")

        Part.Name = p4
        Part.Size = p5
        Part.CFrame = p6
        Part.Color = p7

        if p8 then
            Part.Material = Enum.Material.Neon
        else
            Part.Material = Enum.Material.SmoothPlastic
            Part.MaterialVariant = "Stud2"
        end

        Part.TopSurface = Enum.SurfaceType.Smooth
        Part.BottomSurface = Enum.SurfaceType.Smooth
        Part.Parent = Model

        return Part
    end

    local v4

    for v5, v6 in ipairs(t4) do
        local v7 = t5[v5] == true
        local v8 = if v7 then v3.band else v3.shell[(v5 - 1) % #v3.shell + 1]
        local v9 = CFrame.new(0, (v5 - 0.5) * 0.72, 0)
        local v12 = piece("Shell", new(v6 * 2, 0.72, v6 * 2), v9, v8, v7 and v3.bandNeon)

        piece("Shell", new(v6 * 2, 0.72, v6 * 2), v9 * CFrame.Angles(0, 0.7853981633974483, 0), v8, v7 and v3.bandNeon)

        if v5 == 4 then
            v4 = v12
        end
    end

    if v3.stars then
        local v15 = Random.new(7)

        for i = 1, if p3 then 10 else 22 do
            local v16 = v15:NextInteger(1, #t4 - 1)

            if not t5[v16] then
                local v17 = t4[v16]
                local v18 = v15:NextNumber(0, 6.283185307179586)
                local v21 = v17 * (math.abs((math.cos(4 * v18))) * 0.08 + 1) + 0.02
                local v22 = if i % 5 == 0 then 0.5 else 0.32
                local v23 = new(v22, v22, v22)
                local v24 = CFrame.new(math.cos(v18) * v21, (v16 - 0.5) * 0.72 + v15:NextNumber(-0.2, 0.2), math.sin(v18) * v21) * CFrame.Angles(0, -v18, 0.7853981633974483)
                local v25 = v3.stars[i % #v3.stars + 1]
                local Part = Instance.new("Part")

                Part.Name = "Star"
                Part.Size = v23
                Part.CFrame = v24
                Part.Color = v25
                Part.Material = Enum.Material.Neon
                Part.TopSurface = Enum.SurfaceType.Smooth
                Part.BottomSurface = Enum.SurfaceType.Smooth
                Part.Parent = Model
            end
        end
    end

    if v3.ring then
        local v26 = CFrame.new(0, 2.592, 0) * CFrame.Angles(0.24434609527920614, 0, -0.3141592653589793)
        local v27 = if p3 then 14 else 24

        for i = 1, if p3 then 1 else 2 do
            local v28 = if i == 1 then 3.35 else 4.05
            local v29 = if i == 1 then 0.62 else 0.42

            for j = 0, v27 - 1 do
                local v30 = (j + 0.5) / v27 * 3.141592653589793 * 2
                local v31 = v26 * CFrame.Angles(0, -v30, 0) * CFrame.new(v28, 0, 0)

                piece("Ring", new(v29, 0.16, 6.283185307179586 * v28 / v27 * 1.06), v31, if i == 1 then v3.ring else v3.ring2, i == 2)
            end
        end
    end

    local v33 = CFrame.new(0, #t4 * 0.72 + 0.3, 0) * CFrame.Angles(0.7853981633974483, 0, 0.7853981633974483)
    local gem = v3.gem
    local Part = Instance.new("Part")

    Part.Name = "Gem"
    Part.Size = Vector3.new(0.9, 0.9, 0.9)
    Part.CFrame = v33
    Part.Color = gem
    Part.Material = Enum.Material.Neon
    Part.TopSurface = Enum.SurfaceType.Smooth
    Part.BottomSurface = Enum.SurfaceType.Smooth
    Part.Parent = Model

    local PointLight = Instance.new("PointLight")

    PointLight.Color = v3.gem
    PointLight.Range = 12
    PointLight.Brightness = 1.2
    PointLight.Shadows = false
    PointLight.Parent = Part
    Model.PrimaryPart = v4

    return Model
end

function t1.Build(p9, p10, p11, p12) -- line: 108
    -- upvalues: t3 (copy), chest (copy), egg (copy)
    local v35 = t3[p9] and chest(p9) or egg(p9, p12)

    v35.Name = "Egg"

    if p11 and p11 ~= 1 then
        v35:ScaleTo(v35:GetScale() * p11)
    end

    for _, descendant in ipairs(v35:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true
            descendant.CanCollide = false
            descendant.CanTouch = false
            descendant.CanQuery = false
            descendant.CastShadow = false
        end
    end

    local BoundingBox, BoundingBox2 = v35:GetBoundingBox()

    v35:PivotTo(p10 * (BoundingBox * CFrame.new(0, -BoundingBox2.Y / 2, 0)):ToObjectSpace(v35:GetPivot()))
    v35:SetAttribute("Key", p9)

    return v35
end

return t1
