-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Minigames = require(ReplicatedStorage.Shared.Modules.Minigames)

return function(p1) -- line: 5
    -- upvalues: Minigames (copy)
    p1:RegisterType("minigameName", p1.Cmdr.Util.MakeEnumType("Minigame", Minigames.Names))
end
