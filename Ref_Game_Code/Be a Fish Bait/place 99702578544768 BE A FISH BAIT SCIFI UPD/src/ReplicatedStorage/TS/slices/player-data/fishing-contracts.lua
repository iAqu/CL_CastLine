-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "immut-utils")
local includesOriginal, produceWrapper, push = v1.includesOriginal, v1.produceWrapper, v1.push
local v8 = createProducer({}, {
    playerJoined = produceWrapper(function(p1, p2) -- line: 10
        p1[p2.userId] = p2.data.fishingContracts
    end),
    playerLeft = produceWrapper(function(p3, p4) -- line: 16
        p3[p4.userId] = nil
    end),
    fishingContractsRefreshed = produceWrapper(function(p5, p6) -- line: 21
        local v2 = p5[p6.userId]

        if not v2 then
            return nil
        end

        local v3 = v2.weekKey ~= p6.weekKey

        v2.dayKey = p6.dayKey
        v2.weekKey = p6.weekKey
        v2.dailyContractTemplateIds = p6.dailyContractTemplateIds
        v2.completedContractIds = {}
        v2.claimedMilestoneIds = {}
        v2.dailyRerollsUsed = 0

        if v3 then
            v2.weeklyScore = 0
        end
    end),
    fishingContractCompleted = produceWrapper(function(p7, p8) -- line: 39
        -- upvalues: includesOriginal (copy), push (copy)
        local v4 = p7[p8.userId]

        if not v4 or includesOriginal(v4.completedContractIds, p8.contractId) then
            return nil
        end

        push(v4.completedContractIds, p8.contractId)
        v4.badgeBalance += p8.badgeReward
        v4.weeklyScore += p8.scoreReward
    end),
    fishingContractMilestoneClaimed = produceWrapper(function(p9, p10) -- line: 50
        -- upvalues: includesOriginal (copy), push (copy)
        local v5 = p9[p10.userId]

        if not v5 or includesOriginal(v5.claimedMilestoneIds, p10.milestoneId) then
            return nil
        end

        push(v5.claimedMilestoneIds, p10.milestoneId)
        v5.badgeBalance += p10.badgeReward
    end),
    fishingContractLicensePurchased = produceWrapper(function(p11, p12) -- line: 60
        -- upvalues: includesOriginal (copy), push (copy)
        local v6 = p11[p12.userId]

        if not v6 or v6.badgeBalance < p12.badgeCost or includesOriginal(v6.ownedLicenseIds, p12.licenseId) then
            return nil
        end

        v6.badgeBalance -= p12.badgeCost
        push(v6.ownedLicenseIds, p12.licenseId)
    end),
    fishingContractRerolled = produceWrapper(function(p13, p14) -- line: 70
        local v7 = p13[p14.userId]

        if not v7 then
            return nil
        end

        v7.dailyContractTemplateIds = p14.dailyContractTemplateIds
        v7.dailyRerollsUsed = p14.dailyRerollsUsed
    end)
})

v8:getActions()

return {
    fishingContractsSlice = v8
}
