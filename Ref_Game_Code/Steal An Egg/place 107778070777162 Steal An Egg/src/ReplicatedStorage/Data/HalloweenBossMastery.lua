-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = require(ReplicatedStorage.Data.Assets)
local BossMasteryFlags = require(ReplicatedStorage.Shared.Flags.BossMasteryFlags)
local Gears = require(ReplicatedStorage.Data.Gears)
local HalloweenTokens = require(ReplicatedStorage.Data.Currency.Configs.HalloweenTokens)
local Numbers = require(ReplicatedStorage.Shared.Utils.Numbers)
local Rarity = require(ReplicatedStorage.Data.Rarity)
local v1 = table.freeze({
    Kind = "Tokens",
    Amount = 2250
})
local v2 = table.freeze({
    Kind = "Tokens",
    Amount = 3000
})
local v3 = table.freeze({
    Kind = "Tokens",
    Amount = 3500
})
local v4 = table.freeze({
    Kind = "Tokens",
    Amount = 5000
})
local v5 = table.freeze({
    Kind = "Tokens",
    Amount = 6500
})
local v6 = table.freeze({
    Kind = "SpeedBoost",
    Seconds = 600
})
local v7 = table.freeze({
    Kind = "Pet",
    Category = "Cauldron"
})
local v8 = table.freeze({
    Kind = "Pet",
    Category = "Coffin Skeleton"
})
local v9 = table.freeze({
    Kind = "Pet",
    Category = "Bell Ghost"
})
local v10 = table.freeze({
    Kind = "Pet",
    Category = "Ghost Bird"
})
local v11 = table.freeze({
    Kind = "Pet",
    Category = "Big Moth"
})
local v12 = table.freeze({
    Kind = "Pet",
    Category = "Pumpkin Brute"
})
local v13 = table.freeze({
    Kind = "Gear",
    GearId = "Pumpkin Scythe"
})
local t1 = {}

for v14, v15 in {
        v1,
        v1,
        v7,
        v1,
        v4,
        v6,
        v1,
        v1,
        v6,
        v8,
        v1,
        v6,
        v1,
        v1,
        v4,
        v1,
        v9,
        v6,
        v1,
        v4,
        v6,
        v1,
        v1,
        v6,
        v4,
        v1,
        v6,
        v1,
        v1,
        v10,
        v1,
        v1,
        v6,
        v1,
        v4,
        v6,
        v2,
        v2,
        v6,
        v4,
        v2,
        v6,
        v2,
        v2,
        v11,
        v2,
        v2,
        v6,
        v2,
        v5,
        v6,
        v13,
        v3,
        v6,
        v5,
        v3,
        v6,
        v3,
        v3,
        v5,
        v3,
        v3,
        v6,
        v3,
        v12
    } do
    table.insert(t1, table.freeze({
        Id = ("PumpkinBoss%*"):format(v14),
        Kills = v14,
        Reward = v15
    }))
end

table.freeze(t1)

local function petConfig(p1) -- line: 80
    -- upvalues: Assets (copy)
    local v18 = assert(Assets.Directory[p1], (("Unknown Halloween mastery pet %*"):format(p1)))

    assert(type(v18.Egg.Icon) == "string", (("%* has no egg icon"):format(p1)))

    return v18
end

local function gearConfig(p2) -- line: 86
    -- upvalues: Gears (copy)
    assert(Gears.GearNameExists(p2))

    return Gears.Directory[p2]
end

local t3 = {
    Milestones = t1,
    Presentation = function(p3) -- Presentation | line: 97
        -- upvalues: Assets (copy), BossMasteryFlags (copy), Gears (copy), HalloweenTokens (copy), Numbers (copy), Rarity (copy)
        if p3.Kind == "Tokens" then
            return {
                Title = HalloweenTokens.DisplayName,
                Icon = HalloweenTokens.Icon,
                Amount = ("x%*"):format((Numbers.AddCommas(p3.Amount)))
            }
        end

        if p3.Kind == "Pet" then
            local Category = p3.Category
            local v23 = assert(Assets.Directory[Category], (("Unknown Halloween mastery pet %*"):format(Category)))

            assert(type(v23.Egg.Icon) == "string", (("%* has no egg icon"):format(Category)))

            return {
                Amount = "x1",
                Title = v23.DisplayName,
                Rarity = v23.Rarity.DisplayName,
                Icon = v23.Icon
            }
        end

        if p3.Kind == "SpeedBoost" then
            local v28 = math.max(math.floor(p3.Seconds / 60), 1)
            local v29 = ("%*x Speed"):format((BossMasteryFlags.SpeedBoostMultiplier:Get()))

            return {
                Icon = "rbxassetid://78137530993637",
                Title = v29,
                Amount = ("%*m"):format(v28),
                HoverTitle = string.upper(v29),
                HoverDescription = ("Run faster for %* minutes"):format(v28)
            }
        end

        if p3.Kind == "Gear" then
            local GearId = p3.GearId

            assert(Gears.GearNameExists(GearId))

            local v30 = Gears.Directory[GearId]

            return {
                Label = "Weapon",
                Amount = "x1",
                HoverDescription = "A permanent Halloween bat",
                Title = v30.DisplayName,
                Rarity = Rarity.Get(v30.Rarity).DisplayName,
                Icon = v30.Icon,
                HoverTitle = string.upper(v30.DisplayName)
            }
        end

        error((("Unknown Halloween mastery reward %*"):format(p3.Kind)))
    end,
    GetMilestone = function(p4) -- GetMilestone | line: 132
        -- upvalues: t1 (copy)
        for _, v31 in t1 do
            if v31.Id == p4 then
                return v31
            end
        end

        return nil
    end
}

for _, v32 in t1 do
    local Reward = v32.Reward

    if Reward.Kind == "Pet" then
        local Category = Reward.Category

        assert(type(assert(Assets.Directory[Category], (("Unknown Halloween mastery pet %*"):format(Category))).Egg.Icon) == "string", (("%* has no egg icon"):format(Category)))
    elseif Reward.Kind == "Gear" then
        local GearId = Reward.GearId

        assert(Gears.GearNameExists(GearId))

        local _ = Gears.Directory[GearId]
    end
end

return table.freeze(t3)
