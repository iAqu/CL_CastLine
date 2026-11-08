-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags)
local t = require(ReplicatedStorage.Packages.t)

local function typecheckAssertion(p1) -- line: 8
    return function(p2) -- line: 9
        -- upvalues: p1 (copy)
        local v1, v2 = p1(p2)

        assert(v1, v2)

        return p2
    end
end

local function typecheckChecker(p3) -- line: 15
    return function(p4) -- line: 16
        -- upvalues: p3 (copy)
        local ok, result = pcall(p3, p4)

        if ok then
            return ok, nil
        end

        return ok, (tostring(result))
    end
end

local v3 = t.intersection(t.numberMinExclusive((-1e999)), t.numberMaxExclusive(1e999))
local v4 = t.intersection(v3, t.numberMin(0))
local v5 = t.intersection(v3, t.numberPositive)
local v6 = t.intersection(t.integer, t.numberMin(1))

local function typecheckSetAssertion(p5) -- line: 31
    -- upvalues: t (copy)
    local v7 = t.valueOf(p5)

    return function(p6) -- line: 9
        -- upvalues: v7 (copy)
        local v8, v9 = v7(p6)

        assert(v8, v9)

        return p6
    end
end

local Replicated = FastFlags.Replicated
local boolean = t.boolean
local v10 = Replicated("Game.TreadmillRecommendations.Enabled", function(p7) -- line: 9
    -- upvalues: boolean (copy)
    local v11, v12 = boolean(p7)

    assert(v11, v12)

    return p7
end, false)
local Replicated2 = FastFlags.Replicated
local t1 = {
    "MaximizeEngagement",
    "MaximizeTimespent",
    "MaximizeReactions",
    "RecentlyAdded",
    "TreadmillFeedV1",
    "TreadmillFeedV2"
}
local v13 = t.valueOf(t1)
local MaximizeEngagement = Replicated2("Game.TreadmillRecommendations.ConfigName", function(p8) -- line: 9
    -- upvalues: v13 (copy)
    local v14, v15 = v13(p8)

    assert(v14, v15)

    return p8
end, "MaximizeEngagement")
local v16 = FastFlags.Replicated("Game.TreadmillRecommendations.PageSize", function(p9) -- line: 9
    -- upvalues: v6 (copy)
    local v17, v18 = v6(p9)

    assert(v17, v18)

    return p9
end, 20)
local v19 = FastFlags.Replicated("Game.TreadmillRecommendations.PrefetchMargin", function(p10) -- line: 9
    -- upvalues: v6 (copy)
    local v20, v21 = v6(p10)

    assert(v20, v21)

    return p10
end, 5)
local v22 = FastFlags.Replicated("Game.TreadmillRecommendations.PrefetchJitterSeconds", function(p11) -- line: 9
    -- upvalues: v4 (copy)
    local v23, v24 = v4(p11)

    assert(v23, v24)

    return p11
end, 10)
local v25 = FastFlags.Replicated("Game.TreadmillRecommendations.ConfigSwapSpreadSeconds", function(p12) -- line: 9
    -- upvalues: v4 (copy)
    local v26, v27 = v4(p12)

    assert(v26, v27)

    return p12
end, 60)
local v28 = FastFlags.Replicated("Game.TreadmillRecommendations.StaleSeconds", function(p13) -- line: 9
    -- upvalues: v5 (copy)
    local v29, v30 = v5(p13)

    assert(v29, v30)

    return p13
end, 900)
local v31 = FastFlags.Replicated("Game.TreadmillRecommendations.FetchRetryDelaySeconds", function(p14) -- line: 9
    -- upvalues: v5 (copy)
    local v32, v33 = v5(p14)

    assert(v32, v33)

    return p14
end, 5)
local v34 = FastFlags.Replicated("Game.TreadmillRecommendations.FailureCooldownSeconds", function(p15) -- line: 9
    -- upvalues: v5 (copy)
    local v35, v36 = v5(p15)

    assert(v35, v36)

    return p15
end, 30)

return table.freeze({
    Enabled = v10,
    ConfigName = MaximizeEngagement,
    PageSize = v16,
    PrefetchMargin = v19,
    PrefetchJitterSeconds = v22,
    ConfigSwapSpreadSeconds = v25,
    StaleSeconds = v28,
    FetchRetryDelaySeconds = v31,
    FailureCooldownSeconds = v34
})
