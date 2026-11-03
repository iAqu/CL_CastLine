-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Replion = require(ReplicatedStorage.Packages.Replion)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Net = require(ReplicatedStorage.Packages.Net)
local PolicyWrapper = require(ReplicatedStorage.Shared.PolicyWrapper)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local SkinCrates = require(ReplicatedStorage.SkinCrates)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
require(ReplicatedStorage.Modules.CurrencyUtility)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local CoinProductsUtility = require(ReplicatedStorage.Modules.CoinProductsUtility)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local v1 = nil
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local v2 = Net:RemoteFunction("PurchaseSkinCrate")
local v3 = Trove.new()
local Lootbox = PlayerGui:WaitForChild("Lootbox")
local LootboxDisplay = PlayerGui:WaitForChild("LootboxDisplay")
local ScrollingFrame = Lootbox.Main.Background.Items.ScrollingFrame
local Scrolling = LootboxDisplay.Main.Scroller.Scrolling
local Template = Scrolling.Template
Template.Parent = nil
local t = {}
function t.Start(p1) --[[ Start | Line: 44 | Upvalues: v1 (ref), Replion (copy), SkinCrates (copy), t (copy) ]]
	v1 = Replion.Client:WaitReplion("Data")
	for v12 in SkinCrates do
		t:Render(v12)
	end
end
function t.Render(p1, p2) --[[ Render | Line: 52 | Upvalues: SkinCrates (copy), ScrollingFrame (copy), PolicyWrapper (copy), LocalPlayer (copy), GuiControl (copy), v1 (ref), CoinProductsUtility (copy), v2 (copy), Soundbook (copy), StringLibrary (copy), ItemUtility (copy), TierUtility (copy), TweenService (copy), t (copy) ]]
	local v12 = SkinCrates[p2]
	if not v12 then
		return
	end
	local v22 = ScrollingFrame:FindFirstChild(p2)
	if not v22 then
		return
	end
	if PolicyWrapper:GetPolicyInfo(LocalPlayer).ArePaidRandomItemsRestricted then
		v22.RegionLocked.Visible = true
		return
	end
	local List = v22.Roller.List
	local Grid = List.Grid
	local ItemTemplate = Grid.ItemTemplate
	local Options = v22.Options
	for i, v in ipairs(v12.PurchaseOptions) do
		local v3 = Options:FindFirstChild((("Buy%d"):format(v.Quantity)))
		if v3 then
			local Inside = v3:FindFirstChild("Inside")
			if not Inside then
				return
			end
			if v.DevProductId then
				v3:SetAttribute("ProductId", v.DevProductId)
				v3:SetAttribute("DevProductId", v.DevProductId)
				v3:AddTag("DevProductPurchase")
				v3:AddTag("DevProductPrice")
			elseif v.Coins then
				local v4 = false
				GuiControl:Hook("Hold Button", v3).Clicked:Connect(function() --[[ Line: 96 | Upvalues: v4 (ref), v (copy), v1 (ref), CoinProductsUtility (ref), v2 (ref), p2 (copy), i (copy), Soundbook (ref) ]]
					if v4 then
						return
					end
					v4 = true
					task.delay(1, function() --[[ Line: 102 | Upvalues: v4 (ref) ]]
						v4 = false
					end)
					if v.Coins then
						local v12 = v1:GetExpect("Coins")
						if v12 < v.Coins then
							CoinProductsUtility:PurchaseBestCoinPack(v12, v.Coins)
							return
						end
					end
					if not v2:InvokeServer(p2, i) then
						return
					end
					local v22 = Soundbook.Sounds.CoinsChanged:Play()
					v22.Volume = 0.5
					v22.PlaybackSpeed = 1 + math.random() * 0.5
				end)
				Inside.Cost.Text = StringLibrary:AddCommas(v.Coins)
			end
			v3.LayoutOrder = v.Quantity
		end
	end
	for i, v in ipairs(v12.Items) do
		local v6 = ItemTemplate:Clone()
		if v.Currency == "ItemReward" then
			local v7, v8, _, _2 = table.unpack(v.CurrencyRewardInfo)
			local v9 = ItemUtility.GetItemDataFromItemType(v7, v8)
			if v9 then
				if v9.Data.NewIcon then
					v6.Vector.Position = UDim2.fromScale(0.5, 0.5)
					v6.Vector.AnchorPoint = Vector2.new(0.5, 0.5)
					v6.Vector.Size = UDim2.new(1.2, 0, 1.2, 0)
				end
				v6.Vector.Image = v9.Data.Icon or ""
				local v10 = TierUtility:GetTier(v9.Data.Tier or 1)
				if v10 then
					v6.UIGradient.Color = v10.TierColor
					v6.UIStroke.UIGradient.Color = v10.TierColor
				end
				v6.Label.Text = ("%*%%"):format(math.round(v.Chance * 10) / 10)
			end
		end
		v6.LayoutOrder = v.Chance * 10000
		v6.Parent = Grid
	end
	ItemTemplate:Destroy()
	task.spawn(function() --[[ Line: 168 | Upvalues: List (copy), v12 (copy), TweenService (ref) ]]
		local count = 1
		while true do
			count = count + 1
			local v1 = UDim2.fromOffset(10, 0)
			local v2 = UDim2.fromOffset(List.AbsoluteSize.X - List.Grid.UIGridLayout.AbsoluteContentSize.X - 10, 0)
			local v5 = TweenService:Create(List.Grid, TweenInfo.new(if #v12.Items <= 6 then 1 else #v12.Items, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
				Position = if count % 2 == 1 then v2 else v1
			})
			v5:Play()
			v5.Completed:Wait()
			v5:Destroy()
			task.wait(0.5)
		end
	end)
	local function promptDisplay() --[[ promptDisplay | Line: 193 | Upvalues: t (ref), p2 (copy), v12 (copy) ]]
		t:RenderDisplay(p2, v12)
	end
	GuiControl:Hook("Hold Button", v22).Clicked:Connect(promptDisplay)
	GuiControl:Hook("Hold Button", v22.Inspect).Clicked:Connect(promptDisplay)
	v22.RegionLocked.Visible = false
	v22.LayoutOrder = v12.Order or 1
end
function t.RenderDisplay(p1, p2, p3) --[[ RenderDisplay | Line: 205 | Upvalues: v3 (copy), LootboxDisplay (copy), Template (copy), ItemUtility (copy), TierUtility (copy), Scrolling (copy), GuiControl (copy) ]]
	v3:Clean()
	LootboxDisplay.Main.Top.Chest.Image = p3.Icon
	LootboxDisplay.Main.Top.Fade.Title.Text = p2
	for i, v in ipairs(p3.Items) do
		local v1 = v3:Clone(Template)
		if v.Currency == "ItemReward" then
			local v2, v32, _, _2 = table.unpack(v.CurrencyRewardInfo)
			local v4 = ItemUtility.GetItemDataFromItemType(v2, v32)
			if v4 then
				v1.Vector.Image = v4.Data.Icon or ""
				local v5 = TierUtility:GetTier(v4.Data.Tier or 1)
				if v5 then
					v1.Outline.UIStroke.UIGradient.Color = v5.TierColor
					v1.Outline.Gradient.UIGradient.Color = v5.TierColor
					v1.Glow.UIGradient.Color = v5.TierColor
					v1.Rays.UIGradient.Color = v5.TierColor
				end
				v1.Title.Text = v4.Data.Name or "???"
				v1.Odds.Text = ("%*%%"):format(math.round(v.Chance * 10) / 10)
			end
		end
		v1.LayoutOrder = v.Chance * 10000
		v1.Parent = Scrolling
	end
	GuiControl:Open("LootboxDisplay")
end
return t