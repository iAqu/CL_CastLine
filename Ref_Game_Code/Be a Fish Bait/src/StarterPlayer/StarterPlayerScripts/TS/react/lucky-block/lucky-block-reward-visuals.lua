-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local images = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local t1 = {
    strengthBoost = {
        label = "Strength Boost",
        image = images.strongArmIcon
    },
    moneyBoost = {
        label = "Money Boost",
        image = images.moneyIcon
    },
    wheelSpin = {
        label = "Wheel Spin",
        image = images.wheelIcon
    },
    rareShard = {
        label = "Rare Shard",
        rarity = "rare",
        image = images.rareShard
    },
    epicShard = {
        label = "Epic Shard",
        rarity = "epic",
        image = images.epicShard
    },
    legendaryShard = {
        label = "Legendary Shard",
        rarity = "legendary",
        image = images.legendaryShard
    },
    mythicShard = {
        label = "Mythic Shard",
        rarity = "mythic",
        image = images.mythicShard
    }
}

return {
    formatLuckyBlockChancePercent = function(p1) -- formatLuckyBlockChancePercent | line: 39
        local v1 = p1 * 100

        if v1 == math.floor(v1) then
            return (("%*%%"):format((string.format("%.0f", v1))))
        end

        return (("%*%%"):format((string.format("%.1f", v1))))
    end,
    luckyBlockRewardVisuals = t1
}
