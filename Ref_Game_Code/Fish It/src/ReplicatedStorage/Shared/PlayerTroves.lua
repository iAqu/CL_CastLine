-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Players")
local Signal = require(ReplicatedStorage.Packages.Signal)
local Trove = require(ReplicatedStorage.Packages.Trove)
local PlayerEvents = require(ReplicatedStorage.Shared.PlayerEvents)
local v1 = Signal.new()
local t = {}
local t2 = {
	GetTrove = function(p1, p2) --[[ GetTrove | Line: 20 | Upvalues: t (copy), v1 (copy) ]]
		local v12 = t[p2]
		if not v12 then
			repeat
				v1:Wait()
			until t[p2] ~= nil
			v12 = t[p2]
		end
		return v12
	end,
	GetPlayerTroves = function(p1) --[[ GetPlayerTroves | Line: 32 | Upvalues: t (copy) ]]
		return t
	end
}
PlayerEvents:PlayerAdded(function(p1) --[[ Line: 38 | Upvalues: Trove (copy), t (copy), v1 (copy) ]]
	t[p1] = Trove.new()
	v1:Fire(p1)
end)
PlayerEvents:PlayerRemoving(function(p1) --[[ Line: 45 | Upvalues: t (copy) ]]
	local v1 = t[p1]
	if not v1 then
		return
	end
	v1:Destroy()
end)
return t2