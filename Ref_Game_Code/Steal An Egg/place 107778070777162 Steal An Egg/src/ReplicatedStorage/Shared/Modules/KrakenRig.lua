-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Workspace = game:GetService("Workspace")
local t1 = {
    0, 8, 14
}
local t2 = {
    -30, -15, 0, 15
}
local t3 = {
    -45, -30, -15, 0, 15
}
local t4 = {
    Timing = table.freeze({
        Windup = 1.05,
        Hold = 0.25,
        Strike = 0.3,
        Settle = 0.3,
        Down = 0.85,
        Recover = 0.55
    }),
    Raise = table.freeze({ -30, -16, -28 }),
    Whip = table.freeze(t1),
    Hump = 4.5,
    Attribute = "KrakenPose"
}

local function closestOnBox(p1, p2, p3) -- line: 72
    local v1 = p2:PointToObjectSpace(p3)
    local v2 = p1.Size / 2

    return p2:PointToWorldSpace((Vector3.new(math.clamp(v1.X, -v2.X, v2.X), math.clamp(v1.Y, -v2.Y, v2.Y), (math.clamp(v1.Z, -v2.Z, v2.Z)))))
end

local function extentAlong(p4, p5, p6) -- line: 84
    return math.abs((p5.RightVector:Dot(p6))) * p4.Size.X + math.abs((p5.UpVector:Dot(p6))) * p4.Size.Y + math.abs((p5.LookVector:Dot(p6))) * p4.Size.Z
end

local function restFrames(p7) -- line: 90
    local t5 = {}

    for _, v14 in p7 do
        local Part0, Part1 = v14.Part0, v14.Part1
        local v15 = t5[Part0] or Part0.CFrame

        t5[Part0] = v15
        t5[Part1] = v15 * v14.C0 * v14.C1:Inverse()
    end

    return t5
end

local function makeJoint(p8, p9, p10) -- line: 101
    local v16 = p9[p8.Part0] * p8.C0

    return {
        Motor = p8,
        Rest = v16,
        Inverse = v16:Inverse(),
        Pivot = p10
    }
end

local function chainOf(p11) -- line: 106
    local t6 = {}

    for _, descendant in p11:GetDescendants() do
        if descendant:IsA("Motor6D") and descendant.Part0 and descendant.Part1 then
            t6[descendant.Part0] = descendant
        end
    end

    local t7 = {}
    local Root = p11:FindFirstChild("Root")

    while Root and Root:IsA("BasePart") and t6[Root] and #t7 < 8 do
        local v17 = t6[Root]

        table.insert(t7, v17)
        Root = v17.Part1
    end

    return t7
end

local function probe(p12, p13) -- line: 123
    -- upvalues: Workspace (copy)
    return Workspace:Raycast(Vector3.new(p12.X, 900, p12.Z), Vector3.new(0, -1600, 0), p13)
end

function t4.About(p14, p15) -- line: 131
    return CFrame.new(p14) * p15 * CFrame.new(-p14)
end

function t4.Drive(p16, p17) -- line: 135
    p16.Motor.Transform = p16.Inverse * p17 * p16.Rest
end

function t4.StrikeAngle(p18, p19) -- line: 139
    return p18.Pose[p19] or 0
end

function t4.Head(p20) -- line: 143
    -- upvalues: closestOnBox (copy), restFrames (copy), chainOf (copy)
    local v18 = chainOf(p20)

    if #v18 ~= 1 then
        return nil
    end

    local Part1 = v18[1].Part1
    local v19 = restFrames(v18)
    local v20 = v19[Part1]
    local v21 = v18[1]
    local v22 = closestOnBox(Part1, v20, v20.Position - Vector3.new(0, 10000, 0))
    local v23 = v19[v21.Part0] * v21.C0

    return {
        Motor = v21,
        Rest = v23,
        Inverse = v23:Inverse(),
        Pivot = v22
    }
end

local function geometryOf(p21) -- line: 172
    -- upvalues: closestOnBox (copy), extentAlong (copy), restFrames (copy), chainOf (copy)
    local v24 = chainOf(p21)

    if #v24 < 2 then
        return nil
    end

    local t8 = {}

    for _, v25 in v24 do
        table.insert(t8, v25.Part1)
    end

    local v26 = t8[1]
    local v27 = t8[#t8]
    local v28 = restFrames(v24)
    local v29 = closestOnBox(v26, v28[v26], v28[v26].Position - Vector3.new(0, 10000, 0))
    local t9 = {
        v29
    }

    for i = 2, #t8 do
        local v30 = t8[i - 1]
        local v31 = t8[i]

        table.insert(t9, (closestOnBox(v30, v28[v30], v28[v31].Position) + closestOnBox(v31, v28[v31], v28[v30].Position)) / 2)
    end

    local v33 = v28[v27].Position + (v28[v27].Position - t9[#t9])
    local v36 = Vector3.new(v33.X - v29.X, 0, v33.Z - v29.Z)

    if v36.Magnitude < 1 then
        return nil
    end

    local Unit = v36.Unit
    local Unit2 = (Vector3.new(0, 1, 0)):Cross(Unit).Unit
    local t10 = {}

    for v37, v38 in v24 do
        local v39 = t9[v37]
        local v40 = v28[v38.Part0] * v38.C0

        table.insert(t10, {
            Motor = v38,
            Rest = v40,
            Inverse = v40:Inverse(),
            Pivot = v39
        })
    end

    local t12 = {}

    for v41, v42 in t8 do
        t12[v41] = extentAlong(v42, v28[v42], Unit2) / 2
    end

    local v43 = table.clone(t9)

    table.insert(v43, v33)

    return {
        Model = p21,
        Joints = t10,
        Segments = t8,
        Pivots = t9,
        Line = v43,
        Thickness = t12,
        Base = v29,
        Tip = v33,
        Reach = v36,
        Heading = Unit,
        Curl = Unit2
    }
end

local function sample(p22, p23) -- line: 235
    -- upvalues: t4 (copy)
    local t13 = {}
    local t14 = {}
    local v44 = CFrame.identity

    for v45, v46 in p22.Pivots do
        local v48 = CFrame.fromAxisAngle(p22.Curl, (math.rad(p23[v45] or 0)))

        v44 *= t4.About(v46, v48)

        local v49 = p22.Line[v45]
        local v50 = p22.Line[v45 + 1]

        for i = 0, 11 do
            table.insert(t13, v44 * v49:Lerp(v50, i / 12))
            table.insert(t14, p22.Thickness[v45])
        end
    end

    return t13, t14, v44 * p22.Tip
end

local function crossingsAt(p24, p25, p26) -- line: 251
    -- upvalues: Workspace (copy), sample (copy)
    local v53, v54 = sample(p24, p25)
    local t15 = {}
    local v55

    for v56, v57 in v53 do
        local v58 = Workspace:Raycast(Vector3.new(v57.X, 900, v57.Z), Vector3.new(0, -1600, 0), p26)

        if v58 ~= nil then
            local v59 = v54[v56]
            local v60 = v57.Y + v59 - v58.Position.Y

            v55 = math.max(v55 or (-1e999), v60)

            if not (v60 < 0.5) then
                local v63 = math.max(v59 - math.min(v60, v59), 0)
                local v66 = math.sqrt((math.max(v59 * v59 - v63 * v63, 0)))

                table.insert(t15, {
                    Point = v57,
                    Surface = v58.Position.Y,
                    Top = v57.Y + v59,
                    Radius = math.max(v66 * 0.8, 5)
                })
            end
        end
    end

    return t15, v55
end

local function includeParams(p27) -- line: 282
    local v68 = RaycastParams.new()

    v68.FilterType = Enum.RaycastFilterType.Include
    v68.FilterDescendantsInstances = { p27 }

    return v68
end

local function excludeParams(p28) -- line: 289
    local v69 = RaycastParams.new()

    v69.FilterType = Enum.RaycastFilterType.Exclude
    v69.FilterDescendantsInstances = p28
    v69.IgnoreWater = false

    return v69
end

local function waterlineOf(p29) -- line: 297
    return p29.Model:FindFirstChild("Root").Position.Y
end

local function surfaceUnder(p30, p31, p32) -- line: 301
    -- upvalues: Workspace (copy)
    local Y = p30.Model:FindFirstChild("Root").Position.Y
    local v70 = Workspace:Raycast(Vector3.new(p31.X, 900, p31.Z), Vector3.new(0, -1600, 0), p32)

    if v70 == nil then
        return Vector3.new(p31.X, Y, p31.Z), true
    end

    return v70.Position, v70.Material == Enum.Material.Water or v70.Position.Y <= Y + 1
end

local function visibleCount(p33, p34, p35) -- line: 314
    -- upvalues: Workspace (copy), sample (copy)
    local v71, v72 = sample(p33, p34)
    local n1 = 0

    for v73, v74 in v71 do
        local v75 = Workspace:Raycast(Vector3.new(v74.X, 900, v74.Z), Vector3.new(0, -1600, 0), p35)
        local Y = if v75 then v75.Position.Y else p33.Model:FindFirstChild("Root").Position.Y

        if v74.Y + v72[v73] > Y + 0.5 then
            n1 += 1
        end
    end

    return n1
end

local function sceneryPose(p36, p37) -- line: 327
    -- upvalues: Workspace (copy), t1 (copy), sample (copy)
    local v76 = p36.Tip - p36.Base
    local Magnitude = v76.Magnitude
    local v77 = math.atan2(v76.Y, p36.Reach.Magnitude)

    local function toward(p38) -- line: 331
        -- upvalues: p36 (copy), Magnitude (copy), v77 (copy)
        return (math.clamp(math.deg(v77 - math.asin((math.clamp((p38 - p36.Base.Y) / Magnitude, -1, 1)))), 18, 78))
    end

    local v83 = table.clone(t1)

    v83[1] = math.clamp(math.deg(v77 - math.asin((math.clamp((p36.Model:FindFirstChild("Root").Position.Y + 3 - p36.Base.Y) / Magnitude, -1, 1)))), 18, 78)

    local _, _, v88 = sample(p36, v83)
    local Y2 = p36.Model:FindFirstChild("Root").Position.Y
    local v89 = Workspace:Raycast(Vector3.new(v88.X, 900, v88.Z), Vector3.new(0, -1600, 0), p37)
    local Position

    if v89 ~= nil then
        Position = v89.Position

        if v89.Material ~= Enum.Material.Water and v89.Position.Y <= Y2 + 1 then
        end
    else
        Position = Vector3.new(v88.X, Y2, v88.Z)
    end

    v83[1] = math.clamp(math.deg(v77 - math.asin((math.clamp((Position.Y + 3 - p36.Base.Y) / Magnitude, -1, 1)))), 18, 78)

    return v83
end

local function slamFor(p39, p40, p41) -- line: 343
    -- upvalues: crossingsAt (copy)
    local v94 = table.clone(p40)
    local n2 = 0

    while n2 <= 95 do
        v94[1] = n2

        local _, v95 = crossingsAt(p39, v94, p41)

        if v95 == nil or not (v95 <= 4.5) then
            n2 += 1
            continue
        end

        local v97 = math.max(n2 - 1, 0)

        for _ = 1, 6 do
            v94[1] = (v97 + n2) / 2

            local _, v98 = crossingsAt(p39, v94, p41)

            if v98 == nil or not (v98 <= 4.5) then
                v97 = v94[1]
            else
                n2 = v94[1]
            end
        end

        v94[1] = n2

        local v99 = crossingsAt(p39, v94, p41)

        if #v99 > 0 then
            return n2, v99
        end

        return nil, {}
    end

    return nil, {}
end

function t4.Solve(p42, p43, p44, p45) -- line: 376
    -- upvalues: t2 (copy), t3 (copy), geometryOf (copy), visibleCount (copy), sceneryPose (copy), slamFor (copy)
    local v100 = geometryOf(p42)

    if v100 == nil then
        return nil
    end

    local v101 = RaycastParams.new()

    v101.FilterType = Enum.RaycastFilterType.Include
    v101.FilterDescendantsInstances = { p43 }

    local v102 = RaycastParams.new()

    v102.FilterType = Enum.RaycastFilterType.Exclude
    v102.FilterDescendantsInstances = p44
    v102.IgnoreWater = false

    local n3 = (-1e999)
    local v103

    for _, v104 in t2 do
        local v105 = v103
        local v106 = n3

        for _, v107 in t3 do
            local t17 = {
                0,
                v104,
                v107
            }
            local v108, v109 = slamFor(v100, t17, v101)

            if v108 ~= nil then
                t17[1] = v108

                local v110 = visibleCount(v100, t17, v102) + #v109 * 3 - (math.abs(v104) + math.abs(v107)) * 0.02

                if v106 < v110 then
                    v106 = v110
                    v105 = t17
                end
            end

            n3 = v106

            if p45 then
                p45()
            end

            v103 = v105
        end
    end

    return v103 or sceneryPose(v100, v102)
end

function t4.Encode(p46) -- line: 412
    local v111 = table.create(#p46, "")

    for v112, v113 in p46 do
        v111[v112] = string.format("%.3f", v113)
    end

    return table.concat(v111, ",")
end

function t4.Decode(p47) -- line: 420
    if type(p47) ~= "string" then
        return nil
    end

    local t18 = {}

    for match in string.gmatch(p47, "[^,]+") do
        local v114 = tonumber(match)

        if v114 == nil or v114 ~= v114 or math.abs(v114) > 180 then
            return nil
        end

        table.insert(t18, v114)
    end

    return if #t18 > 0 then t18 else nil
end

function t4.Arm(p48, p49, p50, p51) -- line: 435
    -- upvalues: Workspace (copy), geometryOf (copy), sample (copy), crossingsAt (copy)
    local v115 = geometryOf(p48)

    if v115 == nil then
        return nil
    end

    local v116 = RaycastParams.new()

    v116.FilterType = Enum.RaycastFilterType.Include
    v116.FilterDescendantsInstances = { p49 }

    local v117 = RaycastParams.new()

    v117.FilterType = Enum.RaycastFilterType.Exclude
    v117.FilterDescendantsInstances = p50
    v117.IgnoreWater = false

    local v118 = crossingsAt(v115, p51, v116)
    local Position, v119

    if #v118 > 0 then
        local v120 = v118[1]

        for _, v121 in v118 do
            if v121.Top - v121.Surface > v120.Top - v120.Surface then
                v120 = v121
            end
        end

        v119 = false
        Position = Vector3.new(v120.Point.X, v120.Surface, v120.Point.Z)
    else
        local _, _, v122 = sample(v115, p51)
        local Y = v115.Model:FindFirstChild("Root").Position.Y
        local v123 = Workspace:Raycast(Vector3.new(v122.X, 900, v122.Z), Vector3.new(0, -1600, 0), v117)

        if v123 ~= nil then
            Position = v123.Position
            v119 = v123.Material == Enum.Material.Water or v123.Position.Y <= Y + 1
        else
            Position = Vector3.new(v122.X, Y, v122.Z)
            v119 = true
        end
    end

    return {
        Model = p48,
        Joints = v115.Joints,
        Segments = v115.Segments,
        Curl = v115.Curl,
        Heading = v115.Heading,
        Tip = v115.Tip,
        Pose = p51,
        Impact = Position,
        Wet = v119,
        Crossings = v118
    }
end

return table.freeze(t4)
