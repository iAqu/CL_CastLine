-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MutationsConfig = require(ReplicatedStorage.Config.MutationsConfig)
local LuckyCatch = require(ReplicatedStorage.Shared.LuckyCatch)
local t1 = {}

function t1.MultiplierOf(p1) -- line: 33
    -- upvalues: MutationsConfig (copy)
    local v1 = MutationsConfig.Get(p1)

    return v1 and v1.Multiplier or 1
end

function t1.Best(p2, p3) -- line: 41
    -- upvalues: MutationsConfig (copy), LuckyCatch (copy)
    local v2 = false
    local n1 = 1
    local n2 = 0

    for _, v3 in pairs(p2 and p2.Animals or {}) do
        if v3.ModelName == p3 then
            local Mutation = v3.Mutation
            local v4 = MutationsConfig.Get(Mutation)

            n1 = math.max(n1, v4 and v4.Multiplier or 1)
            v2 = true
            n2 = math.max(n2, LuckyCatch.SizeSteps(v3.Size))
        end
    end

    return v2, n1, n2
end

function t1.Classify(p4, p5, p6, p7, p8, p9) -- line: 55
    -- upvalues: MutationsConfig (copy), LuckyCatch (copy), t1 (copy)
    if not (p4 and p4.Index and p4.Index[p5]) then
        return "New", false
    end

    if p8 then
        return "Lucky", false
    end

    local v6, v7, v8 = t1.Best(p4, p5)

    if not v6 then
        return "Missing", false
    end

    local v9 = MutationsConfig.Get(p6)

    if v7 < (v9 and v9.Multiplier or 1) then
        return "BetterMutation", false
    end

    if p9 and p9.SizeCounts and v8 < LuckyCatch.SizeSteps(p7) then
        return "BestSize", false
    end

    return "Repeat", true
end

function t1.Badge(p10) -- line: 75
    if p10 == "New" then
        return "NEW!"
    end

    return if p10 == "BetterMutation" or p10 == "BestSize" then "NEW BEST!" else nil
end

return t1
