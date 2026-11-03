-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Network = require(ReplicatedStorage.Shared.Packages.Network)
local Signal = require(ReplicatedStorage.Shared.Packages.Signal)
local t = {
	OT_Products = {},
	CountBought = {},
	Stock = {},
	StockChanged = Signal.new(),
	OneTimeChanged = Signal.new(),
	CountBoughtChanged = Signal.new()
}
function FixToNumber(p1) --[[ FixToNumber | Line: 24 ]]
	local t = {}
	for k, v in pairs(p1) do
		if tonumber(k) then
			t[tonumber(k)] = v
		end
		t[k] = v
	end
	return t
end
function OnStockUpdate(p1) --[[ OnStockUpdate | Line: 38 | Upvalues: t (copy) ]]
	local v1 = FixToNumber(p1)
	t.Stock = v1
	t.StockChanged:Fire(v1)
end
function OnOneTimeUpdate(p1) --[[ OnOneTimeUpdate | Line: 44 | Upvalues: t (copy) ]]
	if p1 then
		local v1 = FixToNumber(p1)
		t.OT_Products = v1
		t.OneTimeChanged:Fire(v1)
	end
end
function OnCountUpdate(p1) --[[ OnCountUpdate | Line: 54 | Upvalues: t (copy) ]]
	if p1 then
		local v1 = FixToNumber(p1)
		t.CountBought = v1
		t.CountBoughtChanged:Fire(v1)
	end
end
function OnDataUpdate(p1, p2) --[[ OnDataUpdate | Line: 64 ]]
	OnOneTimeUpdate(p1)
	OnCountUpdate(p2)
end
function t._init() --[[ _init | Line: 71 | Upvalues: Network (copy) ]]
	Network.OnClientEvent("myMarket_data"):Connect(OnDataUpdate)
	Network.OnClientEvent("myMarket_stock"):Connect(OnStockUpdate)
end
return t