-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(ReplicatedStorage.Shared.Packages.Signal)
local Network = require(ReplicatedStorage.Shared.Packages.Network)
local t = {
	AddedSlots = 0,
	MAX_SLOTS = 20,
	SlotsChanged = Signal.new()
}
function OnSlotsChanged(p1) --[[ OnSlotsChanged | Line: 21 | Upvalues: t (copy) ]]
	t.AddedSlots = p1
	t.SlotsChanged:Fire(p1)
end
function t.RequestUpgrade(p1) --[[ RequestUpgrade | Line: 28 | Upvalues: Network (copy) ]]
	if p1.AddedSlots ~= p1.MAX_SLOTS then
		Network.FireServer("bs_upgrade")
	end
end
function t._init() --[[ _init | Line: 38 | Upvalues: Network (copy) ]]
	Network.OnClientEvent("bs_updateClient"):Connect(OnSlotsChanged)
end
return t