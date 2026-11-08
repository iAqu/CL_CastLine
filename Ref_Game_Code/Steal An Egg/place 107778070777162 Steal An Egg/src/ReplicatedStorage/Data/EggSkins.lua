-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local v1 = table.freeze({
    Biohazard = table.freeze({
        ModelName = "Biohazard Egg",
        Icon = "rbxassetid://103838374075457",
        DisplayName = "Biohazard Egg"
    }),
    Experimental = table.freeze({
        ModelName = "Experiment Egg",
        Icon = "rbxassetid://77124617553239",
        DisplayName = "Experiment Egg"
    }),
    UnstableDNA = table.freeze({
        ModelName = "Unstable",
        Icon = "rbxassetid://121178065227483",
        DisplayName = "Unstable Egg"
    }),
    LimitedExperiment = table.freeze({
        ModelName = "LimitedExperimentEgg",
        Icon = "",
        DisplayName = "Limited Experiment Egg"
    }),
    Riftborn = table.freeze({
        ModelName = "Riftborn Egg",
        Icon = "rbxassetid://136340085637939",
        DisplayName = "Riftborn Egg"
    }),
    Riftbeasts = table.freeze({
        ModelName = "Riftbeasts Egg",
        Icon = "rbxassetid://97679329738336",
        DisplayName = "Riftbeasts Egg"
    }),
    ShatteredRift = table.freeze({
        ModelName = "Shattered Rift Egg",
        Icon = "rbxassetid://85929412992561",
        DisplayName = "Shattered Rift Egg"
    })
})
local t1 = {
    Directory = v1
}

function t1.Get(p1) -- line: 48
    -- upvalues: v1 (copy)
    return if p1 ~= nil then v1[p1] else nil
end

return table.freeze(t1)
