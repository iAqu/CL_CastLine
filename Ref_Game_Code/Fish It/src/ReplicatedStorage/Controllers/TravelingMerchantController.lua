-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local TweenService = game:GetService("TweenService")
game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Net = require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Thread = require(ReplicatedStorage.Packages.Thread)
local Signal = require(ReplicatedStorage.Packages.Signal)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local CurrencyUtility = require(ReplicatedStorage.Modules.CurrencyUtility)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
local SkinCrates = require(ReplicatedStorage.SkinCrates)
local InventoryMapping = require(ReplicatedStorage.Shared.InventoryMapping)
local MarketItemData = require(ReplicatedStorage.Shared.MarketItemData)
local PolicyWrapper = require(ReplicatedStorage.Shared.PolicyWrapper)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local LootboxController = require(ReplicatedStorage.Controllers.LootboxController)
local MarketplaceService = require(ReplicatedStorage.Packages.MarketplaceService)
local v1 = Net:RemoteFunction("PurchaseMarketItem")
local LocalPlayer = Players.LocalPlayer
local v2 = nil
local v3 = nil
local v4 = false
local v5 = false
local v6 = Trove.new()
local v7 = Signal.new()
local Background = LocalPlayer.PlayerGui:WaitForChild("Merchant"):WaitForChild("Main").Background
local RefreshLabel = Background.RefreshLabel
local ScrollingFrame = Background.Items.ScrollingFrame
local v8 = ScrollingFrame:WaitForChild("Mysterious Crate")
v8.Visible = false
local Template = ScrollingFrame:WaitForChild("Template")
Template.Parent = nil
local t = {}
local function getRemainingTimeString(p1) --[[ getRemainingTimeString | Line: 66 ]]
	local v1 = p1 % 86400
	return ("%dH, %dM, %dS"):format(math.floor(v1 / 3600), math.floor(v1 % 3600 / 60), (math.floor(p1 % 60)))
end
function t.Start(p1) --[[ Start | Line: 76 | Upvalues: v3 (ref), Replion (copy), v2 (ref), GuiControl (copy), t (copy), v8 (copy), Background (copy), MarketplaceService (copy), LocalPlayer (copy), Thread (copy), RefreshLabel (copy) ]]
	v3 = Replion.Client:WaitReplion("Merchant")
	v2 = Replion.Client:WaitReplion("Data")
	GuiControl.GuiFocusedSignal:Connect(t._updateAll)
	v3:OnChange("Items", t._updateAll)
	t._updateAll()
	t:RenderCrateButton(v8, "Mystery Crate")
	GuiControl:Hook("Hold Button", Background.Bottom.Purchase).Clicked:Connect(function() --[[ Line: 90 | Upvalues: MarketplaceService (ref), LocalPlayer (ref) ]]
		MarketplaceService:PromptProductPurchase(LocalPlayer, 3417203011)
	end)
	Thread:Execute(1, function() --[[ Line: 95 | Upvalues: RefreshLabel (ref) ]]
		local v1 = workspace:GetServerTimeNow()
		local v2 = math.max((v1 // 86400 + 1) * 86400 - v1, 0)
		local v3 = v2 % 86400
		RefreshLabel.Text = ("Next Refresh: %s"):format((("%dH, %dM, %dS"):format(math.floor(v3 / 3600), math.floor(v3 % 3600 / 60), (math.floor(v2 % 60)))))
	end)
end
function t._updateAll() --[[ _updateAll | Line: 107 | Upvalues: v5 (ref), v6 (copy), v3 (ref), t (copy), v8 (copy) ]]
	if v5 then
		return
	end
	v5 = true
	v6:Clean()
	local v2 = false
	for i, v in ipairs((v3:GetExpect("Items"))) do
		local v32 = t:GetMarketDataFromId(v)
		if v32 then
			if v32.SkinCrate then
				v2 = true
				continue
			end
			t._renderTile(v, v32)
		end
	end
	v8.Visible = v2
	v5 = false
end
function t._renderTile(p1, p2) --[[ _renderTile | Line: 141 | Upvalues: ItemUtility (copy), TierUtility (copy), v6 (copy), Template (copy), CurrencyUtility (copy), StringLibrary (copy), t (copy), v7 (copy), GuiControl (copy), ScrollingFrame (copy) ]]
	local v1 = ItemUtility.GetItemDataFromItemType(p2.Type, p2.Identifier)
	if not v1 then
		return
	end
	local v2 = TierUtility:GetTier(v1.Data.Tier or 1) or TierUtility:GetTierFromRarity(0)
	local v3 = v6:Clone(Template)
	local VectorFrame = v3:FindFirstChild("VectorFrame")
	local Frame = v3:FindFirstChild("Frame")
	local Frame_2 = Frame:FindFirstChild("Frame")
	local v4 = false
	if p2.Price then
		local v5 = CurrencyUtility:GetCurrency(p2.Currency)
		if v5 then
			Frame_2.Price.UIGradient.Color = v5.TextColor
			Frame_2.Price.Text = StringLibrary:Shorten(p2.Price)
			Frame_2.Vector.Image = v5.Icon
			v4 = true
		end
	end
	if not v4 then
		Frame_2.Price.Visible = false
		Frame_2.Vector.Visible = false
	end
	if v1.Data.Type == "Fishing Rods" then
		VectorFrame.Vector.AnchorPoint = Vector2.new(0.5, 1)
		VectorFrame.Vector.Position = UDim2.fromScale(0.5, 1)
		VectorFrame.Vector.Size = UDim2.fromScale(0.5, 1.6)
		VectorFrame.Vector.ScaleType = Enum.ScaleType.Crop
	else
		VectorFrame.Vector.AnchorPoint = Vector2.new(0.5, 0.5)
		VectorFrame.Vector.Position = UDim2.fromScale(0.5, 0.5)
		VectorFrame.Vector.Size = UDim2.fromScale(1, 1)
		VectorFrame.Vector.ScaleType = Enum.ScaleType.Fit
	end
	if p2.Currency ~= "Robux" and p2.SingleCopy then
		local v62 = v7:Connect(function() --[[ updating | Line: 187 | Upvalues: v3 (copy), t (ref), p2 (copy) ]]
			v3.Owned.Visible = t:OwnsLocalItem(p2)
		end)
		v3.Owned.Visible = t:OwnsLocalItem(p2)
		v6:Add(function() --[[ Line: 194 | Upvalues: v62 (copy) ]]
			v62:Disconnect()
		end)
	end
	VectorFrame.Vector.Image = v1.Data.Icon or ""
	Frame.ItemName.Text = v1.Data.Name or "???"
	Frame.TierName.Text = v2.Name
	Frame.TierName.UIGradient.Color = v2.TierColor
	v3.Glow.UIGradient.Color = v2.TierColor
	v3.UIGradient.Color = v2.TierColor
	GuiControl:Hook("Hold Button", v3.Button).Clicked:Connect(function() --[[ Line: 209 | Upvalues: p2 (copy), t (ref), p1 (copy) ]]
		if not (if p2.SingleCopy then t:OwnsLocalItem(p2) else false) then
			t:InitiatePurchase(p1, p2)
		end
	end)
	v3.LayoutOrder = p1
	v3.Parent = ScrollingFrame
end
function t.OwnsLocalItem(p1, p2) --[[ OwnsLocalItem | Line: 223 | Upvalues: ItemUtility (copy), InventoryMapping (copy), PlayerStatsUtility (copy), v2 (ref) ]]
	local v1 = ItemUtility.GetItemDataFromItemType(p2.Type, p2.Identifier)
	if v1 then
		return PlayerStatsUtility:GetItemFromInventory(v2, function(p1) --[[ Line: 233 | Upvalues: v1 (copy) ]]
			return p1.Id == v1.Data.Id
		end, InventoryMapping[p2.Type or "Items"]) and true or false
	else
		return false
	end
end
function t.GetMarketDataFromId(p1, p2) --[[ GetMarketDataFromId | Line: 244 | Upvalues: MarketItemData (copy) ]]
	for v1, v2 in MarketItemData do
		if v2.Id == p2 then
			return v2
		end
	end
end
function t.InitiatePurchase(p1, p2, p3) --[[ InitiatePurchase | Line: 254 | Upvalues: MarketplaceService (copy), LocalPlayer (copy), CurrencyUtility (copy), v4 (ref), v2 (ref), v1 (copy), TextNotificationController (copy), v7 (copy) ]]
	if p3.SkinCrate then
		return
	end
	if p3.ProductId then
		MarketplaceService:PromptProductPurchase(LocalPlayer, p3.ProductId)
		return
	end
	local Price = p3.Price
	if not Price then
		return
	end
	local v12 = CurrencyUtility:GetCurrency(p3.Currency)
	if not v12 then
		return
	end
	if v4 then
		return
	end
	v4 = true
	local v22 = nil
	if Price <= (v2:Get(v12.Path) or 0) then
		v22 = v1:InvokeServer(p2)
	else
		TextNotificationController:DeliverNotification({
			Type = "Text",
			Text = "You cannot afford this item!",
			TextColor = {
				R = 255,
				G = 0,
				B = 0
			}
		})
	end
	if not v22 then
		v4 = false
		return
	end
	v7:Fire()
	TextNotificationController:DeliverNotification({
		Type = "Text",
		Text = "Completed purchase!",
		TextColor = {
			R = 0,
			G = 255,
			B = 0
		}
	})
	v4 = false
end
function t.RenderCrateButton(p1, p2, p3) --[[ RenderCrateButton | Line: 306 | Upvalues: SkinCrates (copy), PolicyWrapper (copy), LocalPlayer (copy), ItemUtility (copy), TierUtility (copy), TweenService (copy), LootboxController (copy), GuiControl (copy) ]]
	local Frame = p2:WaitForChild("Frame")
	local v1 = SkinCrates[p3]
	if not v1 then
		return
	end
	if PolicyWrapper:GetPolicyInfo(LocalPlayer).ArePaidRandomItemsRestricted then
		Frame.RegionLocked.Visible = true
		return
	end
	local List = Frame:WaitForChild("Roller"):WaitForChild("List")
	local Grid = List:WaitForChild("Grid")
	local Options = Frame:WaitForChild("Options")
	for i, v in ipairs(v1.PurchaseOptions) do
		local v2 = Options:FindFirstChild((("Buy%d"):format(v.Quantity)))
		if v2 then
			if not v2:FindFirstChild("Inside") then
				return
			end
			if v.DevProductId then
				v2:SetAttribute("ProductId", v.DevProductId)
				v2:SetAttribute("DevProductId", v.DevProductId)
				v2:AddTag("DevProductPurchase")
				v2:AddTag("DevProductPrice")
			end
			v2.LayoutOrder = v.Quantity
		end
	end
	local ItemTemplate = Grid:FindFirstChild("ItemTemplate")
	if ItemTemplate then
		for i, v in ipairs(v1.Items) do
			local v3 = ItemTemplate:Clone()
			if v.Currency == "ItemReward" then
				local v4, v5, _, _2 = table.unpack(v.CurrencyRewardInfo)
				local v6 = ItemUtility.GetItemDataFromItemType(v4, v5)
				if v6 then
					v3.Vector.Image = v6.Data.Icon or ""
					local v7 = TierUtility:GetTier(v6.Data.Tier or 1)
					if v7 then
						v3.UIGradient.Color = v7.TierColor
						v3.UIStroke.UIGradient.Color = v7.TierColor
					end
					v3.Label.Text = ("%*%%"):format(math.round(v.Chance * 10) / 10)
				end
			end
			v3.LayoutOrder = v.Chance * 10000
			v3.Parent = Grid
		end
		ItemTemplate:Destroy()
	end
	task.spawn(function() --[[ Line: 382 | Upvalues: List (copy), v1 (copy), TweenService (ref) ]]
		local count = 1
		while true do
			count = count + 1
			local v12 = UDim2.fromOffset(10, 0)
			local v2 = UDim2.fromOffset(List.AbsoluteSize.X - List.Grid.UIGridLayout.AbsoluteContentSize.X - 10, 0)
			local v5 = TweenService:Create(List.Grid, TweenInfo.new(if #v1.Items <= 6 then 1 else #v1.Items, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
				Position = if count % 2 == 1 then v2 else v12
			})
			v5:Play()
			v5.Completed:Wait()
			v5:Destroy()
			task.wait(0.5)
		end
	end)
	local function promptDisplay() --[[ promptDisplay | Line: 408 | Upvalues: LootboxController (ref), p3 (copy), v1 (copy) ]]
		LootboxController:RenderDisplay(p3, v1)
	end
	GuiControl:Hook("Hold Button", p2).Clicked:Connect(promptDisplay)
	GuiControl:Hook("Hold Button", Frame.Inspect).Clicked:Connect(promptDisplay)
	Frame.RegionLocked.Visible = false
end
return t