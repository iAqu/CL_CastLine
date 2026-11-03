-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Lighting")
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local Stadium = script.Stadium
local v1 = Trove.new()
return {
	Start = function(p1) --[[ Start | Line: 15 | Upvalues: v1 (copy), Stadium (copy) ]]
		v1:Clone(Stadium).Parent = workspace
	end,
	Destroy = function(p1) --[[ Destroy | Line: 20 | Upvalues: v1 (copy) ]]
		v1:Clean()
	end
}