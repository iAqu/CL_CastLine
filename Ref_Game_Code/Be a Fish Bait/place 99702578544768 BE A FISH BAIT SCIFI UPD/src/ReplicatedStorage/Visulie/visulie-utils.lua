-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Visulie = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "Visulie", "Visulie")

return {
    playVisulie = function(p1, p2, p3) -- playVisulie | line: 4
        -- upvalues: Visulie (copy)
        Visulie.new(p1, p2, p3):PlayOnce()
    end
}
