-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "money-fly-atom")
local moneyHudFrozenAtom, pushMoneyBurst = v1.moneyHudFrozenAtom, v1.pushMoneyBurst
local v2 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "playtime-spin-wheel-reward-atom")
local clearPlaytimeSpinWheelRewardReveal, playtimeSpinWheelRewardRevealAtom = v2.clearPlaytimeSpinWheelRewardReveal, v2.playtimeSpinWheelRewardRevealAtom
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "reward-screen").default
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local useSound = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-sound").useSound

return {
    default = function() -- PlaytimeSpinWheelRewardRevealManager | line: 17
        -- upvalues: react (copy), useEffect (copy), useState (copy), subscribe (copy), moneyHudFrozenAtom (copy), pushMoneyBurst (copy), clearPlaytimeSpinWheelRewardReveal (copy), playtimeSpinWheelRewardRevealAtom (copy), default (copy), useScreenSizeState (copy), useSound (copy)
        local v3 = useScreenSizeState()
        local v4 = v3 == "sm" or v3 == "md"
        local playSound = useSound("SkillCheckSuccess").playSound
        local v5, v6 = useState(playtimeSpinWheelRewardRevealAtom())

        useEffect(function() -- line: 23
            -- upvalues: v6 (copy), subscribe (copy), playtimeSpinWheelRewardRevealAtom (copy)
            return subscribe(playtimeSpinWheelRewardRevealAtom, function(p1) -- line: 24
                -- upvalues: v6 (copy)
                return v6(p1)
            end)
        end, {})

        if v5 == nil then
            return nil
        end

        return react.createElement(default, {
            zIndex = 200,
            iconImage = v5.iconImage,
            key = v5.id,
            onFinished = function() -- onFinished | line: 34
                -- upvalues: v5 (copy), clearPlaytimeSpinWheelRewardReveal (copy)
                return clearPlaytimeSpinWheelRewardReveal(v5.id)
            end,
            onReveal = function() -- onReveal | line: 37
                -- upvalues: playSound (copy), v5 (copy), moneyHudFrozenAtom (copy), pushMoneyBurst (copy)
                playSound()
                moneyHudFrozenAtom(false)

                if v5.cashAmount ~= nil and v5.cashAmount > 0 then
                    pushMoneyBurst(v5.cashAmount)
                end
            end,
            rewardText = v5.rewardText,
            showIcon = v5.showIcon,
            timeSkipReward = v5.timeSkipReward,
            title = v5.title,
            titleReward = v5.titleReward,
            uiScale = v4 and 0.78 or 1
        })
    end
}
