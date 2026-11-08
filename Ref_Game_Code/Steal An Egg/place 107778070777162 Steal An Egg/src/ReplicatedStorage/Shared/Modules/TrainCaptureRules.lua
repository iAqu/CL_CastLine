-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    InCone = function(p1, p2, p3, p4, p5) -- InCone | line: 4
        local v1 = p3 - p1
        local Magnitude = v1.Magnitude

        if p4 < Magnitude or p2.Magnitude < 0.001 then
            return false
        end

        if Magnitude < 0.001 then
            return true
        end

        return p2.Unit:Dot(v1.Unit) >= math.cos((math.rad(p5 / 2)))
    end
}

function t1.InCaptureCone(p6, p7, p8, p9, p10, _, p12) -- line: 11
    -- upvalues: t1 (copy)
    local v5 = p8 - p6
    local v6 = p9 < v5.Magnitude
    local v7 = if not v6 then p12 < math.abs(v5.Y) else nil

    if v6 or v7 then
        return false
    end

    local v8 = Vector3.new(v5.X, 0, v5.Z)

    if v8.Magnitude < 0.001 then
        return true
    end

    return t1.InCone(Vector3.new(0, 0, 0), Vector3.new(p7.X, 0, p7.Z), v8, p9, p10)
end

function t1.Advance(p13, p14, p15, p16) -- line: 19
    return (math.clamp(p13 + (if p16 then math.clamp(p14, 0, 0.2) else 0), 0, p15))
end

function t1.Reward(p17, p18, p19, p20) -- line: 24
    local v10 = p17 + 1 == p18

    return p19 + (if v10 then p20 else 0), v10
end

function t1.Recover(p21, p22, p23, p24) -- line: 29
    return (math.max(0, p21 - math.max(0, p22) * p23 / p24))
end

return table.freeze(t1)
