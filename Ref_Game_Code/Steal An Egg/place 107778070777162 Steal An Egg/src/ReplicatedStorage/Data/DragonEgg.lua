-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}
local v1 = t1

t1.EggDisplayName = "Dragon Egg"
t1.RewardEggDisplayName = "Dragon's Egg"
t1.MaxCountedReturns = 10
t1.BaseAssetScale = 0.3
t1.AssetScalePerReturn = 0.42
t1.NestBaseScale = 0.3
t1.NestScalePerReturn = 0.42
t1.DropTable = {
    { "Baby Aurora Dragon", 85, -8.5 },
    { "Shadow Dragon", 13.5, 1.25 },
    { "Ember Dragon", 1, 6.5 },
    { "Void Dragon", 0.5, 0.75 }
}
t1.RestoreDropTable = {
    { "Baby Aurora Dragon", 45 },
    { "Shadow Dragon", 35 },
    { "Ember Dragon", 15 },
    { "Void Dragon", 5 }
}
t1.RewardCategory = "ScorchedDragon"
t1.CarryCategory = "Baby Aurora Dragon"

local function GetCountedReturns(p1) -- line: 37
    -- upvalues: v1 (ref)
    return (math.clamp(math.floor(p1), 0, v1.MaxCountedReturns))
end

local v3 = v1

v3.GetCountedReturns = GetCountedReturns

function v3.GetEntryWeight(p2, p3) -- line: 41
    -- upvalues: v1 (ref)
    return (math.max(p2[2] + p2[3] * v1.GetCountedReturns(p3), 0))
end

function v3.GetTotalWeight(p4) -- line: 48
    -- upvalues: v1 (ref)
    local n1 = 0

    for _, v5 in v1.DropTable do
        n1 += v1.GetEntryWeight(v5, p4)
    end

    return n1
end

function v3.RollRestore() -- line: 63
    -- upvalues: v1 (ref)
    local v6 = Random.new()
    local n2 = 0

    for _, v7 in v1.RestoreDropTable do
        n2 += v7[2]
    end

    local v8 = v6:NextNumber() * n2
    local n3 = 0

    for _, v9 in v1.DropTable do
        n3 += v9[2]

        if v8 <= n3 then
            return v9[1]
        end
    end

    error((("[%*] Roll out of bounds exception"):format(script.Name)))
end

function v3.Roll(p5, p6) -- line: 85
    -- upvalues: v1 (ref)
    assert(#v1.DropTable > 0, "DragonEgg.DropTable is empty")
    p6 = p6 or Random.new()

    local v12 = v1.GetTotalWeight(p5)

    if v12 <= 0 then
        return v1.DropTable[1][1]
    end

    local v13 = p6:NextNumber() * v12
    local n4 = 0

    for _, v14 in v1.DropTable do
        n4 += v1.GetEntryWeight(v14, p5)

        if v13 <= n4 then
            return v14[1]
        end
    end

    return v1.DropTable[#v1.DropTable][1]
end

function v3.GetAssetScale(p7) -- line: 109
    -- upvalues: v1 (ref)
    return v1.BaseAssetScale + v1.AssetScalePerReturn * v1.GetCountedReturns(p7)
end

function v3.GetNestVisualScale(p8) -- line: 114
    -- upvalues: v1 (ref)
    return v1.NestBaseScale + v1.NestScalePerReturn * v1.GetCountedReturns(p8)
end

function v3.IsEventCategory(p9) -- line: 119
    -- upvalues: v1 (ref)
    if p9 == nil then
        return false
    end

    if p9 == v1.RewardCategory then
        return true
    end

    for _, v15 in v1.DropTable do
        if v15[1] == p9 then
            return true
        end
    end

    return false
end

v1 = require(game:GetService("ReplicatedStorage").Shared.Flags.BalanceConfig).Bind("Game.Balance.DragonEgg", v3, {
    MaxCountedReturns = true,
    BaseAssetScale = true,
    AssetScalePerReturn = true,
    DropTable = true,
    RestoreDropTable = true
}, false, function(p10) -- line: 148
    assert(p10.MaxCountedReturns % 1 == 0 and p10.BaseAssetScale > 0)
end)

return v1
