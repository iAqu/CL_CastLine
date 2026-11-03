-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EntitiesData = require(ReplicatedStorage.Shared.Data.EntitiesData)
local MutationData = require(ReplicatedStorage.Shared.Data.MutationData)
local Signal = require(ReplicatedStorage.Shared.Packages.Signal)
local Network = require(ReplicatedStorage.Shared.Packages.Network)
local t = {
	List = {},
	Mobs = {},
	IndexChanged = Signal.new()
}
function OnUpdate(p1, p2) --[[ OnUpdate | Line: 18 | Upvalues: t (copy) ]]
	if typeof(p1) == "table" then
		for k, v in pairs(p1) do
			t.Mobs[k] = v
		end
	else
		if typeof(p1) ~= "string" then
			t.IndexChanged:Fire()
			return
		end
		table.insert(t.Mobs[p2], p1)
	end
	t.IndexChanged:Fire()
end
function LoadList() --[[ LoadList | Line: 29 | Upvalues: EntitiesData (copy), t (copy), MutationData (copy) ]]
	for k, v in pairs(EntitiesData.Brainrots) do
		if v.CPS then
			table.insert(t.List, k)
		end
	end
	table.sort(t.List, function(p1, p2) --[[ Line: 38 | Upvalues: EntitiesData (ref) ]]
		return EntitiesData.Brainrots[p1].CPS < EntitiesData.Brainrots[p2].CPS
	end)
	for i, v in ipairs(MutationData.ValidMutations) do
		t.Mobs[v] = {}
	end
	t.Mobs.None = {}
end
function t._init(p1) --[[ _init | Line: 50 | Upvalues: Network (copy) ]]
	LoadList()
	Network.OnClientEvent("IndexUpdate"):Connect(OnUpdate)
end
return t