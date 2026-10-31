-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local images = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "images").images

return {
    shardOrder = { "universalShard", "mythicShard", "legendaryShard", "epicShard", "rareShard" },
    shardsData = {
        universalShard = {
            displayName = "Wild Shard",
            image = images.universalShard
        },
        mythicShard = {
            displayName = "Mythic Shard",
            image = images.mythicShard
        },
        legendaryShard = {
            displayName = "Legendary Shard",
            image = images.legendaryShard
        },
        epicShard = {
            displayName = "Epic Shard",
            image = images.epicShard
        },
        rareShard = {
            displayName = "Rare Shard",
            image = images.rareShard
        }
    },
    shardTypeToSkinShardRarity = {
        universalShard = nil,
        mythicShard = "mythic",
        legendaryShard = "legendary",
        epicShard = "epic",
        rareShard = "rare"
    },
    skinShardRarityToShardType = {
        mythic = "mythicShard",
        legendary = "legendaryShard",
        epic = "epicShard",
        rare = "rareShard"
    }
}
