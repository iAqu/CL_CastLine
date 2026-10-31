-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Networking = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "networking", "out").Networking

return {
    globalEvents = Networking.createEvent("shared/network@globalEvents"),
    globalFunctions = Networking.createFunction("shared/network@globalFunctions")
}
