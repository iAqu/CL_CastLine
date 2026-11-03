-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
game:GetService("RunService")
game:GetService("UserInputService")
game:GetService("GuiService")
local Net = require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Trove = require(ReplicatedStorage.Packages.Trove)
require(ReplicatedStorage.Shared.InventoryMapping)
local TradeData = require(ReplicatedStorage.Shared.Trading.TradeData)
require(ReplicatedStorage.Types.Modifiers)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
require(ReplicatedStorage.Modules.Util.TableUtil)
local Renderer = require(script.Parent.TradeController.Renderer)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local PromptController = require(ReplicatedStorage.Controllers.PromptController)
local TradingPagination = require(ReplicatedStorage.Controllers.Trading.TradeController.TradingPagination)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local RAPController = require(ReplicatedStorage.Controllers.Trading.RAPController)
local ToolTip = require(ReplicatedStorage.Modules.ToolTip)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local v1 = false
local v2 = Trove.new()
local v3 = Trove.new()
local v4 = Trove.new()
local v5 = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 211, 34)), ColorSequenceKeypoint.new(0.379, Color3.fromRGB(255, 231, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 126, 34)) })
local v6 = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(88, 93, 98)), ColorSequenceKeypoint.new(0.379, Color3.fromRGB(93, 99, 104)), ColorSequenceKeypoint.new(1, Color3.fromRGB(48, 50, 53)) })
local LocalPlayer = Players.LocalPlayer
local v7 = Replion.Client:WaitReplion("Data")
local v8 = LocalPlayer.PlayerGui:WaitForChild("! Booth")
local Frame = v8:WaitForChild("Frame")
local BoothSkin = v8:WaitForChild("BoothSkin")
local Items = v8.BoothSkin.Interior.Content.SelectABooth.Items
local Top = v8.Frame.Top
local Bottom = v8.Frame.Bottom
local Interior = v8.Frame.Interior
local Sell = Interior.Sell.SellFrame.Sell
local BoothSkinTemplate = Items.BoothSkinTemplate
BoothSkinTemplate.Parent = nil
local v9 = nil
local v10 = nil
local v11 = Renderer.new(LocalPlayer, nil, Interior.InventoryPreview.Items, true, true)
local t = {}
local v12 = false
local v13 = "Fish"
local v14 = nil
local v15 = Net:RemoteEvent("ChangeBoothSkin")
local function updateCategories() --[[ updateCategories | Line: 82 | Upvalues: Interior (copy), v13 (ref), v5 (copy), v6 (copy) ]]
	for i, v in ipairs(Interior.Tabs:GetChildren()) do
		if v:IsA("ImageButton") then
			v.UIGradient.Color = v.Name == v13 and v5 or v6
		end
	end
end
local function getListingId(p1) --[[ getListingId | Line: 92 | Upvalues: v7 (copy) ]]
	local v1 = v7:Get("SaleListings.Booth")
	if not v1 then
		return nil
	end
	for v2, v3 in v1 do
		if v3.ItemId == p1 then
			return v2
		end
	end
	return nil
end
local function sendMessage(p1, p2) --[[ sendMessage | Line: 107 | Upvalues: TextNotificationController (copy) ]]
	TextNotificationController:DeliverNotification({
		Type = "Text",
		Text = p1,
		CustomDuration = p2
	})
end
local function messageSuccess(p1, p2) --[[ messageSuccess | Line: 115 | Upvalues: TextNotificationController (copy) ]]
	TextNotificationController:DeliverNotification({
		Type = "Text",
		Text = p1,
		TextColor = {
			R = 0,
			G = 255,
			B = 0
		},
		CustomDuration = p2
	})
end
local function messageError(p1) --[[ messageError | Line: 124 | Upvalues: TextNotificationController (copy) ]]
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
function t.ShowAll(p1) --[[ ShowAll | Line: 132 | Upvalues: v12 (ref), v3 (copy), v11 (copy), v7 (copy), ItemUtility (copy), Interior (copy), v9 (ref), TradingPagination (copy), TradeData (copy), messageError (copy), t (copy), v10 (ref) ]]
	if v12 then
		return
	end
	v12 = true
	v3:Clean()
	v11:DestroyTiles()
	local t2 = {}
	for k, v in pairs((v7:GetExpect("Inventory"))) do
		for i, v2 in ipairs(v) do
			local v22 = ItemUtility.GetItemDataFromItemType(k, v2.Id)
			if v22 then
				table.insert(t2, {
					Item = v2,
					Category = k,
					LayoutOrder = v11:GetLayoutOrder(v2, v22, nil)
				})
			end
		end
	end
	table.sort(t2, function(p1, p2) --[[ Line: 189 ]]
		return p1.LayoutOrder < p2.LayoutOrder
	end)
	local Items = Interior.InventoryPreview.Items
	local v32 = Items:FindFirstChildWhichIsA("UIGridLayout") or Items:FindFirstChildWhichIsA("UIListLayout")
	v9 = TradingPagination.new(Items, {
		OnPageLoaded = function() --[[ OnPageLoaded | Line: 199 | Upvalues: v32 (copy), Items (copy) ]]
			if not v32 then
				return
			end
			Items.CanvasSize = UDim2.new(0, 0, 0, v32.AbsoluteContentSize.Y + 10)
		end
	})
	v9:SetItems(t2)
	local function f4(p1, p2) --[[ Line: 209 | Upvalues: v11 (ref), TradeData (ref), messageError (ref), t (ref) ]]
		local Item = p1.Item
		local v1 = v11:Draw(p1.Category, Item.Id, Item)
		if v1 then
			v1.Tile:SetAttribute("__originalOrder", v1.Tile.LayoutOrder)
			v11:AddInteractionFromTile(v1.Tile, function() --[[ Line: 220 | Upvalues: TradeData (ref), v1 (copy), messageError (ref), t (ref) ]]
				if TradeData.FollowTradeRules(v1.Data, v1.Item) then
					t:UpdateSelectedItem(v1)
				else
					messageError("This item is trade locked!")
				end
			end)
		end
	end
	if v32 then
		v3:Add(v32:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() --[[ Line: 231 | Upvalues: Items (copy), v32 (copy) ]]
			Items.CanvasSize = UDim2.new(0, 0, 0, v32.AbsoluteContentSize.Y)
		end))
	end
	v10 = f4
	if v9:GetTotalItems() > 0 then
		v9:LoadNextPage(f4)
		v9:StartScrollMonitoring(f4)
	end
	v12 = false
end
function t.UpdateSelectedItem(p1, p2) --[[ UpdateSelectedItem | Line: 246 | Upvalues: v14 (ref), v1 (ref), v2 (copy), Interior (copy), Sell (copy), v7 (copy), RAPController (copy), StringLibrary (copy) ]]
	if v14 == p2 then
		return
	end
	v14 = p2
	if v1 then
		pcall(function() --[[ Line: 254 | Upvalues: v2 (ref) ]]
			v2:Clean()
		end)
	end
	local Rap = Interior.Sell.SellFrame.Rap
	local v12 = Interior.Sell.Preview:FindFirstChildWhichIsA("ImageButton")
	if v12 then
		v12:Destroy()
	end
	local v22 = p2.Tile:Clone()
	v22.Size = UDim2.fromScale(0.9, 0.9)
	v22.AnchorPoint = Vector2.new(0.5, 0.5)
	v22.Position = UDim2.fromScale(0.5, 0.5)
	v22.Parent = Interior.Sell.Preview
	local UUID = p2.Item.UUID
	local v3 = v7:Get("SaleListings.Booth")
	local v4
	if v3 then
		for v5, v6 in v3 do
			if v6.ItemId == UUID then
				v4 = v5
				break
			end
		end
	end
	Sell.Label.Text = if v4 == nil then "Sell Item" else "Take Off"
	local v8 = RAPController:GetRAP(p2.Type, p2.Data.Data.Name)
	if v8 then
		Rap.Counter.Text = StringLibrary:Shorten(v8)
	else
		Rap.Counter.Text = "Loading..."
		local v9 = nil
		v9 = v2:Add(task.spawn(function() --[[ Line: 280 | Upvalues: RAPController (ref), p2 (copy), StringLibrary (ref), Rap (copy), v2 (ref), v9 (ref), v1 (ref) ]]
			local v12 = RAPController:GetRAPAsync(p2.Type, p2.Data.Data.Name)
			Rap.Counter.Text = if typeof(v12) == "number" then StringLibrary:AddCommas(v12) else "Unknown"
			v2:Remove(v9)
			v1 = false
		end))
	end
end
function t.UpdateFilter(p1, p2) --[[ UpdateFilter | Line: 297 | Upvalues: v13 (ref), updateCategories (copy), v11 (copy), Bottom (copy) ]]
	if p2 ~= v13 then
		v13 = p2
		updateCategories()
	end
	v11:SetFilter(p2, Bottom.Search.TextBox.Text)
end
local function createBooth(p1) --[[ createBooth | Line: 306 | Upvalues: BoothSkinTemplate (copy), TierUtility (copy), Items (copy) ]]
	if p1 then
		local v1 = BoothSkinTemplate:Clone()
		v1.Name = p1.Data.Id
		v1.Label.Text = p1.Data.Name
		v1.Vector.Image = p1.Data.Icon
		v1.UIGradient.Color = TierUtility:GetTier(p1.Data.Tier).TierColor
		v1.Parent = Items
		return v1
	end
end
function t.Start(p1) --[[ Start | Line: 318 | Upvalues: Interior (copy), GuiControl (copy), v13 (ref), v12 (ref), t (copy), TradeData (copy), Sell (copy), v14 (ref), messageError (copy), StringLibrary (copy), PromptController (copy), messageSuccess (copy), v7 (copy), Bottom (copy), Frame (copy), Items (copy), ItemUtility (copy), BoothSkinTemplate (copy), TierUtility (copy), v4 (copy), BoothSkin (copy), v15 (copy), Soundbook (copy), Renderer (copy), TextNotificationController (copy), v8 (copy), v3 (copy), ToolTip (copy), v11 (copy) ]]
	for i, v in ipairs(Interior.Tabs:GetChildren()) do
		if v:IsA("ImageButton") then
			GuiControl:Hook("Hold Button", v).Clicked:Connect(function() --[[ Line: 324 | Upvalues: v13 (ref), v (copy), v12 (ref), t (ref) ]]
				if v13 == v.Name then
					return
				end
				if not v12 then
					t:UpdateFilter(v.Name)
				end
			end)
		end
	end
	Interior.Sell.SellFrame.Input.TextBox:GetPropertyChangedSignal("Text"):Connect(function() --[[ Line: 337 | Upvalues: Interior (ref), TradeData (ref) ]]
		local Text = Interior.Sell.SellFrame.Input.TextBox.Text
		if Text:find("%.") then
			Interior.Sell.SellFrame.Receive.Counter.Text = "-"
			return
		end
		local v1 = tonumber(Text)
		if v1 then
			Interior.Sell.SellFrame.Receive.Counter.Text = TradeData.CalculatePostTaxPrice((math.floor(v1)))
		else
			Interior.Sell.SellFrame.Receive.Counter.Text = "-"
		end
	end)
	GuiControl:Hook("Hold Button", Sell).Clicked:Connect(function() --[[ Line: 354 | Upvalues: v14 (ref), Sell (ref), Interior (ref), messageError (ref), StringLibrary (ref), PromptController (ref), TradeData (ref), messageSuccess (ref), v7 (ref) ]]
		if not v14 or Sell.Label.Text == "" then
			return
		end
		local Text = Interior.Sell.SellFrame.Input.TextBox.Text
		if Text:find("%.") then
			messageError("Cannot use decimals!")
			return
		end
		local v1 = tonumber(Text)
		if Sell.Label.Text == "Sell Item" and (not v1 or v1 <= 0) then
			messageError("Invalid Price!")
			return
		end
		local v2 = math.floor(v1)
		if v1 ~= v2 then
			messageError("Cannot use decimals!")
			return
		end
		if Sell.Label.Text == "Sell Item" then
			local v3, v4 = PromptController:FirePrompt((("Sell item for <font color=\"rgb(255, 206, 93)\">%* Trade Tokens</font> Tokens?"):format((StringLibrary:AddCommas(v2))))):catch(warn):await()
			if not (v3 and v4) then
				return
			end
			Sell.Label.Text = "Take Off"
			local v5, v6 = TradeData.Remotes.CreateSaleListing:InvokeServer("Booth", v14.Data.Data.Type, v14.Item.UUID, v2)
			if v5 then
				messageSuccess("This item is now selling!")
			else
				Sell.Label.Text = "Sell Item"
				messageError(v6)
			end
		else
			local UUID = v14.Item.UUID
			local v72 = v7:Get("SaleListings.Booth")
			local v8
			if v72 then
				for v9, v10 in v72 do
					if v10.ItemId == UUID then
						v8 = v9
						break
					end
				end
			end
			if not v8 then
				messageError("This item is NO longer selling!")
				return
			end
			Sell.Label.Text = "Sell Item"
			local v11, v12 = TradeData.Remotes.DeleteSaleListing:InvokeServer("Booth", v8)
			if v11 then
				messageSuccess("This item is NO longer selling!")
			else
				Sell.Label.Text = "Take Off"
				messageError(v12)
			end
		end
	end)
	GuiControl:Hook("Hold Button", Bottom.EditBoothSkin).Clicked:Connect(function() --[[ Line: 421 | Upvalues: Frame (ref), v7 (ref), Items (ref), ItemUtility (ref), BoothSkinTemplate (ref), TierUtility (ref), v4 (ref), GuiControl (ref), BoothSkin (ref), v15 (ref), Soundbook (ref) ]]
		Frame.Visible = false
		local v1 = v7:GetExpect({ "Inventory", "Booths" })
		if not v1 then
			print("Failed to get booths!")
			Frame.Visible = true
			return
		end
		for v2, v3 in Items:GetChildren() do
			if v3:IsA("ImageButton") then
				v3:Destroy()
			end
		end
		local function OnButtonClicked(p1) --[[ OnButtonClicked | Line: 432 | Upvalues: Items (ref) ]]
			for v1, v2 in Items:GetChildren() do
				if v2:IsA("ImageButton") then
					v2.Check.Visible = false
				end
			end
			p1.Check.Visible = true
		end
		local v42 = ItemUtility.GetItemDataFromItemType("Booths", 1)
		local v5
		if v42 then
			local v6 = BoothSkinTemplate:Clone()
			v6.Name = v42.Data.Id
			v6.Label.Text = v42.Data.Name
			v6.Vector.Image = v42.Data.Icon
			v6.UIGradient.Color = TierUtility:GetTier(v42.Data.Tier).TierColor
			v6.Parent = Items
			v5 = v6
		else
			v5 = nil
		end
		if not v5 then
			Frame.Visible = true
			return
		end
		v4:Add(v5)
		v4:Add(GuiControl:Hook("Hold Button", v5).Clicked:Connect(OnButtonClicked))
		for v8, v9 in v1 do
			local v72
			local v10 = ItemUtility.GetItemDataFromItemType("Booths", v9.Id)
			if v10 then
				local v11 = BoothSkinTemplate:Clone()
				v11.Name = v10.Data.Id
				v11.Label.Text = v10.Data.Name
				v11.Vector.Image = v10.Data.Icon
				v11.UIGradient.Color = TierUtility:GetTier(v10.Data.Tier).TierColor
				v11.Parent = Items
				v72 = v11
			else
				v72 = nil
			end
			if v72 then
				v4:Add(v72)
				v4:Add(GuiControl:Hook("Hold Button", v72).Clicked:Connect(OnButtonClicked))
			end
		end
		v4:Add(GuiControl:Hook("Hold Button", BoothSkin.Confirm).Clicked:Connect(function() --[[ Line: 463 | Upvalues: Items (ref), GuiControl (ref), Frame (ref), BoothSkin (ref), v4 (ref), v15 (ref), Soundbook (ref) ]]
			local v1 = nil
			for v2, v3 in Items:GetChildren() do
				if v3:IsA("GuiButton") and v3.Check.Visible then
					v1 = tonumber(v3.Name)
					break
				end
			end
			if v1 then
				GuiControl:Close()
				Frame.Visible = true
				BoothSkin.Visible = false
				v4:Clean()
				v15:FireServer(v1)
				Soundbook.Sounds["Booth Skin Changed"]:Play()
			else
				print("failed to find a selected item!")
			end
		end))
		BoothSkin.Visible = true
	end)
	TradeData.Remotes.SaleListingSold.OnClientEvent:Connect(function(p1, p2, p3, p4, p5, p6) --[[ Line: 496 | Upvalues: ItemUtility (ref), Renderer (ref), TextNotificationController (ref) ]]
		local v1 = ItemUtility.GetItemDataFromItemType(p4, p5.Id)
		if not v1 then
			return
		end
		local v2 = Renderer.getTierData(v1)
		if v2 then
			local v3 = v2.TierColor.Keypoints[1].Value
			TextNotificationController:DeliverNotification({
				Type = "Text",
				CustomDuration = 5,
				Text = ("You sold <font color=\"rgb(%*)\">%*</font> to %* for <font color=\"rgb(255, 206, 93)\">%* Trade Tokens</font>!"):format(("%*, %*, %*"):format(math.round(v3.R * 255), math.round(v3.G * 255), (math.round(v3.B * 255))), v1.Data.Name, p1.DisplayName, p6)
			})
		end
	end)
	Bottom.Search.TextBox.FocusLost:Connect(function() --[[ Line: 515 | Upvalues: t (ref), v13 (ref) ]]
		t:UpdateFilter(v13)
	end)
	GuiControl.GuiFocusedSignal:Connect(function(p1) --[[ Line: 520 | Upvalues: v8 (ref), v3 (ref), t (ref), ToolTip (ref) ]]
		if p1 == v8 then
			v3:Clean()
			t:ShowAll()
			ToolTip.destroyAll()
		end
	end)
	GuiControl.GuiUnfocusedSignal:Connect(function(p1) --[[ Line: 530 | Upvalues: v8 (ref), Interior (ref), v14 (ref), Sell (ref), v3 (ref), v11 (ref), ToolTip (ref) ]]
		if p1 ~= v8 then
			return
		end
		local v1 = Interior.Sell.Preview:FindFirstChildWhichIsA("ImageButton")
		if v1 then
			v1:Destroy()
		end
		v14 = nil
		Sell.Label.Text = "Sell Item"
		Interior.Sell.SellFrame.Input.TextBox.Text = ""
		v3:Clean()
		v11:DestroyTiles()
		ToolTip.destroyAll()
	end)
end
return t