-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local getDailyRewardDisplayText = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "daily-rewards-utils").getDailyRewardDisplayText
local t1 = {
    {
        rewardId = "celebration-1",
        rewardType = "tickets",
        rewardAmount = 10,
        rewardIcon = images.celebrationTicket
    },
    {
        rewardId = "celebration-2",
        rewardType = "tickets",
        rewardAmount = 20,
        rewardIcon = images.celebrationTicket
    },
    {
        rewardId = "celebration-3",
        rewardType = "tickets",
        rewardAmount = 25,
        rewardIcon = images.celebrationTicket
    },
    {
        rewardId = "celebration-4",
        rewardType = "tickets",
        rewardAmount = 25,
        rewardIcon = images.celebrationTicket
    },
    {
        rewardId = "celebration-5",
        rewardType = "tickets",
        rewardAmount = 30,
        rewardIcon = images.celebrationTicket
    },
    {
        rewardId = "celebration-6",
        rewardType = "tickets",
        rewardAmount = 30,
        rewardIcon = images.celebrationTicket
    },
    {
        rewardId = "celebration-7",
        rewardType = "tickets",
        rewardAmount = 60,
        rewardIcon = images.celebrationTicket
    },
    {
        rewardId = "celebration-8",
        rewardType = "tickets",
        rewardAmount = 40,
        rewardIcon = images.celebrationTicket
    },
    {
        rewardId = "celebration-9",
        rewardType = "tickets",
        rewardAmount = 45,
        rewardIcon = images.celebrationTicket
    },
    {
        rewardId = "celebration-10",
        rewardType = "tickets",
        rewardAmount = 50,
        rewardIcon = images.celebrationTicket
    },
    {
        rewardId = "celebration-11",
        rewardType = "tickets",
        rewardAmount = 70,
        rewardIcon = images.celebrationTicket
    },
    {
        rewardId = "celebration-12",
        rewardType = "tickets",
        rewardAmount = 90,
        rewardIcon = images.celebrationTicket
    },
    {
        rewardId = "celebration-13",
        rewardType = "tickets",
        rewardAmount = 120,
        rewardIcon = images.celebrationTicket
    },
    {
        rewardId = "celebration-14",
        rewardType = "tickets",
        rewardAmount = 150,
        rewardIcon = images.celebrationTicket
    }
}

return {
    celebrationRewardCooldownSeconds = 86400,
    celebrationRewardFirstLoopEndDay = 14,
    celebrationRewardLoopStartDay = 8,
    celebrationRewardWeekLength = 7,
    getCelebrationRewardDisplayText = function(p1, p2) -- getCelebrationRewardDisplayText | line: 99
        -- upvalues: getDailyRewardDisplayText (copy)
        if p1.rewardType == "tickets" then
            return (("%* Tickets"):format(p1.rewardAmount))
        end

        return getDailyRewardDisplayText(p1, p2)
    end,
    celebrationRewards = t1
}
