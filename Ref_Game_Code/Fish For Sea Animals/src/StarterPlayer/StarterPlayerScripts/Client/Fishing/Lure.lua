-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    build = function(p1) -- build | line: 8
        local Model = Instance.new("Model")

        Model.Name = p1.Key

        local function part(p2) -- line: 11
            -- upvalues: Model (copy)
            local Part = Instance.new("Part")

            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.CanTouch = false
            Part.CastShadow = false
            Part.Material = Enum.Material.SmoothPlastic

            local Smooth, Smooth2 = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth

            Part.TopSurface = Smooth
            Part.BottomSurface = Smooth2

            for v1, v2 in p2 do
                Part[v1] = v2
            end

            Part.Parent = Model

            return Part
        end

        local function egg(p3, p4, p5, p6) -- line: 26
            -- upvalues: part (copy)
            local v3 = part({
                Size = Vector3.new(1, 1, 1),
                CFrame = p4,
                Color = p5,
                Material = p6 or Enum.Material.SmoothPlastic
            })
            local SpecialMesh = Instance.new("SpecialMesh")

            SpecialMesh.MeshType = Enum.MeshType.Sphere
            SpecialMesh.Scale = p3
            SpecialMesh.Parent = v3

            return v3
        end

        local v4 = if p1.Key == "DiamondLure" then Enum.Material.Glass else Enum.Material.SmoothPlastic
        local v5 = egg(Vector3.new(1.3, 1.5, 3), CFrame.new(), p1.Color, v4)

        v5.Reflectance = 0.15

        local v6 = egg(Vector3.new(1.05, 0.9, 2.5), CFrame.new(0, -0.35, 0.05), p1.Accent)
        local v7 = part({
            Size = Vector3.new(0.15, 1.4, 1.1),
            CFrame = CFrame.new(0, 0, 1.75) * CFrame.Angles(0.7853981633974483, 0, 0),
            Color = p1.Accent
        })
        local v8 = egg(Vector3.new(1.35, 0.25, 2.6), CFrame.new(0, 0.2, 0), p1.Accent, Enum.Material.Neon)

        for _, v9 in { -1, 1 } do
            egg(Vector3.new(0.3, 0.3, 0.3), CFrame.new(v9 * 0.55, 0.25, -0.95), Color3.new(1, 1, 1))
            egg(Vector3.new(0.16, 0.16, 0.16), CFrame.new(v9 * 0.68, 0.27, -1.02), Color3.fromRGB(20, 20, 30))
        end

        local v10 = Color3.fromRGB(200, 205, 215)

        part({
            Size = Vector3.new(1, 0.12, 0.12),
            Shape = Enum.PartType.Cylinder,
            CFrame = CFrame.new(0, -1.1, 0.1) * CFrame.Angles(0, 0, 1.5707963267948966),
            Color = v10,
            Material = Enum.Material.Metal
        })
        part({
            Size = Vector3.new(0.6, 0.12, 0.12),
            Shape = Enum.PartType.Cylinder,
            CFrame = CFrame.new(0, -1.6, -0.15) * CFrame.Angles(0, 1.5707963267948966, 0),
            Color = v10,
            Material = Enum.Material.Metal
        })
        part({
            Size = Vector3.new(0.45, 0.12, 0.12),
            Shape = Enum.PartType.Cylinder,
            CFrame = CFrame.new(0, -1.4, -0.45) * CFrame.Angles(0, 0, 1.5707963267948966),
            Color = v10,
            Material = Enum.Material.Metal
        })

        local v11 = part({
            Name = "Eyelet",
            Size = Vector3.new(0.1, 0.45, 0.45),
            Shape = Enum.PartType.Cylinder,
            CFrame = CFrame.new(0, 0.1, -1.6) * CFrame.Angles(0, 1.5707963267948966, 0),
            Color = v10,
            Material = Enum.Material.Metal
        })
        local Attachment = Instance.new("Attachment")

        Attachment.Name = "Tie"
        Attachment.Parent = v11
        Model.PrimaryPart = v5

        if p1.Rainbow then
            return Model, { v5, v6, v7, v8 }
        end

        return Model, {}
    end,
    cycle = function(p7, p8) -- cycle | line: 59
        for v12, v13 in p7 do
            v13.Color = Color3.fromHSV((p8 * 0.25 + v12 * 0.12) % 1, v12 == 2 and 0.45 or 0.85, 1)
        end
    end
}
