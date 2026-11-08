-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

require(script.Parent.Types)

local t1 = {
    OnboardingQuestline = {
        ExperimentId = "OnboardingQuestline",
        ConfigKey = "onboarding_questline_variant",
        DefaultVariant = "Control",
        PayloadByVariant = {
            Control = {
                QuestlineEnabled = false
            },
            Questline = {
                QuestlineEnabled = true
            }
        }
    }
}

return {
    Ids = {
        OnboardingQuestline = "OnboardingQuestline"
    },
    Directory = t1,
    Lookup = function(p1) -- Lookup | line: 27
        -- upvalues: t1 (copy)
        return t1[p1]
    end
}
