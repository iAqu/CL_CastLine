-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observers = require(ReplicatedStorage.Packages.Observers)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
Observers.observeTag("ClickSound", function(p1) --[[ Line: 11 | Upvalues: Soundbook (copy) ]]
	local v1 = p1.Activated:Connect(function() --[[ Line: 12 | Upvalues: Soundbook (ref) ]]
		Soundbook.Sounds.ThickClick:Play()
	end)
	return function() --[[ Line: 16 | Upvalues: v1 (copy) ]]
		v1:Disconnect()
	end
end)
return {}