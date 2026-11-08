-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    FallSeconds = 0.55,
    BounceSeconds = 0.4,
    MagnetDelay = 1.02,
    MagnetSeconds = 0.52
}

function t1.GroundPosition(p1, p2, p3) -- line: 4
    -- upvalues: t1 (copy)
    local v2 = math.clamp(p3 / t1.FallSeconds, 0, 1)

    if v2 < 1 then
        return p1:Lerp(p2, v2) + Vector3.new(0, v2 * 4 * (1 - v2) * 2, 0)
    end

    local v6 = math.clamp((p3 - t1.FallSeconds) / t1.BounceSeconds, 0, 1)

    return p2 + Vector3.new(0, math.abs((math.sin(v6 * 3.141592653589793 * 2))) * (1 - v6) ^ 2 * 1.1, 0)
end

function t1.MagnetPosition(p4, p5, p6) -- line: 13
    local v10 = math.clamp(p6, 0, 1)

    return p4:Lerp(p5, v10 * v10) + Vector3.new(0, math.sin(v10 * 3.141592653589793) ^ 2 * 0.65, 0)
end

return table.freeze(t1)
