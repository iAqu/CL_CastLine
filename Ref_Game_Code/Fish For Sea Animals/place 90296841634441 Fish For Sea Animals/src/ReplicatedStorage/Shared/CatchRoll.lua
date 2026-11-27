-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Config = require(script.Parent.Config)
local Economy = require(script.Parent.Economy)
local Animals = require(script.Parent.Animals)
local t1 = {}

local function variety(p1, p2, p3) -- line: 20
    -- upvalues: Economy (copy)
    local v1 = if not p2 then 1 elseif p2[p1] then 1 else 1 * Economy.NewSpeciesWeight

    if p3 then
        for v3, v4 in p3 do
            if v4 == p1 then
                v1 *= Economy.RecentWeight[v3] or 1
            end
        end
    end

    return v1
end

function t1.speciesChances(p4, p5, p6, p7) -- line: 37
    -- upvalues: Animals (copy), variety (copy)
    local t2 = {}
    local n1 = 0

    for _, v5 in Animals.ByBiome[p4] or {} do
        local v6 = Animals.speciesWeight(v5, p5) * variety(v5.Id, p6, p7)

        table.insert(t2, {
            info = v5,
            chance = v6
        })
        n1 += v6
    end

    for _, v7 in t2 do
        v7.chance /= n1
    end

    return t2
end

function t1.mutationChances(p8, p9) -- line: 53
    -- upvalues: Config (copy)
    local v9 = math.min(math.max(p8, 1) ^ Config.MutationLuckPower, Config.MutationLuckCap)
    local t4 = {}
    local n2 = 0

    for _, v10 in Config.Mutations do
        t4[v10.Name] = v10.Chance * v9 * (if p9 and p9[v10.Name] then p9[v10.Name] else 1)
        n2 += t4[v10.Name]
    end

    return t4, (math.max(1 - n2, 0))
end

local t5 = {}
local t6 = {}
local v12 = #Config.Sizes
local n3 = 0

for i = v12, 1, -1 do
    n3 += Config.Sizes[i].Chance
    t6[i] = n3
end

for i = 1, #Config.Sizes do
    t5[i] = t6[i] / (t6[i - 1] or 1)
end

function t1.sizeSteps(p10) -- line: 80
    -- upvalues: Config (copy), t5 (copy)
    local v14 = math.min(math.max(p10, 1) ^ Config.SizeLuckPower, Config.SizeLuckCap)
    local t7 = {}

    for v15, v16 in t5 do
        t7[v15] = math.min(v16 * v14, Config.SizeStepMax)
    end

    return t7
end

function t1.sizeChance(p11, p12) -- line: 90
    local n4 = 1

    for i = 1, p12 do
        n4 *= p11[i]
    end

    if p11[p12 + 1] then
        n4 *= 1 - p11[p12 + 1]
    end

    return n4
end

function t1.oddsOf(p13) -- line: 102
    if p13 ~= p13 or p13 <= 0 then
        return 1E+15
    end

    return (math.clamp(math.floor(1 / p13 + 0.5), 1, 1E+15))
end

function t1.roll(p14, p15, p16, p17) -- line: 115
    -- upvalues: Config (copy), Animals (copy), t1 (copy)
    p17 = p17 or {}

    local v21 = if p15 == p15 then math.max(p15, 1) else 1
    local v22 = p17.ForcedId and Animals.get(p17.ForcedId)
    local v23 = t1.speciesChances(p14, v21, p17.Discovered, p17.Recent)
    local v24, v25

    if v22 then
        local chance

        for _, v26 in v23 do
            if v26.info == v22 then
                chance = v26.chance
            end
        end

        v24 = v22
        v25 = chance or 0.01
    else
        local v27 = p16:NextNumber()

        for _, v28 in v23 do
            v27 -= v28.chance

            if v27 <= 0 then
                v24 = v28.info
                v25 = v28.chance
                break
            end

            v24 = nil
            v25 = nil
        end

        if not v24 then
            local v29 = v23[#v23]

            v24 = v29.info
            v25 = v29.chance
        end
    end

    local v30, v31 = t1.mutationChances(v21, p17.MutationBoost)
    local v32, v33

    if v22 then
        local ForcedMutation = p17.ForcedMutation

        v33 = ForcedMutation

        if ForcedMutation then
            local v34 = Config.MutationByName[ForcedMutation]

            v32 = v30[ForcedMutation] or v34 and v34.Chance or 1
        else
            v32 = v31
        end
    else
        local v35 = p16:NextNumber()

        v32 = v31

        for _, v36 in Config.Mutations do
            v32 = v30[v36.Name]
            v35 -= v32

            if v35 < 0 then
                v33 = v36.Name
                break
            end

            v32 = v31
            v33 = nil
        end
    end

    local v37 = t1.sizeSteps(v21)
    local n5 = 0

    if not v22 then
        while v37[n5 + 1] and p16:NextNumber() < v37[n5 + 1] do
            n5 += 1
        end
    end

    local v38 = t1.sizeChance(v37, n5)

    return {
        Info = v24,
        Mutation = v33,
        Size = if n5 > 0 then Config.Sizes[n5].Name else nil,
        Odds = Animals.odds(v24.Id),
        RealOdds = t1.oddsOf(v25 * v32 * v38),
        Chances = {
            Species = v25,
            Mutation = v32,
            Size = v38
        }
    }
end

function t1.newVariant(p18, p19, p20, p21) -- line: 186
    local v39 = p18 and p18[p19]

    return p20 ~= nil and not (v39 and v39[p20]), p21 ~= nil and not (v39 and v39[p21])
end

function t1.recordVariant(p22, p23, p24, p25) -- line: 191
    if not (p24 or p25) then
        return
    end

    local v40 = p22[p23] or {}

    p22[p23] = v40

    if p24 then
        v40[p24] = true
    end

    if p25 then
        v40[p25] = true
    end
end

function t1.cleanVariants(p26, ...) -- line: 207
    -- upvalues: Config (copy), Animals (copy), t1 (copy)
    local t9 = {}

    for _, v41 in { ... } do
        for _, v42 in v41 do
            t1.recordVariant(t9, v42.Id, v42.Mutation, v42.Size)
        end
    end

    if type(p26) == "table" then
        for v43, v44 in p26 do
            if type(v43) == "string" and Animals.get(v43) and type(v44) == "table" then
                local v45 = t9[v43] or {}

                for v46, v47 in v44 do
                    if v47 == true and type(v46) == "string" and (Config.MutationByName[v46] or Config.SizeByName[v46]) then
                        v45[v46] = true
                    end
                end

                if next(v45) then
                    t9[v43] = v45
                end
            end
        end
    end

    return t9
end

return t1
