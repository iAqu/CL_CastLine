-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Rarity = require(ReplicatedStorage.Data.Rarity)

local function makeAnimation(p1) -- line: 6
    local Animation = Instance.new("Animation")

    Animation.AnimationId = p1

    return Animation
end

local freeze = table.freeze
local t1 = {
    _id = "RazorFang",
    DisplayName = "RazorFang",
    Icon = "rbxassetid://102849850756685",
    EarningRate = 3.5E+08,
    IndexSpeedReward = 9E+07,
    DropWeight = 0,
    VisualOdds = 135.13513513513513,
    ModelWeight = 12000,
    BaseModelScale = 1,
    LimitedEggViewportScale = 1,
    LimitedEggViewportVerticalOffset = 0,
    AlbinosColorFullWhite = true,
    Egg = table.freeze({
        DisplayName = "RazorFang Egg",
        Icon = "rbxassetid://78651457785123",
        ModelName = "RazorFang",
        GrowthTime = 12600,
        WeightKg = 5
    })
}
local freeze2 = table.freeze
local t2 = {}
local Animation = Instance.new("Animation")

Animation.AnimationId = "rbxassetid://136791371854597"
t2.Idle = Animation

local Animation2 = Instance.new("Animation")

Animation2.AnimationId = "rbxassetid://103039030085527"
t2.Walk = Animation2
t1.Animations = freeze2(t2)
t1.Rarity = Rarity.Rarities.Secret
t1.BaseModelColor = Color3.fromRGB(85, 78, 76)
t1.PossibleModelColors = table.freeze({
    table.freeze({
        Color3.fromRGB(85, 78, 76),
        80
    }),
    table.freeze({
        Color3.fromRGB(104, 87, 75),
        19
    }),
    table.freeze({
        Color3.fromRGB(255, 255, 255),
        1
    })
})

return freeze(t1)
