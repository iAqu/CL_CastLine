-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}
local t2 = {}
local t3 = {}

for _, child in script:GetChildren() do
    if child:IsA("ModuleScript") then
        local v1 = require(child)

        assert(v1.Id == child.Name, (("FusionShrines.%* must have Id \"%*\""):format(child.Name, child.Name)))
        assert(#v1.Sides >= 2, (("FusionShrines.%* needs at least two sides"):format(child.Name)))
        t1[v1.Id] = v1

        for _, v6 in v1.Tiers do
            assert(t2[v6] == nil, (("Fusion tier %* is claimed by two shrines"):format(v6)))
            t2[v6] = v1
            table.insert(t3, v6)
        end
    end
end

table.sort(t3)

local t4 = {
    Default = "LightDark",
    Tiers = table.freeze(t3)
}

function t4.Get(p1) -- line: 84
    -- upvalues: t1 (copy)
    return t1[if type(p1) == "string" then p1 else "LightDark"]
end

function t4.Of(p2) -- line: 88
    -- upvalues: t4 (copy)
    return t4.Get(p2:GetAttribute("FusionShrine") or "LightDark")
end

function t4.KindOfTier(p3) -- line: 92
    -- upvalues: t2 (copy)
    return t2[p3]
end

function t4.PadsOf(p4, p5) -- line: 96
    local t5 = {}

    for _, v10 in p5.Sides do
        local v11 = p4:FindFirstChild(p5.Pads[v10])

        if not v11 or not v11:IsA("BasePart") then
            return nil
        end

        t5[v10] = v11
    end

    return t5
end

function t4.SlotsOf(p6, p7) -- line: 108
    local Placement = p7.Placement

    if not Placement then
        return nil
    end

    local t6 = {}

    for v12, v13 in Placement.Slots do
        local v14 = p6:FindFirstChild(v12)

        if not v14 or not v14:IsA("BasePart") then
            return nil
        end

        table.insert(t6, {
            Name = v12,
            Side = v13,
            Pad = v14
        })
    end

    table.sort(t6, function(p8, p9) -- line: 121
        return p8.Name < p9.Name
    end)

    return t6
end

function t4.SeatOf(p10, p11) -- line: 127
    local Placement = p10.Placement

    if Placement then
        for v15, v16 in Placement.Seats do
            if table.find(v16, p11) then
                return v15
            end
        end
    end

    return nil
end

function t4.Claim(p12, p13, p14, p15, p16) -- line: 140
    -- upvalues: t4 (copy)
    local v17 = t4.SeatOf(p12, p16)
    local t8 = {}
    local v18

    for v19, v20 in p13 do
        if v20 == p15 then
            t8[p14[v19]] = true
            v18 = t4.SeatOf(p12, v19)
        elseif t4.SeatOf(p12, v19) == v17 then
            return "Taken", nil
        end
    end

    if t8[p14[p16]] or v18 ~= nil and v18 ~= v17 then
        for _, v21 in p12.Sides do
            if not t8[v21] then
                return "Partner", v21
            end
        end

        return "Partner", nil
    end

    return "Open", nil
end

function t4.PairSlots(p17, p18) -- line: 169
    local Placement = p18.Placement

    if not (Placement and Placement.Seats) then
        local t9 = {}

        for _, v22 in p17 do
            t9[v22.Side] = t9[v22.Side] or {}
            table.insert(t9[v22.Side], v22)
        end

        local v24 = p18.Sides[1]
        local v25 = p18.Sides[2]
        local t10 = {}
        local t11 = {}

        for _, v26 in t9[v24] or {} do
            local v27

            for _, v28 in t9[v25] or {} do
                if not t10[v28] and (v27 == nil or (v28.Pad.Position - v26.Pad.Position).Magnitude < (v27.Pad.Position - v26.Pad.Position).Magnitude) then
                    v27 = v28
                end
            end

            if v27 then
                t10[v27] = true
                table.insert(t11, {
                    [v24] = v26.Pad,
                    [v25] = v27.Pad
                })
            end
        end

        return t11
    end

    local t13 = {}

    for _, v29 in p17 do
        t13[v29.Name] = v29
    end

    local t14 = {}

    for _, v30 in Placement.Seats do
        local t15 = {}

        for _, v31 in v30 do
            local v32 = t13[v31]

            if v32 then
                t15[v32.Side] = v32.Pad
            end
        end

        table.insert(t14, t15)
    end

    return t14
end

function t4.Others(p19, p20) -- line: 219
    local t16 = {}

    for _, v33 in p19.Sides do
        if v33 ~= p20 then
            table.insert(t16, v33)
        end
    end

    return t16
end

return table.freeze(t4)
