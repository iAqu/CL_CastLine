-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

local function accrualsFor(p1, p2) -- line: 36
    local v1 = p1.accruals[p2]

    if v1 then
        return v1
    end

    local t2 = {}

    for _, v2 in ipairs(p1.accrualTemplate) do
        table.insert(t2, {
            credit = 0,
            tokens = v2.tokens,
            interval = v2.interval
        })
    end

    p1.accruals[p2] = t2

    return t2
end

local function harvest(p3, p4, p5) -- line: 52
    local n1 = 0

    for _, v3 in ipairs(p4) do
        local v4 = p3.maxTokens / (v3.tokens / v3.interval)
        local v6 = math.min(v3.credit + p5, v4)
        local v8 = math.floor(v6 / v3.interval)

        if v8 <= 0 then
            v3.credit = v6
        else
            n1 += v8 * v3.tokens
            v3.credit = math.fmod(v6, v8 * v3.interval)
        end
    end

    return n1
end

function t1.Build(p6, p7) -- line: 71
    assert(p7.MaximumTokens, (("endpoint %* has no MaximumTokens"):format(p6)))

    if p7.InitialTokens then
        assert(p7.InitialTokens <= p7.MaximumTokens, (("endpoint %* starts above its own ceiling"):format(p6)))
    end

    local t4 = {}

    for _, v13 in ipairs(p7.Refresh or {}) do
        assert(v13.Tokens > 0, (("a refresh rule on %* grants no tokens"):format(p6)))
        assert(v13.Interval > 0, (("a refresh rule on %* has no interval"):format(p6)))
        table.insert(t4, {
            tokens = v13.Tokens,
            interval = v13.Interval
        })
    end

    table.freeze(t4)

    return {
        name = p6,
        maxTokens = p7.MaximumTokens,
        initialTokens = p7.InitialTokens or p7.MaximumTokens,
        causesBan = p7.Ban == true,
        accrualTemplate = t4,
        tokens = {},
        stamps = {},
        accruals = {}
    }
end

function t1.Spend(p8, p9) -- line: 101
    -- upvalues: accrualsFor (copy), harvest (copy)
    local ServerTimeNow = workspace:GetServerTimeNow()

    if not p8.stamps[p9] then
        p8.stamps[p9] = ServerTimeNow
    end

    if not p8.tokens[p9] then
        p8.tokens[p9] = p8.initialTokens
    end

    local v18 = accrualsFor(p8, p9)
    local v19 = p8.tokens[p9]
    local v21 = harvest(p8, v18, (math.max(ServerTimeNow - p8.stamps[p9], 0)))
    local v22 = v19 + v21 >= 1
    local v24 = math.min(v19 + v21, p8.maxTokens)

    if v22 then
        v24 -= 1
    end

    p8.tokens[p9] = math.clamp(v24, -1, p8.maxTokens)
    p8.stamps[p9] = ServerTimeNow

    return v22
end

function t1.Forget(p10, p11) -- line: 127
    p10.stamps[p11] = nil
    p10.tokens[p11] = nil
    p10.accruals[p11] = nil
end

return t1
