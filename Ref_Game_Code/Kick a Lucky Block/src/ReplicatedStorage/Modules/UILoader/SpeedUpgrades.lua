-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ClientBalanceService = require(ReplicatedStorage.Modules.ServicesLoader.ClientBalanceService)
local SpeedServiceClient = require(ReplicatedStorage.Modules.ServicesLoader.SpeedServiceClient)
local MessagesService = require(ReplicatedStorage.Modules.ServicesLoader.MessagesService)
require(ReplicatedStorage.Shared.Data.Types)
local SpeedData = require(ReplicatedStorage.Shared.Data.SpeedData)
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local InfiniteMath = require(ReplicatedStorage.Shared.Utility.InfiniteMath)
local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
local SpeedUpgrades = (PlayerGui:FindFirstChild("Frames") or PlayerGui:WaitForChild("Frames")).SpeedUpgrades
local v2 = Trove.new()
local t = {
	Affordable = {
		Background = Color3.fromRGB(14, 136, 0),
		Stroke = Color3.fromRGB(8, 70, 0),
		Gradient = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromHex("d4ff00")), ColorSequenceKeypoint.new(1, Color3.fromHex("57ff4e")) })
	},
	Unaffordable = {
		Background = Color3.fromRGB(80, 80, 80),
		Stroke = Color3.fromRGB(40, 40, 40),
		Gradient = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 100, 100)), ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 60, 60)) })
	}
}
local t2 = {}
function GetMaxCanBuy() --[[ GetMaxCanBuy | Line: 53 | Upvalues: ClientBalanceService (copy), InfiniteMath (copy), SpeedData (copy), SpeedServiceClient (copy) ]]
	local Balance = ClientBalanceService.Balance
	local sum = InfiniteMath.new(0)
	local count = 0
	while true do
		local v1 = SpeedData:GetCostForLevel(SpeedServiceClient.Level + count)
		if not (sum + v1 <= Balance) then
			break
		end
		count = count + 1
		sum = sum + v1
	end
	return count, sum
end
function ApplyButtonStyle(p1, p2) --[[ ApplyButtonStyle | Line: 71 | Upvalues: t (copy) ]]
	local v1 = p2 and t.Affordable or t.Unaffordable
	p1.BackgroundColor3 = v1.Background
	p1.UIStroke.Color = v1.Stroke
	p1.Color.UIGradient.Color = v1.Gradient
	p1.Color.Layout.UIGradient.Color = v1.Gradient
end
function StartConnections() --[[ StartConnections | Line: 80 | Upvalues: v2 (copy), SpeedUpgrades (copy), InfiniteMath (copy), ClientBalanceService (copy), SpeedData (copy), SpeedServiceClient (copy), MessagesService (copy) ]]
	v2:Clean()
	local ButtonsFrame = SpeedUpgrades.ScrollingFrame["+1 Speed"].ButtonsFrame
	local list = {
		{
			Added = 1,
			Button = ButtonsFrame.One,
			Cost = InfiniteMath.new(0)
		},
		{
			Added = 1,
			Button = ButtonsFrame.Two,
			Cost = InfiniteMath.new(0)
		},
		{
			Added = 1,
			Button = ButtonsFrame.Three,
			Cost = InfiniteMath.new(0)
		}
	}
	local function UpdateMax() --[[ UpdateMax | Line: 104 | Upvalues: ClientBalanceService (ref), list (copy), SpeedData (ref), SpeedServiceClient (ref) ]]
		local v1 = GetMaxCanBuy(ClientBalanceService.Balance)
		local v2 = math.floor(v1 / 2)
		list[1].Button.Visible = true
		list[1].Added = 1
		list[1].Button.NameLabel.Text = "+1 Speed"
		list[1].Cost = SpeedData:GetCostForLevel(SpeedServiceClient.Level)
		list[1].Button.Label.Text = ("%*$"):format(list[1].Cost)
		ApplyButtonStyle(list[1].Button, v1 >= 1)
		if v1 == 0 then
			list[2].Button.Visible = false
			list[3].Button.Visible = false
		else
			local v5 = v2 > 1
			list[2].Button.Visible = v5
			if v5 then
				list[2].Added = v2
				list[2].Button.NameLabel.Text = "+" .. v2 .. " Speed"
				list[2].Cost = SpeedData:GetCostForRange(SpeedServiceClient.Level, SpeedServiceClient.Level + v2 - 1)
				list[2].Button.Label.Text = ("%*$"):format(list[2].Cost)
				ApplyButtonStyle(list[2].Button, true)
			end
			local v6 = if v2 < v1 then if v1 > 1 then true else false else false
			list[3].Button.Visible = v6
			if v6 then
				list[3].Added = v1
				list[3].Button.NameLabel.Text = "+" .. v1 .. " Speed"
				list[3].Cost = SpeedData:GetCostForRange(SpeedServiceClient.Level, SpeedServiceClient.Level + v1 - 1)
				list[3].Button.Label.Text = ("%*$"):format(list[3].Cost)
				ApplyButtonStyle(list[3].Button, true)
			end
		end
	end
	for i, v in ipairs(list) do
		v2:Add(v.Button.Activated:Connect(function() --[[ Line: 148 | Upvalues: v (copy), ClientBalanceService (ref), MessagesService (ref), SpeedServiceClient (ref) ]]
			if v.Cost then
				if v.Cost > ClientBalanceService.Balance then
					MessagesService:PlayMessage("Missing Cash", "Error")
				elseif v.Button.Visible and v.Added > 0 then
					SpeedServiceClient:RequestUpgrade(v.Added)
				end
			end
		end))
	end
	UpdateMax()
	v2:Add(ClientBalanceService.CoinsChanged:Connect(UpdateMax))
	v2:Add(SpeedServiceClient.LevelChanged:Connect(UpdateMax))
end
function Cleanup() --[[ Cleanup | Line: 170 | Upvalues: v2 (copy) ]]
	v2:Clean()
end
function VisibilityChanged() --[[ VisibilityChanged | Line: 174 | Upvalues: SpeedUpgrades (copy) ]]
	if SpeedUpgrades.Visible then
		StartConnections()
	else
		Cleanup()
	end
end
function InitFrame() --[[ InitFrame | Line: 183 | Upvalues: SpeedUpgrades (copy) ]]
	SpeedUpgrades:GetPropertyChangedSignal("Visible"):Connect(VisibilityChanged)
	SpeedUpgrades.Top.Main.Close.Activated:Connect(function() --[[ Line: 185 | Upvalues: SpeedUpgrades (ref) ]]
		SpeedUpgrades.Visible = false
	end)
end
function UpdateRunSpeed() --[[ UpdateRunSpeed | Line: 190 | Upvalues: SpeedData (copy), SpeedServiceClient (copy), SpeedUpgrades (copy) ]]
	SpeedUpgrades.ScrollingFrame["+1 Speed"].NameLabel.Text = ("Run Speed: %*"):format((SpeedData:GetSpeedFromLevel(SpeedServiceClient.Level)))
end
function t2.OpenFrame(p1) --[[ OpenFrame | Line: 197 | Upvalues: SpeedUpgrades (copy) ]]
	if not SpeedUpgrades.Visible then
		SpeedUpgrades.Visible = true
	end
end
function t2._init(p1) --[[ _init | Line: 205 | Upvalues: SpeedServiceClient (copy) ]]
	InitFrame()
	UpdateRunSpeed()
	SpeedServiceClient.LevelChanged:Connect(UpdateRunSpeed)
end
return t2