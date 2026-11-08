-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    HalfExtents = function(p1) -- HalfExtents | line: 13
        local Size = p1.Size

        return math.max(Size.X * 0.5 - 1.75, 0), (math.max(Size.Z * 0.5 - 1.75, 0))
    end
}

function t1.ClampedPointToward(p2, p3) -- line: 19
    -- upvalues: t1 (copy)
    local v4, v5 = t1.HalfExtents(p2)
    local v6 = p2.CFrame:PointToObjectSpace(p3)
    local v8 = math.clamp(v6.X, -v4, v4)
    local v10 = math.clamp(v6.Z, -v5, v5)

    return (p2.CFrame * CFrame.new(v8, 0, v10)).Position
end

function t1.RandomPoint(p4, p5) -- line: 28
    -- upvalues: t1 (copy)
    local v11, v12 = t1.HalfExtents(p4)
    local v13 = p5:NextNumber(-v11, v11)
    local v14 = p5:NextNumber(-v12, v12)

    return (p4.CFrame * CFrame.new(v13, 0, v14)).Position
end

function t1.IsPositionInside(p6, p7) -- line: 36
    -- upvalues: t1 (copy)
    local v15, v16 = t1.HalfExtents(p6)
    local v17 = p6.CFrame:PointToObjectSpace(p7)

    if not (math.abs(v17.X) <= v15) then
        return false
    end

    return math.abs(v17.Z) <= v16
end

function t1.PointNearOwner(p8, p9, p10) -- line: 43
    -- upvalues: t1 (copy)
    return t1.ClampedPointToward(p8, p9 + p10)
end

return t1
