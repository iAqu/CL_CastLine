-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function createWhitePart(p1, p2, p3, p4, p5) -- line: 2
    local v1 = if p5 == nil then Enum.PartType.Block else p5
    local Part = Instance.new("Part")

    Part.Name = p2
    Part.Anchored = true
    Part.BottomSurface = Enum.SurfaceType.Smooth
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Color = Color3.fromRGB(245, 245, 245)
    Part.CFrame = p4
    Part.Material = Enum.Material.SmoothPlastic
    Part.Massless = true
    Part.Shape = v1
    Part.Size = p3
    Part.TopSurface = Enum.SurfaceType.Smooth
    Part.Parent = p1

    return Part
end

local function createWhiteCharmModel(p6) -- line: 24
    -- upvalues: createWhitePart (copy)
    local Model = Instance.new("Model")

    Model.Name = ("%*Whitebox"):format(p6.id)

    local v2 = createWhitePart(Model, "Core", Vector3.new(1.35, 1.35, 1.35), CFrame.new(0, 0, 0), Enum.PartType.Ball)

    createWhitePart(Model, "OrbitArm", Vector3.new(1.7, 0.16, 0.16), CFrame.new(0.65, 0.05, 0), Enum.PartType.Cylinder)
    createWhitePart(Model, "Satellite", Vector3.new(0.48, 0.48, 0.48), CFrame.new(1.45, 0.05, 0), Enum.PartType.Ball)
    createWhitePart(Model, "Tail", Vector3.new(0.55, 0.3, 0.8), CFrame.new(-0.82, -0.05, 0.42) * CFrame.Angles(0, 0.4886921905584123, 0))
    createWhitePart(Model, "Antenna", Vector3.new(0.18, 0.72, 0.18), CFrame.new(0, 0.82, 0))

    if p6.id == "premiumFomo" then
        for v5, v6 in {
                -0.42, 0, 0.42
            } do
            createWhitePart(Model, `CrownPoint{ v5 - 1 + 1 }`, Vector3.new(0.22, v6 == 0 and 0.62 or 0.46, 0.22), CFrame.new(v6, v6 == 0 and 1.23 or 1.15, 0))
        end
    end

    Model.PrimaryPart = v2

    return Model
end

return {
    createCharmModel = function(p7) -- createCharmModel | line: 50
        -- upvalues: createWhiteCharmModel (copy)
        if p7.model == nil then
            return (createWhiteCharmModel(p7))
        end

        return (p7.model:Clone())
    end,
    getCharmTargetCFrame = function(p8, p9, p10) -- getCharmTargetCFrame | line: 53
        local v10 = math.sin(p10 * p9.hoverSpeed) * p9.hoverAmplitude
        local v11 = p10 * p9.rotationSpeed
        local v12 = CFrame.new(p9.followOffset)
        local v13 = CFrame.new(0, v10, 0)
        local v14 = CFrame.Angles(0, v11, 0)

        return p8 * v12 * v13 * v14
    end,
    stepCharmCFrame = function(p11, p12, p13, p14) -- stepCharmCFrame | line: 62
        if (p11.Position - p12.Position).Magnitude >= p13.teleportDistance then
            return p12
        end

        return p11:Lerp(p12, (math.clamp(1 - math.exp(-p13.followResponsiveness * p14), 0, 1)))
    end
}
