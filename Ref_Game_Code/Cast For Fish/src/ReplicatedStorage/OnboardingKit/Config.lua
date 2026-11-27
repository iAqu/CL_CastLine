-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    Enabled = true,
    SampleRate = 1,
    StoreName = "OnboardingLogs_v1",
    StudioStoreName = "OnboardingLogs_Studio",
    RecordInStudio = true,
    DryRunInStudio = true,
    Steps = {}
}

for _, v1 in require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("TutorialSteps")).List do
    table.insert(t1.Steps, v1.text)
end

t1.HintLabelPath = { "HUD", "TipBubble", "Instruction" }
t1.TargetAttribute = nil
t1.TutorialHighlightName = nil
t1.ReadProgress = nil
t1.ProgressPollSeconds = 2
t1.MaxSessionSeconds = 1800
t1.SecondsAfterTutorial = 20

return t1
