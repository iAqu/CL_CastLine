-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local SoundService = game:GetService("SoundService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
game:GetService("TweenService")
local Players = game:GetService("Players")
local TimerService = require(ReplicatedStorage.Modules.ServicesLoader.TimerService)
local MyMarketplaceServiceClient = require(ReplicatedStorage.Modules.ServicesLoader.MyMarketplaceServiceClient)
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local v1 = PlayerGui:FindFirstChild("Frames") or PlayerGui:WaitForChild("Frames")
local Store = v1.Store
local Gift = v1.Gift
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local ServerLuckClient = require(ReplicatedStorage.Modules.ServicesLoader.ServerLuckClient)
local ClientProfile = require(ReplicatedStorage.Modules.ServicesLoader.ClientProfile)
require(ReplicatedStorage.Shared.Packages.Network)
local v2 = Trove.new()
local v3 = nil
local v4 = Trove.new()
local v5 = nil
local t = {
	[1] = {
		Product = 3571980293,
		Price = nil,
		Text = "x2 + 15M"
	},
	[2] = {
		Product = 3571980509,
		Price = nil,
		Text = "x4 + 15M"
	},
	[4] = {
		Product = 3571980660,
		Price = nil,
		Text = "x8 + 15M"
	},
	[8] = {
		Text = "x8 MAX!"
	}
}
local t2 = {
	{
		ProductID = 3585750158,
		Frame = Store.Content.ScrollingFrame.StarterPackHolder.BeginnerPack
	},
	{
		ProductID = 3585750289,
		Frame = Store.Content.ScrollingFrame.StarterPackHolder.GoldPack
	},
	{
		ProductID = 3585750405,
		Frame = Store.Content.ScrollingFrame.StarterPackHolder.PinkPack
	}
}
local t3 = {}
function LoadServerLuck() --[[ LoadServerLuck | Line: 74 | Upvalues: Store (copy), v2 (copy), TimerService (copy), ServerLuckClient (copy), t (copy), MarketplaceService (copy), LocalPlayer (copy) ]]
	local ServerLuck = Store.Content.ScrollingFrame.ServerLuck
	local BuyButton1 = ServerLuck.Content.BuyButton1
	local v1 = v2:Extend()
	local v22 = TimerService.AddTimer(ServerLuck.Content.Timer, ServerLuckClient.EndTime)
	local function UpdateServerLuck(p1) --[[ UpdateServerLuck | Line: 81 | Upvalues: ServerLuck (copy), v22 (copy), ServerLuckClient (ref), v1 (copy), t (ref), BuyButton1 (copy), MarketplaceService (ref), LocalPlayer (ref) ]]
		if p1 == 1 then
			ServerLuck.Content.Timer.Visible = false
			v22:Destroy()
		else
			ServerLuck.Content.Timer.Visible = true
			v22:UpdateEndTime(ServerLuckClient.EndTime)
		end
		v1:Clean()
		local v12 = t[p1]
		if v12.Product then
			ServerLuck.Content.SunHeader.Text = v12.Text
			BuyButton1.Visible = true
			BuyButton1.Label.Text = ("%*%*"):format(utf8.char(57346), v12.Price or "?")
			v1:Add(BuyButton1.Activated:Connect(function() --[[ Line: 103 | Upvalues: MarketplaceService (ref), LocalPlayer (ref), v12 (copy) ]]
				MarketplaceService:PromptProductPurchase(LocalPlayer, v12.Product)
			end))
		else
			BuyButton1.Visible = false
			if v12.Text then
				ServerLuck.Content.SunHeader.Text = v12.Text
			end
		end
	end
	v2:Add(function() --[[ Line: 109 | Upvalues: v22 (copy) ]]
		v22:Destroy()
	end)
	UpdateServerLuck(ServerLuckClient.Luck)
	v2:Connect(ServerLuckClient.Changed, UpdateServerLuck)
end
function InitPacks() --[[ InitPacks | Line: 117 | Upvalues: t2 (copy), LocalPlayer (copy), Store (copy) ]]
	for i, v in ipairs(t2) do
		v.Frame.Visible = false
	end
	LocalPlayer:GetAttributeChangedSignal("GiftTargetId"):Connect(function() --[[ Line: 122 | Upvalues: LocalPlayer (ref), Store (ref) ]]
		if LocalPlayer:GetAttribute("GiftTargetId") then
			Store.Content.ScrollingFrame.StarterPackHolder.Visible = false
		else
			UpdatePacks()
		end
	end)
end
function UpdatePacks() --[[ UpdatePacks | Line: 132 | Upvalues: t2 (copy), MyMarketplaceServiceClient (copy), Store (copy) ]]
	local v1 = nil
	for i, v in ipairs(t2) do
		if MyMarketplaceServiceClient.OT_Products[v.ProductID] then
			continue
		end
		v.Frame.Visible = true
		Store.Content.ScrollingFrame.StarterPackHolder.Visible = true
		v1 = true
		break
	end
	if not v1 then
		Store.Content.ScrollingFrame.StarterPackHolder.Visible = false
	end
end
function PackTimer() --[[ PackTimer | Line: 150 | Upvalues: Store (copy), TimerService (copy) ]]
	local Timer = Store.Content.ScrollingFrame.LuckyBlock.Content.Timer
	local v1 = TimerService.AddTimer(Timer, 1778418000, nil, function() --[[ Line: 153 | Upvalues: Timer (copy) ]]
		Timer.Text = "SOON!"
	end)
	return function() --[[ Line: 157 | Upvalues: v1 (copy) ]]
		v1:Destroy()
	end
end
function InitializePrices() --[[ InitializePrices | Line: 162 | Upvalues: t (copy), MarketplaceService (copy) ]]
	task.spawn(function() --[[ Line: 163 | Upvalues: t (ref), MarketplaceService (ref) ]]
		for k, v in pairs(t) do
			local v1, v2 = pcall(function() --[[ Line: 165 | Upvalues: MarketplaceService (ref), v (copy) ]]
				return MarketplaceService:GetProductInfoAsync(v.Product, Enum.InfoType.Product)
			end)
			if v1 then
				v.Price = v2.PriceInRobux
			end
		end
	end)
end
function InitializeConnections() --[[ InitializeConnections | Line: 176 | Upvalues: SoundService (copy), ClientProfile (copy) ]]
	LoadServerLuck()
	PackTimer()
	SoundService.Effects.ShopBell:Play()
	if ClientProfile.Device == ClientProfile.DeviceTypes.Console then
		HandleGamepad()
	end
end
function VisibilityChanged() --[[ VisibilityChanged | Line: 186 | Upvalues: Store (copy), v2 (copy) ]]
	if Store.Visible then
		InitializeConnections()
	else
		v2:Clean()
	end
end
function ShopInitialize() --[[ ShopInitialize | Line: 195 | Upvalues: Store (copy), v5 (ref) ]]
	Store.Header.Holder.ExitButton.Activated:Connect(function() --[[ Line: 196 | Upvalues: Store (ref), v5 (ref) ]]
		Store.Visible = false
		if v5 then
			v5()
		end
	end)
end
function HandleGamepad() --[[ HandleGamepad | Line: 204 | Upvalues: GuiService (copy), Store (copy), v2 (copy), UserInputService (copy) ]]
	GuiService:Select(Store.ScrollingFrame.LuckyBlock)
	v2:Add(UserInputService.InputBegan:Connect(function(p1, p2) --[[ Line: 207 | Upvalues: Store (ref) ]]
		if not p2 and p1.KeyCode == Enum.KeyCode.ButtonB then
			Store.Visible = false
		end
	end))
	v2:Add(function() --[[ Line: 217 | Upvalues: GuiService (ref) ]]
		GuiService.SelectedObject = nil
	end)
end
function LoadGifting() --[[ LoadGifting | Line: 222 | Upvalues: Store (copy), Gift (copy), v3 (ref), LocalPlayer (copy), v4 (copy), v5 (ref), Players (copy) ]]
	local Gift_2 = Store.Gift
	local Cancel = Store.Cancel
	local Close = Gift.Top.Main.Close
	local PlayerTemplate = Gift.ScrollingFrame:FindFirstChild("PlayerTemplate")
	PlayerTemplate.Visible = false
	Cancel.Visible = false
	local function ClearPlayers() --[[ ClearPlayers | Line: 231 | Upvalues: Gift (ref), PlayerTemplate (copy) ]]
		Gift.NoPlayers.Visible = false
		for v1, v2 in Gift.ScrollingFrame:GetChildren() do
			if v2 ~= PlayerTemplate and v2:IsA(PlayerTemplate.ClassName) then
				v2:Destroy()
			end
		end
	end
	v5 = function() --[[ StopGifting | Line: 240 | Upvalues: v3 (ref), LocalPlayer (ref), v4 (ref), ClearPlayers (copy), Gift (ref), Cancel (copy), Gift_2 (copy) ]]
		v3 = nil
		LocalPlayer:SetAttribute("GiftTargetId", nil)
		v4:Clean()
		ClearPlayers()
		Gift.Visible = false
		Cancel.Visible = false
		Gift_2.Visible = true
	end
	local function SelectPlayer(p1) --[[ SelectPlayer | Line: 252 | Upvalues: v3 (ref), LocalPlayer (ref), Gift (ref), Store (ref), Cancel (copy), Gift_2 (copy) ]]
		v3 = p1
		LocalPlayer:SetAttribute("GiftTargetId", p1.UserId)
		Gift.Visible = false
		Store.Visible = true
		Cancel.Visible = true
		Gift_2.Visible = false
		Cancel.GiftingTo.Text = ("GIFTING TO: %*"):format(p1.DisplayName)
	end
	local function LoadPlayers() --[[ LoadPlayers | Line: 262 | Upvalues: ClearPlayers (copy), Players (ref), LocalPlayer (ref), PlayerTemplate (copy), Gift (ref), v4 (ref), v3 (ref), Store (ref), Cancel (copy), Gift_2 (copy) ]]
		ClearPlayers()
		local count = 0
		for v1, v2 in Players:GetPlayers() do
			if v2 ~= LocalPlayer then
				local v32 = PlayerTemplate:Clone()
				v32.PlayerName.Text = v2.DisplayName
				v32.Visible = true
				v32.Parent = Gift.ScrollingFrame
				task.spawn(function() --[[ Line: 279 | Upvalues: Players (ref), v2 (copy), v32 (copy) ]]
					local v1, v22 = pcall(function() --[[ Line: 280 | Upvalues: Players (ref), v2 (ref) ]]
						return Players:GetUserThumbnailAsync(v2.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
					end)
					if v1 and v22 then
						v32.Main.Icon.Image = v22
					end
				end)
				v4:Add(v32.GiftButton.Activated:Connect(function() --[[ Line: 293 | Upvalues: v2 (copy), Players (ref), v3 (ref), LocalPlayer (ref), Gift (ref), Store (ref), Cancel (ref), Gift_2 (ref) ]]
					if v2 and v2.Parent == Players then
						local v1 = v2
						v3 = v1
						LocalPlayer:SetAttribute("GiftTargetId", v1.UserId)
						Gift.Visible = false
						Store.Visible = true
						Cancel.Visible = true
						Gift_2.Visible = false
						Cancel.GiftingTo.Text = ("GIFTING TO: %*"):format(v1.DisplayName)
					end
				end))
				count = count + 1
			end
		end
		local NoPlayers = Gift.NoPlayers
		NoPlayers.Visible = count == 0
	end
	Gift_2.Activated:Connect(function() --[[ Line: 304 | Upvalues: Store (ref), Gift (ref), LoadPlayers (copy) ]]
		Store.Visible = false
		Gift.Visible = true
		LoadPlayers()
	end)
	Cancel.Activated:Connect(function() --[[ Line: 310 | Upvalues: v3 (ref), LocalPlayer (ref), v4 (ref), ClearPlayers (copy), Gift (ref), Cancel (copy), Gift_2 (copy) ]]
		v3 = nil
		LocalPlayer:SetAttribute("GiftTargetId", nil)
		v4:Clean()
		ClearPlayers()
		Gift.Visible = false
		Cancel.Visible = false
		Gift_2.Visible = true
	end)
	Close.Activated:Connect(function() --[[ Line: 314 | Upvalues: v3 (ref), LocalPlayer (ref), v4 (ref), ClearPlayers (copy), Gift (ref), Cancel (copy), Gift_2 (copy), Store (ref) ]]
		v3 = nil
		LocalPlayer:SetAttribute("GiftTargetId", nil)
		v4:Clean()
		ClearPlayers()
		Gift.Visible = false
		Cancel.Visible = false
		Gift_2.Visible = true
		Store.Visible = true
	end)
end
function t3.OpenStore(p1) --[[ OpenStore | Line: 322 | Upvalues: Store (copy) ]]
	Store.Content.ScrollingFrame.CanvasPosition = Vector2.new(0, 0)
	Store.Visible = true
end
function t3._init() --[[ _init | Line: 329 | Upvalues: MyMarketplaceServiceClient (copy), Store (copy) ]]
	ShopInitialize()
	LoadGifting()
	InitializePrices()
	VisibilityChanged()
	InitPacks()
	UpdatePacks()
	MyMarketplaceServiceClient.OneTimeChanged:Connect(UpdatePacks)
	Store:GetPropertyChangedSignal("Visible"):Connect(VisibilityChanged)
end
return t3