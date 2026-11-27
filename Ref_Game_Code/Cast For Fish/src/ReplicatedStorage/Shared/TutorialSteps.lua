-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    List = {
        {
            id = "dock",
            text = "Step on the dock"
        },
        {
            id = "cast",
            text = "Tap to cast!"
        },
        {
            id = "place",
            text = "Place your fish"
        },
        {
            id = "circle",
            text = "Step inside the circle"
        },
        {
            id = "train",
            text = "Train to Level 3"
        },
        {
            id = "bait",
            text = "Buy new bait"
        },
        {
            id = "recast",
            text = "Cast again"
        }
    }
}

t1.DONE = #t1.List + 1
t1.TRAIN_TO_LEVEL = 3
t1.IndexOf = {}

for v1, v2 in ipairs(t1.List) do
    t1.IndexOf[v2.id] = v1
end

t1.FROM_OLD = {
    1, 2, 3, 4, 4, 5, 6, 6,
    7
}

local function count(p1) -- line: 28
    local n1 = 0

    for _ in pairs(p1) do
        n1 += 1
    end

    return n1
end

function t1.DataAllows(p2, p3) -- line: 38
    -- upvalues: t1 (copy)
    if p2 == "cast" then
        return next(p3.Index) ~= nil
    end

    if p2 == "place" then
        return #p3.Placed >= 1
    end

    if p2 == "train" then
        return p3.Level >= t1.TRAIN_TO_LEVEL
    end

    if p2 ~= "bait" then
        return true
    end

    local BaitsOwned = p3.BaitsOwned
    local n2 = 0

    for _ in pairs(BaitsOwned) do
        n2 += 1
    end

    return n2 >= 2
end

return t1
