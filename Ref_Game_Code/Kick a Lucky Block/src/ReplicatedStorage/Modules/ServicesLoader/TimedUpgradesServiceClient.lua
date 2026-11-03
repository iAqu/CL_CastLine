-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Network = require(ReplicatedStorage.Shared.Packages.Network)
local t = {
	Multipliers = {},
	NewTable = require(ReplicatedStorage.Shared.Packages.Signal).new()
}
function FixTable(p1) --[[ FixTable | Line: 15 ]]
	local t = {}
	for k, v in pairs(p1) do
		t[k] = {}
		for k2, v2 in pairs(v) do
			t[k][tonumber(k2)] = v2
		end
	end
	return t
end
function OnUpdate(p1) --[[ OnUpdate | Line: 28 | Upvalues: t (copy) ]]
	local v1 = FixTable(p1)
	t.Multipliers = v1
	t.NewTable:Fire(v1)
end
function t.GetMultiplierForType(p1, p2) --[[ GetMultiplierForType | Line: 37 ]]
	local v1 = 1
	if p1.Multipliers[p2] then
		for k in pairs(p1.Multipliers[p2]) do
			if typeof(k) == "number" then
				v1 = math.max(v1 * (k / 100), 1)
			end
		end
	end
	return v1
end
function t._init() --[[ _init | Line: 51 | Upvalues: Network (copy) ]]
	Network.OnClientEvent("TU_upd"):Connect(OnUpdate)
end
return t