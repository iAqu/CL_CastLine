-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}
local v1 = t1

t1.EggDisplayName = "Demonic Egg"
t1.DropTable = { { "Demon Imp", 42 } }

local function IsEventCategory(p1) -- line: 12
    -- upvalues: v1 (ref)
    if p1 == nil then
        return false
    end

    for _, v2 in v1.DropTable do
        if v2[1] == p1 then
            return true
        end
    end

    return false
end

local v3 = v1

v3.IsEventCategory = IsEventCategory

function v3.GetTotalWeight() -- line: 26
    -- upvalues: v1 (ref)
    local n1 = 0

    for _, v4 in v1.DropTable do
        n1 += v4[2]
    end

    return n1
end

function v3.Roll(p2) -- line: 36
    -- upvalues: v1 (ref)
    p2 = p2 or Random.new()

    local v6 = v1.GetTotalWeight()

    if v6 <= 0 then
        return v1.DropTable[1][1]
    end

    local v7 = p2:NextNumber() * v6
    local n2 = 0

    for _, v8 in v1.DropTable do
        n2 += v8[2]

        if v7 <= n2 then
            return v8[1]
        end
    end

    return v1.DropTable[#v1.DropTable][1]
end

v1 = require(game:GetService("ReplicatedStorage").Shared.Flags.BalanceConfig).Bind("Game.Balance.AdminAbuseEgg", v3, {
    DropTable = true
}, false, function(p3) -- line: 63
    local n3 = 0

    for _, v9 in p3.DropTable do
        n3 += v9[2]
    end

    assert(n3 > 0)
end)

return v1
