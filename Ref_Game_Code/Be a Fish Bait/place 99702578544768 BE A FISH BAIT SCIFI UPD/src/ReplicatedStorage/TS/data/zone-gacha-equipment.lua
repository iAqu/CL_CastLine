-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local images = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local t1 = {
    "head",
    "eyes",
    "legendary"
}
local t2 = {
    head1 = {
        id = "head1",
        displayName = "Head 1",
        category = "head",
        rarity = "common",
        chancePercent = 45,
        imageId = images.charmIcon,
        buffs = {
            buffMultiplier = 1.2
        }
    },
    head2 = {
        id = "head2",
        displayName = "Head 2",
        category = "head",
        rarity = "uncommon",
        chancePercent = 30,
        imageId = images.charmIcon,
        buffs = {
            buffMultiplier = 1.5
        }
    },
    head3 = {
        id = "head3",
        displayName = "Head 3",
        category = "head",
        rarity = "rare",
        chancePercent = 15,
        imageId = images.charmIcon,
        buffs = {
            buffMultiplier = 2
        }
    },
    head4 = {
        id = "head4",
        displayName = "Head 4",
        category = "head",
        rarity = "epic",
        chancePercent = 7,
        imageId = images.charmIcon,
        buffs = {
            buffMultiplier = 2.5
        }
    },
    head5 = {
        id = "head5",
        displayName = "Head 5",
        category = "head",
        rarity = "legendary",
        chancePercent = 3,
        imageId = images.charmIcon,
        buffs = {
            buffMultiplier = 3.5
        }
    },
    eyes1 = {
        id = "eyes1",
        displayName = "Eyes 1",
        category = "eyes",
        rarity = "common",
        chancePercent = 45,
        imageId = images.charmIcon,
        buffs = {
            buffMultiplier = 1.2
        }
    },
    eyes2 = {
        id = "eyes2",
        displayName = "Eyes 2",
        category = "eyes",
        rarity = "uncommon",
        chancePercent = 30,
        imageId = images.charmIcon,
        buffs = {
            buffMultiplier = 1.5
        }
    },
    eyes3 = {
        id = "eyes3",
        displayName = "Eyes 3",
        category = "eyes",
        rarity = "rare",
        chancePercent = 15,
        imageId = images.charmIcon,
        buffs = {
            buffMultiplier = 2
        }
    },
    eyes4 = {
        id = "eyes4",
        displayName = "Eyes 4",
        category = "eyes",
        rarity = "epic",
        chancePercent = 7,
        imageId = images.charmIcon,
        buffs = {
            buffMultiplier = 2.5
        }
    },
    eyes5 = {
        id = "eyes5",
        displayName = "Eyes 5",
        category = "eyes",
        rarity = "legendary",
        chancePercent = 3,
        imageId = images.charmIcon,
        buffs = {
            buffMultiplier = 3.5
        }
    },
    legendary1 = {
        id = "legendary1",
        displayName = "Ancient Crown",
        category = "legendary",
        rarity = "legendary",
        chancePercent = 70,
        imageId = images.charmIcon,
        buffs = {
            buffMultiplier = 4
        }
    },
    legendary2 = {
        id = "legendary2",
        displayName = "Mythic Halo",
        category = "legendary",
        rarity = "mythic",
        chancePercent = 30,
        imageId = images.charmIcon,
        buffs = {
            buffMultiplier = 5
        }
    }
}
local t3 = {
    head = {
        id = "head",
        category = "head",
        displayName = "Head",
        costPerRoll = 10,
        costTokenType = "tokenA",
        itemIds = { "head1", "head2", "head3", "head4", "head5" }
    },
    eyes = {
        id = "eyes",
        category = "eyes",
        displayName = "Eyes",
        costPerRoll = 10,
        costTokenType = "tokenB",
        itemIds = { "eyes1", "eyes2", "eyes3", "eyes4", "eyes5" }
    },
    legendary = {
        id = "legendary",
        category = "legendary",
        displayName = "Legendary",
        costPerRoll = 10,
        costTokenType = "tokenC",
        itemIds = { "legendary1", "legendary2" }
    }
}

local function getZoneGachaMachineItems(p1) -- line: 173
    -- upvalues: t2 (copy), t3 (copy)
    local v1 = t3[p1]

    if not v1 then
        return {}
    end

    local t4 = {}

    for _, v2 in v1.itemIds do
        local v3 = t2[v2]

        if v3 ~= nil then
            table.insert(t4, v3)
        end
    end

    return t4
end

local function rollZoneGachaMachine(p2) -- line: 189
    -- upvalues: getZoneGachaMachineItems (copy)
    local v4 = getZoneGachaMachineItems(p2)

    if #v4 == 0 then
        return nil
    end

    local function v5(p3, p4) -- line: 196
        return p3 + p4.chancePercent
    end

    local n1 = 0

    for i = 1, #v4 do
        local v7 = v4[i]
        local _ = i - 1

        n1 += v7.chancePercent
    end

    local v8 = math.random() * n1

    for _, v9 in v4 do
        v8 -= v9.chancePercent

        if v8 <= 0 then
            return v9
        end
    end

    return v4[#v4]
end

local function getZoneGachaBuffDescriptions(p5) -- line: 214
    local t5 = {}

    if p5.buffMultiplier ~= nil then
        table.insert(t5, (("%*x buff"):format(p5.buffMultiplier)))
    end

    return t5
end

return {
    getZoneGachaMachineItems = getZoneGachaMachineItems,
    rollZoneGachaMachine = rollZoneGachaMachine,
    getZoneGachaBuffDescriptions = getZoneGachaBuffDescriptions,
    zoneGachaMachineOrder = t1,
    zoneGachaEquipmentData = t2,
    zoneGachaMachineData = t3
}
