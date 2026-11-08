-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = require(ReplicatedStorage.Data.Assets)
local EggSkins = require(ReplicatedStorage.Data.EggSkins)
local ScrambleTradeIn = require(ReplicatedStorage.Data.ScrambleTradeIn)
local v1 = table.freeze({
    Category = "Mecha Scrambler",
    Scale = 1
})
local v2 = table.freeze({
    Kind = "Banner",
    BannerId = "Biohazard",
    Mutated = false
})
local v3 = table.freeze({
    Kind = "Banner",
    BannerId = "Biohazard",
    Mutated = true
})
local v4 = table.freeze({
    Kind = "Banner",
    BannerId = "Experimental",
    Mutated = false
})
local v5 = table.freeze({
    Kind = "Banner",
    BannerId = "Experimental",
    Mutated = true
})
local v6 = table.freeze({
    Kind = "Banner",
    BannerId = "UnstableDNA",
    Mutated = false
})
local v7 = table.freeze({
    Kind = "Banner",
    BannerId = "UnstableDNA",
    Mutated = true
})
local v8 = table.freeze({
    Kind = "RandomBanner",
    Mutated = true
})
local v9 = table.freeze({
    Kind = "Pet",
    Category = "Eye Bat",
    Scale = 1
})
local v10 = table.freeze({
    Kind = "Pet",
    Category = "Citadel Snail",
    Scale = 1
})
local v11 = table.freeze({
    Kind = "Pet",
    Category = "Uncoiled Armadillo",
    Scale = 1
})
local v12 = table.freeze({
    Kind = "Pet",
    Category = "Mecha Chompa",
    Scale = 1
})
local v13 = table.freeze({
    Kind = "Pet",
    Category = "Pink Dragon Experiment",
    Scale = 1
})
local v14 = table.freeze({
    table.freeze({
        Id = "Scramble1",
        Kills = 1,
        Reward = v2
    }),
    table.freeze({
        Id = "Scramble3",
        Kills = 3,
        Reward = v4
    }),
    table.freeze({
        Id = "Scramble5",
        Kills = 5,
        Reward = v3
    }),
    table.freeze({
        Id = "Scramble7",
        Kills = 7,
        Reward = v6
    }),
    table.freeze({
        Id = "Scramble10",
        Kills = 10,
        Reward = v9
    }),
    table.freeze({
        Id = "Scramble13",
        Kills = 13,
        Reward = v2
    }),
    table.freeze({
        Id = "Scramble15",
        Kills = 15,
        Reward = v3
    }),
    table.freeze({
        Id = "Scramble18",
        Kills = 18,
        Reward = v5
    }),
    table.freeze({
        Id = "Scramble21",
        Kills = 21,
        Reward = v6
    }),
    table.freeze({
        Id = "Scramble25",
        Kills = 25,
        Reward = v10
    }),
    table.freeze({
        Id = "Scramble30",
        Kills = 30,
        Reward = v2
    }),
    table.freeze({
        Id = "Scramble35",
        Kills = 35,
        Reward = v3
    }),
    table.freeze({
        Id = "Scramble40",
        Kills = 40,
        Reward = v7
    }),
    table.freeze({
        Id = "Scramble45",
        Kills = 45,
        Reward = v3
    }),
    table.freeze({
        Id = "Scramble50",
        Kills = 50,
        Reward = v11
    }),
    table.freeze({
        Id = "Scramble57",
        Kills = 57,
        Reward = v5
    }),
    table.freeze({
        Id = "Scramble64",
        Kills = 64,
        Reward = v5
    }),
    table.freeze({
        Id = "Scramble70",
        Kills = 70,
        Reward = v6
    }),
    table.freeze({
        Id = "Scramble75",
        Kills = 75,
        Reward = v12
    }),
    table.freeze({
        Id = "Scramble82",
        Kills = 82,
        Reward = v3
    }),
    table.freeze({
        Id = "Scramble90",
        Kills = 90,
        Reward = v7
    }),
    table.freeze({
        Id = "Scramble100",
        Kills = 100,
        Reward = v13
    })
})

local function petConfig(p1) -- line: 85
    -- upvalues: Assets (copy)
    local v17 = assert(Assets.Directory[p1], (("Unknown Scramble mastery egg %*"):format(p1)))

    assert(type(v17.Egg.Icon) == "string", (("%* has no egg icon"):format(p1)))
    assert(type(v17.Egg.DisplayName) == "string", (("%* has no egg name"):format(p1)))

    return v17
end

local function bannerSkin(p2) -- line: 92
    -- upvalues: EggSkins (copy), ScrambleTradeIn (copy)
    local v24 = assert(ScrambleTradeIn.GetBannerEggSkin(p2), (("Unknown Scramble banner %*"):format(p2)))

    return assert(EggSkins.Get(v24), (("Scramble banner %* has no egg skin"):format(p2)))
end

local function validate(p3) -- line: 97
    -- upvalues: Assets (copy), EggSkins (copy), ScrambleTradeIn (copy)
    if p3.Kind == "Pet" then
        local Category = p3.Category
        local v29 = assert(Assets.Directory[Category], (("Unknown Scramble mastery egg %*"):format(Category)))

        assert(type(v29.Egg.Icon) == "string", (("%* has no egg icon"):format(Category)))
        assert(type(v29.Egg.DisplayName) == "string", (("%* has no egg name"):format(Category)))
    elseif p3.Kind == "Banner" then
        local BannerId = p3.BannerId
        local v36 = assert(ScrambleTradeIn.GetBannerEggSkin(BannerId), (("Unknown Scramble banner %*"):format(BannerId)))

        assert(EggSkins.Get(v36), (("Scramble banner %* has no egg skin"):format(BannerId)))
    else
        for _, v39 in ScrambleTradeIn.BannerIds() do
            local v42 = assert(ScrambleTradeIn.GetBannerEggSkin(v39), (("Unknown Scramble banner %*"):format(v39)))

            assert(EggSkins.Get(v42), (("Scramble banner %* has no egg skin"):format(v39)))
        end
    end
end

local function rollBannerId(p4) -- line: 110
    -- upvalues: ScrambleTradeIn (copy)
    local n1 = 0

    for _, v45 in ScrambleTradeIn.BannerIds() do
        n1 += math.max(ScrambleTradeIn.GetBannerWeight(v45), 0)
    end

    assert(n1 > 0, "Scramble banners have no weight")

    local v48 = ""
    local v49 = p4:NextNumber() * n1

    for _, v50 in ScrambleTradeIn.BannerIds() do
        local v51 = ScrambleTradeIn.GetBannerWeight(v50)

        if v51 > 0 then
            v49 -= v51

            if v49 <= 0 then
                return v50
            end

            v48 = v50
        end
    end

    return v48
end

local t1 = {
    Milestones = v14,
    InfiniteMilestoneId = "ScrambleInfinite",
    InfiniteEveryKills = 10,
    InfiniteReward = v8,
    BossDropEgg = v1
}

function t1.Roll(p5, p6) -- line: 143
    -- upvalues: ScrambleTradeIn (copy), rollBannerId (copy)
    if p5.Kind == "Pet" then
        return {
            Category = p5.Category,
            Scale = p5.Scale
        }
    end

    local v52 = if p5.Kind == "Banner" then p5.BannerId else rollBannerId(p6)

    return {
        Category = assert(ScrambleTradeIn.RollPet(v52, p6), (("Scramble banner %* has no pets"):format(v52))),
        Mutation = if p5.Mutated then "Scrambled" else nil,
        EggSkin = ScrambleTradeIn.GetBannerEggSkin(v52)
    }
end

function t1.GetMilestone(p7) -- line: 156
    -- upvalues: v14 (copy)
    for _, v55 in v14 do
        if v55.Id == p7 then
            return v55
        end
    end

    return nil
end

function t1.FinalMilestone() -- line: 165
    -- upvalues: v14 (copy)
    return v14[#v14]
end

function t1.ClaimableInfiniteCount(p8) -- line: 169
    -- upvalues: t1 (copy)
    local v56 = t1.FinalMilestone()

    if not p8.ClaimedMilestoneIds[v56.Id] then
        return 0
    end

    return (math.max(math.max((p8.Mastery - v56.Kills) // 10, 0) - p8.InfiniteRewardsClaimed, 0))
end

function t1.Presentation(p9) -- line: 178
    -- upvalues: Assets (copy), EggSkins (copy), ScrambleTradeIn (copy)
    if p9.Kind == "Pet" then
        local Category = p9.Category
        local v61 = assert(Assets.Directory[Category], (("Unknown Scramble mastery egg %*"):format(Category)))

        assert(type(v61.Egg.Icon) == "string", (("%* has no egg icon"):format(Category)))
        assert(type(v61.Egg.DisplayName) == "string", (("%* has no egg name"):format(Category)))

        return {
            Amount = "x1",
            Title = v61.DisplayName,
            Rarity = v61.Rarity.DisplayName,
            Icon = v61.Icon
        }
    end

    if p9.Kind == "Banner" then
        local BannerId = p9.BannerId
        local v68 = assert(ScrambleTradeIn.GetBannerEggSkin(BannerId), (("Unknown Scramble banner %*"):format(BannerId)))
        local v71 = assert(EggSkins.Get(v68), (("Scramble banner %* has no egg skin"):format(BannerId)))
        local v72 = if p9.Mutated then ("Scrambled %*"):format(v71.DisplayName) else v71.DisplayName

        return {
            Amount = "x1",
            Title = v72,
            Icon = v71.Icon,
            HoverTitle = string.upper(v72),
            HoverDescription = if p9.Mutated then ("Awards a random %* pet with the Scrambled mutation"):format(v71.DisplayName) else ("Awards a random %* pet"):format(v71.DisplayName)
        }
    end

    local t4 = {}

    for _, v73 in ScrambleTradeIn.BannerIds() do
        local v76 = assert(ScrambleTradeIn.GetBannerEggSkin(v73), (("Unknown Scramble banner %*"):format(v73)))

        table.insert(t4, assert(EggSkins.Get(v76), (("Scramble banner %* has no egg skin"):format(v73))).Icon)
    end

    local v79 = if p9.Mutated then "Random Scrambled Egg" else "Random Egg"

    return {
        Amount = "x1",
        Title = v79,
        Icon = t4[1],
        CycleIcons = t4,
        HoverTitle = string.upper(v79),
        HoverDescription = p9.Mutated and "Awards a random lab egg with the Scrambled mutation" or "Awards a random lab egg"
    }
end

for _, v80 in v14 do
    validate(v80.Reward)
end

validate(t1.InfiniteReward)

local Category = t1.BossDropEgg.Category
local v83 = assert(Assets.Directory[Category], (("Unknown Scramble mastery egg %*"):format(Category)))

assert(type(v83.Egg.Icon) == "string", (("%* has no egg icon"):format(Category)))
assert(type(v83.Egg.DisplayName) == "string", (("%* has no egg name"):format(Category)))

return table.freeze(t1)
