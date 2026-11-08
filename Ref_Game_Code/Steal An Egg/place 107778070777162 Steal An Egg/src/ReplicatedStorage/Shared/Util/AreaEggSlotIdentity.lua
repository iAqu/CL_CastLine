-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.strict(t.instanceIsA("Model"))
local v2 = t.strict(t.string)
local t1 = {}

local function rankOf(p1) -- line: 35
    local EggSpotBottom = p1.EggSpotBottom

    assert(EggSpotBottom:IsA("BasePart"), (("%* is missing its EggSpotBottom marker"):format((p1:GetFullName()))))

    local EggSpotBottomPosition = EggSpotBottom.Position

    return {
        model = p1,
        grid = {
            math.round(EggSpotBottomPosition.X * 1000),
            math.round(EggSpotBottomPosition.Z * 1000),
            (math.round(EggSpotBottomPosition.Y * 1000))
        },
        label = p1.Name
    }
end

local function precedes(p2, p3) -- line: 51
    for i = 1, 3 do
        if p2.grid[i] ~= p3.grid[i] then
            return p2.grid[i] < p3.grid[i]
        end
    end

    return p2.label < p3.label
end

local function isEventNest(p4) -- line: 60
    return p4:GetAttribute("EventNestId") ~= nil
end

function t1.SortedNests(p5) -- line: 64
    -- upvalues: v1 (copy), rankOf (copy), precedes (copy)
    v1(p5)

    local Nests = p5.Nests

    assert(Nests:IsA("Folder") or Nests:IsA("Model"), (("%* must keep its nests in a Folder or a Model"):format((p5:GetFullName()))))

    local t3 = {}

    for _, child in Nests:GetChildren() do
        if child:IsA("Model") and child:GetAttribute("EventNestId") == nil then
            table.insert(t3, (rankOf(child)))
        end
    end

    table.sort(t3, precedes)

    local v12 = table.create(#t3)

    for v13, v14 in t3 do
        v12[v13] = v14.model
    end

    return v12
end

function t1.NestIdFor(p6, p7) -- line: 88
    -- upvalues: v1 (copy), t1 (copy)
    v1(p6)
    v1(p7)

    local v15 = table.find(t1.SortedNests(p6), p7)

    if v15 == nil then
        error((("%* does not sit under %*"):format(p7:GetFullName(), (p6:GetFullName()))))
    end

    return string.format("Slot_%03d", v15)
end

function t1.NestFor(p8, p9) -- line: 99
    -- upvalues: v1 (copy), v2 (copy), t1 (copy)
    v1(p8)
    v2(p9)

    local v16 = string.match(p9, "^Slot_(%d+)$")

    assert(v16 ~= nil, (("%* does not name a nest slot"):format(p9)))

    local v19 = tonumber(v16)

    assert(v19 ~= nil, (("%* carries a slot number that will not parse"):format(p9)))

    local v22 = t1.SortedNests(p8)[v19]

    assert(v22 ~= nil, (("%* has nothing at slot %*"):format(p8.Name, p9)))

    return v22
end

function t1.MarkEventNest(p10, p11) -- line: 113
    -- upvalues: v1 (copy), v2 (copy)
    v1(p10)
    v2(p11)
    assert(p10.Parent == nil, "Mark event nests before parenting them")

    local v26 = ("EventNest_%*"):format(p11)

    p10:SetAttribute("EventNestId", v26)

    return v26
end

function t1.LooksLikeEventNestId(p12) -- line: 123
    -- upvalues: v2 (copy)
    v2(p12)

    return string.find(p12, "EventNest_", 1, true) == 1
end

function t1.SlotKey(p13, p14) -- line: 128
    -- upvalues: v2 (copy)
    v2(p13)
    v2(p14)

    return string.format("%s:%s", p13, p14)
end

function t1.LooksLikeFirstAreaUid(p15) -- line: 135
    -- upvalues: v2 (copy)
    v2(p15)

    return string.find(p15, "FirstAreaEgg_", 1, true) == 1
end

function t1.FirstAreaOwnerUserId(p16) -- line: 140
    -- upvalues: v2 (copy)
    v2(p16)

    local v27 = string.match(p16, "^FirstAreaEgg_(-?%d+)_")

    return if v27 ~= nil then tonumber(v27) else nil
end

return table.freeze(t1)
