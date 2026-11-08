-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local FastFlags = require(game.ReplicatedStorage.UserGenerated.FastFlags)
local Parent = require(script.Parent)
local Warn = FastFlags.Replicated("UserGenerated.Logging.ClientLevel", Parent.AssertLevel, "Warn")

Parent.SetLevel(Warn:Get())
Warn.Changed:Connect(function(p1) -- line: 24
    -- upvalues: Parent (copy)
    Parent.SetLevel(p1)
end)
