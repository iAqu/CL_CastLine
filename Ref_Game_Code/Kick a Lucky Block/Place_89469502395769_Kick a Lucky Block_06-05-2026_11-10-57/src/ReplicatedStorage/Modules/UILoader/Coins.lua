-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ClientBalanceService = require(ReplicatedStorage.Modules.ServicesLoader.ClientBalanceService)
local SoundService = game:GetService("SoundService")
local InfiniteMath = require(ReplicatedStorage.Shared.Utility.InfiniteMath)
require(ReplicatedStorage.Shared.Packages.Network)
require(ReplicatedStorage.Shared.Packages.Signal)
local v1 = require("./UI_Labels")
require(ReplicatedStorage.Shared.Data.Types)
local InsideFrame = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("HUD").BottomLeft.CoinsFrame.InsideFrame
local FormatInfNumber = require(ReplicatedStorage.Functional.FormatInfNumber)
local t = {
	LastValue = nil
}
function UpdateUI(p1, p2) --[[ UpdateUI | Line: 36 | Upvalues: v1 (copy), InsideFrame (copy), FormatInfNumber (copy), t (copy), InfiniteMath (copy) ]]
	if p2 then
		v1.IncrementEffect(t.LastValue or InfiniteMath.new(0), p1, InsideFrame.CoinLabel, "$%s")
	else
		v1.UpdateLabel(InsideFrame.CoinLabel, ("$%s"):format(FormatInfNumber(p1)))
	end
end
function PlaySound(p1) --[[ PlaySound | Line: 45 | Upvalues: t (copy), SoundService (copy) ]]
	if t.LastValue then
		if t.LastValue < p1 then
			return
		end
		if not (p1 < t.LastValue) then
			return
		end
		SoundService.Effects.MoneyDown:Play()
	end
end
function OnCoinsChanged(p1) --[[ OnCoinsChanged | Line: 55 | Upvalues: InfiniteMath (copy), t (copy) ]]
	local v1 = InfiniteMath.new(p1)
	if t.Initialized then
		PlaySound(p1)
	end
	UpdateUI(v1, t.Initialized)
	t.LastValue = p1
	if not t.Initialized then
		t.Initialized = true
	end
end
function t._init() --[[ _init | Line: 70 | Upvalues: ClientBalanceService (copy) ]]
	OnCoinsChanged(ClientBalanceService.Balance)
	ClientBalanceService.CoinsChanged:Connect(OnCoinsChanged)
end
return t