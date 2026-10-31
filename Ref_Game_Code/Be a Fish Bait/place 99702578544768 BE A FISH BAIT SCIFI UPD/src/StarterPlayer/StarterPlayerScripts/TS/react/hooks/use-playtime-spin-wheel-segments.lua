-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local playtimeSpinWheelSegments = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "playtime-spin-wheel-config").playtimeSpinWheelSegments

return {
    usePlaytimeSpinWheelSegments = function() -- usePlaytimeSpinWheelSegments | line: 11
        -- upvalues: playtimeSpinWheelSegments (copy)
        return playtimeSpinWheelSegments
    end
}
