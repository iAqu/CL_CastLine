-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Replion = require(ReplicatedStorage.Packages.Replion)
local Net = require(ReplicatedStorage.Packages.Net)
require(ReplicatedStorage.Packages.Trove)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Events = require(ReplicatedStorage.Events)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local EventUtility = require(ReplicatedStorage.Shared.EventUtility)
local CoinProductsUtility = require(ReplicatedStorage.Modules.CoinProductsUtility)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local PromptController = require(ReplicatedStorage.Controllers.PromptController)
local v1 = Net:RemoteFunction("PurchaseWeatherEvent")
local v2 = nil
local v3 = nil
local PlayerGui = Players.LocalPlayer.PlayerGui
local v4 = PlayerGui:WaitForChild("!!! Weather Machine")
local PurchaseOptions = v4.Frame.PurchaseOptions
local Grid = v4.Frame.Frame.Right.Frame.Grid
local Grid_2 = v4.Frame.Frame.Left.Frame.Grid
local ActiveTile = Grid_2.ActiveTile
ActiveTile.Parent = nil
local SelectionTile = Grid.SelectionTile
SelectionTile.Parent = nil
local t = {}
local t2 = {}
local v5 = nil
local v6 = Signal.new()
local t3 = {}
function t3.Start(p1) --[[ Start | Line: 61 | Upvalues: v2 (ref), Replion (copy), v3 (ref), t3 (copy), GuiControl (copy), v4 (copy), v5 (ref), v6 (copy), PurchaseOptions (copy), EventUtility (copy), TextNotificationController (copy), CoinProductsUtility (copy), PromptController (copy), v1 (copy), Soundbook (copy), Events (copy) ]]
	v2 = Replion.Client:WaitReplion("Events")
	v3 = Replion.Client:WaitReplion("Data")
	v2:OnArrayInsert("WeatherMachine", function(p1, p2) --[[ Line: 66 | Upvalues: t3 (ref) ]]
		t3:AddActiveTile(p2)
		UpdateSlots()
	end)
	v2:OnArrayRemove("WeatherMachine", function(p1, p2) --[[ Line: 71 | Upvalues: t3 (ref) ]]
		t3:RemoveActiveTile(p2)
		UpdateSlots()
	end)
	local v12 = nil
	v12 = GuiControl.GuiFocusedSignal:Connect(function(p1) --[[ Line: 78 | Upvalues: v4 (ref), v12 (ref) ]]
		if p1 ~= v4 then
			return
		end
		v12:Disconnect()
		Populate()
	end)
	GuiControl.GuiUnfocusedSignal:Connect(function(p1) --[[ Line: 85 | Upvalues: v4 (ref), v5 (ref), v6 (ref) ]]
		if p1 ~= v4 then
			return
		end
		v5 = nil
		v6:Fire()
	end)
	v6:Connect(function(p1) --[[ Line: 93 ]]
		UpdateSelectionTiles()
		UpdatePurchaseOptions()
	end)
	GuiControl:Hook("Hold Button", PurchaseOptions.Buy).Clicked:Connect(function() --[[ Line: 99 | Upvalues: v5 (ref), EventUtility (ref), v2 (ref), TextNotificationController (ref), v3 (ref), CoinProductsUtility (ref), PromptController (ref), v1 (ref), Soundbook (ref) ]]
		local v12 = v5
		if not v12 then
			return
		end
		local v22 = EventUtility:GetEvent(v12)
		if not v22 then
			return
		end
		if not v22.WeatherMachinePrice then
			return
		end
		if v2:Find("Events", v12) then
			TextNotificationController:DeliverNotification({
				Type = "Text",
				Text = "Already active!",
				CustomDuration = 2,
				TextColor = {
					R = 255,
					G = 0,
					B = 0
				}
			})
			return
		end
		if v2:Find("WeatherMachine", v12) then
			TextNotificationController:DeliverNotification({
				Type = "Text",
				Text = "Event is in use!",
				CustomDuration = 2,
				TextColor = {
					R = 255,
					G = 0,
					B = 0
				}
			})
			return
		end
		local v32 = v3:GetExpect("Coins")
		if v32 < v22.WeatherMachinePrice then
			CoinProductsUtility:PurchaseBestCoinPack(v32, v22.WeatherMachinePrice)
			return
		end
		local _, v4 = PromptController:FirePrompt((GetPurchaseMessage(v22))):catch(warn):await()
		if v4 then
			if v1:InvokeServer(v12) then
				Soundbook.Sounds.StorePurchase:Play()
				Soundbook.Sounds.CoinsChanged:Play()
			end
		else
			TextNotificationController:DeliverNotification({
				Type = "Text",
				Text = "Not enough coins!",
				CustomDuration = 2,
				TextColor = {
					R = 255,
					G = 0,
					B = 0
				}
			})
		end
	end)
	for k, v in pairs(Events) do
		t3:AddSelectionTile(k)
	end
	UpdateSelectionTiles()
	UpdatePurchaseOptions()
end
function t3.AddSelectionTile(p1, p2) --[[ AddSelectionTile | Line: 173 | Upvalues: EventUtility (copy), TierUtility (copy), SelectionTile (copy), GuiControl (copy), v5 (ref), v6 (copy), PlayerGui (copy), Grid (copy), t2 (copy) ]]
	local v1 = EventUtility:GetEvent(p2)
	if not v1 then
		return
	end
	if not v1.WeatherMachine then
		return
	end
	if not v1.WeatherMachinePrice then
		return
	end
	local v2 = v1.Tier or 100
	local v3 = TierUtility:GetTier(v2)
	local v4 = SelectionTile:Clone()
	local v52 = v4.Content
	local Vector = v52.Vector
	GuiControl:Hook("Hold Button", v4).Clicked:Connect(function() --[[ Line: 194 | Upvalues: v5 (ref), p2 (copy), v6 (ref) ]]
		if v5 == p2 then
			v5 = nil
			v6:Fire()
		else
			v5 = p2
			v6:Fire(p2)
		end
	end)
	local v62 = PlayerGui.Events.Frame:FindFirstChild(p2, true)
	if v62 then
		local v7 = v62:Clone()
		v7.AnchorPoint = Vector.AnchorPoint
		v7.Position = Vector.Position
		v7.Visible = true
		v7.Parent = v52
		Vector.Visible = false
	else
		Vector.Image = v1.Icon
		Vector.Visible = true
	end
	v52.ItemName.Text = p2
	v52.ItemName.UIGradient.Color = v3.TierColor
	v4.LayoutOrder = v2
	v4.Parent = Grid
	t2[p2] = v4
end
function t3.AddActiveTile(p1, p2) --[[ AddActiveTile | Line: 227 | Upvalues: t (copy), EventUtility (copy), ActiveTile (copy), PlayerGui (copy), Grid_2 (copy) ]]
	if t[p2] then
		return
	end
	local v1 = EventUtility:GetEvent(p2)
	if not v1 then
		return
	end
	local v2 = ActiveTile:Clone()
	local v3 = v2.Content
	local Vector = v3.Vector
	local v4 = PlayerGui.Events.Frame:FindFirstChild(p2, true)
	if v4 then
		local v5 = v4:Clone()
		v5.AnchorPoint = Vector.AnchorPoint
		v5.Position = Vector.Position
		v5.Visible = true
		v5.Parent = v3
		Vector.Visible = false
	else
		Vector.Image = v1.Icon
		Vector.Visible = true
	end
	v3.ItemName.Text = v1.Name
	v2.Parent = Grid_2
	t[p2] = v2
end
function t3.RemoveActiveTile(p1, p2) --[[ RemoveActiveTile | Line: 261 | Upvalues: t (copy) ]]
	local v1 = t[p2]
	if not v1 then
		return
	end
	v1:Destroy()
	t[p2] = nil
end
function UpdatePurchaseOptions() --[[ UpdatePurchaseOptions | Line: 269 | Upvalues: v5 (ref), EventUtility (copy), TierUtility (copy), PurchaseOptions (copy), StringLibrary (copy) ]]
	local v1 = v5
	local v2 = if v1 then EventUtility:GetEvent(v1) else v1
	if v2 and (v2.WeatherMachine and v2.WeatherMachinePrice) then
		local v3 = TierUtility:GetTier(v2.Tier or 100)
		PurchaseOptions.Info.WeatherName.Text = ("%*:"):format(v2.Name)
		PurchaseOptions.Info.WeatherName.UIGradient.Color = v3.TierColor
		PurchaseOptions.Info.Description.Text = v2.Description
		PurchaseOptions.Buy.Counter.Text = StringLibrary:AddCommas(v2.WeatherMachinePrice)
		PurchaseOptions.Visible = true
	else
		PurchaseOptions.Visible = false
	end
end
function UpdateSlots() --[[ UpdateSlots | Line: 289 | Upvalues: v2 (ref), v4 (copy) ]]
	v4.Frame.Frame.Left.Label.Text = ("Available Slots (%*/%*)"):format(#v2:GetExpect("WeatherMachine"), 3)
end
function UpdateSelectionTiles() --[[ UpdateSelectionTiles | Line: 296 | Upvalues: v5 (ref), t2 (copy) ]]
	local v1 = v5
	for v2, v3 in t2 do
		local v4 = v3:FindFirstChildWhichIsA("UIStroke")
		if v4 then
			v4.Enabled = v2 == v1
		end
	end
end
function GetPurchaseMessage(p1) --[[ GetPurchaseMessage | Line: 307 | Upvalues: TierUtility (copy), StringLibrary (copy) ]]
	if not p1.WeatherMachinePrice then
		error("Unable to prompt this purchase!")
	end
	local v1 = TierUtility:GetTier(p1.Tier or 100)
	return ("Start <b><font color=\"#%*\">%*</font></b> Event for %*?"):format((if v1 then v1.TierColor.Keypoints[1].Value else Color3.fromRGB(255, 255, 255)):ToHex(), p1.Name, (("<font color=\"rgb(255, 196, 57)\">%* Coins</font>"):format((StringLibrary:Shorten(p1.WeatherMachinePrice)))))
end
function Populate() --[[ Populate | Line: 323 | Upvalues: v2 (ref), t3 (copy) ]]
	for i, v in ipairs((v2:GetExpect("WeatherMachine"))) do
		t3:AddActiveTile(v)
	end
end
return t3