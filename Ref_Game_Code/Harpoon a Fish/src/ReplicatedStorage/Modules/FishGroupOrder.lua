-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Parent = script.Parent
local FishDisplay = require(Parent:WaitForChild("FishDisplay"))
local RarityDisplay = require(Parent:WaitForChild("RarityDisplay"))
local IndexSpecial = require(Parent:WaitForChild("IndexSpecial"))
local t1 = {}
local t2 = {}

for v1, v2 in ipairs(RarityDisplay.order) do
    t2[v2] = v1
end

local t3 = {}

for v3, v4 in ipairs(IndexSpecial.TABS) do
    if v4.mode == "WEATHER" then
        t3[v4.id] = v3
    end
end

local t4 = {}
local t5 = {}

for v5, v6 in pairs(FishDisplay) do
    if type(v6) == "table" then
        local v7 = t3[IndexSpecial.TAB_OF[v5]]
        local v8 = (if v6.shown == "Halloween" or v6.halloween then 5
            elseif v7 then if v6.world == "jurassic" then 4 else 2
            elseif v6.world == "jurassic" then 3
            else 1) * 10000 + (v7 or 0) * 100 + (t2[v6.rarity] or 0)

        t4[v5] = v8

        if not table.find(t5, v8) then
            t5[#t5 + 1] = v8
        end
    end
end

table.sort(t5)

local t6 = {}

for v9, v10 in pairs(t4) do
    t6[v9] = table.find(t5, v10)
end

t1.COUNT = #t5

function t1.Of(p1) -- line: 53
    -- upvalues: t1 (copy), t6 (copy)
    return t6[p1] or t1.COUNT + 1
end

return t1
