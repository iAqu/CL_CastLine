-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local v1 = nil
local MarketplaceService = require(ReplicatedStorage.Packages.MarketplaceService)
local Client = require(ReplicatedStorage.Packages.Replion).Client
local Trove = require(ReplicatedStorage.Packages.Trove)
local Net = require(ReplicatedStorage.Packages.Net)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local GamePassUtility = require(ReplicatedStorage.Shared.GamePassUtility)
local CoinProductsUtility = require(ReplicatedStorage.Modules.CoinProductsUtility)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
require(ReplicatedStorage.Types.Modifiers)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local InterfaceHighlight = require(ReplicatedStorage.Modules.InterfaceHighlight)
local v2 = Net:RemoteFunction("PurchaseBait")
local v3 = Net:RemoteEvent("EquipBait")
local v4 = Players.LocalPlayer.PlayerGui:WaitForChild("Bait Shop")
local ScrollingFrame = v4.Main.Content.List.ScrollingFrame
local Tile = ScrollingFrame.Tile
Tile.Parent = nil
local t = {}
local v5 = Trove.new()
local v6 = nil
local v7 = TierUtility:GetTier("Exclusive")
local t2 = {
	Start = function(p1) --[[ Start | Line: 50 | Upvalues: v1 (ref), Client (copy), GuiControl (copy), v4 (copy), ItemUtility (copy), t (copy), v6 (ref), InterfaceHighlight (copy) ]]
		v1 = Client:WaitReplion("Data")
		GuiControl.GuiUnfocusedSignal:Connect(DestroyTiles)
		GuiControl.GuiFocusedSignal:Connect(function(p1) --[[ Line: 55 | Upvalues: v4 (ref), ItemUtility (ref), v1 (ref), t (ref), v6 (ref), InterfaceHighlight (ref) ]]
			if p1 ~= v4 then
				return
			end
			DestroyTiles()
			for i, v in ipairs((ItemUtility:GetBaits())) do
				DrawShopTile(v)
			end
			if not v1:Get({ "Quests", "Mainline", "Catch 5 Fish & Upgrade Bait!" }) then
				return
			end
			task.defer(function() --[[ Line: 66 | Upvalues: t (ref), v6 (ref), InterfaceHighlight (ref) ]]
				local v1 = t["Topwater Bait"]
				if not v1 then
					return
				end
				v6 = InterfaceHighlight.highlight(v1)
			end)
		end)
		v1:OnArrayInsert({ "Inventory", "Baits" }, function(p1, p2) --[[ Line: 77 | Upvalues: ItemUtility (ref) ]]
			local v1 = ItemUtility:GetBaitData(p2.Id)
			if v1 then
				MarkAsOwned(v1.Data.Name)
			end
		end)
	end,
	Check = function(p1, p2) --[[ Check | Line: 87 | Upvalues: v1 (ref) ]]
		for i, v in ipairs((v1:GetExpect({ "Inventory", "Baits" }))) do
			if v.Id == p2 then
				return false
			end
		end
		return true
	end
}
function DrawShopTile(p1) --[[ DrawShopTile | Line: 102 | Upvalues: GamePassUtility (copy), MarketplaceService (copy), t (copy), Tile (copy), TierUtility (copy), StringLibrary (copy), v7 (copy), PlayerStatsUtility (copy), t2 (copy), Soundbook (copy), TextNotificationController (copy), v1 (ref), CoinProductsUtility (copy), v2 (copy), v3 (copy), v5 (copy), ScrollingFrame (copy) ]]
	if p1.HiddenInShop then
		return
	end
	local Price = p1.Price
	local LinkedGamePass = p1.LinkedGamePass
	if LinkedGamePass then
		local v12 = GamePassUtility:GetGamePassIdFromName(LinkedGamePass)
		if not v12 then
			return
		end
		local v22, v32 = MarketplaceService:GetProductInfoAsync(v12, Enum.InfoType.GamePass):andThen(function(p1) --[[ Line: 116 ]]
			return p1.PriceInRobux
		end):catch(warn):await()
		if v22 and v32 then
			Price = v32
		end
	end
	if not Price then
		return
	end
	if t[p1.Data.Name] then
		return
	end
	local v4 = Tile:Clone()
	local Luck = v4.Padded.Bottom.Luck
	local Buy = v4.Padded.Buy
	local CurrencyFrame = v4.Padded.Top.CurrencyFrame
	v4.Padded.Top.Label.Text = p1.Data.Name or ""
	v4.BG.Vector.Image = p1.Data.Icon or ""
	local Tier = p1.Data.Tier
	local v52 = if Tier then TierUtility:GetTier(Tier) else Tier
	if v52 and v52.Tier > 1 then
		v4.BG.Glow.UIGradient.Color = v52.TierColor
		v4.BG.Glow.Visible = true
	else
		v4.BG.Glow.Visible = false
	end
	if LinkedGamePass then
		StringLibrary:AddCommas(Price)
		CurrencyFrame.Counter.Text = "GAMEPASS"
		CurrencyFrame.Counter.UIGradient.Color = v7.TierColor
		CurrencyFrame.Counter.UIStroke.Color = Color3.new(0/255, 0/255, 0/255)
		CurrencyFrame.VectorFrame.Visible = false
	else
		CurrencyFrame.Counter.Text = StringLibrary:Shorten(Price)
	end
	local Modifiers = p1.Modifiers
	if Modifiers then
		local count = 0
		for v72 in Modifiers do
			count = count + 1
		end
		v4.Padded.Bottom.Size = UDim2.fromScale(1, count / 10)
		v4.Padded.Bottom.UIGridLayout.CellSize = UDim2.fromScale(1, (math.min(1 / count, 0.9)))
		for v9, v10 in Modifiers do
			local v8
			local v11, v12 = PlayerStatsUtility:GetModifierDisplayName(v9)
			if v11 then
				v8 = if v11:find("Multi") then ("x%*"):format(math.round((1 + v10) * 10) / 10) else ("%*%%"):format((math.round(v10 * 100)))
				local v15 = Luck:Clone()
				v15.Label.Text = ("%*:"):format(v11)
				v15.Counter.Text = v8
				v15.Counter.TextColor3 = v12
				v15.Parent = v4.Padded.Bottom
			end
		end
	end
	Luck:Destroy()
	local v16 = nil
	if t2:Check(p1.Data.Id) then
		v16 = function() --[[ Line: 206 | Upvalues: Soundbook (ref), t2 (ref), p1 (copy), TextNotificationController (ref), LinkedGamePass (copy), GamePassUtility (ref), v1 (ref), CoinProductsUtility (ref), v2 (ref), v3 (ref) ]]
			Soundbook.Sounds.ThickClick:Play()
			if t2:Check(p1.Data.Id) then
				if LinkedGamePass and not GamePassUtility:ClientPromptGamepassFromName(LinkedGamePass) then
					return
				end
				local Price = p1.Price
				if Price then
					local v12 = v1:GetExpect("Coins")
					if v12 < Price then
						CoinProductsUtility:PurchaseBestCoinPack(v12, Price)
						return
					end
				end
				local v22, v32 = v2:InvokeServer(p1.Data.Id)
				if not v22 then
					return
				end
				Soundbook.Sounds.StorePurchase:Play()
				Soundbook.Sounds.CoinsChanged:Play()
				if not v32 then
					return
				end
				v3:FireServer(p1.Data.Id)
				TextNotificationController:DeliverNotification({
					Type = "Text",
					Text = "Equipped new Bait!",
					CustomDuration = 6,
					TextColor = {
						R = 0,
						G = 255,
						B = 255
					}
				})
			else
				local t = {
					Type = "Text"
				}
				t.Text = if LinkedGamePass then "You do not own this gamepass!" else "You already own this!"
				t.TextColor = {
					R = 255,
					G = 203,
					B = 16
				}
				return TextNotificationController:DeliverNotification(t)
			end
		end
	else
		task.defer(MarkAsOwned, p1.Data.Name)
	end
	if v16 then
		v5:Add(Buy.Activated:Connect(v16))
	end
	local function f17() --[[ Line: 259 | Upvalues: Buy (copy) ]]
		Buy.BackgroundColor3 = Color3.fromRGB(186, 186, 186)
		Buy.UIStroke.Color = Color3.fromRGB(255, 255, 255)
		Buy.Padded.Label.TextColor3 = Color3.fromRGB(20, 255, 79)
	end
	local function f18() --[[ Line: 265 | Upvalues: Buy (copy) ]]
		Buy.BackgroundColor3 = Color3.fromRGB(28, 186, 78)
		Buy.UIStroke.Color = Color3.fromRGB(20, 255, 79)
		Buy.Padded.Label.TextColor3 = Color3.fromRGB(255, 255, 255)
	end
	v5:Add(Buy.MouseEnter:Connect(f17))
	v5:Add(Buy.SelectionGained:Connect(f17))
	v5:Add(Buy.MouseLeave:Connect(f18))
	v5:Add(Buy.SelectionLost:Connect(f18))
	if LinkedGamePass then
		v4.LayoutOrder = 1000000 + Price
	else
		v4.LayoutOrder = math.ceil(Price / 100)
	end
	v4.Parent = ScrollingFrame
	t[p1.Data.Name] = v4
end
function MarkAsOwned(p1) --[[ MarkAsOwned | Line: 289 | Upvalues: t (copy), v6 (ref) ]]
	local v1 = t[p1]
	if not v1 then
		return
	end
	if p1 == "Topwater Bait" and v6 then
		v6()
		v6 = nil
	end
	local Top = v1.Padded.Top
	Top.CurrencyFrame.Visible = false
	Top.OwnedFrame.Visible = true
	if not v1.BG:FindFirstChild("BlackoutVector") then
		local BlackoutVector = v1.BG.Vector:Clone()
		BlackoutVector.Name = "BlackoutVector"
		BlackoutVector.ImageColor3 = Color3.fromRGB(0, 0, 0)
		BlackoutVector.ImageTransparency = 0.2
		BlackoutVector.Parent = v1.BG
	end
	v1.Padded.Bottom.Position = UDim2.fromScale(0, 1)
	v1.Padded.Buy.Visible = false
end
function DestroyTiles() --[[ DestroyTiles | Line: 319 | Upvalues: v5 (copy), v6 (ref), t (copy) ]]
	v5:Clean()
	if v6 then
		v6()
		v6 = nil
	end
	for v1, v2 in t do
		v2:Destroy()
	end
	table.clear(t)
end
return t2