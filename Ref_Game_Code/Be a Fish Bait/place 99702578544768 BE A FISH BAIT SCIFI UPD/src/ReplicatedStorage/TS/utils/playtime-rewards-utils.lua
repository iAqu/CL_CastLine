-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local getTimeToAddToPlaytime = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "metadata-utils").getTimeToAddToPlaytime
local t1 = {
    {
        rewardId = "playtime-1",
        rewardType = "money",
        rewardAmount = 2,
        isRainbowItem = false,
        timeToClaim = 5,
        rewardIcon = images.coinBundle
    },
    {
        rewardId = "playtime-2",
        rewardType = "money",
        rewardAmount = 4,
        isRainbowItem = false,
        timeToClaim = 10,
        rewardIcon = images.coinChest
    },
    {
        rewardId = "playtime-3",
        rewardType = "gemSpawns",
        rewardAmount = 1,
        isRainbowItem = true,
        timeToClaim = 15,
        rewardIcon = images.gemSpawnIcon
    },
    {
        rewardId = "playtime-4",
        rewardType = "money",
        rewardAmount = 6,
        timeToClaim = 25,
        isRainbowItem = false,
        rewardIcon = images.coinVault
    },
    {
        rewardId = "playtime-5",
        rewardType = "gemSpawns",
        rewardAmount = 1,
        timeToClaim = 30,
        isRainbowItem = true,
        rewardIcon = images.gemSpawnIcon
    },
    {
        rewardId = "playtime-6",
        rewardType = "money",
        rewardAmount = 8,
        timeToClaim = 35,
        isRainbowItem = false,
        rewardIcon = images.coinVault
    },
    {
        rewardId = "playtime-7",
        rewardType = "money",
        rewardAmount = 10,
        timeToClaim = 40,
        isRainbowItem = false,
        rewardIcon = images.coinVault
    },
    {
        rewardId = "playtime-8",
        rewardType = "money",
        rewardAmount = 12,
        timeToClaim = 50,
        isRainbowItem = false,
        rewardIcon = images.coinVault
    },
    {
        rewardId = "playtime-9",
        rewardType = "gem",
        rewardAmount = 18,
        rewardIcon = "rbxassetid://112301528647731",
        rewardGemName = "Hermes",
        timeToClaim = 60,
        isRainbowItem = true
    }
}

return {
    getPlaytimeRewardDisplayText = function(p1) -- getPlaytimeRewardDisplayText | line: 80
        if p1.rewardType == "money" then
            return (("%*%% Money Bonus"):format(p1.rewardAmount))
        end

        if p1.rewardType == "gem" then
            return "Gem"
        end

        return (("%* Gem Spawns"):format(p1.rewardAmount))
    end,
    getPlaytimeRewardElapsedSeconds = function(p2, p3, p4, p5) -- getPlaytimeRewardElapsedSeconds | line: 95
        -- upvalues: getTimeToAddToPlaytime (copy)
        return p3 + getTimeToAddToPlaytime(p2, p4, p5)
    end,
    calculateTimestampForPlaytimeReward = function(p6, p7, p8, p9, p10) -- calculateTimestampForPlaytimeReward | line: 99
        -- upvalues: getTimeToAddToPlaytime (copy)
        local v1 = p8 + getTimeToAddToPlaytime(p6, p9, p10)

        return p6 + math.max(0, p7 * 60 - v1)
    end,
    playtimeRewards = t1
}
