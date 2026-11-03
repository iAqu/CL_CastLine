-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Network = require(ReplicatedStorage.Shared.Packages.Network)
local Signal = require(ReplicatedStorage.Shared.Packages.Signal)
local t = {
	Equipped = "Wooden Stick",
	Owned = {},
	Multipliers = {
		Speed = 1,
		Weight = 1
	},
	EndTimes = {
		Speed = nil,
		Weight = nil
	},
	Changed = Signal.new(),
	MultiplierChanged = Signal.new()
}
function OnUpdate(p1, p2) --[[ OnUpdate | Line: 30 | Upvalues: t (copy) ]]
	t.Equipped = p1
	t.Owned = p2
	t.Changed:Fire(p1, p2)
end
function OnMultiplierUpdate(p1, p2) --[[ OnMultiplierUpdate | Line: 36 | Upvalues: t (copy) ]]
	t.Multipliers = p1
	t.EndTimes = if p2 then p2 else {}
	t.MultiplierChanged:Fire()
end
function t._init(p1) --[[ _init | Line: 44 | Upvalues: Network (copy) ]]
	Network.OnClientEvent("Weight_Update"):Connect(OnUpdate)
	Network.OnClientEvent("Weight_Multi"):Connect(OnMultiplierUpdate)
end
return t