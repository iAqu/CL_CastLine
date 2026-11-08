-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 28
    -- upvalues: t1 (copy)
    local v1 = #p1:GetChildren()

    assert(v1 >= 3, (("%* needs at least 3 attachments"):format((p1:GetFullName()))))

    local v4 = table.create(v1)
    local v5 = table.create(v1)
    local v6 = table.create(v1)

    for i = 1, v1 do
        local v7 = p1:FindFirstChild((tostring(i)))

        assert(v7 ~= nil and v7:IsA("Attachment"), (("%* needs Attachments named 1..%*; %* is missing"):format(p1:GetFullName(), v1, i)))
        v4[i] = v7.WorldPosition
        v5[i] = v7.WorldCFrame.UpVector
        v6[i] = v7:GetAttribute("NoRespawn") ~= true
    end

    assert(table.find(v6, true) ~= nil, (("%* has no respawnable attachment"):format((p1:GetFullName()))))

    local v12 = table.create(v1)
    local v13 = table.create(v1)
    local n1 = 0

    for i = 1, v1 do
        local Magnitude = (v4[i % v1 + 1] - v4[i]).Magnitude

        assert(Magnitude >= 1, (("%* segment %* is shorter than a stud"):format(p1:GetFullName(), i)))
        v12[i] = n1
        v13[i] = Magnitude
        n1 += Magnitude
    end

    return (setmetatable({
        Count = v1,
        Length = n1,
        Points = v4,
        Ups = v5,
        Starts = v12,
        Lengths = v13,
        Respawnable = v6
    }, t1))
end

function t1.Locate(p2, p3) -- line: 70
    local v17 = math.floor(p3 / p2.Length) * p2.Length
    local v18 = p3 - v17
    local v19 = 1
    local v20 = p2.Count

    while v19 < v20 do
        local v21 = (v19 + v20 + 1) // 2

        if p2.Starts[v21] <= v18 then
            v19 = v21
        else
            v20 = v21 - 1
        end
    end

    return v19, v17
end

function t1.FrameAt(p4, p5) -- line: 86
    local v22, v23 = p4:Locate(p5)
    local v24 = v22 % p4.Count + 1
    local v26 = math.clamp((p5 - v23 - p4.Starts[v22]) / p4.Lengths[v22], 0, 1)
    local v27 = p4.Points[v22]
    local v28 = p4.Points[v24]
    local v29 = v27:Lerp(v28, v26)

    return CFrame.lookAt(v29, v29 + (v28 - v27), p4.Ups[v22]:Lerp(p4.Ups[v24], v26))
end

function t1.Project(p6, p7, p8, p9, p10) -- line: 96
    local v30 = p8 - p9
    local v31 = p8 + p10
    local v32, v33 = p6:Locate(v30)
    local v34 = v30
    local n2 = 1e999

    while v33 + p6.Starts[v32] <= v31 do
        local v35 = p6.Points[v32]
        local v36 = p6.Points[v32 % p6.Count + 1] - v35
        local v37 = p6.Lengths[v32]
        local v39 = math.clamp((p7 - v35):Dot(v36) / (v37 * v37), 0, 1)
        local Magnitude = (v35 + v36 * v39 - p7).Magnitude

        if Magnitude < n2 then
            n2 = Magnitude
            v34 = v33 + p6.Starts[v32] + v39 * v37
        end

        v32 += 1

        if p6.Count < v32 then
            v32 = 1
            v33 += p6.Length
        end
    end

    return math.clamp(v34, v30, v31), n2
end

function t1.RespawnAt(p11, p12) -- line: 126
    local v40, v41 = p11:Locate(p12)

    for _ = 1, p11.Count do
        if p11.Respawnable[v40] then
            local v42 = v41 + p11.Starts[v40]

            return p11:FrameAt(v42), v42
        end

        v40 -= 1

        if v40 < 1 then
            v40 = p11.Count
            v41 -= p11.Length
        end
    end

    error("unreachable: RaceTrackPath.new asserts a respawnable point")
end

return table.freeze(t1)
