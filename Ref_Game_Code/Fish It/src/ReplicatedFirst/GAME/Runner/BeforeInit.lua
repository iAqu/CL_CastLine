-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
require(ReplicatedStorage.Modules.Animations)
return function() --[[ BeforeInit | Line: 10 ]]
	if not game:IsLoaded() then
		game.Loaded:Wait()
	end
	if workspace:GetAttribute("GameLoaded") ~= nil then
		return
	end
	workspace:GetAttributeChangedSignal("GameLoaded"):Wait()
end