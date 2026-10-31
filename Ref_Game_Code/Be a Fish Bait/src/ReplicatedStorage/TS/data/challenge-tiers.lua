-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local images = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local t1 = {
    {
        rewardLabel = "20 Tickets",
        rewardQuantity = 20,
        thresholdAmount = 3E+06,
        tierId = "challenge-tier-1",
        rewardIcon = images.celebrationTicket
    },
    {
        rewardLabel = "25 Tickets",
        rewardQuantity = 25,
        thresholdAmount = 6E+06,
        tierId = "challenge-tier-2",
        rewardIcon = images.celebrationTicket
    },
    {
        rewardLabel = "30 Tickets",
        rewardQuantity = 30,
        thresholdAmount = 9E+06,
        tierId = "challenge-tier-3",
        rewardIcon = images.celebrationTicket
    },
    {
        rewardLabel = "40 Tickets",
        rewardQuantity = 40,
        thresholdAmount = 1.2E+07,
        tierId = "challenge-tier-4",
        rewardIcon = images.celebrationTicket
    },
    {
        rewardLabel = "50 Tickets",
        rewardQuantity = 50,
        thresholdAmount = 1.5E+07,
        tierId = "challenge-tier-5",
        rewardIcon = images.celebrationTicket
    },
    {
        rewardLabel = "60 Tickets",
        rewardQuantity = 60,
        thresholdAmount = 1.8E+07,
        tierId = "challenge-tier-6",
        rewardIcon = images.celebrationTicket
    },
    {
        rewardLabel = "70 Tickets",
        rewardQuantity = 70,
        thresholdAmount = 2.1E+07,
        tierId = "challenge-tier-7",
        rewardIcon = images.celebrationTicket
    },
    {
        rewardLabel = "80 Tickets",
        rewardQuantity = 80,
        thresholdAmount = 2.4E+07,
        tierId = "challenge-tier-8",
        rewardIcon = images.celebrationTicket
    },
    {
        rewardLabel = "90 Tickets",
        rewardQuantity = 90,
        thresholdAmount = 2.7E+07,
        tierId = "challenge-tier-9",
        rewardIcon = images.celebrationTicket
    },
    {
        rewardLabel = "100 Tickets",
        rewardQuantity = 100,
        thresholdAmount = 3E+07,
        tierId = "challenge-tier-10",
        rewardIcon = images.celebrationTicket
    }
}
local thresholdAmount = t1[#t1].thresholdAmount

return {
    farewellRodSkinRewardId = "celebration-farewell-rodskin",
    getChallengeTierDefinition = function(p1) -- getChallengeTierDefinition | line: 68
        -- upvalues: t1 (copy)
        for v1, v2 in t1 do
            local _ = v1 - 1

            if v2.tierId == p1 == true then
                return v2
            end
        end

        return nil
    end,
    challengeTiers = t1,
    challengeMaxTicketAmount = thresholdAmount
}
