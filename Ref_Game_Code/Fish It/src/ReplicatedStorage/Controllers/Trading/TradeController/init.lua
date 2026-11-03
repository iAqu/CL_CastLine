-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
game:GetService("RunService")
game:GetService("UserInputService")
game:GetService("GuiService")
game:GetService("CollectionService")
local Net = require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Trove = require(ReplicatedStorage.Packages.Trove)
require(ReplicatedStorage.Shared.InventoryMapping)
local TradeData = require(ReplicatedStorage.Shared.Trading.TradeData)
require(ReplicatedStorage.Types.Modifiers)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
require(ReplicatedStorage.Shared.Constants)
require(ReplicatedStorage.Shared.PlayerStatsUtility)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
require(ReplicatedStorage.Controllers.DialogueController)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local ToolTip = require(ReplicatedStorage.Modules.ToolTip)
local Renderer = require(script.Renderer)
local LocalPlayer = Players.LocalPlayer
local v1 = Replion.Client:WaitReplion("Data")
local v2 = LocalPlayer.PlayerGui:WaitForChild("! Trading")
local Bottom = v2.Frame.Bottom
local Tabs = v2.Frame.Tabs
local Interior = v2.Frame.Interior
local Top = v2.Frame.Top
local v3 = Trove.new()
local v4 = nil
local TradingPagination = require(script.TradingPagination)
local v5 = Renderer.new(LocalPlayer, nil, Interior.YourOffer.InventoryPreview.Items, true, true)
local v6 = false
local v7 = nil
local v8 = nil
Net:RemoteEvent("TradePlazaTeleport")
local TradeStarted = TradeData.Remotes.TradeStarted
local TradeEnded = TradeData.Remotes.TradeEnded
local TradeCompleted = TradeData.Remotes.TradeCompleted
local CancelTrade = TradeData.Remotes.CancelTrade
local SetTokens = TradeData.Remotes.SetTokens
local ConfirmTrade = TradeData.Remotes.ConfirmTrade
local SetReady = TradeData.Remotes.SetReady
local v9 = 0
local v10 = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 211, 34)), ColorSequenceKeypoint.new(0.379, Color3.fromRGB(255, 231, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 126, 34)) })
local v11 = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(88, 93, 98)), ColorSequenceKeypoint.new(0.379, Color3.fromRGB(93, 99, 104)), ColorSequenceKeypoint.new(1, Color3.fromRGB(48, 50, 53)) })
local v12 = "Fish"
local t = {}
local function sendMessage(p1) --[[ sendMessage | Line: 109 | Upvalues: TextNotificationController (copy) ]]
	TextNotificationController:DeliverNotification({
		Type = "Text",
		Text = p1
	})
end
local function successMessage(p1) --[[ successMessage | Line: 116 | Upvalues: TextNotificationController (copy) ]]
	TextNotificationController:DeliverNotification({
		Type = "Text",
		Text = p1,
		TextColor = {
			R = 0,
			G = 255,
			B = 0
		}
	})
end
local function errorMessage(p1) --[[ errorMessage | Line: 124 | Upvalues: TextNotificationController (copy) ]]
	TextNotificationController:DeliverNotification({
		Type = "Text",
		Text = p1,
		TextColor = {
			R = 255,
			G = 0,
			B = 0
		}
	})
end
function t.ShowAll(p1, p2) --[[ ShowAll | Line: 132 | Upvalues: v6 (ref), v5 (copy), v1 (copy), Interior (copy), ItemUtility (copy), v7 (ref), TradingPagination (copy), TradeData (copy), errorMessage (copy), LocalPlayer (copy), successMessage (copy), v3 (copy), v8 (ref) ]]
	if v6 then
		return
	end
	v6 = true
	v5:DestroyTiles()
	local v12 = v1:GetExpect("Inventory")
	local Items = Interior.YourOffer.InventoryPreview.Items
	local t = {}
	for k, v in pairs(v12) do
		for i, v2 in ipairs(v) do
			local v22 = ItemUtility.GetItemDataFromItemType(k, v2.Id)
			if v22 then
				table.insert(t, {
					Item = v2,
					Category = k,
					LayoutOrder = v5:GetLayoutOrder(v2, v22, nil)
				})
			end
		end
	end
	table.sort(t, function(p1, p2) --[[ Line: 211 ]]
		return p1.LayoutOrder < p2.LayoutOrder
	end)
	local v32 = Items:FindFirstChildWhichIsA("UIGridLayout") or Items:FindFirstChildWhichIsA("UIListLayout")
	v7 = TradingPagination.new(Items, {
		OnPageLoaded = function() --[[ OnPageLoaded | Line: 220 | Upvalues: v32 (copy), Items (copy) ]]
			if not v32 then
				return
			end
			Items.CanvasSize = UDim2.new(0, 0, 0, v32.AbsoluteContentSize.Y + 10)
		end
	})
	v7:SetItems(t)
	local function f4(p1, p22) --[[ Line: 230 | Upvalues: v5 (ref), TradeData (ref), errorMessage (ref), p2 (copy), LocalPlayer (ref), successMessage (ref) ]]
		local Item = p1.Item
		local v1 = v5:Draw(p1.Category, Item.Id, Item)
		if v1 then
			v1.Tile:SetAttribute("__originalOrder", v1.Tile.LayoutOrder)
			v5:AddInteractionFromTile(v1.Tile, function() --[[ Line: 241 | Upvalues: TradeData (ref), v1 (copy), errorMessage (ref), p2 (ref), LocalPlayer (ref), Item (copy), successMessage (ref) ]]
				if not TradeData.FollowTradeRules(v1.Data, v1.Item) then
					errorMessage("This item is trade locked!")
					return
				end
				local Type = v1.Data.Data.Type
				local v12 = p2:Get((("Players.%*.Items.%*"):format(LocalPlayer.UserId, Type))) or {}
				if if v1.Tile and v1.Tile:GetAttribute("InTrade") or v12[Item.UUID] then true else nil then
					local v3, v4 = TradeData.Remotes.RemoveItem:InvokeServer(Type, Item.UUID)
					if v3 then
						v1.Tile.Checkmark.Visible = false
						v1.Tile:SetAttribute("InTrade", nil)
						v1.Tile.LayoutOrder = v1.Tile:GetAttribute("__originalOrder") or 0
						successMessage("Item removed from offer!")
						return
					end
					if not v4 then
						return
					end
					errorMessage(v4)
				else
					local v5, v6 = TradeData.Remotes.AddItem:InvokeServer(Type, Item.UUID)
					if v5 then
						v1.Tile.Checkmark.Visible = true
						v1.Tile:SetAttribute("InTrade", true)
						v1.Tile.LayoutOrder = v1.Tile.LayoutOrder * 750000
						successMessage("Item added to offer!")
						return
					end
					if v6 then
						errorMessage(v6)
					end
				end
			end)
		end
	end
	if v32 then
		v3:Add(v32:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() --[[ Line: 286 | Upvalues: Items (copy), v32 (copy) ]]
			Items.CanvasSize = UDim2.new(0, 0, 0, v32.AbsoluteContentSize.Y)
		end))
	end
	v8 = f4
	if v7:GetTotalItems() > 0 then
		v7:LoadNextPage(f4)
		v7:StartScrollMonitoring(f4)
	end
	Interior.YourOffer.YourTrading.Visible = false
	Interior.YourOffer.InventoryPreview.Visible = true
	v6 = false
end
function t.StopAll(p1) --[[ StopAll | Line: 304 | Upvalues: v7 (ref), v5 (copy), Interior (copy) ]]
	if not v7 then
		v5:DestroyTiles()
		Interior.YourOffer.YourTrading.Visible = true
		Interior.YourOffer.InventoryPreview.Visible = false
		return
	end
	v7:Reset()
	v5:DestroyTiles()
	Interior.YourOffer.YourTrading.Visible = true
	Interior.YourOffer.InventoryPreview.Visible = false
end
function t.Init(p1) --[[ Init | Line: 315 | Upvalues: Bottom (copy), v12 (ref), Tabs (copy), GuiControl (copy), v6 (ref) ]]
	Bottom.Search.TextBox.FocusLost:Connect(function() --[[ Line: 317 | Upvalues: v12 (ref) ]]
		updateFilter(v12)
	end)
	for i, v in ipairs(Tabs:GetChildren()) do
		if v:IsA("GuiButton") then
			GuiControl:Hook("Hold Button", v).Clicked:Connect(function() --[[ Line: 326 | Upvalues: v12 (ref), v (copy), v6 (ref) ]]
				if v12 == v.Name then
					return
				end
				if not v6 then
					updateFilter(v.Name)
				end
			end)
		end
	end
end
function t.Start(p1) --[[ Start | Line: 340 | Upvalues: TradeStarted (copy), TradeEnded (copy), v3 (copy), GuiControl (copy), TextNotificationController (copy), TradeCompleted (copy) ]]
	TradeStarted.OnClientEvent:Connect(function(p12) --[[ Line: 341 | Upvalues: p1 (copy) ]]
		p1:TradeStarted(p12)
	end)
	TradeEnded.OnClientEvent:Connect(function(p1) --[[ Line: 345 | Upvalues: v3 (ref), GuiControl (ref), TextNotificationController (ref) ]]
		v3:Clean()
		GuiControl:Unlock()
		GuiControl:Close()
		TextNotificationController:DeliverNotification({
			Type = "Text",
			Text = p1
		})
		GuiControl:SetHUDVisibility(true)
	end)
	TradeCompleted.OnClientEvent:Connect(function(p1, p2) --[[ Line: 354 | Upvalues: v3 (ref), GuiControl (ref), TextNotificationController (ref) ]]
		v3:Clean()
		GuiControl:Unlock()
		GuiControl:Close()
		TextNotificationController:DeliverNotification({
			Type = "Text",
			Text = p2
		})
		GuiControl:SetHUDVisibility(true)
	end)
end
function t.UpdateOtherOffers(p1, p2, p3) --[[ UpdateOtherOffers | Line: 551 | Upvalues: v4 (ref), ItemUtility (copy) ]]
	if not v4 then
		return
	end
	local t = {}
	for v2, v3 in p3:Get((("Players.%*.Items"):format(p2.UserId))) or {} do
		for v42, v5 in v3 do
			local v6 = ItemUtility.GetItemDataFromItemType(v2, v5.Id)
			if not v6 then
				return
			end
			local v7 = v4.getTileId(v6, v5.UUID)
			t[v7] = true
			if not v4.Tiles[v7] then
				v4:Draw(v2, v5.Id, v5)
			end
		end
	end
	for v8, v9 in v4.Tiles do
		if not t[v8] then
			v4:DestroyTileFromTile(v9.Tile)
		end
	end
end
function t.TradeStarted(p1, p2) --[[ TradeStarted | Line: 589 | Upvalues: v3 (copy), GuiControl (copy), ToolTip (copy), Replion (copy), Bottom (copy), LocalPlayer (copy), v4 (ref), Renderer (copy), Interior (copy), v9 (ref), StringLibrary (copy), TradeData (copy), v2 (copy), CancelTrade (copy), TextNotificationController (copy), ConfirmTrade (copy), SetReady (copy), v1 (copy), SetTokens (copy), errorMessage (copy), t (copy) ]]
	v3:Clean()
	GuiControl:SetHUDVisibility(false)
	ToolTip.destroyAll()
	local v12 = Replion.Client:GetReplion(p2)
	if not v12 then
		return
	end
	Bottom.Search.TextBox.Text = ""
	local v22 = v12.Data.PlayerList[1] ~= LocalPlayer and v12.Data.PlayerList[1] or v12.Data.PlayerList[2]
	local v32 = v12.Data.Players[tostring(v22.UserId)]
	local v42 = v12.Data.Players[tostring(LocalPlayer.UserId)]
	v4 = Renderer.new(v22, p2, Interior.TheirOffer.TheirTrading.Items, false, false)
	v9 = 0
	Interior.Buttons.Tokens.RemoveTokens.Visible = false
	Interior.TheirOffer.TopPart.Username.Text = ("@%*\'s Offer"):format(v22.Name)
	Interior.TheirOffer.TopPart.PFP.PFP.Image = ("rbxthumb://type=AvatarHeadShot&id=%*&w=48&h=48"):format(v22.UserId)
	Interior.YourOffer.TopPart.PFP.PFP.Image = ("rbxthumb://type=AvatarHeadShot&id=%*&w=48&h=48"):format(LocalPlayer.UserId)
	Interior.TheirOffer.TheirTrading.Tokens.Tokens.Text = StringLibrary:AddCommas(v32.Tokens)
	local Tokens = Interior.Buttons.Tokens.Tokens
	Tokens.Text = v42.Tokens > 0 and StringLibrary:AddCommas(v42.Tokens) or ""
	Interior.Buttons.Accept.Label.Text = "ACCEPT"
	Interior.TheirOffer.TheirTrading.Ready.Visible = false
	Interior.YourOffer.YourTrading.Ready.Visible = false
	Interior.YourOffer.InventoryPreview.Ready.Visible = false
	Interior.Buttons.Accept.Grey.Visible = false
	Interior.Ready.Visible = false
	Interior.Ready.Label.Text = ("\226\140\155 %* Seconds Left..."):format(TradeData.ConfirmCountdownTime)
	Interior.Buttons.Accept.Lock.Visible = false
	Interior.Buttons.Accept.Lock.Timer.Text = ""
	Interior.TheirOffer.TheirTrading.Ready.TextLabel.Text = "Player is Ready"
	Interior.YourOffer.YourTrading.Ready.TextLabel.Text = "Player is Ready"
	v3:Add(v2.Frame.Close.Activated:Connect(function() --[[ Line: 633 | Upvalues: CancelTrade (ref), TextNotificationController (ref), GuiControl (ref), v3 (ref) ]]
		local v1, v2 = CancelTrade:InvokeServer()
		if v1 then
			TextNotificationController:DeliverNotification({
				Type = "Text",
				Text = "Trade Ended!"
			})
			GuiControl:Unlock()
			GuiControl:Close()
			v3:Clean()
			GuiControl:SetHUDVisibility(true)
			return
		end
		if not v2 then
			return
		end
		TextNotificationController:DeliverNotification({
			Type = "Text",
			Text = v2
		})
	end))
	v3:Add(Interior.Decline.Activated:Connect(function() --[[ Line: 652 | Upvalues: CancelTrade (ref), TextNotificationController (ref), GuiControl (ref), v3 (ref) ]]
		local v1, v2 = CancelTrade:InvokeServer()
		if v1 then
			TextNotificationController:DeliverNotification({
				Type = "Text",
				Text = "Trade Ended!"
			})
			GuiControl:Unlock()
			GuiControl:Close()
			v3:Clean()
			GuiControl:SetHUDVisibility(true)
			return
		end
		if not v2 then
			return
		end
		TextNotificationController:DeliverNotification({
			Type = "Text",
			Text = "Trade Ended!"
		})
	end))
	v3:Add(Interior.Buttons.Accept.Activated:Connect(function() --[[ Line: 670 | Upvalues: Interior (ref), v12 (copy), ConfirmTrade (ref), SetReady (ref) ]]
		if Interior.Buttons.Accept.Lock.Visible then
			return
		end
		if not v12.Data.PlayersReady then
			local _, _2 = SetReady:InvokeServer(true)
			return
		end
		Interior.Buttons.Accept.Label.Text = "CONFIRMED"
		if Interior.YourOffer.YourTrading.Ready.TextLabel.Text == "Player is Ready" then
			Interior.YourOffer.YourTrading.Ready.TextLabel.Text = "Waiting for player to confirm"
		end
		ConfirmTrade:InvokeServer()
	end))
	v3:Add(v12:OnChange(("Players.%*.IsReady"):format(v22.UserId), function(p1) --[[ Line: 688 | Upvalues: Interior (ref) ]]
		Interior.TheirOffer.TheirTrading.Ready.Visible = p1
	end))
	v3:Add(v12:OnChange(("Players.%*.IsReady"):format(LocalPlayer.UserId), function(p1) --[[ Line: 692 | Upvalues: Interior (ref) ]]
		Interior.YourOffer.YourTrading.Ready.Visible = p1
		Interior.YourOffer.InventoryPreview.Ready.Visible = p1
		Interior.Buttons.Accept.Grey.Visible = p1
	end))
	v3:Add(v12:OnChange(("Players.%*.IsConfirmed"):format(v22.UserId), function(p1) --[[ Line: 698 | Upvalues: Interior (ref) ]]
		if p1 and Interior.Buttons.Accept.Label.Text ~= "CONFIRMED" then
			Interior.TheirOffer.TheirTrading.Ready.TextLabel.Text = "Waiting for player to confirm"
		else
			Interior.TheirOffer.TheirTrading.Ready.TextLabel.Text = "Player is Ready"
		end
	end))
	v3:Add(v12:OnChange("PlayersReady", function(p1) --[[ Line: 708 | Upvalues: Interior (ref) ]]
		Interior.Buttons.Accept.Label.Text = if p1 then "CONFIRM" else "ACCEPT"
		Interior.Buttons.Accept.Grey.Visible = false
	end))
	v3:Add(v12:OnChange("LastModifiedTime", function(p1) --[[ Line: 713 | Upvalues: v12 (copy), TradeData (ref), Interior (ref) ]]
		repeat
			if v12.Destroyed or p1 ~= v12.Data.LastModifiedTime then
				break
			end
			local v1 = p1 + TradeData.ConfirmCountdownTime - workspace:GetServerTimeNow()
			Interior.Buttons.Accept.Lock.Visible = true
			Interior.Buttons.Accept.Lock.Timer.Text = string.format("%.1f", v1)
			task.wait(0.1)
		until v1 <= 0.1
		if v12.Destroyed or p1 ~= v12.Data.LastModifiedTime then
			return
		end
		Interior.Buttons.Accept.Lock.Visible = false
	end))
	v3:Add(v12:OnChange("TradeConfirmTime", function(p1) --[[ Line: 732 | Upvalues: Interior (ref), TradeData (ref), v12 (copy) ]]
		if p1 ~= 0 then
			Interior.Ready.Visible = true
			Interior.Ready.Label.Text = ("\226\140\155 %* Seconds Left..."):format(TradeData.ConfirmCountdownTime)
			Interior.TheirOffer.TheirTrading.Ready.TextLabel.Text = "Player Confirmed"
			Interior.YourOffer.YourTrading.Ready.TextLabel.Text = "Player Confirmed"
			repeat
				if v12.Destroyed or p1 ~= v12.Data.TradeConfirmTime then
					break
				end
				local v1 = p1 + TradeData.ConfirmCountdownTime - workspace:GetServerTimeNow()
				local v2 = math.round(v1 * 10) / 10
				Interior.Ready.Label.Text = ("\226\140\155 %* %* Left..."):format(v2, if v2 == 1 then "Second" else "Seconds")
				task.wait(0.1)
			until v1 <= 0.1
			if v12.Destroyed or p1 ~= v12.Data.LastModifiedTime then
				return
			end
		end
		Interior.Ready.Visible = false
	end))
	v3:Add(Interior.Buttons.Tokens.Tokens.FocusLost:Connect(function() --[[ Line: 762 | Upvalues: Interior (ref), v1 (ref), SetTokens (ref), v9 (ref), errorMessage (ref) ]]
		local Text = Interior.Buttons.Tokens.Tokens.Text
		local v3 = math.clamp(if string.len(Text) == 0 then 0 else tonumber(Text) or 0, 0, v1:Get("Tokens") or 0)
		local v4, v5 = SetTokens:InvokeServer(v3)
		if v4 then
			v9 = v3
			Interior.Buttons.Tokens.Tokens.Text = tostring(v3)
			Interior.Buttons.Tokens.RemoveTokens.Visible = v3 > 0
		else
			if v5 then
				errorMessage(v5)
			end
			Interior.Buttons.Tokens.Tokens.Text = ""
			Interior.Buttons.Tokens.RemoveTokens.Visible = false
		end
	end))
	v3:Add(Interior.Buttons.Tokens.RemoveTokens.Activated:Connect(function() --[[ Line: 790 | Upvalues: SetTokens (ref), v9 (ref), Interior (ref) ]]
		local v1, _ = SetTokens:InvokeServer(0)
		if not v1 then
			return
		end
		v9 = 0
		Interior.Buttons.Tokens.Tokens.Text = ""
		Interior.Buttons.Tokens.RemoveTokens.Visible = false
	end))
	v3:Add(v12:OnChange(("Players.%*.Tokens"):format(v22.UserId), function(p1) --[[ Line: 799 | Upvalues: Interior (ref), StringLibrary (ref) ]]
		Interior.TheirOffer.TheirTrading.Tokens.Tokens.Text = StringLibrary:AddCommas(p1)
	end))
	GuiControl:SetHUDVisibility(false)
	GuiControl:Open("! Trading")
	GuiControl:Lock()
	t:ShowAll(v12)
	v3:Add(function() --[[ Line: 810 | Upvalues: t (ref) ]]
		t:StopAll()
	end)
	v3:Add(v12:OnDescendantChange(("Players.%*.Items"):format(v22.UserId), function() --[[ Line: 816 | Upvalues: p1 (copy), v22 (copy), v12 (copy) ]]
		p1:UpdateOtherOffers(v22, v12)
	end))
	v12:BeforeDestroy(function() --[[ Line: 825 | Upvalues: ToolTip (ref) ]]
		updateFilter("Fish")
		ToolTip.destroyAll()
	end)
end
function updateFilter(p1) --[[ updateFilter | Line: 841 | Upvalues: v12 (ref), v5 (copy), Bottom (copy), v7 (ref), Interior (copy), v1 (copy), ItemUtility (copy), v8 (ref) ]]
	v12 = p1
	refreshButtons()
	v5:SetFilter(p1, Bottom.Search.TextBox.Text)
	if not v7 then
		return
	end
	v7:Reset()
	local Items = Interior.YourOffer.InventoryPreview.Items
	Items.CanvasPosition = Vector2.zero
	Items.CanvasSize = UDim2.new(0, 0, 0, 0)
	v5:CleanFilteredTiles()
	local t = {}
	for k, v in pairs((v1:GetExpect("Inventory"))) do
		for i, v2 in ipairs(v) do
			local v22 = ItemUtility.GetItemDataFromItemType(k, v2.Id)
			if v22 and v22.Data.Type == p1 then
				table.insert(t, {
					Item = v2,
					Category = k
				})
			end
		end
	end
	v7:SetItems(t)
	if not (v7:GetTotalItems() > 0) then
		return
	end
	v7:LoadNextPage(v8)
	v7:StartScrollMonitoring(v8)
end
function refreshButtons() --[[ refreshButtons | Line: 892 | Upvalues: Tabs (copy), v12 (ref), v10 (copy), v11 (copy) ]]
	for i, v in ipairs(Tabs:GetChildren()) do
		if v:IsA("ImageButton") then
			v.UIGradient.Color = v.Name == v12 and v10 or v11
		end
	end
end
return t