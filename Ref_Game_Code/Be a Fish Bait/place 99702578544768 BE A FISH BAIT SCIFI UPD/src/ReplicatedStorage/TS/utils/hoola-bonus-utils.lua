-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local hoolaSystemConfig = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "hoola-system-config").hoolaSystemConfig
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquarium-skins")
local aquariumMultiverseSkinMutationLuckSetBonus, aquariumSkinMutationLuckSetBonus, hasAquariumMultiverseSkinMutationLuckSet, hasAquariumSkinMutationLuckSet = v1.aquariumMultiverseSkinMutationLuckSetBonus, v1.aquariumSkinMutationLuckSetBonus, v1.hasAquariumMultiverseSkinMutationLuckSet, v1.hasAquariumSkinMutationLuckSet

local function getHoolaTrainingPowerBonus(p1) -- line: 10
    -- upvalues: hoolaSystemConfig (copy)
    if p1 == nil then
        return 0
    end

    local n1 = 0

    for _, v2 in p1 do
        if table.find(v2.mutations, "hoola2") ~= nil or table.find(v2.mutations, "hoola3") ~= nil then
            n1 += hoolaSystemConfig.trainingPowerBonusByMutation.hoola2
        end
    end

    return n1
end

local function getHoolaMutationLuckBonus(p2) -- line: 23
    -- upvalues: hoolaSystemConfig (copy)
    if p2 == nil then
        return 0
    end

    local n2 = 0

    for _, v3 in p2 do
        if table.find(v3.mutations, "hoola3") ~= nil then
            n2 += hoolaSystemConfig.mutationLuckBonusByMutation.hoola3
        end
    end

    return n2
end

return {
    getHoolaTrainingPowerBonus = getHoolaTrainingPowerBonus,
    getHoolaMutationLuckBonus = getHoolaMutationLuckBonus,
    getAquariumStatBoosts = function(p3, p4) -- getAquariumStatBoosts | line: 42
        -- upvalues: aquariumMultiverseSkinMutationLuckSetBonus (copy), aquariumSkinMutationLuckSetBonus (copy), hasAquariumMultiverseSkinMutationLuckSet (copy), hasAquariumSkinMutationLuckSet (copy), getHoolaTrainingPowerBonus (copy), getHoolaMutationLuckBonus (copy)
        local v4, v5

        if p3 ~= nil then
            local n3 = 0
            local n4 = 0

            v4 = 0
            v5 = 0

            for _, v6 in p3 do
                if table.find(v6.mutations, "hoola2") ~= nil or table.find(v6.mutations, "hoola3") ~= nil then
                    n3 += 1
                end

                if table.find(v6.mutations, "hoola3") ~= nil then
                    n4 += 1
                end

                v5 = n4
                v4 = n3
            end
        else
            v4 = 0
            v5 = 0
        end

        local t1 = {}

        if v4 > 0 then
            table.insert(t1, {
                label = ("Hoola Fish (x%*)"):format(v4),
                value = getHoolaTrainingPowerBonus(p3)
            })
        end

        local t3 = {}

        if v5 > 0 then
            table.insert(t3, {
                label = ("Hoola III Fish (x%*)"):format(v5),
                value = getHoolaMutationLuckBonus(p3)
            })
        end

        if p4 ~= nil and hasAquariumSkinMutationLuckSet(p4) then
            table.insert(t3, {
                label = "Skin Set Bonus",
                value = aquariumSkinMutationLuckSetBonus
            })
        end

        if p4 ~= nil and hasAquariumMultiverseSkinMutationLuckSet(p4) then
            table.insert(t3, {
                label = "Multiverse Set Bonus",
                value = aquariumMultiverseSkinMutationLuckSetBonus
            })
        end

        local t7 = {}
        local t8 = {
            lineItems = t3
        }

        local function v7(p5, p6) -- line: 93
            return p5 + p6.value
        end

        local n5 = 0

        for i = 1, #t3 do
            local v9 = t3[i]
            local _ = i - 1

            n5 += v9.value
        end

        t8.total = n5
        t7.mutationLuck = t8

        local t9 = {
            lineItems = t1
        }

        local function v10(p7, p8) -- line: 109
            return p7 + p8.value
        end

        local n6 = 0

        for i = 1, #t1 do
            local v12 = t1[i]
            local _ = i - 1

            n6 += v12.value
        end

        t9.total = n6
        t7.trainingPower = t9

        return t7
    end
}
