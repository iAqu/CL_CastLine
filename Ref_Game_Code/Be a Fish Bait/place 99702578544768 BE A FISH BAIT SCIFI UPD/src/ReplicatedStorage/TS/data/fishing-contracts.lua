-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    {
        badgeReward = 12,
        coinMultiplier = 1.2,
        id = "standard-common",
        minimumZoneIndex = 0,
        quantity = 6,
        scoreReward = 100,
        targetRarity = "common",
        tier = "standard"
    },
    {
        badgeReward = 18,
        coinMultiplier = 1.25,
        id = "standard-uncommon",
        minimumZoneIndex = 1,
        quantity = 5,
        scoreReward = 150,
        targetRarity = "uncommon",
        tier = "standard"
    },
    {
        badgeReward = 30,
        coinMultiplier = 1.3,
        id = "rare-rare",
        minimumZoneIndex = 2,
        quantity = 3,
        scoreReward = 260,
        targetRarity = "rare",
        tier = "rare"
    },
    {
        badgeReward = 45,
        coinMultiplier = 1.35,
        id = "rare-epic",
        minimumZoneIndex = 3,
        quantity = 3,
        scoreReward = 400,
        targetRarity = "epic",
        tier = "rare"
    },
    {
        badgeReward = 70,
        coinMultiplier = 1.4,
        id = "elite-legendary",
        minimumZoneIndex = 4,
        quantity = 2,
        scoreReward = 650,
        targetRarity = "legendary",
        tier = "elite"
    },
    {
        badgeReward = 100,
        coinMultiplier = 1.45,
        id = "elite-mythic",
        minimumZoneIndex = 5,
        quantity = 1,
        scoreReward = 1000,
        targetRarity = "mythic",
        tier = "elite"
    }
}
local v1 = table.create(#t1)

local function v2(p1) -- line: 71
    return {
        p1.id,
        p1
    }
end

for v3, v4 in t1 do
    local _ = v3 - 1

    v1[v3] = {
        v4.id,
        v4
    }
end

local t2 = {}

for _, v5 in v1 do
    t2[v5[1]] = v5[2]
end

local t3 = {
    {
        badgeReward = 20,
        id = "daily-1",
        requiredCompletedContracts = 1
    },
    {
        badgeReward = 40,
        id = "daily-2",
        requiredCompletedContracts = 2
    },
    {
        badgeReward = 80,
        id = "daily-3",
        requiredCompletedContracts = 3
    }
}
local t4 = {
    {
        badgeCost = 100,
        description = "每天可免费替换一份未完成的委托。",
        id = "dailyReroll",
        name = "调度权限"
    },
    {
        badgeCost = 250,
        description = "委托面板显示目标稀有度及其可出现的区域。",
        id = "targetInsight",
        name = "目标鱼线索"
    }
}
local v6 = table.create(#t4)

local function v7(p2) -- line: 109
    return {
        p2.id,
        p2
    }
end

for v8, v9 in t4 do
    local _ = v8 - 1

    v6[v8] = {
        v9.id,
        v9
    }
end

local t5 = {}

for _, v10 in v6 do
    t5[v10[1]] = v10[2]
end

return {
    isFishingContractsEnabled = false,
    dailyContractCount = 3,
    maxDailyContractRerolls = 1,
    weeklyContractLeaderboardName = "weeklyContractScore",
    getContractTemplatesForZone = function(p3) -- getContractTemplatesForZone | line: 121
        -- upvalues: t1 (copy)
        local t6 = {}
        local n1 = 0

        for v11, v12 in t1 do
            local _ = v11 - 1

            if v12.minimumZoneIndex <= p3 == true then
                n1 += 1
                t6[n1] = v12
            end
        end

        return t6
    end,
    getFishingZoneForContract = function(p4) -- getFishingZoneForContract | line: 137
        local v13 = math.clamp(p4.minimumZoneIndex, 0, 11)

        return ({
            "common",
            "uncommon",
            "rare",
            "epic",
            "legendary",
            "mythic",
            "godly",
            "secret",
            "hacked",
            "cosmic",
            "extinct",
            "kaijuwu"
        })[v13 + 1]
    end,
    fishingContractTemplates = t1,
    fishingContractTemplateById = t2,
    contractMilestones = t3,
    contractLicenses = t4,
    contractLicenseById = t5
}
