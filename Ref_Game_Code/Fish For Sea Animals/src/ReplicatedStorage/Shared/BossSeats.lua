-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    COUNT = 5,
    CHAIR = 1
}

local function layout(p1) -- line: 13
    local v1 = p1 - 3.5

    return {
        {
            Vector3.new(0, 0, -(p1 - 3)),
            (Vector3.new(0, 0, -1))
        },
        {
            Vector3.new(-v1, 0, -2),
            (Vector3.new(-1, 0, 0))
        },
        {
            Vector3.new(v1, 0, -2),
            (Vector3.new(1, 0, 0))
        },
        {
            Vector3.new(-p1 * 0.4, 0, v1),
            (Vector3.new(0, 0, 1))
        },
        {
            Vector3.new(p1 * 0.4, 0, v1),
            (Vector3.new(0, 0, 1))
        }
    }
end

function t1.frame(p2, p3, p4) -- line: 25
    local v6 = Vector3.new(p4.X, 0, p4.Z)
    local v7 = if v6.Magnitude > 0.01 then v6.Unit else Vector3.new(1, 0, 0)
    local v8 = Vector3.new(p2.X, p3, p2.Z)

    return CFrame.lookAt(v8, v8 + v7)
end

function t1.spot(p5, p6, p7, p8, p9) -- line: 33
    -- upvalues: t1 (copy), layout (copy)
    local v10 = layout(p8)[math.clamp(p5, 1, t1.COUNT)]
    local v11 = t1.frame(p6, p7, p9)
    local v12 = v11:PointToWorldSpace(v10[1])

    return CFrame.lookAt(v12, v12 + v11:VectorToWorldSpace(v10[2]))
end

return t1
