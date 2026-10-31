-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local tutorialSteps = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "tutorial-utils").tutorialSteps

return {
    isAutoPromptBlocked = function(p1, p2, p3) -- isAutoPromptBlocked | line: 11
        -- upvalues: tutorialSteps (copy)
        if not (p1 < tutorialSteps.completed) and p2 == "none" then
            return not not p3
        end

        return true
    end
}
