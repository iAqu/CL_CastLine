-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    Part = function(p1, p2) -- Part | line: 23
        local Part = Instance.new("Part")

        Part.Name = p1
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.CastShadow = false
        Part.Material = Enum.Material.Neon
        Part.TopSurface = Enum.SurfaceType.Smooth
        Part.BottomSurface = Enum.SurfaceType.Smooth
        Part.Size = p2

        return Part
    end,
    Resize = function(p3, p4) -- Resize | line: 40
        for v1, v2 in p3.Corners do
            local v3 = (v1 - 1) * 3.141592653589793 / 2
            local v6 = Vector3.new(math.cos(v3), math.sin(v3), 0)
            local v9 = Vector3.new(-math.sin(v3), math.cos(v3), 0)

            v2.CFrame = CFrame.fromMatrix(v6 * p4, v9, v6)
        end

        local v10 = p4 * 0.5522847498307933

        for _, v11 in p3.Beams do
            v11.CurveSize0 = v10
            v11.CurveSize1 = v10
        end
    end
}

function t1.Circle(p5, p6) -- line: 55
    -- upvalues: t1 (copy)
    local v12 = t1.Part(p5, (Vector3.new(0.2, 0.2, 0.2)))

    v12.Transparency = 1

    local t2 = {}

    for i = 1, 4 do
        local Attachment = Instance.new("Attachment")

        Attachment.Name = ("Corner%*"):format(i)
        Attachment.Parent = v12
        table.insert(t2, Attachment)
    end

    local t3 = {}

    for v13, v14 in t2 do
        local Beam = Instance.new("Beam")

        Beam.Attachment0 = v14
        Beam.Attachment1 = t2[v13 % 4 + 1]
        Beam.FaceCamera = true
        Beam.Segments = 12
        Beam.Width0 = 0
        Beam.Width1 = 0
        Beam.LightEmission = 1
        Beam.LightInfluence = 0
        Beam.Brightness = 2
        Beam.Parent = v12
        table.insert(t3, Beam)
    end

    local t4 = {
        Hub = v12,
        Corners = t2,
        Beams = t3
    }

    t1.Resize(t4, p6)

    return t4
end

function t1.Paint(p7, p8, p9) -- line: 87
    for v15, v16 in p7.Beams do
        local v17 = p8 + (v15 - 1) / 4 * p9
        local v18 = p8 + v15 / 4 * p9

        v16.Color = ColorSequence.new(Color3.fromHSV(v17 % 1, 1, 1), Color3.fromHSV(v18 % 1, 1, 1))
    end
end

function t1.SetWidth(p10, p11) -- line: 98
    for _, v19 in p10.Beams do
        v19.Width0 = p11
        v19.Width1 = p11
    end
end

return table.freeze(t1)
