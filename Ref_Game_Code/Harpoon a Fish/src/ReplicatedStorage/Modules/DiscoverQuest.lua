-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Modules = game:GetService("ReplicatedStorage"):WaitForChild("Modules")
local IndexZones = require(Modules:WaitForChild("IndexZones"))
local FishDisplay = require(Modules:WaitForChild("FishDisplay"))
local KeyConfig = require(Modules:WaitForChild("KeyConfig"))
local IndexSpecial = require(Modules:WaitForChild("IndexSpecial"))
local t1 = {
    STEP = 10,
    DONE = -1
}
local t2 = {}
local t3 = {}

for v1, v2 in pairs(IndexZones) do
    local v3 = FishDisplay[v1]

    if type(v2) == "number" and type(v3) == "table" and KeyConfig.INDEX[v3.rarity] and not t3[v1] then
        t3[v1] = true
        t2[#t2 + 1] = v1
    end
end

for _, v4 in ipairs(IndexSpecial.TABS) do
    if v4.claims then
        for _, v5 in ipairs(v4.species) do
            if not t3[v5] then
                t3[v5] = true
                t2[#t2 + 1] = v5
            end
        end
    end
end

t1.LAST = math.floor(#t2 / t1.STEP) * t1.STEP

function t1.KeyFor(p1) -- line: 39
    -- upvalues: t1 (copy)
    if p1 % 100 == 0 or p1 == t1.LAST then
        return "Secret"
    end

    if p1 % 50 ~= 0 then
        if p1 < 50 then
            return "Gold"
        end

        if p1 < 100 then
            return "Ruby"
        end
    end

    return "Diamond"
end

function t1.Count(p2) -- line: 48
    -- upvalues: t2 (copy)
    local n1 = 0

    for _, v7 in ipairs(t2) do
        local v8 = p2 and p2[v7]

        if v8 and (v8.caught or 0) > 0 then
            n1 += 1
        end
    end

    return n1
end

return t1
