-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function playRareFishSfxCue(_, _) -- line: 24
end

local function impactSfxCueForRating(p3) -- line: 77
    if p3 == "perfect" then
        return "perfectImpact"
    end

    if p3 == "great" then
        return "greatImpact"
    end

    if p3 == "okay" then
        return "okayImpact"
    end

    return "missImpact"
end

local t1 = {
    great = "cyan/green expanding ring + medium flash",
    miss = "red slash / fish-escape splash pulse",
    okay = "small white/cyan ring",
    perfect = "gold/rainbow burst + star particles + strong flash"
}

return {
    playRareFishSfxCue = playRareFishSfxCue,
    impactSfxCueForRating = impactSfxCueForRating,
    describeRareFishFeedback = function(p4, p5) -- describeRareFishFeedback | line: 98
        -- upvalues: t1 (copy)
        local v1 = if p4 == "perfect" then "perfectImpact"
            elseif p4 == "great" then "greatImpact"
            elseif p4 == "okay" then "okayImpact"
            else "missImpact"

        return {
            sfxCue = v1,
            sfxDescription = ("play SFX cue \"%*\""):format(v1),
            vfxDescription = ("%* (action: %*)"):format(t1[p4], p5)
        }
    end
}
