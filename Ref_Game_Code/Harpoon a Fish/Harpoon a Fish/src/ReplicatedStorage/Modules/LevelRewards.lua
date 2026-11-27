-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    SPACING = {
        {
            through = 50,
            step = 2
        },
        {
            through = 100,
            step = 3
        },
        {
            through = 150,
            step = 4
        },
        {
            through = 1e999,
            step = 5
        }
    },
    LADDER = {
        {
            upTo = 200,
            step = 1
        },
        {
            upTo = 300,
            step = 0.5
        }
    },
    CAP = 300,
    KEY = "Gold"
}

local function total(p1) -- line: 28
    -- upvalues: t1 (copy)
    local n1 = 0
    local n2 = 0

    for _, v1 in ipairs(t1.LADDER) do
        if p1 <= n2 then
            break
        end

        local v2 = if v1.upTo == 1e999 then 1e999 else math.floor((v1.upTo - n1) / v1.step + 0.5)
        local v5 = math.min(p1 - n2, v2)

        n1 += v5 * v1.step
        n2 += v5
    end

    return n1
end

local function nth(p2) -- line: 40
    -- upvalues: total (copy)
    return total(p2) - total(p2 - 1)
end

local n3 = 0
local n4 = 0
local n5 = 0

for _, v6 in ipairs(t1.LADDER) do
    local v8 = math.floor((math.min(v6.upTo, t1.CAP) - n5) / v6.step + 0.5)

    if v8 > 0 then
        local v9 = n4 + v8

        n3 = v9
        n4 = v9
        n5 += v8 * v6.step
    end
end

local function stepAt(p3) -- line: 55
    -- upvalues: t1 (copy)
    for _, v10 in ipairs(t1.SPACING) do
        if p3 <= v10.through then
            return v10.step
        end
    end

    return t1.SPACING[#t1.SPACING].step
end

local function rewardsUpTo(p4) -- line: 62
    -- upvalues: t1 (copy)
    local n6 = 0
    local n7 = 0
    local n8 = 0

    for _, v11 in ipairs(t1.SPACING) do
        local v12 = math.min(p4, v11.through)

        if n7 < v12 then
            n6 += math.floor(v12 / v11.step) - math.floor(n7 / v11.step)
        end

        if p4 <= v11.through then
            n8 = n6
            break
        end

        n8 = n6
        n7 = v11.through
    end

    return n8
end

local function moneyRewards(p5) -- line: 73
    -- upvalues: rewardsUpTo (copy)
    return (math.ceil(rewardsUpTo(p5) / 2))
end

local function luckRewards(p6) -- line: 74
    -- upvalues: rewardsUpTo (copy)
    return (math.floor(rewardsUpTo(p6) / 2))
end

function t1.IsRewardLevel(p7) -- line: 76
    -- upvalues: t1 (copy)
    if not (p7 >= 1) then
        return false
    end

    local v18 = false
    local step

    for _, v19 in ipairs(t1.SPACING) do
        if p7 <= v19.through then
            step = v19.step
            v18 = true
            break
        end
    end

    if not v18 then
        step = t1.SPACING[#t1.SPACING].step
    end

    return p7 % step == 0
end

function t1.Next(p8) -- line: 80
    -- upvalues: t1 (copy)
    local v22 = math.max(0, (math.floor(p8 or 0))) + 1

    while not t1.IsRewardLevel(v22) do
        v22 += 1
    end

    return v22
end

function t1.At(p9) -- line: 87
    -- upvalues: t1 (copy), total (copy), n3 (ref), rewardsUpTo (copy)
    if not t1.IsRewardLevel(p9) then
        return nil
    end

    local v23 = rewardsUpTo(p9)
    local v24 = v23 / 2
    local v25 = "Luck"

    if v23 % 2 == 1 then
        v25 = "Money"
        v24 = (v23 + 1) / 2
    end

    if v24 <= n3 then
        return {
            kind = v25,
            amount = total(v24) - total(v24 - 1)
        }
    end

    return {
        kind = "Key",
        amount = 1
    }
end

function t1.Money(p10) -- line: 97
    -- upvalues: total (copy), n3 (ref), rewardsUpTo (copy)
    return (total((math.min(math.ceil(rewardsUpTo((math.max(1, p10 or 1))) / 2), n3))))
end

function t1.Luck(p11) -- line: 100
    -- upvalues: total (copy), n3 (ref), rewardsUpTo (copy)
    return (total((math.min(math.floor(rewardsUpTo((math.max(1, p11 or 1))) / 2), n3))))
end

function t1.Keys(p12) -- line: 104
    -- upvalues: n3 (ref), rewardsUpTo (copy)
    local v37 = math.max(1, p12 or 1)

    return math.max(0, math.ceil(rewardsUpTo(v37) / 2) - n3) + math.max(0, math.floor(rewardsUpTo(v37) / 2) - n3)
end

t1.MILESTONES = {
    every = 25,
    through = 400,
    perTier = 4,
    tiers = { "Stone", "Gold", "Ruby", "Diamond" },
    after = {
        every = 100,
        key = "Secret"
    }
}

local MILESTONES = t1.MILESTONES
local v43 = MILESTONES.through / MILESTONES.every

function t1.Milestone(p13) -- line: 118
    -- upvalues: MILESTONES (copy), v43 (copy)
    if p13 <= v43 then
        return p13 * MILESTONES.every, MILESTONES.tiers[math.ceil(p13 / MILESTONES.perTier)]
    end

    return MILESTONES.through + (p13 - v43) * MILESTONES.after.every, MILESTONES.after.key
end

function t1.MilestonesUpTo(p14) -- line: 123
    -- upvalues: MILESTONES (copy), v43 (copy)
    local v48 = math.max(0, (math.floor(p14 or 0)))

    if v48 <= MILESTONES.through then
        return (math.floor(v48 / MILESTONES.every))
    end

    return v43 + math.floor((v48 - MILESTONES.through) / MILESTONES.after.every)
end

function t1.MilestoneAt(p15) -- line: 129
    -- upvalues: t1 (copy)
    local v51 = t1.MilestonesUpTo(p15)

    if v51 == 0 then
        return nil
    end

    local v52, v53 = t1.Milestone(v51)

    if v52 ~= p15 or not v53 then
        v53 = nil
    end

    return v53
end

function t1.Percent(p16) -- line: 137
    return string.format("%.1f", p16):gsub("%.0$", "") .. "%"
end

return t1
