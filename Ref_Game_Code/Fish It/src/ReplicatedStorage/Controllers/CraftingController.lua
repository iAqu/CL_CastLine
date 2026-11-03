-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Net = require(ReplicatedStorage.Packages.Net)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Replion = require(ReplicatedStorage.Packages.Replion)
require(ReplicatedStorage.Packages.MarketplaceService)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local CraftingItems = require(ReplicatedStorage.Shared.CraftingItems)
local InventoryMapping = require(ReplicatedStorage.Shared.InventoryMapping)
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local PolicyWrapper = require(ReplicatedStorage.Shared.PolicyWrapper)
local ModelProjectionController = require(ReplicatedStorage.Controllers.ModelProjectionController)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
require(ReplicatedStorage.Types.Modifiers)
local v1 = Net:RemoteEvent("InstantCraft")
local LocalPlayer = Players.LocalPlayer
local v2 = nil
local Crafting = LocalPlayer.PlayerGui:WaitForChild("Crafting")
local Right = Crafting.Frame.Frame.Right
local Left = Crafting.Frame.Left
local CraftTile = Left.ScrollingFrame.CraftTile
CraftTile.Parent = nil
local PaidTile = Left.ScrollingFrame.PaidTile
PaidTile.Parent = nil
local IngredientTile = Right.ScrollingFrame.IngredientTile
IngredientTile.Parent = nil
local v3 = nil
local v4 = nil
local v5 = Trove.new()
local t = {}
local function ArePaidRandomItemsRestricted() --[[ ArePaidRandomItemsRestricted | Line: 66 | Upvalues: PolicyWrapper (copy), LocalPlayer (copy) ]]
	local v1, v2 = PolicyWrapper:_getPolicy(LocalPlayer)
	if v1 and v2 then
		return v2.ArePaidRandomItemsRestricted
	else
		return true
	end
end
local function ReportUserError(p1) --[[ ReportUserError | Line: 75 | Upvalues: TextNotificationController (copy) ]]
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
function t.Start(p1) --[[ Start | Line: 83 | Upvalues: v2 (ref), Replion (copy), Right (copy), v1 (copy), t (copy), Soundbook (copy), GuiControl (copy), v3 (ref), ReportUserError (copy), CraftingItems (copy), Crafting (copy), PolicyWrapper (copy), LocalPlayer (copy) ]]
	v2 = Replion.Client:WaitReplion("Data")
	local Button = Right.Options.BuyButton.Button
	v1.OnClientEvent:Connect(function(p1) --[[ Line: 89 | Upvalues: t (ref), Soundbook (ref) ]]
		if p1 then
			t:Expand(p1)
			t:Show3D(p1)
			Soundbook.Sounds.CraftSound:Play()
		end
	end)
	GuiControl:Hook("Hold Button", Right.Options.CraftButton.Button).Clicked:Connect(function() --[[ Line: 100 | Upvalues: v3 (ref), ReportUserError (ref), CraftingItems (ref), v2 (ref), t (ref) ]]
		if not v3 then
			ReportUserError("Nothing was selected!")
			return
		end
		local v1 = CraftingItems.Items[v3]
		if not v1 then
			ReportUserError("Unknown item selected!")
			return
		end
		if not CraftingItems:Verify(v2, v1) then
			ReportUserError("You don\'t own all resources!")
			return
		end
		if v2:Find("CompletedQuests", "Kohana Gatekeeper") then
			t:Show3D(v3)
		else
			ReportUserError("You must complete the Kohana Gatekeeper quest!")
		end
	end)
	GuiControl.GuiUnfocusedSignal:Connect(function(p1) --[[ Line: 127 | Upvalues: Crafting (ref), t (ref) ]]
		if p1 ~= Crafting then
			return
		end
		t:Clear()
	end)
	local v12 = nil
	v12 = GuiControl.GuiFocusedSignal:Connect(function(p1) --[[ Line: 134 | Upvalues: Crafting (ref), v12 (ref), t (ref) ]]
		if p1 ~= Crafting then
			return
		end
		v12:Disconnect()
		t:_render()
		t:Expand("Winged Charm")
	end)
	local function registerPurchaseButton() --[[ registerPurchaseButton | Line: 144 | Upvalues: PolicyWrapper (ref), LocalPlayer (ref), Button (copy) ]]
		local v1, v2 = PolicyWrapper:_getPolicy(LocalPlayer)
		if if v1 and v2 then v2.ArePaidRandomItemsRestricted else true then
			Button:RemoveTag("DevProductPrice")
			Button:RemoveTag("DevProductPurchase")
			Button:SetAttribute("DevProductId", nil)
		else
			Button:SetAttribute("DevProductId", 3531959716)
			Button:AddTag("DevProductPrice")
			Button:AddTag("DevProductPurchase")
		end
	end
	if v2:Find("CompletedQuests", "Kohana Gatekeeper") then
		registerPurchaseButton()
	else
		local v22 = GuiControl:Hook("Hold Button", Button)
		v22.Clicked:Connect(function() --[[ Line: 163 | Upvalues: ReportUserError (ref) ]]
			ReportUserError("You must complete the Kohana Gatekeeper quest!")
		end)
		v2:OnArrayInsert("CompletedQuests", function(p1, p2) --[[ Line: 167 | Upvalues: v2 (ref), v22 (copy), registerPurchaseButton (copy) ]]
			if p2 ~= "Kohana Gatekeeper" and not v2:Find("CompletedQuests", "Kohana Gatekeeper") then
				return
			end
			v22:Destroy()
			registerPurchaseButton()
		end)
	end
end
function t._render(p1) --[[ _render | Line: 176 | Upvalues: PolicyWrapper (copy), LocalPlayer (copy), t (copy), CraftingItems (copy) ]]
	local v1, v2 = PolicyWrapper:_getPolicy(LocalPlayer)
	if not (if v1 and v2 then v2.ArePaidRandomItemsRestricted else true) then
		t:_renderItem("Astryx Core", "Gears", true)
	end
	for k, v in pairs(CraftingItems.Items) do
		t:_renderItem(k, v.Type, false)
	end
end
function t._renderItem(p1, p2, p3, p4) --[[ _renderItem | Line: 187 | Upvalues: ItemUtility (copy), TierUtility (copy), PaidTile (copy), CraftTile (copy), GuiControl (copy), t (copy), Left (copy) ]]
	local v1 = ItemUtility.GetItemDataFromItemType(p3, p2)
	if not v1 then
		return
	end
	local v2 = if v1.Probability then TierUtility:GetTier(v1.Probability.Chance) else TierUtility:GetTier(v1.Data.Tier)
	local v7 = (if p4 then PaidTile else CraftTile):Clone()
	if not p4 then
		local v8 = v7.UIStroke:FindFirstChildWhichIsA("UIGradient")
		if v8 then
			v8.Color = v2.TierColor
			v8:AddTag("AnimateTier")
		end
		local v9 = v7.Box.UIStroke:FindFirstChildWhichIsA("UIGradient")
		if v9 then
			v9.Color = v2.TierColor
			v9:AddTag("AnimateTier")
		end
		v7.Box.Glow.UIGradient.Color = v2.TierColor
		v7.Box.Glow.UIGradient:AddTag("AnimateTier")
	end
	v7.Box.Icon.Image = v1.Data.Icon or ""
	v7.ItemName.Text = v1.Data.Name or ""
	GuiControl:Hook("Hold Button", v7).Clicked:Connect(function() --[[ Line: 224 | Upvalues: t (ref), p2 (copy), p4 (copy) ]]
		t:Expand(p2, p4)
	end)
	local v10 = v2.Tier * -(if p4 then 10000 else 100)
	v7.LayoutOrder = v10 - string.len(v1.Data.Name)
	v7.Parent = Left.ScrollingFrame
end
function t.Clear(p1) --[[ Clear | Line: 232 | Upvalues: Right (copy), v5 (copy), v3 (ref) ]]
	Right.Visible = false
	v5:Clean()
	v3 = nil
end
function t.Expand(p1, p2, p3) --[[ Expand | Line: 240 | Upvalues: PolicyWrapper (copy), LocalPlayer (copy), ReportUserError (copy), v5 (copy), v3 (ref), CraftingItems (copy), RewardInfo (copy), Right (copy), ItemUtility (copy), TierUtility (copy), IngredientTile (copy), t (copy) ]]
	if p3 then
		local v1, v2 = PolicyWrapper:_getPolicy(LocalPlayer)
		if if v1 and v2 then v2.ArePaidRandomItemsRestricted else true then
			ReportUserError("You cannot purchase this in your region!")
			return
		end
	end
	v5:Clean()
	v3 = p2
	local tbl = {}
	if p3 then
		for k, v in pairs(CraftingItems.Weighted) do
			local v4 = RewardInfo.charmReward(k, 1)
			v4.Odds = v
			table.insert(tbl, v4)
		end
	else
		tbl = CraftingItems.Items[p2].Ingredients
	end
	Right.ScrollingFrame.Header.Text = if p3 then "RANDOM CHANCE" else "Required Materials"
	for k, v in pairs(tbl) do
		local v6
		local v7 = ItemUtility.GetItemDataFromItemType(v.Type, v.Identifier)
		if v7 then
			v6 = if v7.Probability then TierUtility:GetTierFromRarity(v7.Probability.Chance) else TierUtility:GetTier(v7.Data.Tier)
			if v6 then
				local v10 = v.Quantity or 1
				local v11 = IngredientTile:Clone()
				local Count = v11.Count
				local Paid = v11.Paid
				Paid.Visible = p3
				v11.UIGradient.Color = v6.TierColor
				v11.UIStroke.UIGradient.Color = v6.TierColor
				v11.Box.UIStroke.UIGradient.Color = v6.TierColor
				v11.Box.Glow.UIGradient.Color = v6.TierColor
				v11.Box.Icon.Image = v7.Data.Icon or ""
				v11.ItemName.Text = v7.Data.Name or ""
				if v6.Tier >= 5 then
					v11.UIStroke.UIGradient:AddTag("AnimateTier")
					v11.Box.UIStroke.UIGradient:AddTag("AnimateTier")
					v11.Box.Glow.UIGradient:AddTag("AnimateTier")
				else
					v11.UIStroke.UIGradient:RemoveTag("AnimateTier")
					v11.Box.UIStroke.UIGradient:RemoveTag("AnimateTier")
					v11.Box.Glow.UIGradient:RemoveTag("AnimateTier")
				end
				local v13 = t:ObserveTile(v.Type, v.Identifier, if p3 then function() --[[ Line: 325 | Upvalues: v (copy), Paid (copy), Count (copy) ]]
	local Odds = v.Odds
	if Odds then
		Paid.Text = ("%*%% Chance"):format(math.round(Odds * 100) / 100)
	else
		Paid.Text = "?? Chance"
	end
	Count.Text = "x1"
end else function(p1) --[[ Line: 336 | Upvalues: Count (copy), v10 (copy) ]]
	Count.Text = ("%* / %*"):format(p1, v10)
end)
				if v13 then
					v5:Add(v13)
				end
				v11.LayoutOrder = -v6.Tier
				v11.Parent = Right.ScrollingFrame
				v5:Add(v11)
				continue
			end
			warn((("[Error] Unable to draw tile for %* %* due to missing tier data!"):format(v.Type, v.Identifier)))
		end
	end
	Right.Options.BuyButton.Visible = p3 and true or false
	Right.Options.CraftButton.Visible = not p3
	Right.Visible = true
end
function t.Show3D(p1, p2, p3) --[[ Show3D | Line: 357 | Upvalues: v4 (ref), GuiControl (copy), ModelProjectionController (copy) ]]
	v4 = p2
	GuiControl:Close(true)
	ModelProjectionController:Focus("Charms", p2, p3)
	GuiControl:Lock()
end
function t.ObserveTile(p1, p2, p3, p4) --[[ ObserveTile | Line: 375 | Upvalues: InventoryMapping (copy), ItemUtility (copy), v2 (ref) ]]
	local v1 = nil
	local v22 = InventoryMapping[p2] or "Items"
	local v3 = ItemUtility.GetItemDataFromItemType(p2, p3)
	if v3 then
		local t = { "Inventory", v22 }
		local function itemChanged() --[[ itemChanged | Line: 383 | Upvalues: v2 (ref), t (copy), v3 (copy), p4 (copy) ]]
			local sum = 0
			local v1 = v2:Get(t)
			if v1 then
				for i, v in ipairs(v1) do
					if v.Id == v3.Data.Id then
						sum = sum + (v.Quantity or 1)
					end
				end
			end
			p4(sum)
		end
		task.defer(itemChanged)
		v1 = v2:OnChange(t, itemChanged)
	else
		warn((("Unable to observe charm tile with data: %* - %*!"):format(p2, p3)))
		p4(0)
	end
	return function() --[[ Line: 405 | Upvalues: v1 (ref) ]]
		if not v1 then
			return
		end
		v1:Disconnect()
	end
end
return t