-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local v1 = nil
local LocalPlayer = Players.LocalPlayer
local MarketplaceService = require(ReplicatedStorage.Packages.MarketplaceService)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Client = require(ReplicatedStorage.Packages.Replion).Client
local Trove = require(ReplicatedStorage.Packages.Trove)
local Net = require(ReplicatedStorage.Packages.Net)
local spr = require(ReplicatedStorage.Packages.spr)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local BoatsHandlingData = require(ReplicatedStorage.Shared.BoatsHandlingData)
local GamePassUtility = require(ReplicatedStorage.Shared.GamePassUtility)
local CoinProductsUtility = require(ReplicatedStorage.Modules.CoinProductsUtility)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
local Device = require(ReplicatedStorage.Modules.Device)
require(ReplicatedStorage.Types.Modifiers)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local InterfaceHighlight = require(ReplicatedStorage.Modules.InterfaceHighlight)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local TradeData = require(ReplicatedStorage.Shared.Trading.TradeData)
local RAPController = require(ReplicatedStorage.Controllers.Trading.RAPController)
local v2 = Net:RemoteFunction("PurchaseBoat")
local v3 = Net:RemoteFunction("SpawnBoat")
local v4 = Net:RemoteFunction("DespawnBoat")
local v5 = Net:RemoteEvent("BoatChanged")
local v6 = Net:RemoteEvent("BoatTeleport")
local v7 = LocalPlayer.PlayerGui:WaitForChild("Boat Shop")
local v8 = v7.Main.Content
local RightContent = v8.RightContent
local Inside = RightContent.Inside
local CurrencyFrame = Inside.BoatData.CurrencyFrame
local RapCounter = Inside.BoatData.RapCounter
local ScrollingFrame = v8.List.ScrollingFrame
local Teleport = Inside.Teleport
local TeleportGlow = Inside.TeleportGlow
local Tile = ScrollingFrame.Tile
Tile.Parent = nil
local t = {}
local v9 = Trove.new()
local v10 = Trove.new()
local v11 = nil
local v12 = nil
local v13 = false
local v14 = nil
local v15 = false
local v16 = nil
local v17 = false
local v18 = false
local v19 = Signal.new()
local v20 = TierUtility:GetTier("Exclusive")
local t2 = {}
local function ClearHighlight() --[[ ClearHighlight | Line: 89 | Upvalues: v11 (ref) ]]
	if not v11 then
		return
	end
	v11:destroy()
	v11 = nil
end
local function ShouldStartGuidedBoatPurchase(p1) --[[ ShouldStartGuidedBoatPurchase | Line: 96 | Upvalues: v1 (ref), t2 (copy) ]]
	if p1 == nil then
		return false
	end
	local v12 = v1:Get("OnboardingStep")
	if v1:Get("PlayerOnboarding") ~= true or (v12 == nil or v12 >= 6) then
		return false
	end
	if not t2:OwnsBoat(p1) then
		return true
	end
	return t2:GetMyBoat() == nil
end
local function IsGuidedBoatPurchaseIncomplete() --[[ IsGuidedBoatPurchaseIncomplete | Line: 114 | Upvalues: v12 (ref), t2 (copy) ]]
	if v12 == nil then
		return false
	end
	if not t2:OwnsBoat(v12) then
		return true
	end
	return t2:GetMyBoat() == nil
end
local function GetBoatTileById(p1) --[[ GetBoatTileById | Line: 126 | Upvalues: ItemUtility (copy), t (copy) ]]
	local v1 = ItemUtility:GetBoatData(p1)
	if v1 then
		return t[v1.Data.Name]
	else
		return nil
	end
end
local function GetGuidedBoatTarget() --[[ GetGuidedBoatTarget | Line: 135 | Upvalues: v7 (copy), v12 (ref), t2 (copy), v13 (ref), v14 (ref), v16 (ref), RightContent (copy), ItemUtility (copy), t (copy) ]]
	if not v7.Enabled or v12 == nil then
		return nil
	end
	if not (if v12 == nil then false elseif t2:OwnsBoat(v12) then t2:GetMyBoat() == nil else true) then
		return nil
	end
	if v13 and (v14 ~= "SelectBoat" and (v16 == v12 and RightContent.Visible)) then
		return RightContent.Action
	end
	local v2 = ItemUtility:GetBoatData(v12)
	if v2 then
		return t[v2.Data.Name]
	else
		return nil
	end
end
local function UpdateHighlight() --[[ UpdateHighlight | Line: 147 | Upvalues: v7 (copy), v12 (ref), t2 (copy), v13 (ref), v14 (ref), v16 (ref), RightContent (copy), ItemUtility (copy), t (copy), v11 (ref), InterfaceHighlight (copy) ]]
	local v1
	if v7.Enabled and v12 ~= nil and (if v12 == nil then false elseif t2:OwnsBoat(v12) then t2:GetMyBoat() == nil else true) then
		if v13 and (v14 ~= "SelectBoat" and (v16 == v12 and RightContent.Visible)) then
			v1 = RightContent.Action
		else
			local v3 = ItemUtility:GetBoatData(v12)
			v1 = if v3 then t[v3.Data.Name] else nil
		end
	else
		v1 = nil
	end
	if v1 then
		if v11 then
			v11:setTarget(v1)
		else
			v11 = InterfaceHighlight.track(v1)
		end
	else
		if not v11 then
			return
		end
		v11:destroy()
		v11 = nil
	end
end
function t2.Start(p1) --[[ Start | Line: 162 | Upvalues: v1 (ref), Client (copy), v7 (copy), GuiControl (copy), t2 (copy), v11 (ref), ShouldStartGuidedBoatPurchase (copy), v12 (ref), v13 (ref), v14 (ref), v16 (ref), RightContent (copy), ItemUtility (copy), t (copy), InterfaceHighlight (copy), Teleport (copy), v6 (copy), TextNotificationController (copy), LocalPlayer (copy), Device (copy) ]]
	v1 = Client:WaitReplion("Data")
	v7:GetPropertyChangedSignal("Enabled"):Connect(function() --[[ Line: 165 | Upvalues: v7 (ref) ]]
		local Enabled = game.ProximityPromptService.Enabled
		task.wait(0.5)
		local Enabled_2 = game.ProximityPromptService.Enabled
		local v2 = not v7.Enabled
		if Enabled ~= Enabled_2 or not v7.Enabled ~= v2 then
			return
		end
		game.ProximityPromptService.Enabled = v2
	end)
	GuiControl.GuiFocusedSignal:Connect(function(p1) --[[ Line: 180 | Upvalues: v7 (ref), t2 (ref), v11 (ref), ShouldStartGuidedBoatPurchase (ref), v12 (ref), v13 (ref), v14 (ref), v16 (ref), RightContent (ref), ItemUtility (ref), t (ref), InterfaceHighlight (ref) ]]
		if p1 ~= v7 then
			return
		end
		t2:Render()
		local v1 = t2:GetDefaultBoatId()
		if v11 then
			v11:destroy()
			v11 = nil
		end
		if ShouldStartGuidedBoatPurchase(v1) then
			v12 = v1
			v13 = false
			v14 = if t2:OwnsBoat(v1) then "SpawnBoat" else "SelectBoat"
			t2:CloseInfo()
			task.defer(function() --[[ Line: 195 | Upvalues: v7 (ref), v12 (ref), t2 (ref), v13 (ref), v14 (ref), v16 (ref), RightContent (ref), ItemUtility (ref), t (ref), v11 (ref), InterfaceHighlight (ref) ]]
				local v1
				if v7.Enabled and v12 ~= nil and (if v12 == nil then false elseif t2:OwnsBoat(v12) then t2:GetMyBoat() == nil else true) then
					if v13 and (v14 ~= "SelectBoat" and (v16 == v12 and RightContent.Visible)) then
						v1 = RightContent.Action
					else
						local v3 = ItemUtility:GetBoatData(v12)
						v1 = if v3 then t[v3.Data.Name] else nil
					end
				else
					v1 = nil
				end
				if v1 then
					if v11 then
						v11:setTarget(v1)
						return
					end
					v11 = InterfaceHighlight.track(v1)
				elseif v11 then
					v11:destroy()
					v11 = nil
				end
			end)
		else
			v12 = nil
			v13 = false
			v14 = nil
			t2:OpenInfo(v1)
		end
	end)
	GuiControl.GuiUnfocusedSignal:Connect(function(p1) --[[ Line: 207 | Upvalues: v7 (ref), t2 (ref) ]]
		if p1 ~= v7 then
			return
		end
		t2:Unrender()
	end)
	GuiControl:Hook("Hold Button", Teleport).Clicked:Connect(function() --[[ Line: 213 | Upvalues: t2 (ref), v6 (ref), GuiControl (ref), TextNotificationController (ref) ]]
		if t2:GetMyBoat() then
			v6:FireServer()
			GuiControl:Close()
		else
			TextNotificationController:DeliverNotification({
				Type = "Text",
				Text = "You do not have a boat!",
				TextColor = {
					R = 255,
					G = 0,
					B = 0
				}
			})
		end
	end)
	LocalPlayer:GetAttributeChangedSignal("BoatTeleportCooldown"):Connect(TeleportRestrictionChanged)
	TeleportRestrictionChanged()
	Device:_onDeviceChanged(DeviceChanged)
	DeviceChanged()
end
function t2.OwnsBoat(p1, p2) --[[ OwnsBoat | Line: 236 | Upvalues: v1 (ref) ]]
	for i, v in ipairs((v1:GetExpect({ "Inventory", "Boats" }))) do
		if v.Id == p2 then
			return true, v
		end
	end
	return false
end
function t2.OpenInfo(p1, p2, p3) --[[ OpenInfo | Line: 248 | Upvalues: v15 (ref), ItemUtility (copy), v10 (copy), v16 (ref), v1 (ref), Inside (copy), TierUtility (copy), BoatsHandlingData (copy), spr (copy), t2 (copy), CurrencyFrame (copy), StringLibrary (copy), TradeData (copy), RAPController (copy), RapCounter (copy), RightContent (copy), GamePassUtility (copy), MarketplaceService (copy), v7 (copy), v12 (ref), v13 (ref), v14 (ref), t (copy), v11 (ref), InterfaceHighlight (copy), v5 (copy), GuiControl (copy), v4 (copy), v3 (copy), TextNotificationController (copy), CoinProductsUtility (copy), v2 (copy), Soundbook (copy), PlayerStatsUtility (copy) ]]
	if v15 then
		return
	end
	local v17 = ItemUtility:GetBoatData(p2)
	if not v17 then
		return
	end
	v15 = true
	v10:Clean()
	v16 = p2
	local v22 = v1:GetExpect({ "Inventory", "Boats" })
	local v32 = nil
	for i, v in ipairs(v22) do
		if p2 == v.Id and v.Metadata then
			v32 = v.Metadata
			break
		end
	end
	Inside.Header.Text = if v32 and v32.Placement then ("%* (#%*)"):format(v17.Data.Name, v32.Placement) else v17.Data.Name
	Inside.BoatData.Vector.Image = v17.Data.Icon or ""
	local v6 = TierUtility:GetTier(v17.Data.Tier)
	if v6 then
		local v72 = v6.TierColor.Keypoints[1].Value
		Inside.BoatData.Gradient.BackgroundColor3 = v72
		Inside.BoatData.UIStroke.Color = v72
		Inside.BoatData.Glow.ImageColor3 = v72
		Inside.BoatData.Glow.Visible = v6.Tier > 1
		Inside.BoatData.TierName.UIGradient.Color = v6.TierColor
		Inside.BoatData.TierName.Text = v6.Name
	end
	local v9 = BoatsHandlingData[v17.Data.Name]
	if v9 then
		local v102 = math.min(v9.RotationSpeed, 3) / 3
		local v112 = math.min(v9.Speed, 325) / 325
		spr.stop(Inside.Stats.HandlingFrame.Bar)
		spr.target(Inside.Stats.HandlingFrame.Bar, 1, 3, {
			Size = UDim2.fromScale(v102, 1)
		})
		spr.stop(Inside.Stats.SpeedFrame.Bar)
		spr.target(Inside.Stats.SpeedFrame.Bar, 1, 3, {
			Size = UDim2.fromScale(v112, 1)
		})
	else
		Inside.Stats.HandlingFrame.Bar.Size = UDim2.fromScale(0, 1)
		Inside.Stats.SpeedFrame.Bar.Size = UDim2.fromScale(0, 1)
	end
	local function boatOwnershipChanged() --[[ boatOwnershipChanged | Line: 323 | Upvalues: p3 (ref), t2 (ref), p2 (copy), v17 (copy), CurrencyFrame (ref), StringLibrary (ref), TradeData (ref), RAPController (ref), RapCounter (ref), RightContent (ref), GamePassUtility (ref), MarketplaceService (ref), v7 (ref), v12 (ref), v13 (ref), v14 (ref), v16 (ref), ItemUtility (ref), t (ref), v11 (ref), InterfaceHighlight (ref) ]]
		local v1 = nil
		if p3 then
			v1 = true
		else
			local v2, v3 = t2:OwnsBoat(p2)
			if v2 then
				v1 = true
				p3 = v3
			end
		end
		local Price = v17.Price
		local LinkedGamePass = v17.LinkedGamePass
		if LinkedGamePass then
			CurrencyFrame.Counter.Visible = false
			CurrencyFrame.VectorFrame.Visible = false
		elseif Price then
			CurrencyFrame.Counter.Text = StringLibrary:Shorten(Price)
			CurrencyFrame.Counter.Visible = true
			CurrencyFrame.VectorFrame.Visible = true
		else
			CurrencyFrame.Counter.Visible = false
			CurrencyFrame.VectorFrame.Visible = false
		end
		if v1 then
			local v4 = if p3 then TradeData.FollowTradeRules(v17, p3) else false
			local v5 = if v4 then RAPController:GetRAP(v17.Data.Type, v17.Data.Name) else nil
			RapCounter.Counter.Text = if v5 then StringLibrary:AddCommas(v5) else "???"
			RapCounter.Visible = v4
		else
			RapCounter.Visible = false
		end
		if v1 then
			if t2:GetMyBoat() then
				RightContent.Action.BackgroundColor3 = Color3.fromRGB(229, 29, 92)
				RightContent.Action.Label.TextColor3 = Color3.fromRGB(255, 255, 255)
				RightContent.Action.Label.Text = "Despawn"
			else
				RightContent.Action.BackgroundColor3 = Color3.fromRGB(48, 175, 229)
				RightContent.Action.Label.TextColor3 = Color3.fromRGB(255, 255, 255)
				RightContent.Action.Label.Text = "Spawn"
			end
		elseif LinkedGamePass then
			local v72 = GamePassUtility:GetGamePassIdFromName(LinkedGamePass)
			local v8 = nil
			if v72 then
				local v9, v10 = MarketplaceService:GetProductInfoAsync(v72, Enum.InfoType.GamePass):andThen(function(p1) --[[ Line: 382 ]]
					if p1.PriceInRobux then
						return tostring(p1.PriceInRobux)
					else
						return "???"
					end
				end):catch(warn):await()
				if v9 and v10 then
					v8 = v10
				end
			end
			if v8 then
				RightContent.Action.BackgroundColor3 = Color3.fromRGB(11, 227, 162)
				RightContent.Action.Label.TextColor3 = Color3.fromRGB(2, 48, 34)
				RightContent.Action.Label.Text = ("\238\128\130%* Robux"):format(v8)
			else
				RightContent.Action.BackgroundColor3 = Color3.fromRGB(11, 227, 162)
				RightContent.Action.Label.TextColor3 = Color3.fromRGB(2, 48, 34)
				RightContent.Action.Label.Text = "??? Robux"
			end
		elseif Price then
			RightContent.Action.BackgroundColor3 = Color3.fromRGB(28, 186, 78)
			RightContent.Action.Label.TextColor3 = Color3.fromRGB(6, 38, 15)
			RightContent.Action.Label.Text = "Buy"
		else
			RightContent.Action.BackgroundColor3 = Color3.fromRGB(218, 218, 218)
			RightContent.Action.Label.TextColor3 = Color3.fromRGB(0, 0, 0)
			RightContent.Action.Label.Text = "Not Owned"
		end
		local v112
		if v7.Enabled and v12 ~= nil and (if v12 == nil then false elseif t2:OwnsBoat(v12) then t2:GetMyBoat() == nil else true) then
			if v13 and (v14 ~= "SelectBoat" and (v16 == v12 and RightContent.Visible)) then
				v112 = RightContent.Action
			else
				local v132 = ItemUtility:GetBoatData(v12)
				v112 = if v132 then t[v132.Data.Name] else nil
			end
		else
			v112 = nil
		end
		if v112 then
			if v11 then
				v11:setTarget(v112)
				return
			end
			v11 = InterfaceHighlight.track(v112)
		elseif v11 then
			v11:destroy()
			v11 = nil
		end
	end
	local v122 = v5.OnClientEvent:Connect(boatOwnershipChanged)
	local v132 = v1:OnArrayInsert({ "Inventory", "Boats" }, boatOwnershipChanged)
	boatOwnershipChanged()
	local v142 = GuiControl:Hook("Hold Button", RightContent.Action)
	local v152 = v142.Clicked:Connect(function() --[[ Line: 431 | Upvalues: t2 (ref), v4 (ref), v7 (ref), v12 (ref), v13 (ref), v14 (ref), v16 (ref), RightContent (ref), ItemUtility (ref), t (ref), v11 (ref), InterfaceHighlight (ref), p2 (copy), v17 (copy), GamePassUtility (ref), v3 (ref), TextNotificationController (ref), GuiControl (ref), v1 (ref), CoinProductsUtility (ref), v2 (ref), Soundbook (ref), PlayerStatsUtility (ref) ]]
		if t2:GetMyBoat() then
			v4:InvokeServer()
			local v15
			if v7.Enabled and v12 ~= nil and (if v12 == nil then false elseif t2:OwnsBoat(v12) then t2:GetMyBoat() == nil else true) then
				if v13 and (v14 ~= "SelectBoat" and (v16 == v12 and RightContent.Visible)) then
					v15 = RightContent.Action
				else
					local v32 = ItemUtility:GetBoatData(v12)
					v15 = if v32 then t[v32.Data.Name] else nil
				end
			else
				v15 = nil
			end
			if v15 then
				if v11 then
					v11:setTarget(v15)
					return
				end
				v11 = InterfaceHighlight.track(v15)
			elseif v11 then
				v11:destroy()
				v11 = nil
			end
		else
			local v42 = t2:OwnsBoat(p2)
			if not v42 then
				local LinkedGamePass = v17.LinkedGamePass
				if LinkedGamePass and not GamePassUtility:ClientPromptGamepassFromName(LinkedGamePass) then
					return
				end
			end
			if v42 then
				local v5, _, v6 = v3:InvokeServer(v17.Data.Id)
				if not v5 then
					return
				end
				TeleportRestrictionChanged()
				if v12 == p2 and v13 then
					v14 = nil
				end
				local v72
				if v7.Enabled and v12 ~= nil and (if v12 == nil then false elseif t2:OwnsBoat(v12) then t2:GetMyBoat() == nil else true) then
					if v13 and (v14 ~= "SelectBoat" and (v16 == v12 and RightContent.Visible)) then
						v72 = RightContent.Action
					else
						local v9 = ItemUtility:GetBoatData(v12)
						v72 = if v9 then t[v9.Data.Name] else nil
					end
				else
					v72 = nil
				end
				if v72 then
					if v11 then
						v11:setTarget(v72)
					else
						v11 = InterfaceHighlight.track(v72)
					end
				elseif v11 then
					v11:destroy()
					v11 = nil
				end
				TextNotificationController:DeliverNotification({
					Type = "Text",
					Text = "Spawned boat!",
					TextColor = {
						R = 0,
						G = 255,
						B = 0
					}
				})
				if v6 then
					GuiControl:Close()
				end
			else
				local v10 = v1:Get("OnboardingStep")
				local v112 = if v1:Get("PlayerOnboarding") == true and (v10 ~= nil and v10 < 6) then v17.Data.Id == 1 else false
				if not v112 then
					local Price = v17.Price
					if Price then
						local v122 = v1:GetExpect("Coins")
						if v122 < Price then
							CoinProductsUtility:PurchaseBestCoinPack(v122, Price)
							return
						end
					end
				end
				if not v2:InvokeServer(v17.Data.Id) then
					return
				end
				Soundbook.Sounds.StorePurchase:Play()
				Soundbook.Sounds.CoinsChanged:Play()
				if v12 == p2 and v13 then
					v14 = "SpawnBoat"
				end
				t2:OpenInfo(p2, (PlayerStatsUtility:GetItemFromInventory(v1, function(p1) --[[ Line: 497 | Upvalues: v17 (ref) ]]
					return p1.Id == v17.Data.Id
				end, "Boats")))
				if v12 ~= p2 or not v13 then
					return
				end
				if v11 then
					v11:destroy()
					v11 = nil
				end
				task.defer(function() --[[ Line: 505 | Upvalues: v7 (ref), v12 (ref), t2 (ref), v13 (ref), v14 (ref), v16 (ref), RightContent (ref), ItemUtility (ref), t (ref), v11 (ref), InterfaceHighlight (ref) ]]
					local v1
					if v7.Enabled and v12 ~= nil and (if v12 == nil then false elseif t2:OwnsBoat(v12) then t2:GetMyBoat() == nil else true) then
						if v13 and (v14 ~= "SelectBoat" and (v16 == v12 and RightContent.Visible)) then
							v1 = RightContent.Action
						else
							local v3 = ItemUtility:GetBoatData(v12)
							v1 = if v3 then t[v3.Data.Name] else nil
						end
					else
						v1 = nil
					end
					if v1 then
						if v11 then
							v11:setTarget(v1)
							return
						end
						v11 = InterfaceHighlight.track(v1)
					elseif v11 then
						v11:destroy()
						v11 = nil
					end
				end)
			end
		end
	end)
	v10:Add(function() --[[ Line: 514 | Upvalues: v152 (copy), v142 (copy) ]]
		v152:Disconnect()
		v142:Destroy()
	end)
	v10:Add(function() --[[ Line: 519 | Upvalues: v122 (copy), v132 (copy) ]]
		v122:Disconnect()
		v132:Disconnect()
	end)
	TeleportRestrictionChanged()
	RightContent.Visible = true
	v15 = false
	local v162
	if v7.Enabled and v12 ~= nil and (if v12 == nil then false elseif t2:OwnsBoat(v12) then t2:GetMyBoat() == nil else true) then
		if v13 and (v14 ~= "SelectBoat" and (v16 == v12 and RightContent.Visible)) then
			v162 = RightContent.Action
		else
			local v18 = ItemUtility:GetBoatData(v12)
			v162 = if v18 then t[v18.Data.Name] else nil
		end
	else
		v162 = nil
	end
	if v162 then
		if v11 then
			v11:setTarget(v162)
		else
			v11 = InterfaceHighlight.track(v162)
		end
	else
		if not v11 then
			return
		end
		v11:destroy()
		v11 = nil
	end
end
function t2.CloseInfo(p1) --[[ CloseInfo | Line: 532 | Upvalues: v15 (ref), RightContent (copy), v10 (copy), v16 (ref), spr (copy), Inside (copy), v7 (copy), v12 (ref), t2 (copy), v13 (ref), v14 (ref), ItemUtility (copy), t (copy), v11 (ref), InterfaceHighlight (copy) ]]
	if v15 then
		return
	end
	RightContent.Visible = false
	v10:Clean()
	v16 = nil
	spr.stop(Inside.Stats.HandlingFrame.Bar)
	spr.stop(Inside.Stats.SpeedFrame.Bar)
	Inside.Stats.HandlingFrame.Bar.Size = UDim2.fromScale(0, 1)
	Inside.Stats.SpeedFrame.Bar.Size = UDim2.fromScale(0, 1)
	local v1
	if v7.Enabled and v12 ~= nil and (if v12 == nil then false elseif t2:OwnsBoat(v12) then t2:GetMyBoat() == nil else true) then
		if v13 and (v14 ~= "SelectBoat" and (v16 == v12 and RightContent.Visible)) then
			v1 = RightContent.Action
		else
			local v3 = ItemUtility:GetBoatData(v12)
			v1 = if v3 then t[v3.Data.Name] else nil
		end
	else
		v1 = nil
	end
	if v1 then
		if v11 then
			v11:setTarget(v1)
			return
		end
		v11 = InterfaceHighlight.track(v1)
	elseif v11 then
		v11:destroy()
		v11 = nil
	end
end
function t2.Unrender(p1) --[[ Unrender | Line: 552 | Upvalues: v18 (ref), v9 (copy), v11 (ref), t (copy), v12 (ref), v13 (ref), v14 (ref), t2 (copy), v19 (copy) ]]
	if v18 then
		return
	end
	v18 = true
	v9:Clean()
	if not v11 then
		table.clear(t)
		v12 = nil
		v13 = false
		v14 = nil
		t2:CloseInfo()
		v18 = false
		v19:Fire()
		return
	end
	v11:destroy()
	v11 = nil
	table.clear(t)
	v12 = nil
	v13 = false
	v14 = nil
	t2:CloseInfo()
	v18 = false
	v19:Fire()
end
function t2.RenderTile(p1, p2, p3) --[[ RenderTile | Line: 573 | Upvalues: t (copy), Tile (copy), t2 (copy), v20 (copy), StringLibrary (copy), TierUtility (copy), BoatsHandlingData (copy), GuiControl (copy), v13 (ref), v12 (ref), v14 (ref), v9 (copy), ScrollingFrame (copy) ]]
	local v1 = p2.Data.Name
	if p3 and t[v1] then
		return
	end
	local Price = p2.Price
	local v2 = Tile:Clone()
	local CurrencyFrame = v2.Padded.Top.CurrencyFrame
	local OwnedFrame = v2.Padded.Top.OwnedFrame
	local v3 = t2:OwnsBoat(p2.Data.Id)
	if p2.HiddenInShop then
		v2.Visible = v3
	end
	if v3 then
		OwnedFrame.Visible = true
		CurrencyFrame.Visible = false
	elseif p2.LinkedGamePass then
		CurrencyFrame.Counter.Text = "GAMEPASS"
		CurrencyFrame.Counter.UIGradient.Color = v20.TierColor
		CurrencyFrame.Counter.UIStroke.Color = Color3.new(0/255, 0/255, 0/255)
		CurrencyFrame.VectorFrame.Visible = false
	else
		if Price then
			CurrencyFrame.Counter.Text = StringLibrary:Shorten(Price)
			CurrencyFrame.Counter.UIGradient.Enabled = true
			CurrencyFrame.Visible = true
		else
			CurrencyFrame.Visible = false
		end
		OwnedFrame.Visible = false
	end
	v2.Padded.Top.Label.Text = p2.Data.Name
	v2.BG.Vector.Image = p2.Data.Icon or ""
	local v4 = TierUtility:GetTier(p2.Data.Tier)
	if v4 then
		v2.BG.Glow.Visible = v4.Tier > 1
		v2.BG.Glow.ImageColor3 = v4.TierColor.Keypoints[1].Value
	end
	local v7 = BoatsHandlingData[p2.Data.Name]
	if v7 then
		v2.Padded.Bottom.Acceleration.Counter.Text = ("%d%%"):format(100 + (v7.Acceleration - 0.15) / 0.15 * 100)
		v2.Padded.Bottom.TopSpeed.Counter.Text = ("%d%%"):format(100 + (v7.Speed - 100) / 100 * 100)
		v2.Padded.Bottom.Passengers.Counter.Text = tostring(p2.Seats)
		v2.Padded.Bottom.Visible = true
	else
		v2.Padded.Bottom.Visible = false
	end
	local v10 = GuiControl:Hook("Hold Button", v2)
	local v11 = v10.Clicked:Connect(function() --[[ Line: 645 | Upvalues: v13 (ref), v12 (ref), p2 (copy), t2 (ref), v14 (ref) ]]
		v13 = if v12 == nil then false else p2.Data.Id == v12
		if not v13 then
			t2:OpenInfo(p2.Data.Id)
			return
		end
		v14 = if t2:OwnsBoat(p2.Data.Id) then "SpawnBoat" else "BuyBoat"
		t2:OpenInfo(p2.Data.Id)
	end)
	v9:Add(function() --[[ Line: 658 | Upvalues: v11 (copy), v10 (copy), v2 (copy) ]]
		v11:Disconnect()
		v10:Destroy()
		v2:Destroy()
	end)
	local v122 = p2.Order or p2.Data.Tier * 1000 + string.len(p2.Data.Name)
	local v15
	if Price == nil then
		v15 = 100000 + v122
	else
		local v18 = p2.Data.Tier * 1000 + math.log10(p2.Price or 0) * 1000
		v15 = v18 + string.len(p2.Data.Name)
	end
	v2.LayoutOrder = v15
	v2.Parent = ScrollingFrame
	if t[v1] ~= nil then
		return
	end
	t[v1] = v2
end
function t2.Render(p1) --[[ Render | Line: 680 | Upvalues: v17 (ref), v18 (ref), v19 (copy), v1 (ref), ItemUtility (copy), t2 (copy) ]]
	if v17 then
		return
	end
	v17 = true
	if v18 then
		v19:Wait()
	end
	local v12 = v1:GetExpect({ "Inventory", "Boats" })
	if #v12 > 0 then
		for i, v in ipairs(v12) do
			ItemUtility:GetBoatData(v.Id)
		end
	end
	for i, v in ipairs((ItemUtility:GetBoats())) do
		t2:RenderTile(v, nil)
	end
	v17 = false
end
function t2.GetMyBoat(p1) --[[ GetMyBoat | Line: 713 | Upvalues: CollectionService (copy), LocalPlayer (copy) ]]
	for i, v in ipairs((CollectionService:GetTagged("Boat"))) do
		local v2 = v:GetAttribute("OwnerId")
		if v2 and v2 == LocalPlayer.UserId then
			return v
		end
	end
end
function t2.GetDefaultBoatId(p1) --[[ GetDefaultBoatId | Line: 730 | Upvalues: v1 (ref), ItemUtility (copy), t2 (copy) ]]
	local v12 = v1:Get("OnboardingStep")
	if if v12 == nil then false else v12 < 6 then
		local v3 = v1:GetExpect("Coins")
		local v5 = -1
		local v6 = nil
		for i, v in ipairs((ItemUtility:GetBoats())) do
			local Price = v.Price
			if Price and (Price <= v3 and v5 < v.Data.Tier) then
				v5 = v.Data.Tier
				v6 = v
			end
		end
		if v6 then
			return v6.Data.Id
		else
			return 1
		end
	else
		local v7 = v1:Get("LastBoatId")
		if v7 and t2:OwnsBoat(v7) then
			return v7
		end
		local v8 = -1
		local v9 = nil
		for v10, v11 in v1:GetExpect({ "Inventory", "Boats" }) do
			local v122 = ItemUtility:GetBoatData(v11.Id)
			if v122 and v8 < v122.Data.Tier then
				v8 = v122.Data.Tier
				v9 = v122
			end
		end
		if v9 then
			return v9.Data.Id
		else
			return 1
		end
	end
end
function DeviceChanged() --[[ DeviceChanged | Line: 783 | Upvalues: Device (copy), ScrollingFrame (copy) ]]
	ScrollingFrame.UIGridLayout.CellSize = if Device:IsMobile() then UDim2.new(0.975, 0, 0, 150) else UDim2.new(0.975, 0, 0, 230)
end
function TeleportRestrictionChanged() --[[ TeleportRestrictionChanged | Line: 794 | Upvalues: LocalPlayer (copy), t2 (copy), Teleport (copy), TeleportGlow (copy) ]]
	local v1 = LocalPlayer:GetAttribute("BoatTeleportCooldown") and true or false
	if not t2:GetMyBoat() then
		v1 = true
	end
	Teleport.Visible = not v1
	TeleportGlow.Visible = not v1
end
return t2