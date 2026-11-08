-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage.Data.Rarity)

local t = require(ReplicatedStorage.Packages.t)
local v1 = t.interface({
    Single = t.interface({
        Ids = t.array(t.string),
        Data = t.interface({
            Speed = t.array(t.number),
            Volume = t.number
        })
    })
})
local v2 = t.interface({
    DisplayName = t.string,
    Rarity = t.optional(t.table),
    Desc = t.optional(t.string),
    Icon = t.optional(t.string),
    Sounds = t.optional(v1),
    CollectDistanceOverride = t.optional(t.numberPositive),
    PickupDistanceOverride = t.optional(t.numberPositive),
    _id = t.string
})

local function byName(p1, p2) -- line: 52
    return p1.Name < p2.Name
end

local v7 = (function(p3) -- collectCurrencies | line: 56
    -- upvalues: v2 (copy), byName (copy)
    local Children = p3:GetChildren()

    table.sort(Children, byName)

    local t1 = {}

    for _, v3 in Children do
        if v3:IsA("ModuleScript") then
            local v4 = require(v3)
            local v5, v6 = v2(v4)

            if not v5 then
                error((("currency config %* is malformed: %*"):format(v3.Name, v6)))
            end

            if v4._id ~= v3.Name then
                error((("currency config %* declares _id \"%*\""):format(v3.Name, v4._id)))
            end

            t1[v3.Name] = v4
        end
    end

    return table.freeze(t1)
end)(script.Configs)
local t2 = {
    Directory = v7
}

function t2.Get(p4) -- line: 85
    -- upvalues: v7 (copy)
    local v8 = v7[p4]

    if v8 == nil then
        error(("no currency is registered under \"%*\""):format(p4), 2)
    end

    return v8
end

function t2.CurrencyNameExists(p5) -- line: 93
    -- upvalues: v7 (copy)
    if v7[p5] == nil then
        return false, (("no currency is registered under \"%*\""):format(p5))
    end

    return true
end

return table.freeze(t2)
