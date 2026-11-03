-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local spr = require(ReplicatedStorage.Packages.spr)
require(ReplicatedStorage.Packages.Net)
local Signal = require(ReplicatedStorage.Packages.Signal)
require(ReplicatedStorage.Packages.Replion)
local MarketplaceService = require(ReplicatedStorage.Packages.MarketplaceService)
require(ReplicatedStorage.Potions)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
require(ReplicatedStorage.Types.Modifiers)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local LocalPlayer = Players.LocalPlayer
local v1 = LocalPlayer.PlayerGui:WaitForChild("Potion Shop")
local Left = v1.Main.Content.List.Left
local v2 = Left.Options["Buy 1"]
local v3 = Left.Options["Buy 10"]
local Right = v1.Main.Content.List.Right
local Tile = Right.Tile
Tile.Parent = nil
local v4 = nil
local v5 = Signal.new()
local t = {}
function t.Init(p1) --[[ Init | Line: 41 | Upvalues: GuiControl (copy), v2 (copy), MarketplaceService (copy), LocalPlayer (copy), v3 (copy), ItemUtility (copy), TierUtility (copy), Tile (copy), t (copy), Right (copy), v5 (copy), v1 (copy) ]]
	GuiControl:Hook("Hold Button", v2).Clicked:Connect(function() --[[ Line: 43 | Upvalues: v2 (ref), MarketplaceService (ref), LocalPlayer (ref) ]]
		local v1 = v2:GetAttribute("ProductId")
		if not (v1 and v1 > 0) then
			return
		end
		MarketplaceService:PromptProductPurchase(LocalPlayer, v1)
	end)
	GuiControl:Hook("Hold Button", v3).Clicked:Connect(function() --[[ Line: 51 | Upvalues: v3 (ref), MarketplaceService (ref), LocalPlayer (ref) ]]
		local v1 = v3:GetAttribute("ProductId")
		if not (v1 and v1 > 0) then
			return
		end
		MarketplaceService:PromptProductPurchase(LocalPlayer, v1)
	end)
	for i, v in ipairs(ItemUtility:GetPotions()) do
		if not v.Hidden and v.SingleProductId then
			local v12 = TierUtility:GetTier(v.Data.Tier)
			if v12 then
				local v22 = Tile:Clone()
				MarketplaceService:GetProductInfoAsync(v.SingleProductId, Enum.InfoType.Product):andThen(function(p1) --[[ Line: 76 | Upvalues: v22 (copy) ]]
					v22.Content.Cost.Text = ("\238\128\130%*"):format(if p1 then tostring(p1.PriceInRobux) else "???")
					v22.LayoutOrder = p1.PriceInRobux or 0
				end):catch(function() --[[ Line: 82 | Upvalues: v22 (copy) ]]
					v22.Content.Cost.Visible = false
					v22.LayoutOrder = 0
				end)
				v22.Content.ItemName.Text = v.Data.Name
				v22.Content.TierName.Text = ("Tier %*"):format(v12.Tier - 1)
				v22.Content.TierName.UIGradient.Color = v12.TierColor
				v22.Start.Vector.Image = v.Data.Icon or ""
				GuiControl:Hook("Hold Button", v22).Clicked:Connect(function() --[[ Line: 92 | Upvalues: t (ref), v (copy) ]]
					t:ChangePotion(v.Data.Id)
				end)
				v22.Parent = Right
			end
		end
	end
	v5:Connect(function(p1) --[[ Line: 100 | Upvalues: ItemUtility (ref), t (ref) ]]
		local v1 = ItemUtility:GetPotionData(p1)
		if not v1 then
			return
		end
		t:UpdateProducts(v1)
	end)
	GuiControl.GuiFocusedSignal:Once(function(p1) --[[ Line: 108 | Upvalues: v1 (ref), t (ref) ]]
		if p1 ~= v1 then
			return
		end
		t:ChangePotion(1)
	end)
	v2:AddTag("DevProductPrice")
	v3:AddTag("DevProductPrice")
	task.delay(3, function() --[[ Line: 119 | Upvalues: t (ref) ]]
		t:ChangePotion(1)
	end)
end
function t.ChangePotion(p1, p2) --[[ ChangePotion | Line: 124 | Upvalues: v4 (ref), v5 (copy) ]]
	if p2 ~= v4 then
		v4 = p2
		v5:Fire(p2)
	end
end
function t.UpdateProducts(p1, p2) --[[ UpdateProducts | Line: 133 | Upvalues: Left (copy), t (copy), TierUtility (copy), spr (copy), v2 (copy), v3 (copy) ]]
	if p2.Infinite then
		Left.Display.TimerFrame.Counter.Text = "Duration: \226\136\158"
	else
		local Duration = p2.Duration
		local v1 = math.floor(Duration % 60)
		local v22 = (Duration - v1) / 60
		if v22 >= 1 then
			Left.Display.TimerFrame.Counter.Text = ("Duration: %*m %*s"):format(math.floor(v22), (math.floor(v1)))
		else
			Left.Display.TimerFrame.Counter.Text = ("Duration: %*s"):format((math.floor(v1)))
		end
	end
	Left.Display.Vector.Image = p2.Data.Icon
	Left.Display.Header.Text = p2.Data.Name
	Left.Display.Description.Text = t:FormatModifiers(p2.Modifiers)
	local v4 = TierUtility:GetTier(p2.Data.Tier)
	if v4 then
		spr.stop(Left.Display.Description.UIGradient)
		spr.target(Left.Display.Description.UIGradient, 1, 3, {
			Color = v4.TierColor
		})
	end
	v2:SetAttribute("ProductId", p2.SingleProductId or 0)
	v3:SetAttribute("ProductId", p2.TenProductId or 0)
end
function t.FormatModifiers(p1, p2) --[[ FormatModifiers | Line: 171 | Upvalues: PlayerStatsUtility (copy) ]]
	local t = {}
	for v1, v2 in p2 do
		if typeof(v2) == "number" then
			local v3, _ = PlayerStatsUtility:GetModifierDisplayName(v1)
			if v3 then
				table.insert(t, (("+%*%% %*"):format(math.round(v2 * 10000) / 100, v3)))
			end
		end
	end
	return table.concat(t, ", ")
end
return t