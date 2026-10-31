-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))

RuntimeLib.import(script, script.Parent, "components", "charm-podium-component")

local Flamework = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Flamework

Flamework._addPaths({ { "StarterPlayer", "StarterPlayerScripts", "TS", "components" } })
Flamework._addPaths({ { "StarterPlayer", "StarterPlayerScripts", "TS", "controllers" } })
Flamework._addPaths({ { "StarterPlayer", "StarterPlayerScripts", "TS", "centurion-commands" } })
Flamework._addPaths({ { "ReplicatedStorage", "TS", "components" } })
Flamework.ignite()
