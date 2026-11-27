-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Parent = script.Parent
local FishDisplay = require(Parent:WaitForChild("FishDisplay"))
local PassPerks = require(Parent:WaitForChild("PassPerks"))
local TitanConfig = require(Parent:WaitForChild("TitanConfig"))
local t1 = {
    SECONDS = 346,
    RANGE = 8
}

function t1.CanSell(p1, p2) -- line: 20
    -- upvalues: FishDisplay (copy)
    if p1 == nil or p1 == "Mimic" or p2 then
        return false
    end

    local v1 = FishDisplay[p1]

    return not (v1 and v1.rarity == "Exclusive")
end

function t1.Price(p3, p4, p5) -- line: 28
    -- upvalues: PassPerks (copy), TitanConfig (copy), t1 (copy)
    if p5 and TitanConfig.IsTitan(p5) then
        return (math.floor((tonumber(p4 and p4:GetAttribute("PenRate")) or 0) * TitanConfig.SELL))
    end

    return (math.floor((tonumber(p3) or 0) * t1.SECONDS * PassPerks.CashMul(p4)))
end

return t1
