-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LeaderboardData = require(ReplicatedStorage.Shared.Data.LeaderboardData)
require(ReplicatedStorage.Shared.Utility.InfiniteMath)
local Network = require(ReplicatedStorage.Shared.Packages.Network)
local t = {
	Config = {
		MAX_PLACEMENTS = 30
	},
	Placements = {},
	LeaderboardUpdated = require(ReplicatedStorage.Shared.Packages.Signal).new()
}
function ConvertAllValues(p1) --[[ ConvertAllValues | Line: 20 | Upvalues: LeaderboardData (copy) ]]
	for k, v in pairs(p1) do
		local v1 = LeaderboardData.ValueConvertions[k]
		if v1 then
			for i, v2 in ipairs(v) do
				v2.value = v1(v2.value)
			end
		end
	end
end
function OnUpdate(p1) --[[ OnUpdate | Line: 31 | Upvalues: t (copy) ]]
	ConvertAllValues(p1)
	t.Placements = p1
	t.LeaderboardUpdated:Fire(p1)
end
function t._init() --[[ _init | Line: 37 | Upvalues: Network (copy) ]]
	Network.OnClientEvent("LeaderboardUPD"):Connect(OnUpdate)
end
return t