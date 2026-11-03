-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(ReplicatedStorage.Shared.Packages.Signal)
local Network = require(ReplicatedStorage.Shared.Packages.Network)
local KickData = require(ReplicatedStorage.Shared.Data.KickData)
local t = {
	Level = 0,
	MaxDistance = KickData.BASE_DISTANCE,
	Multipliers = {
		Speed = 1,
		Power = 1
	},
	EndTimes = {
		Speed = nil,
		Power = nil
	},
	LevelChanged = Signal.new(),
	DistanceChanged = Signal.new(),
	MultiplierChanged = Signal.new()
}
function OnKickLevelUpdate(p1) --[[ OnKickLevelUpdate | Line: 31 | Upvalues: t (copy), KickData (copy) ]]
	if p1 ~= t.Level then
		t.Level = p1
		t.LevelChanged:Fire(p1)
		local v1 = KickData:GetDistanceFromLevel(p1)
		t.MaxDistance = v1
		t.DistanceChanged:Fire(v1)
	end
end
function OnMultiUpdate(p1, p2) --[[ OnMultiUpdate | Line: 44 | Upvalues: t (copy) ]]
	t.Multipliers = p1
	t.EndTimes = if p2 then p2 else {}
	t.MultiplierChanged:Fire()
end
function t._init() --[[ _init | Line: 51 | Upvalues: Network (copy) ]]
	Network.OnClientEvent("KickData"):Connect(OnKickLevelUpdate)
	Network.OnClientEvent("KickMulti"):Connect(OnMultiUpdate)
end
return t