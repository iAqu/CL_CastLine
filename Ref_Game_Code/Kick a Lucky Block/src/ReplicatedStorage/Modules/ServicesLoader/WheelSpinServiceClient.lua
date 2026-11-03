-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = game:GetService("Players").LocalPlayer
require(ReplicatedStorage.Shared.Data.Attributes)
require(ReplicatedStorage.Shared.Data.Products)
local Network = require(ReplicatedStorage.Shared.Packages.Network)
local Signal = require(ReplicatedStorage.Shared.Packages.Signal)
local t = {
	Spins = 0,
	LastFreeSpin = 0,
	IsSpinning = false,
	SpinTheWheel = Signal.new(),
	SpinsChanged = Signal.new(),
	FreeSpinUPD = Signal.new()
}
function OnSpinsUpdate(p1) --[[ OnSpinsUpdate | Line: 33 | Upvalues: t (copy) ]]
	t.Spins = p1
	t.SpinsChanged:Fire(p1)
end
function OnSpinWheel(...) --[[ OnSpinWheel | Line: 38 | Upvalues: t (copy) ]]
	t.SpinTheWheel:Fire(...)
end
function t.RequestSpin(p1) --[[ RequestSpin | Line: 44 | Upvalues: Network (copy), MarketplaceService (copy), LocalPlayer (copy) ]]
	if p1.Spins > 0 and not p1.IsSpinning then
		Network.FireServer("RequestSpin")
	elseif p1.Spins == 0 then
		MarketplaceService:PromptProductPurchase(LocalPlayer, 3571980179)
	end
end
function t._init() --[[ _init | Line: 52 | Upvalues: Network (copy) ]]
	Network.OnClientEvent("SpinWheel"):Connect(OnSpinWheel)
	Network.OnClientEvent("UpdateSpins"):Connect(OnSpinsUpdate)
end
return t