-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnimalBend = require(script.Parent.AnimalBend)
local AnimalLooks = require(script.Parent.AnimalLooks)
local Animals = require(script.Parent.Animals)
local Animals2 = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Animals")
local _, sin, cos = math.rad, math.sin, math.cos
local t2 = {}
local t1 = {}

function t1.nativeSize(p1) -- line: 23
    -- upvalues: Animals (copy), Animals2 (copy), t2 (copy)
    local v1 = t2[p1]

    if not v1 then
        local v2 = Animals2:FindFirstChild("A_" .. Animals.look(p1))

        if not v2 then
            return 4
        end

        local _, BoundingBox = v2:GetBoundingBox()

        v1 = math.max(BoundingBox.X, BoundingBox.Y, BoundingBox.Z)
        t2[p1] = v1
    end

    return v1
end

function t1.clone(p2, p3, p4) -- line: 38
    -- upvalues: AnimalLooks (copy), Animals (copy), t1 (copy), Animals2 (copy)
    local v3 = Animals2:FindFirstChild("A_" .. Animals.look(p2))

    if v3 then
        local clone = v3:Clone()

        clone.Name = p2
        clone:SetAttribute("Species", p2)

        if p3 then
            local _, BoundingBox = clone:GetBoundingBox()
            local v4 = math.max(BoundingBox.X, BoundingBox.Y, BoundingBox.Z)

            if v4 > 0 then
                clone:ScaleTo(clone:GetScale() * p3 / v4)
            end
        end

        clone.WorldPivot = clone:GetBoundingBox()

        for _, descendant in clone:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true
                descendant.CanCollide = false
                descendant.CanTouch = false
                descendant.CanQuery = false
                descendant.Massless = true
            end
        end

        AnimalLooks.mutate(clone, p4)

        for _, descendant in clone:GetDescendants() do
            if descendant:IsA("BasePart") and descendant.Material == Enum.Material.Neon then
                descendant.Color = descendant.Color:Lerp(Color3.new(0, 0, 0), 0.35)
            end
        end

        local _, BoundingBox = clone:GetBoundingBox()

        AnimalLooks.decorate(clone, t1.body(clone), p3 or math.max(BoundingBox.X, BoundingBox.Y, BoundingBox.Z))

        return clone
    end

    warn("Missing animal model A_" .. Animals.look(p2))

    return nil
end

local function roleOf(p5, p6) -- line: 78
    -- upvalues: Animals (copy)
    local v7 = "A_" .. Animals.look(p5) .. "_"

    return ((if p6:sub(1, #v7) == v7 then p6:sub(#v7 + 1) else p6):gsub("__.*$", ""):gsub("_Neon$", ""):gsub("_Glass$", ""))
end

function t1.body(p7) -- line: 93
    -- upvalues: roleOf (copy)
    local v8 = p7:GetAttribute("Species") or p7.Name
    local n1 = -1
    local descendant

    for _, descendant2 in p7:GetDescendants() do
        if descendant2:IsA("BasePart") then
            local Magnitude = descendant2.Size.Magnitude

            if roleOf(v8, descendant2.Name) == "Body" then
                Magnitude += 1E+06
            end

            if n1 < Magnitude then
                n1 = Magnitude
                descendant = descendant2
            end
        end
    end

    return descendant
end

local function motionFor(p8) -- line: 114
    -- upvalues: sin (copy), cos (copy)
    if p8 == "Body" then
        return nil
    end

    if p8:find("^Tail") then
        local v9 = tonumber(p8:match("%d+"))
        local v10 = if v9 then 0.2617993877991494 else 0.4537856055185257
        local v11 = v9 or 1

        return function(p9, p10) -- line: 123
            -- upvalues: v11 (copy), v10 (copy), sin (copy)
            return CFrame.Angles(0, sin(p9 - 1.1 - v11 * 0.5) * v10 * p10, 0)
        end
    end

    local v13 = p8:match("^Fin%u?([LR])$")

    if v13 then
        local v14 = if v13 == "L" then 1 else -1

        return function(p11, p12) -- line: 130
            -- upvalues: v14 (copy), sin (copy)
            return CFrame.Angles(0, 0, sin(p11 - 0.6) * 0.3490658503988659 * p12 * v14)
        end
    end

    local v16 = p8:match("^Wing([LR])$")

    if v16 then
        local v17 = if v16 == "L" then 1 else -1

        return function(p13, p14) -- line: 137
            -- upvalues: v17 (copy), sin (copy)
            return CFrame.Angles(0, 0, sin(p13 * 0.5) * 0.4188790204786391 * p14 * v17)
        end
    end

    local v19, v20 = p8:match("^Leg(%d)([LR])$")

    if v19 then
        local v21 = if v20 == "L" then 1 else -1
        local v22 = (tonumber(v19) or 1) * 3.141592653589793 * 0.5 + (if v21 > 0 then 0 else 3.141592653589793)

        return function(p15, p16, _, p18) -- line: 147
            -- upvalues: v21 (copy), v22 (copy), sin (copy), cos (copy)
            if p18 then
                local v23 = p15 * 2 + v22

                return CFrame.Angles(0, sin(v23) * 0.20943951023931956 * p16, v21 * math.max(0, (cos(v23))) * 0.5235987755982988 * p16)
            end

            return CFrame.Angles(sin(p15 + v22) * 0.24434609527920614 * p16, 0, 0)
        end
    end

    local v27 = p8:match("^Leg(%u%u)$")

    if v27 then
        local v28 = if v27 == "FL" or v27 == "BR" then 0 else 3.141592653589793

        return function(p19, p20) -- line: 158
            -- upvalues: v28 (copy), sin (copy)
            return CFrame.Angles(sin(p19 + v28) * 0.3490658503988659 * p20, 0, 0)
        end
    end

    if p8 == "Legs" then
        return function(p21, p22, _, p24) -- line: 163
            -- upvalues: sin (copy)
            if p24 then
                return CFrame.Angles(0, sin(p21 * 2) * 0.06981317007977318 * p22, sin(p21 * 2) * 0.12217304763960307 * p22)
            end

            return CFrame.Angles(sin(p21) * 0.13962634015954636 * p22, 0, 0)
        end
    end

    local v33 = tonumber(p8:match("^Arm(%d+)$"))

    if v33 then
        return function(p25, p26) -- line: 173
            -- upvalues: v33 (copy), sin (copy), cos (copy)
            return CFrame.Angles(sin(p25 * 0.6 + v33) * 0.24434609527920614 * p26, 0, cos(p25 * 0.5 + v33) * 0.13962634015954636 * p26)
        end
    end

    if p8 == "Tentacles" then
        return function(p27, p28) -- line: 178
            -- upvalues: sin (copy)
            return CFrame.Angles(sin(p27 * 0.6 - 1) * 0.20943951023931956 * p28, 0, 0)
        end
    end

    local v38 = p8:match("^Claw([LR])$") or p8:match("^Arm([LR])$")

    if v38 then
        local v39 = if v38 == "L" then 1 else -1

        return function(p29, p30, p31, p32) -- line: 185
            -- upvalues: v39 (copy), sin (copy)
            if p32 then
                local v42 = math.max(0, (sin(p31 * 2.3 + v39))) ^ 6

                return CFrame.Angles(math.min(p30, 1) * -0.13962634015954636, v39 * (sin(p29 * 0.5) * 0.10471975511965978 * p30 + v42 * 0.24434609527920614), 0)
            end

            return CFrame.Angles(0, sin(p29 * 0.5) * 0.17453292519943295 * p30 * v39, 0)
        end
    end

    if p8:find("^Head") or p8:find("^Neck") then
        local v46 = tonumber(p8:match("%d+")) or 0

        return function(p33, p34) -- line: 197
            -- upvalues: v46 (copy), sin (copy)
            return CFrame.Angles(sin(p33 * 0.3 + v46) * 0.05235987755982989 * p34, -sin(p33 + v46 * 0.4) * 0.08726646259971647 * p34, 0)
        end
    end

    if p8 == "Jaw" or p8 == "Lid" then
        return function(p35, p36) -- line: 202
            -- upvalues: sin (copy)
            return CFrame.Angles(-(sin(p35 * 0.4) * 0.5 + 0.5) * 0.20943951023931956 * p36, 0, 0)
        end
    end

    if p8 == "Halo" then
        return function(_, _, p39) -- line: 207
            return CFrame.Angles(0, p39 * 1.5, 0)
        end
    end

    return if p8 == "Lure" then function(p40, p41) -- line: 212
        -- upvalues: sin (copy)
        return CFrame.Angles(sin(p40 * 0.7) * 0.20943951023931956 * p41, 0, 0)
    end else nil
end

local function addToGroup(p42, p43, p44, p45) -- line: 241
    -- upvalues: roleOf (copy)
    local v52 = roleOf(p43, p45.Name)
    local v53 = p42.byRole[v52]

    if not v53 then
        v53 = {
            role = v52,
            parts = {},
            offsets = {},
            along = {},
            min = Vector3.new(1, 1, 1) * 1e999,
            max = Vector3.new(-1, -1, -1, -0) * 1e999
        }
        p42.byRole[v52] = v53
        table.insert(p42.groups, v53)
    end

    local v54 = p44:ToObjectSpace(p45.CFrame)

    table.insert(v53.parts, p45)
    table.insert(v53.offsets, v54)
    p42.offsetOf[p45] = v54
    v53.min = v53.min:Min(v54.Position - p45.Size / 2)
    v53.max = v53.max:Max(v54.Position + p45.Size / 2)
end

local function parentRole(p46, p47, p48) -- line: 259
    if p46 == p48 then
        return nil
    end

    local v55 = p46:match("^Head(%d*)$")

    if v55 and p47["Neck" .. v55] then
        return "Neck" .. v55
    end

    if p46 == "Jaw" and p47.Head then
        return "Head"
    end

    local v56 = tonumber(p46:match("^Tail(%d+)$"))

    if not (v56 and p47["Tail" .. v56 - 1]) then
        return p48
    end

    return "Tail" .. v56 - 1
end

local function depth(p49) -- line: 277
    local n2 = 0

    while p49.parent do
        n2 += 1
        p49 = p49.parent
    end

    return n2
end

local function finish(p50) -- line: 289
    -- upvalues: AnimalBend (copy), motionFor (copy), parentRole (copy)
    local Body = p50.byRole.Body

    if not Body then
        local v58 = Body
        local n3 = -1

        for _, v59 in p50.groups do
            local v60 = v59.max - v59.min

            if n3 < v60.X * v60.Y * v60.Z then
                v58 = v59
                n3 = v60.X * v60.Y * v60.Z
            end

            Body = v58
        end
    end

    p50.root = Body

    for _, v61 in p50.groups do
        local v62 = parentRole(v61.role, p50.byRole, Body.role)

        v61.parent = v62 and p50.byRole[v62]
    end

    table.sort(p50.groups, function(p51, p52) -- line: 306
        local n4 = 0
        local v63 = p51

        while v63.parent do
            n4 += 1
            v63 = v63.parent
        end

        local n5 = 0
        local v64 = p52

        while v64.parent do
            n5 += 1
            v64 = v64.parent
        end

        return n4 < n5
    end)
    table.clear(p50.parts)
    table.clear(p50.cframes)
    p50.bottom = 0

    for _, v65 in p50.groups do
        p50.bottom = math.min(p50.bottom, v65.min.Y)

        local v66 = (v65.min + v65.max) / 2
        local v67 = (v65.max - v65.min) / 2
        local v68 = if v65.parent then (v65.parent.min + v65.parent.max) / 2 - v66 else Vector3.new(0, 0, 0)

        v65.joint = v66 + Vector3.new(math.clamp(v68.X, -v67.X, v67.X), math.clamp(v68.Y, -v67.Y, v67.Y), (math.clamp(v68.Z, -v67.Z, v67.Z)))

        if v65 == Body then
            v65.motion = nil
        else
            v65.motion = motionFor(v65.role)
        end

        if not v65.bend then
            local v75 = v65.max - v65.min
            local v76

            if v65 == Body then
                v76 = not p50.byRole.Body
                v76 = v76 and v75.Z >= math.max(v75.X, v75.Y) * 2.5
            else
                v76 = false
            end

            v65.bend = AnimalBend.spec(v65, v76)

            if v65.bend then
                AnimalBend.prepare(v65.bend, p50.offsetOf)
            end
        end

        table.clear(v65.along)

        if v65.bend then
            for v77, v78 in v65.parts do
                if not table.find(v65.bend.meshes, v78) then
                    v65.along[v77] = AnimalBend.along(v65.bend, v65.offsets[v77].Position)
                end
            end
        end

        if v65.parent and v65.parent.bend then
            v65.attach = AnimalBend.along(v65.parent.bend, v65.joint)
        else
            v65.attach = nil
        end

        for _, v79 in v65.parts do
            table.insert(p50.parts, v79)
        end
    end
end

function t1.rig(p53) -- line: 347
    -- upvalues: AnimalLooks (copy), addToGroup (copy), finish (copy)
    local v80 = p53:GetAttribute("Species") or p53.Name
    local Pivot = p53:GetPivot()
    local t3 = {
        bottom = 0,
        groups = {},
        byRole = {},
        parts = {},
        cframes = {},
        offsetOf = {},
        seed = math.random() * 10,
        pivot = Pivot,
        species = v80,
        rainbow = AnimalLooks.rainbowParts(p53)
    }

    for _, descendant in p53:GetDescendants() do
        if descendant:IsA("BasePart") then
            addToGroup(t3, v80, Pivot, descendant)
        end
    end

    finish(t3)

    return t3
end

function t1.addPart(p54, p55) -- line: 372
    -- upvalues: addToGroup (copy), finish (copy)
    if not table.find(p54.parts, p55) then
        addToGroup(p54, p54.species, p54.pivot, p55)
        finish(p54)
    end
end

function t1.pose(p56, p57, p58, p59, p60) -- line: 385
    -- upvalues: AnimalBend (copy), AnimalLooks (copy), sin (copy)
    local v82 = math.clamp(p58 - (p56.lastT or p58), 0, 0.1)

    p56.lastT = p58

    local v83 = p60 and p56.crab == true
    local v84 = (if v83 then p59 * 9 + 2 elseif p60 then p59 * 6 + 1.2 else p59 * 2.6 + 1.6) * (p56.tempo or 1)

    p56.phase = (p56.phase or p56.seed) + v82 * v84

    local phase = p56.phase
    local v85 = (if p60 then p59 * 1.25 + 0.15 else p59 * 0.5 + 0.5) * (p56.sweep or 1)
    local v86

    if v83 then
        v86 = p57 * CFrame.new(0, math.abs((sin(phase * 2))) * 0.1 * p59, 0) * CFrame.Angles(sin(phase * 2) * 0.03490658503988659 * p59, 0, sin(phase * 2) * 0.06981317007977318 * p59)
    elseif p60 then
        v86 = p57 * CFrame.new(0, math.abs((sin(phase))) * 0.12 * p59, 0) * CFrame.Angles(0, sin(phase) * 0.05235987755982989 * p59, sin(phase) * 0.06981317007977318 * p59)
    else
        local v94 = p56.root and p56.root.bend
        local v95 = if v94 and v94.spine and v94.live then 0.3 else 1

        v86 = p57 * CFrame.Angles(0, sin(phase) * 0.15707963267948966 * v85 * v95, sin(phase) * 0.05235987755982989 * v85)
    end

    local n6 = 0

    for _, v96 in p56.groups do
        local bend = v96.bend

        if bend then
            AnimalBend.update(bend, phase, v85)
        end

        local parent = v96.parent
        local cf

        if parent then
            cf = parent.cf

            if v96.attach then
                cf *= AnimalBend.at(parent.bend, v96.attach)
            end
        else
            cf = if bend and bend.live then v86 * bend.recoil else v86
        end

        if v96.motion then
            cf *= CFrame.new(v96.joint) * v96.motion(phase, v85, p58, v83) * CFrame.new(-v96.joint)
        end

        v96.cf = cf

        for v97, v98 in v96.offsets do
            n6 += 1

            local v99 = bend and bend.live and v96.along[v97]
            local cframes = p56.cframes

            if v99 then
                cframes[n6] = cf * AnimalBend.at(bend, v99) * v98
            else
                cframes[n6] = cf * v98
            end
        end

        if bend then
            AnimalBend.deform(bend, p56.offsetOf)
        end
    end

    workspace:BulkMoveTo(p56.parts, p56.cframes, Enum.BulkMoveMode.FireCFrameChanged)

    if p56.rainbow then
        AnimalLooks.cycleRainbow(p56.rainbow, p58)
    end
end

return t1
