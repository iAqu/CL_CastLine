-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    (Vector3.new(-0.1, 19.9, -35.1)),
    (Vector3.new(-1, 20.4, -34.3)),
    (Vector3.new(-1.7, 20, -34.5)),
    (Vector3.new(-2.2, 19.5, -34.9)),
    (Vector3.new(-2.3, 19.5, -35.3)),
    (Vector3.new(-2.1, 20.1, -35.6)),
    (Vector3.new(-1.9, 20.9, -35.9)),
    (Vector3.new(0.7, 24, -36.3)),
    (Vector3.new(6.1, 29.5, -35.6)),
    (Vector3.new(12.5, 35.2, -32.6)),
    (Vector3.new(18.8, 40.2, -26.8)),
    (Vector3.new(24.3, 43.8, -18.3)),
    (Vector3.new(28.2, 45.8, -7.2)),
    (Vector3.new(29.4, 45.7, 5.4)),
    (Vector3.new(26.7, 43.7, 18.1)),
    (Vector3.new(20.1, 40.8, 28.7)),
    (Vector3.new(10.2, 37.8, 35.4)),
    (Vector3.new(1.5, 35.6, 37.8)),
    (Vector3.new(-1.1, 34.5, 37.9)),
    (Vector3.new(-0.4, 34.5, 37.4)),
    (Vector3.new(3.9, 37.9, 35.4)),
    (Vector3.new(9.6, 50.3, 26.3)),
    (Vector3.new(6.3, 63, 2.6)),
    (Vector3.new(-6.6, 54.8, -23.2)),
    (Vector3.new(-26.6, 26.8, -24.8))
}
local t2 = {
    BodyRadius = 1.6
}

local function flat(p1) -- line: 64
    return (Vector3.new(p1.X, 0, p1.Z))
end

function t2.ActiveSeconds(p2) -- line: 68
    if p2.Kind == "Ring" then
        return (p2.Radius or 0) / math.max(p2.Speed or 1, 1)
    end

    if p2.Kind ~= "Line" then
        return p2.Duration or 0.25
    end

    return (p2.Travel or 0) / math.max(p2.Speed or 1, 1)
end

function t2.Dodgeable(p3) -- line: 78
    if p3.Kind == "Ring" or p3.Kind == "Line" or p3.Kind == "Sweep" then
        return true
    end

    return p3.Kind == "Beam"
end

function t2.BeamProgress(p4, p5) -- line: 82
    local v6 = math.max(p4.Duration or 1, 0.05)
    local v7 = math.clamp(p5, 0, v6)

    if p4.Ramp == nil then
        local v8 = v7 / v6

        return v8 * v8 * (3 - v8 * 2)
    end

    local v10 = math.clamp(p4.Ramp, 0.01, v6 / 2)
    local v11 = 1 / (v6 - v10)

    if v7 < v10 then
        return v11 * v7 * v7 / (v10 * 2)
    end

    if v6 - v10 < v7 then
        local v12 = v6 - v7

        return 1 - v11 * v12 * v12 / (v10 * 2)
    end

    return v11 * (v7 - v10 / 2)
end

function t2.BeamHeading(p6, p7) -- line: 104
    -- upvalues: t2 (copy)
    local v13 = p6.Direction or Vector3.new(0, 0, 1)
    local Unit = Vector3.new(v13.X, 0, v13.Z).Unit
    local v14 = t2.BeamProgress(p6, p7)

    return CFrame.Angles(0, math.rad(p6.Angle or 0) * v14, 0) * Unit
end

function t2.RingRadius(p8, p9) -- line: 111
    return (math.min((p8.Speed or 0) * math.max(p9, 0), p8.Radius or 0))
end

function t2.LineOffset(p10, p11) -- line: 115
    return (math.min((p10.Speed or 0) * math.max(p11, 0), p10.Travel or 0))
end

function t2.Contains(p12, p13, p14, p15, p16) -- line: 119
    -- upvalues: t2 (copy)
    if p13 < 0 or t2.ActiveSeconds(p12) < p13 or p15 and t2.Dodgeable(p12) then
        return false
    end

    local v20 = p14 - p12.Origin
    local v21 = Vector3.new(v20.X, 0, v20.Z)
    local Magnitude = v21.Magnitude
    local v22 = p16 + 1.6

    if p12.Kind == "Ring" then
        return math.abs(Magnitude - t2.RingRadius(p12, p13)) <= (p12.Width or 2) / 2 + v22
    end

    if p12.Kind == "Line" then
        local v24 = p12.Direction or Vector3.new(0, 0, 1)
        local Unit = Vector3.new(v24.X, 0, v24.Z).Unit
        local v25 = Unit:Cross((Vector3.new(0, 1, 0)))
        local v26 = v21:Dot(Unit)
        local v28 = math.abs((v21:Dot(v25)))

        if math.abs(v26 - t2.LineOffset(p12, p13)) <= (p12.Width or 2) / 2 + v22 then
            return v28 <= (p12.Length or 0) / 2 + v22
        end

        return false
    end

    if p12.Kind == "Strike"
        or p12.Kind == "Missile"
        or p12.Kind == "Puddle"
        or p12.Kind == "Grab"
        or p12.Kind == "Sweep"
        or p12.Kind == "Blast" then
        return Magnitude <= (p12.Radius or 0) + v22
    end

    if p12.Kind == "Lane" then
        local v30 = p12.Direction or Vector3.new(0, 0, 1)
        local Unit = Vector3.new(v30.X, 0, v30.Z).Unit
        local v31 = Unit:Cross((Vector3.new(0, 1, 0)))
        local v32 = v21:Dot(Unit)

        if not (-v22 <= v32 and v32 <= (p12.Length or 0) + v22) then
            return false
        end

        return math.abs((v21:Dot(v31))) <= (p12.Width or 0) / 2 + v22
    end

    if p12.Kind == "Beam" then
        local v34 = t2.BeamHeading(p12, p13)
        local v35 = v21:Dot(v34)

        if not (-v22 <= v35 and v35 <= (p12.Length or 0) + v22) then
            return false
        end

        return math.abs((v21:Dot(v34:Cross((Vector3.new(0, 1, 0)))))) <= (p12.Width or 0) / 2 + v22
    end

    if p12.Kind ~= "Pillars" then
        if p12.Kind ~= "Cone" or (p12.Radius or 0) + v22 < Magnitude then
            return false
        end

        if Magnitude < 4 then
            return true
        end

        local v37 = p12.Direction or Vector3.new(0, 0, 1)
        local Unit = Vector3.new(v37.X, 0, v37.Z).Unit
        local v39 = math.clamp(v21.Unit:Dot(Unit), -1, 1)

        return math.rad((p12.Angle or 60) / 2) + math.atan2(v22, Magnitude) >= math.acos(v39)
    end

    for _, v41 in p12.Points or {} do
        local v42 = p14 - v41

        if Vector3.new(v42.X, 0, v42.Z).Magnitude <= (p12.Radius or 0) + v22 then
            return true
        end
    end

    return false
end

function t2.ClawAt(p17) -- line: 203
    -- upvalues: t1 (copy)
    local v45 = math.clamp((p17 - 0.8125) / 0.0625, 0, #t1 - 1)
    local v46 = math.floor(v45)

    return t1[v46 + 1]:Lerp(t1[math.min(v46 + 2, #t1)], v45 - v46)
end

function t2.GripCFrame(p18) -- line: 212
    local v50 = p18 - Vector3.new(0, 3, 0)
    local v53 = Vector3.new(-v50.X, 0, -v50.Z)

    if v53.Magnitude < 0.001 then
        return CFrame.new(v50)
    end

    return CFrame.lookAt(v50, v50 + v53)
end

function t2.Reach(p19) -- line: 222
    if p19.Kind == "Line" then
        return (p19.Travel or 0) + (p19.Length or 0) / 2
    end

    if p19.Kind == "Lane" or p19.Kind == "Beam" then
        return (p19.Length or 0) + (p19.Width or 0)
    end

    if p19.Kind == "Pillars" then
        return 1000
    end

    return p19.Radius or 0
end

return t2
