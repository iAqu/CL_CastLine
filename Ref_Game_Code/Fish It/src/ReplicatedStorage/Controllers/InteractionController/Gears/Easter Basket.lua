-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Packages.Net)
require(ReplicatedStorage.Packages.Replion)
require(ReplicatedStorage.Shared.Soundbook)
require(ReplicatedStorage.Modules.Util.TweenUtil)
require(ReplicatedStorage.Controllers.TextNotificationController)
local LocalPlayer = Players.LocalPlayer
Instance.new("Animation").AnimationId = "rbxassetid://91009047037016"
return {
	OnActivate = function() --[[ OnActivate | Line: 27 ]] end,
	OnEquip = function() --[[ OnEquip | Line: 31 ]] end,
	OnUnequip = function() --[[ OnUnequip | Line: 79 ]] end
}