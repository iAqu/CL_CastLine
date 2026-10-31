-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local mutations = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "mutations")
local championMutationName, deluluMutationName, fishMutations, getFishMutationDisplayName = mutations.championMutationName, mutations.deluluMutationName, mutations.fishMutations, mutations.getFishMutationDisplayName
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "gamepass-utils")
local vipGamepassName, mutationLuckGamepassName = v1.vipGamepassName, v1.mutationLuckGamepassName
local getActivePreLogoutMutationLuckMultiplier = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "pre-logout-buff-utils").getActivePreLogoutMutationLuckMultiplier
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "hoola-system-config")
local hoolaMutationDisplayGradients, hoolaSystemConfig = v2.hoolaMutationDisplayGradients, v2.hoolaSystemConfig
local t1 = {
    Frostwyrm = true,
    UncThulu = true
}

local function canFishReceiveMutations(p1) -- line: 19
    -- upvalues: t1 (copy)
    return t1[p1] == nil
end

local function applyMutationLuckDiminishingReturns(p2) -- line: 40
    if p2 <= 3 then
        return p2
    end

    local v3 = p2 - 3

    return 3 + 0.5 * (v3 / (v3 + 1))
end

local function calculateTotalMutationLuckMultiplier(p3, p4, p5, p6, p7, p8, p9, p10) -- line: 64
    -- upvalues: vipGamepassName (copy), mutationLuckGamepassName (copy), getActivePreLogoutMutationLuckMultiplier (copy)
    local v4 = if p5 == nil then 0 else p5
    local v5 = if p6 == nil then 0 else p6
    local v6 = if p7 == nil then 1 else p7
    local v7 = if p9 == nil then 0 else p9
    local v8 = if p10 == nil then 0 else p10
    local v9

    if p3 and #p3 > 0 then
        local function v10(p11) -- line: 84
            -- upvalues: vipGamepassName (copy)
            return p11.gamepassName == vipGamepassName
        end

        local v11 = false

        for v12, v13 in p3 do
            local _ = v12 - 1

            if v13.gamepassName == vipGamepassName then
                v11 = true
                break
            end
        end

        v9 = if v11 then 1 * 1.5 else 1

        local function v14(p12) -- line: 99
            -- upvalues: mutationLuckGamepassName (copy)
            return p12.gamepassName == mutationLuckGamepassName
        end

        local v15 = false

        for v16, v17 in p3 do
            local _ = v16 - 1

            if v17.gamepassName == mutationLuckGamepassName then
                v15 = true
                break
            end
        end

        if v15 then
            v9 *= 2
        end
    else
        v9 = 1
    end

    local v18 = v9 * getActivePreLogoutMutationLuckMultiplier(p4, v4) * (1 + v5) * (1 + v7) * (1 + v8)

    if if p8 == nil then p8 else p8["Unc's Calling"] ~= nil then
        v18 *= 2
    end

    local v19 = v18 + (v6 - 1)

    if v19 <= 3 then
        return v19
    end

    local v20 = v19 - 3

    return 3 + 0.5 * (v20 / (v20 + 1))
end

local t2 = {}

for v21, v22 in fishMutations do
    if v21 ~= championMutationName and v21 ~= deluluMutationName and v21 ~= "hoola1" and v21 ~= "hoola2" and v21 ~= "hoola3" then
        table.insert(t2, 1, {
            v21,
            v22
        })
    end
end

local function getChampionMutationChance(p13, p14) -- line: 150
    -- upvalues: championMutationName (copy), fishMutations (copy)
    local v23 = if p13 == nil then 0 else p13
    local v24 = if p14 == nil then 1 else p14
    local v25 = fishMutations[championMutationName]

    if v25 == nil then
        return 0
    end

    return v25.mutationChance + v23 + (v24 - 1)
end

local function rollForChampionMutation(p15, p16) -- line: 171
    -- upvalues: championMutationName (copy), fishMutations (copy)
    local v26 = if p15 == nil then 0 else p15
    local v27 = if p16 == nil then 1 else p16
    local v28 = fishMutations[championMutationName]

    return v28 ~= nil and math.random() < v28.mutationChance + v26 + (v27 - 1)
end

local function rollForDeluluMutation() -- line: 190
    -- upvalues: deluluMutationName (copy), fishMutations (copy)
    local v29 = fishMutations[deluluMutationName]

    return v29 ~= nil and math.random() < v29.mutationChance
end

local function rollForFishMutation(p17, p18, p19) -- line: 197
    -- upvalues: t2 (copy)
    local v30 = if p18 == nil then 1 else p18
    local v31 = if p19 == nil then 0 else p19

    for _, v32 in t2 do
        local v33 = v32[1]
        local v34 = v32[2]

        if v34.weatherRequirement == nil or p17[v34.weatherRequirement] ~= nil then
            local v36 = math.min(v30 * (if v34.weatherRequirement == nil then 1 else 1 + v31), 3.5)

            if math.random() < v34.mutationChance * v36 then
                return v33
            end
        end
    end

    return nil
end

local t4 = {}

for v37, v38 in fishMutations do
    t4[v37] = v38.mutationCashMultiplier
end

local function isMutationBetter(p20, p21) -- line: 240
    -- upvalues: t4 (copy)
    if p21 == nil then
        return true
    end

    return t4[p20] > t4[p21]
end

local function applyQteMutation(p22, p23) -- line: 254
    -- upvalues: t4 (copy)
    if p23 == nil then
        local t5 = {}
        local v39 = #t5

        table.move(p22, 1, #p22, v39 + 1, t5)

        return t5
    end

    local v40 = p22[1]

    if v40 == nil or t4[p23] > t4[v40] then
        return { p23 }
    end

    local t6 = {}
    local v41 = #t6

    table.move(p22, 1, #p22, v41 + 1, t6)

    return t6
end

local function getMutationChance(p24) -- line: 280
    -- upvalues: t2 (copy)
    local n1 = 1

    for _, v42 in t2 do
        local v43 = v42[2]

        if v43.weatherRequirement == nil or p24[v43.weatherRequirement] ~= nil then
            n1 *= 1 - v43.mutationChance
        end
    end

    return 1 - n1
end

local t7 = {
    Gold = Color3.fromRGB(255, 200, 0),
    Diamond = Color3.fromRGB(80, 220, 255),
    Plasma = Color3.fromRGB(200, 60, 255),
    Molten = Color3.fromRGB(255, 80, 20),
    Radioactive = Color3.fromRGB(45, 95, 65),
    Glitched = Color3.fromRGB(135, 255, 150),
    Champion = Color3.fromRGB(255, 235, 120),
    Delulu = Color3.fromRGB(255, 20, 147),
    hoola1 = hoolaSystemConfig.displayColors.hoola1,
    hoola2 = hoolaSystemConfig.displayColors.hoola2,
    hoola3 = hoolaSystemConfig.displayColors.hoola3
}

local function getMutationColor(p25) -- line: 311
    -- upvalues: t7 (copy)
    return t7[p25] or Color3.fromRGB(255, 255, 255)
end

local t8 = {
    Gold = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 225, 70)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(240, 150, 20))
    }),
    Diamond = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 245, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 150, 230))
    }),
    Plasma = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 235)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 35, 210))
    }),
    Molten = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 150, 35)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(230, 45, 35))
    }),
    Radioactive = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(105, 130, 115)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(35, 95, 55)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 55, 35))
    }),
    Glitched = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(205, 255, 210)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(135, 255, 150)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 220, 115))
    }),
    Champion = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 120, 215)),
        ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255, 245, 255)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(130, 195, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 120, 215))
    }),
    Delulu = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 180, 220)),
        ColorSequenceKeypoint.new(0.32, Color3.fromRGB(255, 20, 147)),
        ColorSequenceKeypoint.new(0.68, Color3.fromRGB(200, 0, 110)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 180, 220))
    }),
    hoola1 = hoolaMutationDisplayGradients.hoola1,
    hoola2 = hoolaMutationDisplayGradients.hoola2,
    hoola3 = hoolaMutationDisplayGradients.hoola3
}

local function color3ToHex(p26) -- line: 330
    return string.format("#%02X%02X%02X", math.round(p26.R * 255), math.round(p26.G * 255), (math.round(p26.B * 255)))
end

return {
    vipMutationLuckMultiplier = 1.5,
    mutationLuckGamepassMultiplier = 2,
    uncsCallingMutationLuckMultiplier = 2,
    mutationLuckDiminishingReturnsThreshold = 3,
    mutationLuckSoftCap = 3.5,
    canFishReceiveMutations = canFishReceiveMutations,
    applyMutationLuckDiminishingReturns = applyMutationLuckDiminishingReturns,
    calculateTotalMutationLuckMultiplier = calculateTotalMutationLuckMultiplier,
    getChampionMutationChance = getChampionMutationChance,
    rollForChampionMutation = rollForChampionMutation,
    rollForDeluluMutation = rollForDeluluMutation,
    rollForFishMutation = rollForFishMutation,
    isMutationBetter = isMutationBetter,
    applyQteMutation = applyQteMutation,
    getMutationChance = getMutationChance,
    getMutationColor = getMutationColor,
    getMutationsPlainText = function(p27) -- getMutationsPlainText | line: 336
        -- upvalues: getFishMutationDisplayName (copy)
        local v49 = table.create(#p27)

        local function v50(p28) -- line: 339
            -- upvalues: getFishMutationDisplayName (copy)
            return string.upper(getFishMutationDisplayName(p28))
        end

        for v51, v52 in p27 do
            local _ = v51 - 1

            v49[v51] = string.upper(getFishMutationDisplayName(v52))
        end

        return table.concat(v49, ", ")
    end,
    getMutationsShadowText = function(p29) -- getMutationsShadowText | line: 354
        -- upvalues: getFishMutationDisplayName (copy)
        local v53 = table.create(#p29)

        local function v54(p30) -- line: 357
            -- upvalues: getFishMutationDisplayName (copy)
            return getFishMutationDisplayName(p30)
        end

        for v55, v56 in p29 do
            local _ = v55 - 1

            v53[v55] = getFishMutationDisplayName(v56)
        end

        return table.concat(v53, ", ")
    end,
    getMutationsRichText = function(p31) -- getMutationsRichText | line: 374
        -- upvalues: getFishMutationDisplayName (copy), t7 (copy)
        local v57 = table.create(#p31)

        local function v58(p32) -- line: 377
            -- upvalues: getFishMutationDisplayName (copy), t7 (copy)
            local v59 = t7[p32] or Color3.fromRGB(255, 255, 255)

            return (("<font color=\"%*\">%*</font>"):format(string.format("#%02X%02X%02X", math.round(v59.R * 255), math.round(v59.G * 255), (math.round(v59.B * 255))), (getFishMutationDisplayName(p32))))
        end

        for v65, v66 in p31 do
            local _ = v65 - 1
            local v67 = t7[v66] or Color3.fromRGB(255, 255, 255)

            v57[v65] = ("<font color=\"%*\">%*</font>"):format(string.format("#%02X%02X%02X", math.round(v67.R * 255), math.round(v67.G * 255), (math.round(v67.B * 255))), (getFishMutationDisplayName(v66)))
        end

        return table.concat(v57, "<font color=\"#FFFFFF\">, </font>")
    end,
    getMutationColorGradient = function(p33) -- getMutationColorGradient | line: 393
        -- upvalues: t8 (copy)
        return t8[p33] or ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
        })
    end
}
