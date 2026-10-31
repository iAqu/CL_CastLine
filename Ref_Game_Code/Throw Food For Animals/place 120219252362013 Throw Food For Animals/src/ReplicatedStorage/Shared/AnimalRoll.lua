-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FoodsConfig = require(ReplicatedStorage.Config.FoodsConfig)
local AreasConfig = require(ReplicatedStorage.Config.AreasConfig)
local AnimalsData = require(ReplicatedStorage:WaitForChild("AnimalsData"))
local t1 = {
    Config = {
        CeilingOvershoot = 0.5,
        SubSlide = 1.2,
        Pull = 0.5,
        Reach = 0.4,
        Sigma = 0.85,
        OwnFoodsFrom = 13,
        GroupCenters = { 2, 5, 7.7 },
        SubCenters = { 2, 5, 7.7 },
        SubCeilings = { 4, 6, 8 },
        RecentDivisors = { 200, 2.5, 1.9 },
        TipAnimals = {
            {
                Area = "ShadowRealm",
                Rank = 8,
                From = 0.9,
                To = 0.97
            },
            {
                Area = "PhantomHarbor",
                Rank = 8,
                From = 0.9,
                To = 0.97
            }
        }
    }
}

function t1.TipFactor(p1, p2, p3) -- line: 94
    -- upvalues: AreasConfig (copy), t1 (copy)
    local v1 = AreasConfig.All[p1]

    if v1 then
        for _, v2 in ipairs(t1.Config.TipAnimals or {}) do
            if p2 == v2.Rank and v1.Key == v2.Area then
                return (math.clamp(((p3 or 0) - v2.From) / math.max(v2.To - v2.From, 1E-06), 0, 1))
            end
        end
    end

    return 1
end

function t1.BaitBase(p4) -- line: 108
    -- upvalues: t1 (copy)
    local OwnFoodsFrom = t1.Config.OwnFoodsFrom

    if not OwnFoodsFrom or p4 < OwnFoodsFrom then
        return 2 * (p4 - 1)
    end

    return 2 * (OwnFoodsFrom - 1) + 1 + 3 * (p4 - OwnFoodsFrom)
end

function t1.FoodCenter(p5, p6) -- line: 117
    -- upvalues: t1 (copy)
    local Config = t1.Config
    local v7 = math.clamp(p5 - t1.BaitBase(p6), 0.25, 3)

    if v7 < 1 then
        return 1 + (v7 - 0.25) / 0.75 * (Config.GroupCenters[1] - 1)
    end

    if v7 < 2 then
        return Config.GroupCenters[1] + (v7 - 1) * (Config.GroupCenters[2] - Config.GroupCenters[1])
    end

    return Config.GroupCenters[2] + (v7 - 2) * (Config.GroupCenters[3] - Config.GroupCenters[2])
end

function t1.SubAreaForDepth(p7) -- line: 133
    -- upvalues: AreasConfig (copy)
    local SubAreas = AreasConfig.SubAreas
    local v9 = math.clamp(p7 or 0, 0, 0.999999) * SubAreas
    local v10 = math.floor(v9) + 1

    return v10, v9 - (v10 - 1)
end

function t1.PoolCenter(p8, p9, p10) -- line: 142
    -- upvalues: t1 (copy)
    local Config = t1.Config
    local v11, v12 = t1.SubAreaForDepth(p10)
    local v13 = t1.FoodCenter(p8, p9)
    local v14 = Config.SubCenters[v11] + Config.SubSlide * v12
    local v15 = if v13 <= v14 then v13 + Config.Pull * (v14 - v13) else v14 + Config.Reach * (v13 - v14)
    local v16 = Config.SubCeilings[v11]

    return math.min(v15, v16 + Config.CeilingOvershoot), v16
end

function t1.Weights(p11, p12, p13) -- line: 159
    -- upvalues: t1 (copy)
    local Config = t1.Config
    local v18, v19 = t1.PoolCenter(p11, p12, p13)
    local t2 = {}
    local n1 = 0

    for i = 1, 8 do
        local v20 = 0

        if i <= v19 then
            local v21 = (i - v18) / Config.Sigma

            v20 = math.exp(-v21 * v21) * t1.TipFactor(p12, i, p13)
        end

        t2[i] = v20
        n1 += v20
    end

    t2[1] /= n1
    t2[2] /= n1
    t2[3] /= n1
    t2[4] /= n1
    t2[5] /= n1
    t2[6] /= n1
    t2[7] /= n1
    t2[8] /= n1

    return t2, v18
end

function t1.ApplyVariation(p14, p15, p16) -- line: 181
    -- upvalues: t1 (copy)
    if not p16 or #p16 == 0 then
        return p14
    end

    local Config = t1.Config
    local t3 = {}

    for v23, v24 in ipairs(Config.RecentDivisors) do
        local v25 = p16[#p16 - v23 + 1]

        if v25 then
            t3[v25] = (t3[v25] or 1) * v24
        end
    end

    local t4 = {}
    local n2 = 0

    for i = 1, #p15 do
        local ModelName = p15[i].ModelName
        local v27 = p14[i] or 0

        if t3[ModelName] then
            v27 /= t3[ModelName]
        end

        t4[i] = v27
        n2 += v27
    end

    if n2 <= 0 then
        return p14
    end

    for i = 1, #p15 do
        t4[i] /= n2
    end

    return t4
end

function t1.Roll(p17, p18, p19, p20, p21) -- line: 209
    -- upvalues: FoodsConfig (copy), AreasConfig (copy), AnimalsData (copy), t1 (copy)
    local v29 = AnimalsData[AreasConfig.Get(p17).Key]
    local v30 = FoodsConfig.Get(p18) or FoodsConfig.Get(1)
    local v31 = t1.Weights(v30.Bait, p17, p19)
    local v32 = t1.ApplyVariation(v31, v29, p21)
    local v33 = p20 and p20:NextNumber() or math.random()
    local n3 = 0

    for i = 1, #v29 do
        n3 += v32[i] or 0

        if v33 <= n3 then
            return v29[i].ModelName, i, v32
        end
    end

    return v29[#v29].ModelName, #v29, v32
end

function t1.MainPool(p22, p23) -- line: 229
    -- upvalues: FoodsConfig (copy), t1 (copy)
    local v35 = FoodsConfig.Get(p22)

    if not v35 then
        return nil
    end

    local v36 = v35.Bait - t1.BaitBase(p23)

    if v36 < 0.75 or v36 > 3.25 then
        return nil
    end

    local t5 = {}
    local v37 = t1.FoodCenter(v35.Bait, p23)

    for i = 1, 8 do
        if math.abs(i - v37) <= 1.25 then
            table.insert(t5, i)
        end
    end

    return t5
end

function t1.Describe(p24, p25, p26) -- line: 243
    -- upvalues: FoodsConfig (copy), AreasConfig (copy), AnimalsData (copy), t1 (copy)
    local v39 = AreasConfig.Get(p24)
    local v40 = AnimalsData[v39.Key]
    local v41 = FoodsConfig.Get(p25)
    local v42, v43 = t1.Weights(v41.Bait, p24, p26)
    local t6 = {}

    for i = 1, #v40 do
        table.insert(t6, string.format("%s %.1f%%", v40[i].Name, v42[i] * 100))
    end

    return string.format("%s in %s at depth %.2f (centre %.2f): %s", v41.Name, v39.Name, p26, v43, table.concat(t6, ", "))
end

return t1
