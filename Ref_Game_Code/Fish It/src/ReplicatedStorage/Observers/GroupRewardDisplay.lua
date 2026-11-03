-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Replion = require(ReplicatedStorage.Packages.Replion)
local Observers = require(ReplicatedStorage.Packages.Observers)
local v1 = Replion.Client:WaitReplion("Data")
Observers.observeTag("GroupRewardDisplay", function(p1) --[[ Line: 14 | Upvalues: v1 (copy) ]]
	local v12 = nil
	if v1:GetExpect("GroupReward") then
		p1:Destroy()
	else
		v12 = v1:OnChange("GroupReward", function(p12) --[[ Line: 21 | Upvalues: v12 (ref), p1 (copy) ]]
			if not p12 then
				return
			end
			v12:Disconnect()
			p1:Destroy()
		end)
	end
	return function() --[[ Line: 29 | Upvalues: v12 (ref) ]]
		if not (v12 and v12.Connected) then
			return
		end
		v12:Disconnect()
	end
end)
return {}