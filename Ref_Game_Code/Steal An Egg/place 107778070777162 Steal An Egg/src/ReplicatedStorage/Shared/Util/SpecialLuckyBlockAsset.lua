-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = require(ReplicatedStorage.Data.Assets)

require(ReplicatedStorage.Shared.Types.AssetItem)

local Rank = require(ReplicatedStorage.Data.Rarity).Rarities.Secret.Rank
local t1 = {
    CFrame.new(-17.4227905, 1.14494324, -23.6600342),
    CFrame.new(-13.1647339, 1.14494324, -28.0780945),
    CFrame.new(-7.01275635, 1.14494324, -31.1100464),
    CFrame.new(7.54925537, 1.79094315, -31.1380615),
    CFrame.new(13.3172607, 1.14494324, -28.1280518),
    CFrame.new(17.959259, 1.14494324, -24.9380493)
}
local t2 = {}

local function qualifies(p1) -- line: 38
    -- upvalues: Assets (copy)
    local v1 = Assets.Directory[p1]
    local LuckyBlockDropTable = v1 and v1.LuckyBlockDropTable or nil

    if typeof(LuckyBlockDropTable) == "table" then
        return #LuckyBlockDropTable > 0
    end

    return false
end

local function stampOf(p2, p3) -- line: 46
    local SpecialLuckyBlockCapturedAt = p3.SpecialLuckyBlockCapturedAt

    if typeof(SpecialLuckyBlockCapturedAt) == "number" then
        return SpecialLuckyBlockCapturedAt
    end

    return string.byte(p2, 1) or 0
end

local function shelfOf(p4) -- line: 51
    local SpecialLuckyBlockColumn = p4.SpecialLuckyBlockColumn

    return if typeof(SpecialLuckyBlockColumn) == "number" and SpecialLuckyBlockColumn >= 1 and SpecialLuckyBlockColumn <= 6 then SpecialLuckyBlockColumn else nil
end

local function olderFirst(p5, p6) -- line: 57
    local uid = p5.uid
    local SpecialLuckyBlockCapturedAt = p5.data.SpecialLuckyBlockCapturedAt

    if typeof(SpecialLuckyBlockCapturedAt) ~= "number" then
        SpecialLuckyBlockCapturedAt = string.byte(uid, 1) or 0
    end

    local uid2 = p6.uid
    local SpecialLuckyBlockCapturedAt2 = p6.data.SpecialLuckyBlockCapturedAt

    if typeof(SpecialLuckyBlockCapturedAt2) ~= "number" then
        SpecialLuckyBlockCapturedAt2 = string.byte(uid2, 1) or 0
    end

    if SpecialLuckyBlockCapturedAt == SpecialLuckyBlockCapturedAt2 then
        return p5.uid < p6.uid
    end

    return SpecialLuckyBlockCapturedAt < SpecialLuckyBlockCapturedAt2
end

function t2.MatchesCategory(p7) -- line: 65
    -- upvalues: Assets (copy)
    local v2 = Assets.Directory[p7]
    local LuckyBlockDropTable = v2 and v2.LuckyBlockDropTable or nil

    if typeof(LuckyBlockDropTable) == "table" then
        return #LuckyBlockDropTable > 0
    end

    return false
end

function t2.Matches(p8) -- line: 67
    -- upvalues: Assets (copy)
    local Category = p8.Category
    local v3 = Assets.Directory[Category]
    local LuckyBlockDropTable = v3 and v3.LuckyBlockDropTable or nil

    if typeof(LuckyBlockDropTable) == "table" then
        return #LuckyBlockDropTable > 0
    end

    return false
end

function t2.Capacity() -- line: 69
    return 36
end

function t2.ProgressGoalForCategory(p9) -- line: 71
    -- upvalues: Assets (copy), Rank (copy)
    local Rarity = Assets.Directory[p9].Rarity
    local v4 = Rarity and Rarity.Rank

    assert(typeof(v4) == "number", (("Special lucky block \"%*\" has no rarity rank"):format(p9)))

    if v4 < Rank then
        return 1
    end

    if v4 == Rank then
        return 2
    end

    return 3
end

function t2.ProgressGoalFor(p10) -- line: 82
    -- upvalues: t2 (copy)
    return t2.ProgressGoalForCategory(p10.Category)
end

function t2.CountHeld(p11) -- line: 86
    -- upvalues: t2 (copy)
    local n1 = 0

    for _, v7 in pairs(p11) do
        n1 += if t2.Matches(v7) then 1 else 0
    end

    return n1
end

function t2.NextOpenColumn(p12, p13) -- line: 95
    -- upvalues: t2 (copy)
    local t3 = {}

    for v8, v9 in pairs(p12) do
        local SpecialLuckyBlockColumn

        if v8 ~= p13 and t2.Matches(v9) then
            SpecialLuckyBlockColumn = v9.SpecialLuckyBlockColumn

            if typeof(SpecialLuckyBlockColumn) ~= "number" or not (SpecialLuckyBlockColumn >= 1) or not (SpecialLuckyBlockColumn <= 6) then
                SpecialLuckyBlockColumn = nil
            end
        end

        if SpecialLuckyBlockColumn ~= nil then
            t3[SpecialLuckyBlockColumn] = (t3[SpecialLuckyBlockColumn] or 0) + 1
        end
    end

    local n2 = 1e999
    local v10

    for i = 1, 6 do
        local v11 = t3[i] or 0

        if v11 < 6 and v11 < n2 then
            n2 = v11
            v10 = i
        end
    end

    return v10
end

function t2.BuildLayout(p14, p15) -- line: 117
    -- upvalues: t1 (copy), t2 (copy), olderFirst (copy)
    local t4 = {}

    for v12, v13 in pairs(p14) do
        local SpecialLuckyBlockColumn

        if t2.Matches(v13) then
            SpecialLuckyBlockColumn = v13.SpecialLuckyBlockColumn

            if typeof(SpecialLuckyBlockColumn) ~= "number" or not (SpecialLuckyBlockColumn >= 1) or not (SpecialLuckyBlockColumn <= 6) then
                SpecialLuckyBlockColumn = nil
            end
        end

        if SpecialLuckyBlockColumn ~= nil then
            local v14 = t4[SpecialLuckyBlockColumn] or {}

            t4[SpecialLuckyBlockColumn] = v14
            v14[#v14 + 1] = {
                uid = v12,
                data = v13
            }
        end
    end

    local t5 = {}

    for i = 1, 6 do
        local v15 = t4[i]

        if v15 ~= nil then
            table.sort(v15, olderFirst)

            for j = 1, math.min(#v15, 6) do
                local v17 = Vector3.new(0, 1, 0) * ((j - 1) * 6)

                t5[#t5 + 1] = {
                    uid = v15[j].uid,
                    data = v15[j].data,
                    column = i,
                    row = j,
                    cframe = p15 * t1[i] + v17
                }
            end
        end
    end

    return t5
end

return t2
