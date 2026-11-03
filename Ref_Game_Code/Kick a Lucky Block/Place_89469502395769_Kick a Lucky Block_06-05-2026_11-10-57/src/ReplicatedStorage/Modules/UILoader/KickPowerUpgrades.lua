-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local KickServiceClient = require(ReplicatedStorage.Modules.ServicesLoader.KickServiceClient)
local ClientBalanceService = require(ReplicatedStorage.Modules.ServicesLoader.ClientBalanceService)
local MessagesService = require(ReplicatedStorage.Modules.ServicesLoader.MessagesService)
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local KickData = require(ReplicatedStorage.Shared.Data.KickData)
local FormatInfNumber = require(ReplicatedStorage.Functional.FormatInfNumber)
local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
local KickUpgrades = (PlayerGui:FindFirstChild("Frames") or PlayerGui:WaitForChild("Frames")).KickUpgrades
local v2 = Trove.new()
local t = {
	[1] = {
		Cost = nil,
		NextLabel = KickUpgrades.ScrollingFrame["+1 Kick"].NextSpeed.SpeedLabel,
		CostLabel = KickUpgrades.ScrollingFrame["+1 Kick"].Button.Label,
		Button = KickUpgrades.ScrollingFrame["+1 Kick"].Button
	},
	[5] = {
		Cost = nil,
		NextLabel = KickUpgrades.ScrollingFrame["+5 Kick"].NextSpeed.SpeedLabel,
		CostLabel = KickUpgrades.ScrollingFrame["+5 Kick"].Button.Label,
		Button = KickUpgrades.ScrollingFrame["+5 Kick"].Button
	},
	[10] = {
		Cost = nil,
		NextLabel = KickUpgrades.ScrollingFrame["+10 Kick"].NextSpeed.SpeedLabel,
		CostLabel = KickUpgrades.ScrollingFrame["+10 Kick"].Button.Label,
		Button = KickUpgrades.ScrollingFrame["+10 Kick"].Button
	}
}
local t2 = { KickUpgrades.ScrollingFrame["+1 Kick"].CurrentSpeed.SpeedLabel, KickUpgrades.ScrollingFrame["+5 Kick"].CurrentSpeed.SpeedLabel, KickUpgrades.ScrollingFrame["+10 Kick"].CurrentSpeed.SpeedLabel }
local t3 = {}
function UpdatePrices(p1) --[[ UpdatePrices | Line: 50 | Upvalues: t (copy), KickData (copy), FormatInfNumber (copy) ]]
	for k, v in pairs(t) do
		local v1, v2, v3, v4, v5
		if k == 1 then
			v1 = KickData:GetCostForLevel(p1)
			v.Cost = v1
			v2 = KickData:GetDistanceFromLevel(p1 + k)
			v.NextLabel.Text = ("%* Power"):format(v2)
			v3 = v.CostLabel
			if v1.first == 0 then
				v4 = "Free"
				v3.Text = v4
			end
			v5 = ("$%*"):format((FormatInfNumber(v1)))
			v4 = v5
			v3.Text = v5
		end
		v1 = KickData:GetCostForRange(p1, p1 + k - 1)
		v.Cost = v1
		v2 = KickData:GetDistanceFromLevel(p1 + k)
		v.NextLabel.Text = ("%* Power"):format(v2)
		v3 = v.CostLabel
		if v1.first == 0 then
			v4 = "Free"
			v3.Text = v4
		end
		v5 = ("$%*"):format((FormatInfNumber(v1)))
		v3.Text = v5
	end
end
function UpdateCurrentDistance(p1) --[[ UpdateCurrentDistance | Line: 67 | Upvalues: KickData (copy), t2 (copy) ]]
	local v1 = KickData:GetDistanceFromLevel(p1)
	for i, v in ipairs(t2) do
		v.Text = ("%* Power"):format(v1)
	end
end
function OnKickUpdate() --[[ OnKickUpdate | Line: 74 | Upvalues: KickServiceClient (copy) ]]
	local Level = KickServiceClient.Level
	UpdateCurrentDistance(Level)
	UpdatePrices(Level)
end
function InitializeButtons() --[[ InitializeButtons | Line: 80 | Upvalues: KickUpgrades (copy), t (copy), ClientBalanceService (copy), KickServiceClient (copy), MessagesService (copy) ]]
	KickUpgrades.Top.Main.Close.Activated:Connect(function() --[[ Line: 81 | Upvalues: KickUpgrades (ref) ]]
		KickUpgrades.Visible = false
	end)
	for k, v in pairs(t) do
		v.Button.Activated:Connect(function() --[[ Line: 86 | Upvalues: ClientBalanceService (ref), v (copy), KickServiceClient (ref), k (copy), MessagesService (ref) ]]
			if ClientBalanceService.Balance >= v.Cost then
				KickServiceClient:RequestUpgrade(k)
			else
				MessagesService:PlayMessage("Insufficient cash", "Error")
			end
		end)
	end
end
function OnVisibleChanged() --[[ OnVisibleChanged | Line: 96 | Upvalues: KickUpgrades (copy), v2 (copy), KickServiceClient (copy) ]]
	if KickUpgrades.Visible then
		OnKickUpdate()
		v2:Connect(KickServiceClient.DistanceChanged, OnKickUpdate)
	else
		v2:Clean()
	end
end
function t3.OpenFrame(p1) --[[ OpenFrame | Line: 105 | Upvalues: KickUpgrades (copy) ]]
	KickUpgrades.Visible = true
end
function t3._init() --[[ _init | Line: 109 | Upvalues: KickUpgrades (copy) ]]
	InitializeButtons()
	KickUpgrades:GetPropertyChangedSignal("Visible"):Connect(OnVisibleChanged)
end
return t3