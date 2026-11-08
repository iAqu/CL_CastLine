-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Rarity = require(ReplicatedStorage.Data.Rarity)
local Configs = script.Parent.Configs

local function makeAnimation(p1) -- line: 21
    local Animation = Instance.new("Animation")

    local function setAnimationId() -- line: 23
        -- upvalues: p1 (copy), Animation (copy)
        Animation.AnimationId = p1
    end

    if not pcall(setAnimationId) then
        warn((("Animation %* is not shared with this experience"):format(p1)))
    end

    return Animation
end

local function borrowAnimations(p2) -- line: 31
    -- upvalues: makeAnimation (copy)
    local Animations = p2.Animations

    if Animations == nil then
        return nil
    end

    return table.freeze({
        Idle = if Animations.Idle then makeAnimation(Animations.Idle.AnimationId) else nil,
        Walk = if Animations.Walk then makeAnimation(Animations.Walk.AnimationId) else nil,
        TransitionFadeDuration = Animations.TransitionFadeDuration
    })
end

local t2 = {
    FromTemplate = function(p3, p4) -- FromTemplate | line: 45
        -- upvalues: Rarity (copy), Configs (copy), borrowAnimations (copy)
        local v1 = Configs:FindFirstChild(p3)

        assert(v1 ~= nil, (("No asset config named \"%*\" to borrow placeholder art from"):format(p3)))

        local v4 = require(v1)
        local v5 = Rarity.Rarities[p4.Rarity]

        assert(v5 ~= nil, (("Unknown rarity \"%*\" on %*"):format(p4.Rarity, p4._id)))

        return table.freeze({
            WhiteImage = nil,
            MutationIcons = nil,
            DropWeight = 0,
            LuckyBlockDropTable = nil,
            LuckyBlockDropTableType = nil,
            LuckyBlockLevelRange = nil,
            LuckyBlockOpenDuration = nil,
            DontRoll = nil,
            CannotFuse = nil,
            GenderLocked = nil,
            AlbinosColorFullWhite = nil,
            _id = p4._id,
            DisplayName = p4.DisplayName,
            Icon = v4.Icon,
            Egg = table.freeze({
                DisplayName = ("%* Egg"):format(p4.DisplayName),
                Icon = v4.Egg.Icon,
                GrowthTime = v4.Egg.GrowthTime,
                WeightKg = v4.Egg.WeightKg,
                HideRarity = v4.Egg.HideRarity,
                IgnoreSizeGrowthMultiplier = v4.Egg.IgnoreSizeGrowthMultiplier
            }),
            EarningRate = p4.EarningRate,
            IndexSpeedReward = p4.IndexSpeedReward,
            VisualOdds = p4.VisualOdds,
            ModelWeight = v4.ModelWeight,
            Animations = borrowAnimations(v4),
            WalkAnimationReferenceSpeed = v4.WalkAnimationReferenceSpeed,
            Rarity = v5,
            BaseModelScale = v4.BaseModelScale,
            LimitedEggViewportScale = v4.LimitedEggViewportScale,
            LimitedEggViewportVerticalOffset = v4.LimitedEggViewportVerticalOffset,
            BaseModelColor = v4.BaseModelColor,
            PossibleModelColors = v4.PossibleModelColors,
            PlaceSound = v4.PlaceSound,
            WalkSound = v4.WalkSound,
            RandomIdleSound = v4.RandomIdleSound
        })
    end
}

return table.freeze(t2)
