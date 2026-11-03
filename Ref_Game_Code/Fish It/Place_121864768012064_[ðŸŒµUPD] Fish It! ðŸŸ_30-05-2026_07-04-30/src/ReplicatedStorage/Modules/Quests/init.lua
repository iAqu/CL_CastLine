-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Loader = require(ReplicatedStorage.Packages.Loader)
require(ReplicatedStorage.Shared.RewardInfo)
return {
	Mainline = Loader.LoadChildren(script.Mainline),
	Event = Loader.LoadChildren(script.Event)
}