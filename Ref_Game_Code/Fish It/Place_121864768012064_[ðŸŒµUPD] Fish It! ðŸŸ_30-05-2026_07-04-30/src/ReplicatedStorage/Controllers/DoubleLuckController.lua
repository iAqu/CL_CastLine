-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("StarterGui")
local Players = game:GetService("Players")
local MarketplaceService = require(ReplicatedStorage.Packages.MarketplaceService)
require(ReplicatedStorage.Packages.Observers)
local Thread = require(ReplicatedStorage.Packages.Thread)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Signal = require(ReplicatedStorage.Packages.Signal)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
local DoubleLuckProducts = require(ReplicatedStorage.Shared.Products.DoubleLuckProducts)
local GamePassUtility = require(ReplicatedStorage.Shared.GamePassUtility)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
Signal.new()
Signal.new()
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local Events = PlayerGui:WaitForChild("Events")
PlayerGui:WaitForChild("Exclusive Store")
PlayerGui:WaitForChild("!!! Server Luck")
local v1 = Events.Frame["Server Luck"]
local v2 = 0
local v3 = nil
local v4 = nil
local v5 = nil
for v6, v7 in DoubleLuckProducts do
	v2 = math.max(v7.Value, v2)
end
local v9 = 1
local v10 = 0
local t = {}
function FormatHHMMSS(p1) --[[ FormatHHMMSS | Line: 60 ]]
	local v1 = math.floor(p1 / 86400)
	local v2 = math.floor(p1 % 86400 / 3600)
	local v3 = math.floor(p1 % 3600 / 60)
	local v4 = p1 % 60
	if v1 >= 1 then
		return string.format("%02dd %02dh %02dm %02ds", v1, v2, v3, v4)
	end
	if v2 >= 1 then
		return string.format("%02dh %02dm %02ds", v2, v3, v4)
	else
		return string.format("%02dm %02ds", v3, v4)
	end
end
function GetServerProductId() --[[ GetServerProductId | Line: 75 | Upvalues: v5 (ref), DoubleLuckProducts (copy) ]]
	if v5:GetExpect("MaxLuck") then
		return 0
	end
	local v1 = v5:GetExpect("ServerMultiplier")
	for v2, v3 in DoubleLuckProducts do
		if v3.Value / 2 == v1 or v1 == 1 and v3.Value == 2 then
			return v2
		end
	end
	return 0
end
function UpdatePurchaseProductId() --[[ UpdatePurchaseProductId | Line: 92 | Upvalues: CollectionService (copy) ]]
	local v1 = GetServerProductId()
	if v1 > 0 then
		for i, v in ipairs(CollectionService:GetTagged("ServerLuckFrame")) do
			local PurchaseOptions = v.Inside.PurchaseOptions
			PurchaseOptions:SetAttribute("ProductId", v1)
			PurchaseOptions:AddTag("DevProductPrice")
			PurchaseOptions.Visible = true
		end
	else
		for i, v in ipairs(CollectionService:GetTagged("ServerLuckFrame")) do
			v.Inside.PurchaseOptions.Visible = false
		end
	end
end
function UpdateServerLuckCounters() --[[ UpdateServerLuckCounters | Line: 110 | Upvalues: v5 (ref), v2 (ref), PlayerStatsUtility (copy), LocalPlayer (copy), CollectionService (copy), v1 (copy) ]]
	local v12 = v5:GetExpect("ServerMultiplier")
	local v22 = v5:GetExpect("MaxLuck")
	local v3 = ("x%*"):format((math.floor(v12)))
	local v6 = ("x%*"):format((math.clamp(math.floor(v12 * 2), 1, v2)))
	local v8 = ("+%*%%"):format((math.round(PlayerStatsUtility:GetFriendLuck(LocalPlayer) * 100)))
	UpdatePurchaseProductId()
	local v9, v10, v11 = v3, v6, v8
	for i, v in ipairs((CollectionService:GetTagged("ServerLuckCounter"))) do
		v.Text = v9
	end
	for i, v in ipairs(CollectionService:GetTagged("ServerLuckFrame")) do
		v.Content.Glow.Visible = not v22
		v.Content.Visual.Arrow.Visible = not v22
		v.Content.Visual.BaseCounter.Visible = not v22
		v.Content.Visual.MaxLabel.Visible = v22
		v.Content.Visual.NextLuckCounter.Text = v10
	end
	v1.Server.LuckCounter.Text = v9
	v1.Friend.LuckCounter.Text = v11
end
function UpdateServerLuckTimers() --[[ UpdateServerLuckTimers | Line: 143 | Upvalues: v5 (ref), CollectionService (copy), v1 (copy) ]]
	local v2 = math.max(v5:GetExpect("Expires") - workspace:GetServerTimeNow(), 0)
	local v3 = "Ends: " .. FormatHHMMSS(v2)
	for i, v in ipairs(CollectionService:GetTagged("ServerLuckTimer")) do
		v.Text = v3
	end
	for i, v in ipairs(CollectionService:GetTagged("ServerLuckFrame")) do
		v.Inside.Toggles.Timer.Visible = v2 > 0
	end
	v1.Server.Visible = v2 > 0
end
function t.Start(p1) --[[ Start | Line: 160 | Upvalues: v3 (ref), Replion (copy), v5 (ref), v4 (ref), ReplicatedStorage (copy), v9 (ref), v10 (ref), CollectionService (copy), Players (copy), t (copy), Thread (copy), GuiControl (copy) ]]
	v3 = Replion.Client:WaitReplion("Data")
	v5 = Replion.Client:WaitReplion("ServerLuck")
	v4 = require(ReplicatedStorage.Controllers.GiftingController)
	v9 = v5:GetExpect("ServerMultiplier")
	v10 = v5:GetExpect("Expires")
	v5:OnChange("Expires", UpdateServerLuckTimers)
	CollectionService:GetInstanceAddedSignal("ServerLuckTimer"):Connect(UpdateServerLuckTimers)
	v5:OnChange("ServerMultiplier", UpdateServerLuckCounters)
	CollectionService:GetInstanceAddedSignal("ServerLuckCounter"):Connect(UpdateServerLuckCounters)
	Players.PlayerAdded:Connect(t.delayLuckCounter)
	Players.PlayerRemoving:Connect(t.delayLuckCounter)
	Thread:Execute(3, UpdateServerLuckTimers)
	UpdateServerLuckCounters()
	UpdateServerLuckTimers()
	for i, v in ipairs(CollectionService:GetTagged("ServerLuckFrame")) do
		local PurchaseOptions = v.Inside.PurchaseOptions
		GuiControl:Hook("Hold Button", PurchaseOptions.Buy).Clicked:Connect(t.purchaseServerLuckProduct)
		GuiControl:Hook("Hold Button", PurchaseOptions.Gift).Clicked:Connect(t.giftServerLuckProduct)
	end
	Thread:Execute(2, function() --[[ Line: 201 ]]
		UpdateServerLuckCounters()
	end)
end
function t.delayLuckCounter() --[[ delayLuckCounter | Line: 250 ]]
	task.wait(0.5 + math.random())
	UpdateServerLuckCounters()
end
function t.giftServerLuckProduct() --[[ giftServerLuckProduct | Line: 255 | Upvalues: GamePassUtility (copy), v4 (ref) ]]
	local v1 = GetServerProductId()
	if v1 == 0 then
		return
	end
	local v2 = GamePassUtility:GetGiftData(v1)
	if not v2 then
		return
	end
	if not v4 then
		return
	end
	v4:Open(v2.product)
end
function t.purchaseServerLuckProduct() --[[ purchaseServerLuckProduct | Line: 272 | Upvalues: MarketplaceService (copy), LocalPlayer (copy) ]]
	local v1 = GetServerProductId()
	if v1 ~= 0 then
		pcall(function() --[[ Line: 278 | Upvalues: MarketplaceService (ref), LocalPlayer (ref), v1 (copy) ]]
			return MarketplaceService:PromptProductPurchase(LocalPlayer, v1)
		end)
	end
end
return t