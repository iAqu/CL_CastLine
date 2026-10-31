-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    {
        chancePercent = 0.104,
        shardType = "mythicShard"
    },
    {
        chancePercent = 0.417,
        shardType = "legendaryShard"
    },
    {
        chancePercent = 1.67,
        shardType = "epicShard"
    },
    {
        chancePercent = 6.25,
        shardType = "rareShard"
    }
}

return {
    rollFishCatchShardType = function(p1) -- rollFishCatchShardType | line: 22
        -- upvalues: t1 (copy)
        local v1 = if p1 == nil then 1 else p1

        for _, v2 in t1 do
            if math.random() * 100 < v2.chancePercent * v1 then
                return v2.shardType
            end
        end

        return nil
    end,
    fishCatchShardOutcomes = t1
}
