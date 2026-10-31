-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    Basketball = { 0, 0, 0, 0, 0 },
    Volcanic = { -0.6, -0.8, -1, -1.1, -1.2 },
    Gold = { -1, -1, -1, -1, -1.1 },
    Jurassic = { 0.3, 0.4, 0.4, 0.5, 0.6 },
    RaceArena = { -0.2, 0, -0.2, -0.3, -0.5 },
    IceHockey = { 0.7, 0.7, 1, 0.6, 0.5 },
    Football = { 0, 0, 0, 0, -0.2 },
    Default = { 0, 0.6, 0, 0, 0 },
    Castle = { -0.3, -0.5, -0.6, -0.6, -0.8 },
    Fantasy = { -0.6, -0.7, -0.9, -1.1, -1.2 },
    ModernHouse = { 0, 0, 0, 0, 0 },
    Scifi = { 0, 0, 0, 0, 0 }
}

return {
    prepareAquariumPrefabInstance = function(p1) -- prepareAquariumPrefabInstance | line: 32
        for _, descendant in p1:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true
            end

            if descendant:IsA("BaseScript") then
                descendant:Destroy()
            end
        end
    end,
    computeAquariumPivotCFrame = function(p2, p3, p4, p5, p6, p7) -- computeAquariumPivotCFrame | line: 55
        -- upvalues: t1 (copy)
        local v1 = if p6 == nil then 1 else p6
        local v2 = p7 ~= nil and p7
        local BoundingBox, BoundingBox2 = p2:GetBoundingBox()
        local Pivot = p2:GetPivot()
        local Position, RightVector = p3.Position, p3.RightVector
        local v3 = BoundingBox2.Z / 2
        local v4 = if v2 then Position else Position + RightVector * v3
        local v5 = BoundingBox.Position.Y - BoundingBox2.Y / 2
        local v6 = t1[p5]
        local v7

        if v6 ~= nil then
            v7 = v6[p4]

            if v7 == nil then
                v7 = 0
            end
        else
            v7 = 0
        end

        local v8 = v7 * v1
        local v9 = Position.Y + (Pivot.Position.Y - v5) + v8
        local v10 = p3.Rotation * CFrame.Angles(0, -1.5707963267948966, 0)

        return CFrame.new(v4.X, v9, v4.Z) * v10
    end,
    computeAquariumCenteredPivotCFrame = function(p8, p9) -- computeAquariumCenteredPivotCFrame | line: 111
        local BoundingBox, BoundingBox2 = p8:GetBoundingBox()
        local Pivot = p8:GetPivot()
        local Position = p9.Position
        local v11 = BoundingBox.Position.Y - BoundingBox2.Y / 2
        local v12 = Position.Y + (Pivot.Position.Y - v11)

        return CFrame.new(Position.X, v12, Position.Z) * p9.Rotation
    end,
    aquariumSkinYOffsets = t1
}
