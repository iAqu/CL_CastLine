-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local t1 = {
    Manor = t.strictInterface({
        Met = t.boolean,
        KeyClaimed = t.boolean,
        GateUnlocked = t.boolean
    }),
    BossMastery = t.strictInterface({
        Mastery = t.integer,
        ClaimedMilestoneIds = t.map(t.string, t.boolean),
        InfiniteRewardsClaimed = t.integer
    }),
    HeadlessHorseman = t.strictInterface({
        TokensCollected = t.integer,
        Claimed = t.boolean,
        ClaimedHeadStart = t.boolean,
        ClaimHeadStartTotal = t.boolean
    })
}

t1.State = t.strictInterface({
    Manor = t1.Manor,
    TutorialSeen = t.boolean,
    BossMastery = t1.BossMastery,
    BossLastSlainAt = t.number,
    HeadlessHorseman = t1.HeadlessHorseman
})

function t1.BlankManor() -- line: 71
    return {
        Met = false,
        KeyClaimed = false,
        GateUnlocked = false
    }
end

function t1.BlankBossMastery() -- line: 75
    return {
        Mastery = 0,
        InfiniteRewardsClaimed = 0,
        ClaimedMilestoneIds = {}
    }
end

function t1.BlankHeadlessHorseman() -- line: 79
    return {
        TokensCollected = 0,
        Claimed = false,
        ClaimedHeadStart = false,
        ClaimHeadStartTotal = false
    }
end

function t1.Blank() -- line: 83
    -- upvalues: t1 (copy)
    return {
        TutorialSeen = false,
        BossLastSlainAt = 0,
        Manor = t1.BlankManor(),
        BossMastery = t1.BlankBossMastery(),
        HeadlessHorseman = t1.BlankHeadlessHorseman()
    }
end

return table.freeze(t1)
