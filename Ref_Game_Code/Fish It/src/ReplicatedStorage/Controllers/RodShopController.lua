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
require(ReplicatedStorage.Shared.PlayerStatsUtility)
local UserPriority = require(ReplicatedStorage.Shared.UserPriority)
require(ReplicatedStorage.Types.Modifiers)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local InterfaceHighlight = require(ReplicatedStorage.Modules.InterfaceHighlight)
local v2 = Net:RemoteFunction("PurchaseFishingRod")
local v3 = Net:RemoteEvent("EquipItem")
local v4 = Players.LocalPlayer.PlayerGui:WaitForChild("Rod Shop")
local ScrollingFrame = v4.Main.Content.List.ScrollingFrame
local Tile = ScrollingFrame.Tile
Tile.Parent = nil
local t = {}
local v5 = Trove.new()
local v6 = nil
local v7 = TierUtility:GetTier("Exclusive")
local t2 = {}
function t2.Start(p1) --[[ Start | Line: 52 | Upvalues: v1 (ref), Client (copy), GuiControl (copy), v4 (copy), ItemUtility (copy), t (copy), v6 (ref), InterfaceHighlight (copy), t2 (copy) ]]
	v1 = Client:WaitReplion("Data")
	GuiControl.GuiUnfocusedSignal:Connect(DestroyTiles)
	GuiControl.GuiFocusedSignal:Connect(function(p1) --[[ Line: 57 | Upvalues: v4 (ref), ItemUtility (ref), v1 (ref), t (ref), v6 (ref), InterfaceHighlight (ref) ]]
		if p1 ~= v4 then
			return
		end
		DestroyTiles()
		for i, v in ipairs((ItemUtility:GetFishingRods())) do
			DrawShopTile(v)
		end
		if not v1:Get({ "Quests", "Mainline", "Catch Fish & Upgrade Rod!" }) then
			return
		end
		task.defer(function() --[[ Line: 68 | Upvalues: t (ref), v6 (ref), InterfaceHighlight (ref) ]]
			local v1 = t["Luck Rod"]
			if not v1 then
				return
			end
			v6 = InterfaceHighlight.highlight(v1)
		end)
	end)
	task.delay(4, function() --[[ Line: 79 | Upvalues: v1 (ref), t2 (ref) ]]
		game:GetService("UserInputService").InputBegan:Wait()
		if not v1:Get("AutoFishing") then
			t2:GetTopThreeRods()
		end
	end)
	v1:OnArrayInsert({ "Inventory", "Fishing Rods" }, function(p1, p2) --[[ Line: 94 | Upvalues: ItemUtility (ref) ]]
		local v1 = ItemUtility.GetItemDataFromItemType("Fishing Rods", p2.Id)
		if v1 then
			MarkAsOwned(v1.Data.Name)
		end
	end)
end
function t2.GetTopThreeRods(p1) --[[ GetTopThreeRods | Line: 105 | Upvalues: UserPriority (copy), ItemUtility (copy), v1 (ref), t2 (copy), TextNotificationController (copy) ]]
	if UserPriority:IsTradePlaza() then
		return
	end
	local v12 = ItemUtility:GetFishingRods()
	local list = {}
	local v2 = 0
	local v3 = 0
	for i, v in ipairs(v12) do
		if not (v.HiddenInShop or v.LinkedGamePass) then
			local v4 = v.Price or 0
			if not (v4 < 1) then
				table.insert(list, {
					Id = v.Data.Id,
					Price = v4
				})
			end
		end
	end
	table.sort(list, function(p1, p2) --[[ Line: 135 ]]
		return p1.Price > p2.Price
	end)
	local v5 = v1:GetExpect({ "Coins" })
	local v6 = Color3.fromRGB(0, 255, 255)
	local count = 0
	for i, v in ipairs(list) do
		if count >= 3 then
			break
		end
		if t2:Check(v.Id) and not (v5 < v.Price) then
			local v7 = ItemUtility.GetItemDataFromItemType("Fishing Rods", v.Id)
			if v7 then
				count = count + 1
				local v8, _, _2 = v6:ToHSV()
				local v9 = Color3.fromHSV(v8, 1 - (count - 1) * 0.2, 1 - (count - 1) * 0.2)
				TextNotificationController:DeliverNotification({
					Type = "Text",
					CustomDuration = 5,
					Text = ("You can now afford the <b>%*</b>!"):format(v7.Data.Name),
					TextColor = {
						R = v9.R * 255,
						G = v9.G * 255,
						B = v9.B * 255
					}
				})
			end
		end
	end
	for i, v in ipairs(list) do
		if not t2:Check(v.Id) then
			v2 = i
			break
		end
	end
	v1:OnChange({ "Coins" }, function(p1, p2) --[[ Line: 206 | Upvalues: v2 (ref), list (copy), v3 (ref), ItemUtility (ref), TextNotificationController (ref) ]]
		if not v2 then
			return
		end
		if v2 == 0 then
			return
		end
		if v2 - 1 == 0 then
			return
		end
		local v1 = list[v2 - 1]
		if not v1 then
			return
		end
		if v1.Id == v3 then
			return
		end
		local v22 = ItemUtility.GetItemDataFromItemType("Fishing Rods", v1.Id)
		if not v22 then
			return
		end
		local v32 = v22.Price or 0
		if v32 == 0 then
			return
		end
		if not (v32 <= p1) then
			return
		end
		v3 = v1.Id
		v2 = v2 - 1
		TextNotificationController:DeliverNotification({
			Type = "Text",
			CustomDuration = 5,
			Text = ("You can now afford the <b>%*</b>!"):format(v22.Data.Name),
			TextColor = {
				R = 255,
				G = 255,
				B = 0
			}
		})
	end)
end
function t2.Check(p1, p2) --[[ Check | Line: 248 | Upvalues: v1 (ref) ]]
	for i, v in ipairs((v1:GetExpect({ "Inventory", "Fishing Rods" }))) do
		if v.Id == p2 then
			return false
		end
	end
	return true
end
function DrawShopTile(p1) --[[ DrawShopTile | Line: 263 | Upvalues: GamePassUtility (copy), MarketplaceService (copy), t (copy), Tile (copy), StringLibrary (copy), v7 (copy), TierUtility (copy), t2 (copy), Soundbook (copy), TextNotificationController (copy), v1 (ref), CoinProductsUtility (copy), v2 (copy), v3 (copy), v5 (copy), ScrollingFrame (copy) ]]
	if p1.HiddenInShop then
		return
	end
	local v12 = p1.Price or 0
	local LinkedGamePass = p1.LinkedGamePass
	if LinkedGamePass then
		local v22 = GamePassUtility:GetGamePassIdFromName(LinkedGamePass)
		if not v22 then
			return
		end
		local v32, v4 = MarketplaceService:GetProductInfoAsync(v22, Enum.InfoType.GamePass):andThen(function(p1) --[[ Line: 277 ]]
			return p1.PriceInRobux
		end):catch(warn):await()
		if v32 and v4 then
			v12 = v4
		end
	end
	if v12 < 1 then
		return
	end
	if t[p1.Data.Name] then
		return
	end
	local v52 = Tile:Clone()
	local Buy = v52.Padded.Buy
	local CurrencyFrame = v52.Padded.Top.CurrencyFrame
	v52.Padded.Top.Label.Text = p1.Data.Name or ""
	v52.BG.Vector.Image = p1.Data.Icon or ""
	if LinkedGamePass then
		StringLibrary:AddCommas(v12)
		CurrencyFrame.Counter.Text = "GAMEPASS"
		CurrencyFrame.Counter.UIGradient.Color = v7.TierColor
		CurrencyFrame.Counter.UIStroke.Color = Color3.new(0/255, 0/255, 0/255)
		CurrencyFrame.VectorFrame.Visible = false
	else
		CurrencyFrame.Counter.Text = StringLibrary:Shorten(v12)
	end
	local RollData = p1.RollData
	if RollData then
		local v8 = math.floor((RollData.BaseLuck or 1) * 100)
		local v9 = if p1.VisualClickPowerPercent then math.round(p1.VisualClickPowerPercent * 100) else math.round(((p1.ClickPower or 0.05) * 25) ^ 2.5)
		local v122 = StringLibrary:AddWeight(p1.MaxWeight or 5)
		v52.Padded.Bottom.Luck.Counter.Text = ("%*%%"):format(v8)
		v52.Padded.Bottom.Speed.Counter.Text = ("%*%%"):format(v9)
		v52.Padded.Bottom.Weight.Counter.Text = v122
	end
	local Tier = p1.Data.Tier
	local v13 = if Tier then TierUtility:GetTier(Tier) else Tier
	if v13 and Tier > 1 then
		v52.BG.Glow.UIGradient.Color = v13.TierColor
		v52.BG.Glow.Visible = true
	else
		v52.BG.Glow.Visible = false
	end
	local v14 = nil
	if t2:Check(p1.Data.Id) then
		v14 = function() --[[ Line: 342 | Upvalues: Soundbook (ref), t2 (ref), p1 (copy), TextNotificationController (ref), LinkedGamePass (copy), GamePassUtility (ref), v1 (ref), CoinProductsUtility (ref), v2 (ref), v3 (ref) ]]
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
				v3:FireServer(v32, "Fishing Rods")
				TextNotificationController:DeliverNotification({
					Type = "Text",
					Text = "Equipped new Fishing Rod!",
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
	local function f15() --[[ Line: 390 | Upvalues: Buy (copy) ]]
		Buy.BackgroundColor3 = Color3.fromRGB(186, 186, 186)
		Buy.UIStroke.Color = Color3.fromRGB(255, 255, 255)
		Buy.Padded.Label.TextColor3 = Color3.fromRGB(20, 255, 79)
	end
	local function f16() --[[ Line: 396 | Upvalues: Buy (copy) ]]
		Buy.BackgroundColor3 = Color3.fromRGB(28, 186, 78)
		Buy.UIStroke.Color = Color3.fromRGB(20, 255, 79)
		Buy.Padded.Label.TextColor3 = Color3.fromRGB(255, 255, 255)
	end
	if v14 then
		v5:Add(Buy.Activated:Connect(v14))
	end
	v5:Add(Buy.MouseEnter:Connect(f15))
	v5:Add(Buy.SelectionGained:Connect(f15))
	v5:Add(Buy.MouseLeave:Connect(f16))
	v5:Add(Buy.SelectionLost:Connect(f16))
	if LinkedGamePass then
		v52.LayoutOrder = 10000000 + v12
	else
		v52.LayoutOrder = math.ceil(v12 / 100)
	end
	v52.Parent = ScrollingFrame
	t[p1.Data.Name] = v52
end
function MarkAsOwned(p1) --[[ MarkAsOwned | Line: 428 | Upvalues: t (copy), v6 (ref) ]]
	local v1 = t[p1]
	if not v1 then
		return
	end
	if p1 == "Luck Rod" and v6 then
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
function DestroyTiles() --[[ DestroyTiles | Line: 458 | Upvalues: v5 (copy), v6 (ref), t (copy) ]]
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