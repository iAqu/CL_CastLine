-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = require(ReplicatedStorage.Data.Assets)
local Gears = require(ReplicatedStorage.Data.Gears)
local GearToolLookup = require(ReplicatedStorage.Shared.Util.GearToolLookup)
local BossMasteryFlags = require(ReplicatedStorage.Shared.Flags.BossMasteryFlags)
local MountRace = require(ReplicatedStorage.Data.MountRace)
local Mutations = require(ReplicatedStorage.Shared.Modules.Mutations)
local Numbers = require(ReplicatedStorage.Shared.Utils.Numbers)
local RaceRally = require(ReplicatedStorage.Data.RaceRally)
local RaceRallyFlags = require(ReplicatedStorage.Shared.Flags.RaceRallyFlags)
local ScrambleMutationFlags = require(ReplicatedStorage.Shared.Flags.ScrambleMutationFlags)
local v1 = table.freeze({
    Boss = {
        Title = "Fractured Mutation",
        Icon = "rbxassetid://74755693699202",
        Success = function() -- Success | line: 41
            -- upvalues: BossMasteryFlags (copy)
            return BossMasteryFlags.MutationConsumableSuccessPercent:Get()
        end
    },
    Scrambled = {
        Title = "Scrambled Mutation",
        Icon = "rbxassetid://134710848063255",
        Success = function() -- Success | line: 48
            -- upvalues: ScrambleMutationFlags (copy)
            return ScrambleMutationFlags.SuccessPercent:Get()
        end
    },
    Enchanted = {
        Title = "Enchanted Essence",
        Icon = "rbxassetid://73528861998418",
        Success = function() -- Success | line: 55
            return 100
        end
    },
    Nitro = {
        Title = "Nitro Mutation",
        Icon = "rbxassetid://134287739122547",
        Success = function() -- Success | line: 62
            -- upvalues: RaceRallyFlags (copy)
            return RaceRallyFlags.NitroSuccessPercent:Get()
        end
    }
})

local function duration(p1) -- line: 68
    if p1 >= 3600 and p1 % 3600 == 0 then
        return (`{ p1 // 3600 }h`)
    end

    if not (p1 >= 60) or p1 % 60 ~= 0 then
        return (("%*s"):format(p1))
    end

    return (`{ p1 // 60 }m`)
end

local function count(p2, p3) -- line: 77
    assert(type(p2) == "number" and p2 >= 1 and p2 % 1 == 0, (("%* must be a whole number of at least 1"):format(p3)))
end

local function asset(p4) -- line: 81
    -- upvalues: Assets (copy)
    local v4 = Assets.Directory[p4]

    assert(v4 ~= nil, (("Unknown pet \"%*\""):format(p4)))

    return v4
end

local function boost(p5, p6, p7, p8, p9) -- line: 88
    return {
        Validate = function(p10) -- Validate | line: 90
            -- upvalues: p9 (copy)
            if p10.Seconds ~= nil then
                local Seconds = p10.Seconds
                local v7 = ("%*.Seconds"):format(p10.Kind)

                assert(type(Seconds) == "number" and Seconds >= 1 and Seconds % 1 == 0, (("%* must be a whole number of at least 1"):format(v7)))
            end

            if p10.Multiplier == nil then
                return
            end

            assert(p9, (("%* rewards can't set a Multiplier"):format(p10.Kind)))
            assert(type(p10.Multiplier) == "number" and p10.Multiplier > 1 and p10.Multiplier < 1e999, (("%*.Multiplier must be above 1"):format(p10.Kind)))
        end,
        Present = function(p11) -- Present | line: 102
            -- upvalues: p5 (copy), p6 (copy), p7 (copy), p8 (copy)
            local v13 = ("%*x"):format(p11.Multiplier or p7())
            local t6 = {
                Title = ("%* %*"):format(v13, p5),
                Icon = p6
            }
            local v14 = p11.Seconds or p8()

            t6.Amount = if v14 >= 3600 and v14 % 3600 == 0 then ("%*h"):format(v14 // 3600) elseif not (v14 >= 60) or v14 % 60 ~= 0 then ("%*s"):format(v14) else ("%*m"):format(v14 // 60)
            t6.Multiplier = v13

            return t6
        end
    }
end

local t7 = {
    Gear = {
        Validate = function(p12) -- Validate | line: 116
            -- upvalues: Gears (copy), GearToolLookup (copy)
            local v15 = Gears.Directory[p12.GearId]

            assert(v15 ~= nil and v15.Persistent == true and v15.OneTime == true, "Gear reward needs a permanent one-time gear")
            assert(p12.Amount == 1, "Gear rewards grant exactly one")
            assert(GearToolLookup(v15.ToolModel or p12.GearId) ~= nil, "Gear reward tool is missing")
        end,
        Present = function(p13) -- Present | line: 122
            -- upvalues: Gears (copy)
            local v19 = Gears.Directory[p13.GearId]

            return {
                Amount = "Permanent",
                Title = v19.DisplayName,
                Icon = v19.Icon,
                Rarity = v19.Rarity
            }
        end
    },
    Egg = {
        Validate = function(p14) -- Validate | line: 128
            -- upvalues: Assets (copy), Mutations (copy)
            assert(type(p14.Category) == "string", "Egg reward needs a Category")

            local Category2 = p14.Category

            assert(Assets.Directory[Category2] ~= nil, (("Unknown pet \"%*\""):format(Category2)))

            if p14.Mutation ~= nil then
                assert(Mutations.All()[p14.Mutation] ~= nil, (("Unknown mutation \"%*\""):format(p14.Mutation)))
            end

            if p14.Scale == nil then
                return
            end

            assert(type(p14.Scale) == "number" and p14.Scale > 0, "Egg reward Scale must be positive")
        end,
        Present = function(p15) -- Present | line: 138
            -- upvalues: Assets (copy), Mutations (copy)
            local Category = p15.Category
            local v26 = Assets.Directory[Category]

            assert(v26 ~= nil, (("Unknown pet \"%*\""):format(Category)))

            local v29 = if v26.Egg == nil or v26.Egg.DisplayName == nil then ("%* Egg"):format(v26.DisplayName) else v26.Egg.DisplayName

            if p15.Mutation ~= nil then
                v29 = ("%* %*"):format(Mutations.All()[p15.Mutation].Label, v29)
            end

            return {
                Amount = "x1",
                Title = v29,
                Icon = if v26.Egg == nil or v26.Egg.Icon == nil then v26.Icon else v26.Egg.Icon,
                Rarity = v26.Rarity._id,
                Asset = p15.Category
            }
        end
    },
    MutationConsumable = {
        Validate = function(p16) -- Validate | line: 157
            -- upvalues: v1 (copy)
            assert(v1[p16.MutationId] ~= nil, (("Unsupported mutation token \"%*\""):format(p16.MutationId)))

            local Amount = p16.Amount

            assert(type(Amount) == "number" and Amount >= 1 and Amount % 1 == 0, "MutationConsumable.Amount must be a whole number of at least 1")
        end,
        Present = function(p17) -- Present | line: 161
            -- upvalues: v1 (copy)
            local v33 = v1[p17.MutationId]

            return {
                Title = v33.Title,
                Icon = v33.Icon,
                Amount = ("x%* · %*%%"):format(p17.Amount, (v33.Success()))
            }
        end
    },
    CashBooster = boost("Cash Booster", "rbxassetid://119640363267627", function() -- line: 167
        -- upvalues: BossMasteryFlags (copy)
        return BossMasteryFlags.CashBoosterMultiplier:Get()
    end, function() -- line: 169
        -- upvalues: BossMasteryFlags (copy)
        return BossMasteryFlags.CashBoosterDurationSeconds:Get()
    end, true),
    SpeedBoost = boost("Speed", "rbxassetid://78137530993637", function() -- line: 173
        -- upvalues: BossMasteryFlags (copy)
        return BossMasteryFlags.SpeedBoostMultiplier:Get()
    end, function() -- line: 175
        -- upvalues: BossMasteryFlags (copy)
        return BossMasteryFlags.SpeedBoostDurationSeconds:Get()
    end, false),
    TreadmillBoost = boost("Treadmill Booster", "rbxassetid://107126944152347", function() -- line: 179
        -- upvalues: BossMasteryFlags (copy)
        return BossMasteryFlags.TreadmillBoostMultiplier:Get()
    end, function() -- line: 181
        -- upvalues: BossMasteryFlags (copy)
        return BossMasteryFlags.TreadmillBoostDurationSeconds:Get()
    end, false),
    Racer = {
        Validate = function(p18) -- Validate | line: 186
            -- upvalues: RaceRally (copy)
            assert(RaceRally.Racers[p18.Racer] ~= nil, (("Unknown racer \"%*\""):format(p18.Racer)))
        end,
        Present = function(p19) -- Present | line: 189
            -- upvalues: Assets (copy), RaceRally (copy)
            local v39 = RaceRally.Racers[p19.Racer]
            local Asset = v39.Asset
            local v40 = Assets.Directory[Asset]

            assert(v40 ~= nil, (("Unknown pet \"%*\""):format(Asset)))

            return {
                Amount = "Racer",
                Title = ("%* Racer"):format(v39.DisplayName),
                Icon = v40.Icon,
                Rarity = v40.Rarity._id,
                Asset = v39.Asset
            }
        end
    },
    Tokens = {
        Validate = function(p20) -- Validate | line: 203
            local Amount = p20.Amount

            assert(type(Amount) == "number" and Amount >= 1 and Amount % 1 == 0, "Tokens.Amount must be a whole number of at least 1")
        end,
        Present = function(p21) -- Present | line: 206
            -- upvalues: Numbers (copy), RaceRally (copy)
            return {
                Title = RaceRally.CurrencyName,
                Icon = RaceRally.CurrencyIcon,
                Amount = ("x%*"):format((Numbers.AddCommas(p21.Amount)))
            }
        end
    }
}
local t14 = {
    Kinds = t7,
    Validate = function(p22) -- Validate | line: 220
        -- upvalues: t7 (copy)
        assert(type(p22) == "table" and type(p22.Kind) == "string", "A reward needs a Kind")

        local v45 = t7[p22.Kind]

        assert(v45 ~= nil, (("Unknown reward kind \"%*\""):format(p22.Kind)))
        v45.Validate(p22)
        assert(p22.DisplayName == nil or type(p22.DisplayName) == "string", "DisplayName must be a string")
        assert(p22.Icon == nil or type(p22.Icon) == "string", "Icon must be a string")
    end,
    Present = function(p23) -- Present | line: 230
        -- upvalues: t7 (copy)
        local v50 = t7[p23.Kind].Present(p23)

        if p23.DisplayName ~= nil then
            v50.Title = p23.DisplayName
        end

        if p23.Icon ~= nil then
            v50.Icon = p23.Icon
        end

        return v50
    end
}

assert(RaceRally.Racers[RaceRally.DefaultRacer] ~= nil, (("Default racer \"%*\" is missing"):format(RaceRally.DefaultRacer)))

for v53, v54 in RaceRally.Racers do
    assert(MountRace.Mounts:FindFirstChild(v54.Mount) ~= nil, (("Racer %* has no mount model \"%*\""):format(v53, v54.Mount)))

    local Asset = v54.Asset

    assert(Assets.Directory[Asset] ~= nil, (("Unknown pet \"%*\""):format(Asset)))
end

for v59, v60 in RaceRally.Shop do
    local Validate = t14.Validate
    local Reward = v60.Reward
    local ok, result = pcall(Validate, Reward)

    assert(ok, (("Race shop offer %*: %*"):format(v59, result)))
end

for v62, v63 in RaceRally.Milestones do
    assert(#v63.Rewards > 0, (("Race milestone %* has no rewards"):format(v62)))

    for _, v66 in v63.Rewards do
        local Validate = t14.Validate
        local ok, result = pcall(Validate, v66)

        assert(ok, (("Race milestone %*: %*"):format(v62, result)))
    end
end

assert(#RaceRally.Repeat.Rewards > 0, "The race repeat reward has no rewards")

for _, v69 in RaceRally.Repeat.Rewards do
    local Validate = t14.Validate
    local ok, result = pcall(Validate, v69)

    assert(ok, (("Race repeat reward: %*"):format(result)))
end

return table.freeze(t14)
