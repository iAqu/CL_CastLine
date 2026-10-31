-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    qteVariant = "superBoss",
    randomScreenPromptPositions = true
}
local v1 = table.clone(t1)

setmetatable(v1, nil)
v1.difficultyMultiplier = 1.18
v1.multiTapProgressMultiplier = 0.38
v1.randomPromptScreenInsetScale = 0.2
v1.slidePromptsEnabled = true

local v2 = table.clone(t1)

setmetatable(v2, nil)
v2.difficultyMultiplier = 1.24
v2.multiTapProgressMultiplier = 0.34
v2.randomPromptScreenInsetScale = 0.055
v2.slidePromptsEnabled = true

local v3 = table.clone(t1)

setmetatable(v3, nil)
v3.difficultyMultiplier = 1.24
v3.multiTapProgressMultiplier = 0.34
v3.randomPromptScreenInsetScale = 0.055
v3.slidePromptsEnabled = false

local v4 = table.clone(v3)

setmetatable(v4, nil)
v4.difficultyMultiplier = 1.16
v4.multiTapProgressMultiplier = 0.28

return {
    resolveFrostwyrmStoneSkillCheckTuning = function(p1, p2) -- resolveFrostwyrmStoneSkillCheckTuning | line: 33
        -- upvalues: v1 (copy), v2 (copy), v3 (copy)
        if p1 then
            return v3
        end

        if p2 then
            return v2
        end

        return v1
    end,
    frostwyrmStoneDesktopSkillCheckTuning = v1,
    frostwyrmStoneMobileSkillCheckTuning = v2,
    frostwyrmStoneGamepadSkillCheckTuning = v3,
    frostwyrmWildGamepadSkillCheckTuning = v4
}
