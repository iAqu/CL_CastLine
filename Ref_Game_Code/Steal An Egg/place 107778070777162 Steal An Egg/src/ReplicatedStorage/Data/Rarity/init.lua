-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local t1 = {
    "BrainrotGod",
    "Common",
    "Cosmic",
    "Divine",
    "Epic",
    "Eternal",
    "Legendary",
    "LightDark",
    "Limited",
    "Mythic",
    "Rainbow",
    "Rare",
    "Secret",
    "SuperRare",
    "Titan",
    "Transcendent",
    "Uncommon"
}
local t2 = {
    Prismatic = "Rainbow"
}
local v1 = t.interface({
    _id = t.string,
    DisplayName = t.string,
    Rank = t.integer,
    Color = t.Color3,
    RarityGradient = t.instanceIsA("UIGradient"),
    ItemTemplate = t.instanceIsA("TextButton")
})

local function byName(p1, p2) -- line: 75
    return p1.Name < p2.Name
end

local v9 = (function(p3) -- loadTiers | line: 79
    -- upvalues: t1 (copy), t2 (copy), v1 (copy), byName (copy)
    local Children = p3:GetChildren()

    table.sort(Children, byName)

    local t3 = {}

    for _, v2 in Children do
        if v2:IsA("ModuleScript") then
            local v3 = require(v2)
            local v4, v5 = v1(v3)

            if not v4 then
                error((("rarity config %* is malformed: %*"):format(v2.Name, v5)))
            end

            if v3._id ~= v2.Name then
                error((("rarity config %* declares _id \"%*\""):format(v2.Name, v3._id)))
            end

            t3[v2.Name] = v3
        end
    end

    for _, v6 in t1 do
        if t3[v6] == nil then
            error((("rarity tier \"%*\" has no config module"):format(v6)))
        end
    end

    for v7, v8 in t2 do
        t3[v7] = t3[v8]
    end

    return table.freeze(t3)
end)(script.Configs)
local t4 = {
    Rarities = v9
}

function t4.Get(p4) -- line: 117
    -- upvalues: v9 (copy)
    local v10 = v9[p4]

    if v10 == nil then
        error(("\"%*\" is not a registered rarity tier"):format(p4), 2)
    end

    return v10
end

function t4.RarityNameExists(p5) -- line: 125
    -- upvalues: v9 (copy)
    if v9[p5] == nil then
        return false, (("\"%*\" is not a registered rarity tier"):format(p5))
    end

    return true
end

return table.freeze(t4)
