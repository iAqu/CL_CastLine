-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags)
local ScrambleRules = require(ReplicatedStorage.Shared.Util.ScrambleRules)
local t1 = {
    {
        ProductId = 3713243987,
        EventId = "DrScrambleOutbreak",
        Amount = 100,
        Label = "Sample Pack 1"
    },
    {
        ProductId = 3713244009,
        EventId = "DrScrambleOutbreak",
        Amount = 500,
        Label = "Sample Pack 2"
    },
    {
        ProductId = 3713244032,
        EventId = "DrScrambleOutbreak",
        Amount = 1500,
        Label = "Sample Pack 3"
    },
    {
        ProductId = 3714309175,
        EventId = "DrScrambleOutbreak",
        Amount = 3000,
        Label = "Sample Pack 4"
    }
}

local function validateCatalog(p1) -- line: 42
    -- upvalues: ScrambleRules (copy)
    assert(type(p1) == "table" and #p1 <= 32, "Scramble: invalid pack catalog")

    local t2 = {}

    for _, v2 in p1 do
        assert(type(v2) == "table", "Scramble: invalid Sample pack")
        assert(ScrambleRules.Integer(v2.ProductId, 1, 9E+12) and not t2[v2.ProductId], "Scramble: invalid product ID")
        assert(ScrambleRules.Integer(v2.Amount, 1, ScrambleRules.MAX_SAMPLES), "Scramble: invalid Sample pack amount")
        assert(type(v2.EventId) == "string" and #v2.EventId > 0 and #v2.EventId <= 64, "Scramble: invalid pack event")
        assert(type(v2.Label) == "string" and #v2.Label <= 80, "Scramble: invalid pack label")
        t2[v2.ProductId] = true
    end

    return p1
end

local v8 = FastFlags.Replicated("Game.Scramble.SamplePacks", validateCatalog, t1)
local t3 = {
    Offers = t1
}

function t3.Get() -- line: 77
    -- upvalues: t1 (copy), v8 (copy)
    local t4 = {}
    local t5 = {}

    for _, v9 in v8:Get() do
        table.insert(t4, v9)
        t5[v9.ProductId] = true
    end

    for _, v10 in t1 do
        if not t5[v10.ProductId] then
            table.insert(t4, v10)
        end
    end

    return t4
end

function t3.Find(p2) -- line: 93
    -- upvalues: t3 (copy)
    for _, v11 in t3.Get() do
        if v11.ProductId == p2 then
            return v11
        end
    end

    return nil
end

function t3.getChangedSignal() -- line: 102
    -- upvalues: v8 (copy)
    return v8.Changed
end

return table.freeze(t3)
