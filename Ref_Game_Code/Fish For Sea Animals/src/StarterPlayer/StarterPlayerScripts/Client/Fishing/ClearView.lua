-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

local function distToSegment(p1, p2, p3) -- line: 6
    local v1 = p3 - p2

    return (p2 + v1 * math.clamp((p1 - p2):Dot(v1) / math.max(v1:Dot(v1), 1E-06), 0, 1) - p1).Magnitude
end

local function hideUnit(p4, p5) -- line: 12
    local v5 = if p4:IsA("BasePart") then { p4 } else p4:GetDescendants()

    for _, v6 in v5 do
        if v6:IsA("BasePart") and v6.LocalTransparencyModifier < 1 then
            v6.LocalTransparencyModifier = 1
            table.insert(p5, v6)
        end
    end
end

function t1.hide(p6, p7, p8) -- line: 24
    -- upvalues: hideUnit (copy)
    local t2 = {}

    local function scan(p9) -- line: 26
        -- upvalues: p6 (copy), p7 (copy), p8 (copy), t2 (copy), scan (copy), hideUnit (copy)
        for _, child in p9:GetChildren() do
            if child:IsA("Folder") then
                scan(child)
            elseif child:IsA("Model") or child:IsA("BasePart") then
                local BoundingBox, Position

                if child:IsA("Model") then
                    local BoundingBox2

                    BoundingBox2, BoundingBox = child:GetBoundingBox()
                    Position = BoundingBox2.Position
                else
                    Position = child.Position
                    BoundingBox = child.Size
                end

                local v7 = p7 - p6

                if (p6 + v7 * math.clamp((Position - p6):Dot(v7) / math.max(v7:Dot(v7), 1E-06), 0, 1) - Position).Magnitude - BoundingBox.Magnitude / 2 < p8 then
                    hideUnit(child, t2)
                end
            end
        end
    end

    local Map = workspace:FindFirstChild("Map")
    local v11 = if Map then Map:GetChildren() else {}

    for _, v12 in v11 do
        local Biomes = v12:FindFirstChild("Biomes")
        local v13 = if Biomes then Biomes:GetChildren() else {}

        for _, v14 in v13 do
            local Decor = v14:FindFirstChild("Decor")

            if Decor then
                scan(Decor)
            end
        end
    end

    return function() -- line: 55
        -- upvalues: t2 (copy)
        for _, v15 in t2 do
            v15.LocalTransparencyModifier = 0
        end
    end
end

return t1
