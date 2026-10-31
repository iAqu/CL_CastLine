-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    baseBackpackCapacity = 100,
    backpackSlotsPerUpgrade = 20,
    maxBackpackCapacity = 1000,
    maxBackpackUpgradeCount = 45,
    getRarityColor = function(p1) -- getRarityColor | line: 2
        if p1 == "common" then
            return Color3.new(0.7, 0.7, 0.7)
        end

        if p1 == "uncommon" then
            return Color3.new(0, 1, 0)
        end

        if p1 == "rare" then
            return Color3.new(0, 0.5, 1)
        end

        if p1 == "epic" then
            return Color3.new(0.5, 0, 1)
        end

        if p1 == "legendary" then
            return Color3.new(1, 0.5, 0)
        end

        return Color3.new(0.7, 0.7, 0.7)
    end,
    getBackpackCapacity = function(p2) -- getBackpackCapacity | line: 27
        return math.clamp(if p2 == nil then 0 else p2, 0, 45) * 20 + 100
    end,
    countItemsTowardBackpackCap = function(p3) -- countItemsTowardBackpackCap | line: 41
        if p3 == nil then
            return 0
        end

        local n1 = 0

        for _, v2 in p3 do
            if v2.itemType == "fish" then
                n1 += 1
            end
        end

        return n1
    end,
    hasSpaceInBackpack = function(p4, p5) -- hasSpaceInBackpack | line: 54
        local n2 = 0

        if p4 ~= nil then
            for _, v3 in p4 do
                if v3.itemType == "fish" then
                    n2 += 1
                end
            end
        end

        return n2 < p5
    end
}
