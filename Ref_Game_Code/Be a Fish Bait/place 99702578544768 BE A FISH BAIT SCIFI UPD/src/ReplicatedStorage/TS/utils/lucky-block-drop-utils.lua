-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    {
        chance = 0.356,
        quantity = 1,
        reward = "strengthBoost"
    },
    {
        chance = 0.35,
        quantity = 1,
        reward = "moneyBoost"
    },
    {
        chance = 0.1,
        quantity = 1,
        reward = "wheelSpin"
    },
    {
        chance = 0.17,
        quantity = 1,
        reward = "rareShard"
    },
    {
        chance = 0.09,
        quantity = 1,
        reward = "epicShard"
    },
    {
        chance = 0.027,
        quantity = 1,
        reward = "legendaryShard"
    },
    {
        chance = 0.007,
        quantity = 1,
        reward = "mythicShard"
    }
}

return {
    luckyBlockDropIntervalMinSeconds = 180,
    luckyBlockDropIntervalMaxSeconds = 300,
    luckyBlockDropHeightStuds = 40,
    luckyBlockClaimMaxDistanceStuds = 10,
    luckyBlockClaimDistanceBufferStuds = 20,
    luckyBlockRevealDurationSeconds = 3,
    luckyBlockClaimedDayKeySentinel = "lucky-block-drop",
    luckyBlockBuffDurationSeconds = 180,
    randomPointOnPartTop = function(p1) -- randomPointOnPartTop | line: 54
        local Size = p1.Size
        local v4 = Vector3.new((math.random() - 0.5) * Size.X, Size.Y / 2, (math.random() - 0.5) * Size.Z)

        return p1.CFrame:PointToWorldSpace(v4)
    end,
    pickWeightedLuckyBlockReward = function(p2) -- pickWeightedLuckyBlockReward | line: 59
        -- upvalues: t1 (copy)
        local v5 = if p2 == nil then t1 else p2

        local function v6(p3, p4) -- line: 65
            return p3 + p4.chance
        end

        local n1 = 0

        for i = 1, #v5 do
            local v8 = v5[i]
            local _ = i - 1

            n1 += v8.chance
        end

        local v9 = math.random() * n1

        for _, v10 in v5 do
            v9 -= v10.chance

            if v9 <= 0 then
                return v10
            end
        end

        return v5[#v5]
    end,
    luckyBlockRewardPool = t1
}
