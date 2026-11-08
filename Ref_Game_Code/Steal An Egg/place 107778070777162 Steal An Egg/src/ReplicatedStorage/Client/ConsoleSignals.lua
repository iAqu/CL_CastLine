-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Signal = require(game:GetService("ReplicatedStorage").Packages.Signal)
local t1 = {
    ButtonDown = Signal.new(),
    ButtonUp = Signal.new()
}

return table.freeze(t1)
