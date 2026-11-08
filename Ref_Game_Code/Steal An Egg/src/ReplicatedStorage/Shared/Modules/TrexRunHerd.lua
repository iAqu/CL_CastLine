-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local v1 = table.freeze({
    Course = "TrexRun_Course",
    Lanes = "TrexRun_Lanes",
    LaneWidth = "TrexRun_LaneWidth",
    Near = "TrexRun_Near",
    Far = "TrexRun_Far",
    FloorY = "TrexRun_FloorY",
    IntroAt = "TrexRun_IntroAt",
    StartAt = "TrexRun_StartAt",
    Alpha = "TrexRun_Alpha",
    Phase = "TrexRun_Phase",
    Herd = "TrexRun_Herd",
    EggPosition = "TrexRun_EggPosition",
    CarrierUserId = "TrexRun_CarrierUserId",
    EggLabel = "TrexRun_EggLabel"
})
local t1 = {
    Attributes = v1,
    DepthAt = function(p1, p2) -- DepthAt | line: 53
        if p2 <= p1.At then
            return p1.Depth
        end

        return p1.Depth + p1.Direction * p1.Speed * (p2 - p1.At)
    end,
    IsMoving = function(p3, p4) -- IsMoving | line: 61
        return p3.At < p4
    end,
    TurnAlpha = function(p5, p6) -- TurnAlpha | line: 65
        local TurnFrom = p5.TurnFrom

        if TurnFrom == nil or p5.At <= p6 then
            return 1
        end

        return (math.clamp((p6 - TurnFrom) / math.max(p5.At - TurnFrom, 0.001), 0, 1))
    end
}

function t1.Turn(p7, p8, p9) -- line: 75
    -- upvalues: t1 (copy)
    p7.Depth = t1.DepthAt(p7, p8)
    p7.TurnFrom = p8
    p7.At = p8 + p9
    p7.Direction = -p7.Direction
end

function t1.IsExpired(p10, p11, p12) -- line: 82
    -- upvalues: t1 (copy)
    local v5 = t1.DepthAt(p10, p12)

    if p10.Direction < 0 then
        return v5 < p11.Near - 40
    end

    return p11.Far + 40 < v5
end

function t1.LaneOffset(p13, p14) -- line: 92
    return (p14 - (p13.Lanes + 1) * 0.5) * p13.LaneWidth
end

function t1.TrexLateral(p15, p16, p17) -- line: 96
    -- upvalues: t1 (copy)
    local Offsets = p16.Offsets
    local v6 = Offsets ~= nil and Offsets[p17] or 0

    return t1.LaneOffset(p15, p16.Lanes[p17]) + v6
end

function t1.Forward(p18) -- line: 103
    return p18.Origin.LookVector
end

function t1.Across(p19) -- line: 107
    return p19.Origin.RightVector
end

function t1.Point(p20, p21, p22) -- line: 111
    local Origin = p20.Origin
    local v7 = Origin.Position + Origin.LookVector * p21 + Origin.RightVector * p22

    return (Vector3.new(v7.X, p20.FloorY, v7.Z))
end

function t1.Locate(p23, p24) -- line: 118
    local v8 = p24 - p23.Origin.Position

    return v8:Dot(p23.Origin.LookVector), v8:Dot(p23.Origin.RightVector)
end

function t1.LaneAt(p25, p26) -- line: 124
    return (math.clamp(math.floor(p26 / p25.LaneWidth + (p25.Lanes + 1) * 0.5 + 0.5), 1, p25.Lanes))
end

function t1.ReadCourse(p27) -- line: 130
    -- upvalues: v1 (copy)
    local Attribute = p27:GetAttribute(v1.Course)
    local Attribute2 = p27:GetAttribute(v1.Lanes)
    local Attribute3 = p27:GetAttribute(v1.LaneWidth)
    local Attribute4 = p27:GetAttribute(v1.Near)
    local Attribute5 = p27:GetAttribute(v1.Far)
    local Attribute6 = p27:GetAttribute(v1.FloorY)

    return if typeof(Attribute) == "CFrame" and type(Attribute2) == "number" and type(Attribute3) == "number" and type(Attribute4) == "number" and type(Attribute5) == "number" and type(Attribute6) == "number" then {
        Origin = Attribute,
        Lanes = Attribute2,
        LaneWidth = Attribute3,
        Near = Attribute4,
        Far = Attribute5,
        FloorY = Attribute6
    } else nil
end

function t1.WriteCourse(p28, p29) -- line: 159
    -- upvalues: v1 (copy)
    p28:SetAttribute(v1.Course, if p29 == nil then nil else p29.Origin)
    p28:SetAttribute(v1.Lanes, if p29 == nil then nil else p29.Lanes)
    p28:SetAttribute(v1.LaneWidth, if p29 == nil then nil else p29.LaneWidth)
    p28:SetAttribute(v1.Near, if p29 == nil then nil else p29.Near)
    p28:SetAttribute(v1.Far, if p29 == nil then nil else p29.Far)
    p28:SetAttribute(v1.FloorY, if p29 == nil then nil else p29.FloorY)
end

return table.freeze(t1)
