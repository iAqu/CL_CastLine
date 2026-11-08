-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local AreaEggCycle = require(ReplicatedStorage.Shared.Util.AreaEggCycle)
local Areas = require(ReplicatedStorage.Data.Areas)

require(ReplicatedStorage.Data.Areas.Types)

local LiveEventFlags = require(ReplicatedStorage.Shared.Flags.LiveEventFlags)
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.strict(t.string)
local v2 = t.strict(t.number)
local t1 = {}
local t2 = {}

local function hash(p1) -- line: 34
    local n1 = 2166136261

    for i = 1, #p1 do
        n1 = bit32.bxor(n1, string.byte(p1, i)) * 16777619 % 4294967296
    end

    return n1
end

local function variantsOf(p2) -- line: 43
    -- upvalues: Areas (copy)
    local v4 = Areas.Directory[p2]

    if v4 == nil then
        return nil
    end

    local SubBiomes = v4.SubBiomes

    return if SubBiomes ~= nil and #SubBiomes ~= 0 then SubBiomes else nil
end

function t2.OverrideAttributeName(p3) -- line: 55
    -- upvalues: v1 (copy)
    v1(p3)

    return "SubBiomeOverride_" .. p3:gsub("[^%w]", "_")
end

function t2.LocalRevealAttributeName(p4) -- line: 60
    -- upvalues: v1 (copy)
    v1(p4)

    return "SubBiomeLocalReveal_" .. p4:gsub("[^%w]", "_")
end

function t2.IsRotating(p5) -- line: 65
    -- upvalues: Areas (copy), v1 (copy)
    v1(p5)

    local v5 = Areas.Directory[p5]
    local SubBiomes

    if v5 ~= nil then
        SubBiomes = v5.SubBiomes

        if SubBiomes == nil or #SubBiomes == 0 then
            SubBiomes = nil
        end
    end

    return SubBiomes ~= nil
end

function t2.Variants(p6) -- line: 70
    -- upvalues: Areas (copy), v1 (copy)
    v1(p6)

    local v6 = Areas.Directory[p6]
    local SubBiomes

    if v6 ~= nil then
        SubBiomes = v6.SubBiomes

        if SubBiomes == nil or #SubBiomes == 0 then
            SubBiomes = nil
        end
    end

    return SubBiomes or {}
end

function t2.ById(p7, p8) -- line: 75
    -- upvalues: v1 (copy), t2 (copy)
    v1(p7)
    v1(p8)

    for _, v7 in t2.Variants(p7) do
        if v7.Id == p8 then
            return v7
        end
    end

    return nil
end

local function localRevealOf(p9) -- line: 88
    -- upvalues: Workspace (copy), t2 (copy)
    local Attribute = Workspace:GetAttribute(t2.LocalRevealAttributeName(p9))

    return if type(Attribute) == "string" then t2.ById(p9, Attribute) else nil
end

local function revealStateOf(p10) -- line: 93
    -- upvalues: Areas (copy), LiveEventFlags (copy)
    local v8 = Areas.Directory[p10]
    local Reveal = if v8 == nil then nil else v8.Reveal

    if Reveal == nil then
        return nil, nil
    end

    local v9 = LiveEventFlags.Get(Reveal.Flag):Get()

    if type(v9) == "table" then
        return Reveal, v9
    end

    return Reveal, nil
end

function t2.RevealPhaseAt(p11, p12) -- line: 105
    -- upvalues: Workspace (copy), AreaEggCycle (copy), Areas (copy), LiveEventFlags (copy), v1 (copy), v2 (copy), t2 (copy)
    v1(p11)
    v2(p12)

    local v10 = Areas.Directory[p11]
    local Reveal = if v10 == nil then nil else v10.Reveal
    local v11

    if Reveal ~= nil then
        v11 = LiveEventFlags.Get(Reveal.Flag):Get()

        if type(v11) ~= "table" then
            v11 = nil
        end
    else
        Reveal = nil
    end

    if Reveal == nil then
        return nil
    end

    if v11 == nil then
        local Attribute = Workspace:GetAttribute(t2.LocalRevealAttributeName(p11))

        if (if type(Attribute) == "string" then t2.ById(p11, Attribute) else nil) == nil then
            return "Sealed"
        end

        return "RevealNight"
    end

    if AreaEggCycle.ActivePeriodIndexAt(p12) <= v11.RevealPeriod then
        return "RevealNight"
    end

    return "Open"
end

function t2.RolledForPeriod(p13, p14) -- line: 122
    -- upvalues: Areas (copy), v1 (copy), v2 (copy)
    v1(p13)
    v2(p14)

    local v12 = Areas.Directory[p13]
    local SubBiomes

    if v12 ~= nil then
        SubBiomes = v12.SubBiomes

        if SubBiomes == nil or #SubBiomes == 0 then
            SubBiomes = nil
        end
    end

    if SubBiomes == nil then
        return nil
    end

    local n2 = 0

    for _, v13 in SubBiomes do
        n2 += v13.Weight
    end

    if n2 <= 0 then
        return SubBiomes[1]
    end

    local new = Random.new
    local v14 = ("%*:%*"):format(p13, p14)
    local n3 = 2166136261

    for i = 1, #v14 do
        n3 = bit32.bxor(n3, string.byte(v14, i)) * 16777619 % 4294967296
    end

    local v16 = new(n3 % 2147483647):NextNumber() * n2

    for _, v17 in SubBiomes do
        v16 -= v17.Weight

        if v16 <= 0 then
            return v17
        end
    end

    return SubBiomes[#SubBiomes]
end

function t2.ForPeriod(p15, p16) -- line: 150
    -- upvalues: Workspace (copy), Areas (copy), LiveEventFlags (copy), v1 (copy), v2 (copy), t2 (copy)
    v1(p15)
    v2(p16)

    local Attribute = Workspace:GetAttribute(t2.OverrideAttributeName(p15))
    local v18 = type(Attribute) == "string"
    local v19, v20

    if v18 then
        v19 = t2.ById(p15, Attribute)
        v20 = v19 == nil
    end

    if v18 and not v20 then
        return v19
    end

    local Attribute2 = Workspace:GetAttribute(t2.LocalRevealAttributeName(p15))
    local v21 = if type(Attribute2) == "string" then t2.ById(p15, Attribute2) else nil

    if v21 ~= nil then
        return v21
    end

    local v22 = Areas.Directory[p15]
    local Reveal = if v22 == nil then nil else v22.Reveal
    local v23

    if Reveal ~= nil then
        v23 = LiveEventFlags.Get(Reveal.Flag):Get()

        if type(v23) ~= "table" then
            v23 = nil
        end
    else
        Reveal = nil
    end

    if Reveal ~= nil then
        if v23 ~= nil then
            if p16 <= (v23.WinnerPeriod or v23.RevealPeriod) + 1 then
                local v25 = t2.ById(p15, v23.Winner)

                if v25 ~= nil then
                    return v25
                end
            end
        else
            local v24 = t2.ById(p15, Reveal.RevealSubBiome)

            if v24 ~= nil then
                return v24
            end
        end
    end

    return t2.RolledForPeriod(p15, p16)
end

function t2.ActiveAt(p17, p18) -- line: 188
    -- upvalues: AreaEggCycle (copy), v1 (copy), v2 (copy), t2 (copy)
    v1(p17)
    v2(p18)

    return t2.ForPeriod(p17, AreaEggCycle.ActivePeriodIndexAt(p18))
end

function t2.Active(p19) -- line: 195
    -- upvalues: Workspace (copy), v1 (copy), t2 (copy)
    v1(p19)

    return t2.ActiveAt(p19, Workspace:GetServerTimeNow())
end

function t2.PoolDropTable(p20, p21) -- line: 202
    -- upvalues: Areas (copy), v1 (copy), t1 (copy)
    v1(p20)

    local v26 = ("%*|%*"):format(p20, p21.Id)
    local v27 = t1[v26]

    if v27 ~= nil then
        return v27
    end

    local DropTable = p21.DropTable

    if DropTable == nil then
        local t3 = {}

        for _, v28 in p21.Pool do
            t3[v28] = true
        end

        local t4 = {}

        for _, v29 in Areas.Directory[p20].DropTable do
            if t3[v29[1]] then
                table.insert(t4, v29)
            end
        end

        assert(#t4 > 0, (("Sub-biome \"%*\" of area \"%*\" has no pool entry in the area drop table"):format(p21.Id, p20)))
        t1[v26] = t4

        return t4
    end

    t1[v26] = DropTable

    return DropTable
end

function t2.SetOverride(p22, p23) -- line: 238
    -- upvalues: RunService (copy), Workspace (copy), v1 (copy), t2 (copy)
    assert(RunService:IsServer(), "Only the server may force a sub-biome")
    v1(p22)

    if p23 ~= nil then
        assert(t2.ById(p22, p23) ~= nil, (("Area \"%*\" has no sub-biome \"%*\""):format(p22, p23)))
    end

    Workspace:SetAttribute(t2.OverrideAttributeName(p22), p23)
end

function t2.SetLocalReveal(p24, p25) -- line: 251
    -- upvalues: RunService (copy), Workspace (copy), v1 (copy), t2 (copy)
    assert(RunService:IsServer(), "Only the server may set a local reveal")
    v1(p24)

    if p25 ~= nil then
        assert(t2.ById(p24, p25) ~= nil, (("Area \"%*\" has no sub-biome \"%*\""):format(p24, p25)))
    end

    Workspace:SetAttribute(t2.LocalRevealAttributeName(p24), p25)
end

function t2.IsOverridden(p26) -- line: 264
    -- upvalues: Workspace (copy), v1 (copy), t2 (copy)
    v1(p26)

    return type(Workspace:GetAttribute(t2.OverrideAttributeName(p26))) == "string"
end

return table.freeze(t2)
