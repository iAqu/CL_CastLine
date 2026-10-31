-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local playClonedSound = RuntimeLib.import(script, script.Parent.Parent.Parent, "vfx").playClonedSound
local default = RuntimeLib.import(script, script.Parent, "reward-screen").default

return {
    default = function(p1) -- ExclusiveRewardScreen | line: 7
        -- upvalues: react (copy), playClonedSound (copy), default (copy)
        return react.createElement(default, {
            circularRewardRay = true,
            exclusiveRewardEffects = true,
            iconImage = p1.iconImage,
            onFinished = p1.onFinished,
            onReveal = function() -- onReveal | line: 13
                -- upvalues: playClonedSound (copy)
                return playClonedSound("AuraReveal")
            end,
            rewardText = p1.rewardText,
            title = p1.title,
            uiScale = p1.uiScale,
            zIndex = p1.zIndex
        })
    end
}
