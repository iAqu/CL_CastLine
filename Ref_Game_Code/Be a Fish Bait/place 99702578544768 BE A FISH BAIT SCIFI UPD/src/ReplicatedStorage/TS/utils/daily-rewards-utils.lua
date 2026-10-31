-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images")
local images2, fishImages = images.images, images.fishImages
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local getRarityColorInHex = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils").getRarityColorInHex
local allFishData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish").allFishData
local offlineEarningsConfig = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "offline-earnings-utils").offlineEarningsConfig
local t1 = {
    day1 = 1200,
    day4 = 2700,
    day8 = 3000,
    day10 = 3600
}
local t2 = {
    {
        rewardId = "daily-1",
        rewardType = "money",
        rewardAmount = 0,
        rewardMoneyDurationSeconds = t1.day1,
        rewardIcon = images2.timeSkipIcon
    },
    {
        isLimited = true,
        rewardId = "daily-2",
        rewardType = "aquariumSkin",
        rewardAmount = 1,
        rewardSkinName = "Fossil",
        rewardIcon = "rbxassetid://75140088527655"
    },
    {
        rewardId = "daily-3",
        rewardType = "spinWheelSpins",
        rewardAmount = 2,
        rewardIcon = images2.wheelIcon
    },
    {
        rewardId = "daily-4",
        rewardType = "money",
        rewardAmount = 0,
        rewardMoneyDurationSeconds = t1.day4,
        rewardIcon = images2.timeSkipIcon
    },
    {
        rewardId = "daily-5",
        rewardType = "rerolls",
        rewardAmount = 1,
        rewardIcon = images2.baitAuraRerollOneX
    },
    {
        isOp = true,
        rewardId = "daily-6",
        rewardType = "fish",
        rewardAmount = 1,
        rewardFishName = "Leviathan",
        rewardFishRarity = "cosmic",
        rewardIcon = fishImages.leviathan
    },
    {
        isOp = true,
        isLimited = true,
        rewardId = "daily-7",
        rewardType = "fish",
        rewardAmount = 1,
        rewardDisplayName = "Flame Lord",
        rewardFishName = "FlameLord",
        rewardFishRarity = "exclusive",
        rewardIcon = fishImages.flameLord
    },
    {
        rewardId = "daily-8",
        rewardType = "money",
        rewardAmount = 0,
        rewardMoneyDurationSeconds = t1.day8,
        rewardIcon = images2.timeSkipIcon
    },
    {
        rewardId = "daily-9",
        rewardType = "timedBuff",
        rewardAmount = 2,
        rewardBuffKind = "power",
        rewardBuffDurationSeconds = 900,
        rewardIcon = images2.strongArmIcon
    },
    {
        rewardId = "daily-10",
        rewardType = "money",
        rewardAmount = 0,
        rewardMoneyDurationSeconds = t1.day10,
        rewardIcon = images2.timeSkipIcon
    },
    {
        rewardId = "daily-11",
        rewardType = "spinWheelSpins",
        rewardAmount = 2,
        rewardIcon = images2.wheelIcon
    },
    {
        rewardId = "daily-12",
        rewardType = "timedBuff",
        rewardAmount = 2,
        rewardBuffKind = "money",
        rewardBuffDurationSeconds = 1200,
        rewardIcon = images2.cashPile
    },
    {
        rewardId = "daily-13",
        rewardType = "rerolls",
        rewardAmount = 2,
        rewardIcon = images2.baitAuraRerollTwoX
    },
    {
        rewardId = "daily-14",
        rewardType = "rerolls",
        rewardAmount = 4,
        rewardIcon = images2.baitAuraRerollFourX
    }
}
local t3 = {
    rewardId = "daily-2",
    rewardType = "money",
    rewardAmount = 0,
    rewardMoneyDurationSeconds = t1.day1,
    rewardIcon = images2.timeSkipIcon
}

return {
    dailyRewardCooldownHours = 24,
    dailyRewardCooldownSeconds = 86400,
    dailyRewardFirstLoopEndDay = 14,
    dailyRewardLoopStartDay = 8,
    dailyRewardWeekLength = 7,
    getDay2Reward = function(p1) -- getDay2Reward | line: 141
        -- upvalues: t2 (copy), t3 (copy)
        if p1 then
            return t3
        end

        return t2[2]
    end,
    formatDurationSeconds = function(p2) -- formatDurationSeconds | line: 144
        if p2 < 3600 then
            return (("%*m"):format((math.floor(p2 / 60))))
        end

        return (("%*h"):format((math.floor(p2 / 3600))))
    end,
    getDailyRewardDisplayText = function(p3, p4) -- getDailyRewardDisplayText | line: 150
        -- upvalues: abbreviate (copy), getRarityColorInHex (copy), allFishData (copy), offlineEarningsConfig (copy)
        if p3.rewardType == "money" then
            if p3.rewardMoneyDurationSeconds ~= nil and p4 ~= nil then
                local v3 = math.max(p4, 50) * p3.rewardMoneyDurationSeconds * offlineEarningsConfig.offlineFactor

                return (("$%*"):format(if v3 >= 1000 then abbreviate(v3) else tostring((math.floor(v3)))))
            end

            local rewardAmount = p3.rewardAmount

            return (("x%*"):format(if rewardAmount >= 1000 then abbreviate(rewardAmount) else tostring(rewardAmount)))
        end

        if p3.rewardType == "gem" then
            return "Gem"
        end

        if p3.rewardType == "gemNode" then
            local rewardGemNodeRarity = p3.rewardGemNodeRarity

            if rewardGemNodeRarity == nil then
                return "Gem Node"
            end

            return (("<font color=\"%*\">%* Gem Node</font>"):format(getRarityColorInHex(rewardGemNodeRarity), (string.upper(rewardGemNodeRarity))))
        end

        if p3.rewardType == "fish" then
            if p3.rewardDisplayName ~= nil then
                return p3.rewardDisplayName
            end

            local rewardFishName = p3.rewardFishName

            if rewardFishName == nil then
                return "Fish"
            end

            local v6

            for v7, v8 in allFishData do
                local _ = v7 - 1

                if v8.name == rewardFishName == true then
                    v6 = v8
                    break
                end

                v6 = nil
            end

            if v6 ~= nil then
                v6 = v6.displayName
            end

            if v6 == nil then
                v6 = rewardFishName
            end

            return v6
        end

        if p3.rewardType == "aquariumSkin" then
            if p3.rewardSkinName == nil then
                return "Aquarium Skin"
            end

            return (("%* Skin"):format(p3.rewardSkinName))
        end

        if p3.rewardType == "rerolls" then
            return (("%*x Reroll%*"):format(p3.rewardAmount, if p3.rewardAmount == 1 then "" else "s"))
        end

        if p3.rewardType == "spinWheelSpins" then
            return (("%*x Wheel Spin%*"):format(p3.rewardAmount, if p3.rewardAmount == 1 then "" else "s"))
        end

        if p3.rewardType ~= "timedBuff" then
            return (("%* Gem Spawns"):format(p3.rewardAmount))
        end

        local v9

        if p3.rewardBuffDurationSeconds ~= nil then
            local rewardBuffDurationSeconds = p3.rewardBuffDurationSeconds

            v9 = if rewardBuffDurationSeconds < 3600 then ("%*m"):format((math.floor(rewardBuffDurationSeconds / 60))) else ("%*h"):format((math.floor(rewardBuffDurationSeconds / 3600)))
        else
            v9 = ""
        end

        local v12 = if p3.rewardBuffKind == "power" then "Power" elseif p3.rewardBuffKind == "money" then "Money" else "Mutation Luck"

        return (("x%* %*%*"):format(p3.rewardAmount, v12, if v9 == "" then "" else (" (%*)"):format(v9)))
    end,
    moneyRewardDurations = t1,
    dailyRewards = t2,
    day2FallbackReward = t3
}
