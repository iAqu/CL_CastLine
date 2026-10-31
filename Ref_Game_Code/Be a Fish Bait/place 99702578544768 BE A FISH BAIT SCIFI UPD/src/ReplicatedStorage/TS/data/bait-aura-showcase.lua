-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "bait-aura-utils")
local baitAuraConfigs, getBaitAuraConfig = v1.baitAuraConfigs, v1.getBaitAuraConfig
local animations = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "animation-utils").animations
local t1 = {}

for v2, v3 in pairs(animations) do
    t1[v2] = v3
end

t1.flying = animations.flyingAnim

local t2 = {
    default = {
        cycleType = "syncAnimSeconds",
        cycleSeconds = 5,
        animationId = { "scuba", "monke", "floss" },
        rarities = { "mythic", "legendary" }
    }
}

return {
    auraShowcaseSetAttribute = "AuraShowcaseSet",
    auraShowcaseAuraAttribute = "AuraShowcaseAuraName",
    defaultAuraShowcaseCycleSeconds = 5,
    getAuraShowcaseAnimationIds = function(p1) -- getAuraShowcaseAnimationIds | line: 25
        -- upvalues: t1 (copy)
        if p1.animationId == nil then
            return {}
        end

        local v4 = if type(p1.animationId) == "string" then { p1.animationId } else p1.animationId
        local t3 = {}

        for _, v5 in v4 do
            if v5 ~= "" then
                local v6 = t1[v5]

                if v6 == nil then
                    v6 = v5
                end

                table.insert(t3, v6)
            end
        end

        return t3
    end,
    getAuraShowcaseCycleSeconds = function(p2) -- getAuraShowcaseCycleSeconds | line: 44
        local cycleSeconds = p2.cycleSeconds

        if cycleSeconds == nil then
            cycleSeconds = 5
        end

        return cycleSeconds
    end,
    resolveAuraShowcasePlaylist = function(p3) -- resolveAuraShowcasePlaylist | line: 52
        -- upvalues: baitAuraConfigs (copy), getBaitAuraConfig (copy)
        local t4 = {}
        local t5 = {}

        for _, v7 in p3.rarities do
            for _, v8 in baitAuraConfigs do
                if v8.rarity == v7 and t5[v8.auraName] == nil then
                    table.insert(t4, v8)
                    t5[v8.auraName] = true
                end
            end
        end

        for _, v9 in p3.optionalAuras or {} do
            local v10 = getBaitAuraConfig(v9)

            if v10 ~= nil and t5[v10.auraName] == nil then
                table.insert(t4, v10)
                t5[v10.auraName] = true
            end
        end

        return t4
    end,
    auraShowcaseSetConfigs = t2
}
