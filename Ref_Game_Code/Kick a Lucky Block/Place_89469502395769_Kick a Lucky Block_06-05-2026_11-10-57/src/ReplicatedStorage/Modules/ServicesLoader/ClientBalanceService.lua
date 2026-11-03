-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InfiniteMath = require(ReplicatedStorage.Shared.Utility.InfiniteMath)
local Network = require(ReplicatedStorage.Shared.Packages.Network)
local Signal = require(ReplicatedStorage.Shared.Packages.Signal)
require(ReplicatedStorage.Shared.Data.Types)
local t = {
	Multiplier = 1,
	EndTime = nil,
	MultiplierChanged = Signal.new()
}
t.Balance = InfiniteMath.new(0) or 0
t.CoinsChanged = Signal.new()
function Infinite_UpdateCoins(p1) --[[ Infinite_UpdateCoins | Line: 26 | Upvalues: t (copy), InfiniteMath (copy) ]]
	t.Balance = InfiniteMath.new(p1)
end
function Number_UpdateCoins(p1) --[[ Number_UpdateCoins | Line: 30 | Upvalues: t (copy) ]]
	t.Balance = p1
end
function OnMultiUpdate(p1, p2) --[[ OnMultiUpdate | Line: 34 | Upvalues: t (copy) ]]
	t.Multiplier = p1
	t.EndTime = p2
	t.MultiplierChanged:Fire()
end
function OnCoinsChanged(p1) --[[ OnCoinsChanged | Line: 40 | Upvalues: t (copy) ]]
	Infinite_UpdateCoins(p1)
	t.CoinsChanged:Fire(p1)
end
function t._init() --[[ _init | Line: 49 | Upvalues: Network (copy) ]]
	Network.OnClientEvent("CoinsChanged"):Connect(OnCoinsChanged)
	Network.OnClientEvent("CoinsMulti"):Connect(OnMultiUpdate)
end
return t