-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Rarity = require(ReplicatedStorage.Data.Rarity)
local HalloweenPets = require(ReplicatedStorage.Data.HalloweenPets)
local Dog = require(script.Parent.Configs.Dog)

local function animation(p1) -- line: 6
    if not p1 then
        return nil
    end

    local Animation = Instance.new("Animation")

    Animation.AnimationId = "rbxassetid://" .. p1

    return Animation
end

return function(p2) -- line: 10
    -- upvalues: Rarity (copy), HalloweenPets (copy), Dog (copy)
    local v3 = assert(HalloweenPets.Specs[p2], "Unknown Halloween pet " .. p2)
    local v4 = table.clone(Dog)

    v4._id = p2
    v4.DisplayName = v3.DisplayName
    v4.Icon = v3.Icon
    v4.WhiteImage = nil
    v4.MutationIcons = nil
    v4.Rarity = assert(Rarity.Rarities[v3.Rarity], "Missing Halloween rarity")
    v4.EarningRate = v3.EarningRate
    v4.IndexSpeedReward = 0
    v4.DropWeight = 0
    v4.VisualOdds = v3.Weight
    v4.ModelWeight = v3.ModelWeight or 80
    v4.BaseModelScale = 1
    v4.LimitedEggViewportScale = 1
    v4.LimitedEggViewportVerticalOffset = 0
    v4.BaseModelColor = Color3.new(1, 1, 1)
    v4.PossibleModelColors = table.freeze({
        table.freeze({
            Color3.new(1, 1, 1),
            1
        })
    })

    local freeze = table.freeze
    local Idle = v3.Idle
    local Animation

    if Idle then
        Animation = Instance.new("Animation")
        Animation.AnimationId = "rbxassetid://" .. Idle
    end

    local t1 = {}

    t1.Idle = Animation

    local Walk = v3.Walk
    local Animation2

    if Walk then
        Animation2 = Instance.new("Animation")
        Animation2.AnimationId = "rbxassetid://" .. Walk
    end

    t1.Walk = Animation2
    v4.Animations = freeze(t1)
    v4.WalkSound = nil
    v4.RandomIdleSound = nil
    v4.PlaceSound = nil
    v4.DontRoll = true
    v4.Egg = table.freeze({
        WeightKg = 80,
        DisplayName = if v3.Group == "World" then v3.DisplayName .. " Egg" else v3.EggModel,
        ModelName = v3.EggModel,
        Icon = "rbxassetid://" .. v3.EggIcon,
        GrowthTime = v3.GrowthTime,
        IgnoreSizeGrowthMultiplier = v3.Group ~= "World"
    })

    return table.freeze(v4)
end
