-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
local TokenShardsAd = PlayerGui:WaitForChild("TokenShardsAd")
local WatchAd = TokenShardsAd.Container.Inside.WatchAd
local Blocked = TokenShardsAd.Container.Inside.Blocked
local Claimed = TokenShardsAd.Container.Inside.Claimed
local TokenShardsAdFrame = PlayerGui:WaitForChild("Quest").List.TokenShardsAdFrame
local TokenShardsAd_2 = TokenShardsAdFrame.TokenShardsAd
local Net = require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
local CurrencyUtility = require(ReplicatedStorage.Modules.CurrencyUtility)
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
local UserPriority = require(ReplicatedStorage.Shared.UserPriority)
local AdsUtility = require(ReplicatedStorage.Shared.Products.AdsUtility)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local v1 = nil
local v2 = CurrencyUtility:GetCurrency(RewardInfo.BattlepassCurrency)
local t = {
	[Enum.ShowAdResult.AdNotReady] = "Unable to load video ad!",
	[Enum.ShowAdResult.InternalError] = "Roblox is having difficulties :(",
	[Enum.ShowAdResult.AdAlreadyShowing] = "You are already watching an ad",
	[Enum.ShowAdResult.InsufficientMemory] = "Your device does not have enough memory!"
}
local t2 = {
	token_shards = {
		ProductName = "1 Token Shard",
		Header = "Earn Tokens",
		Quantity = 1,
		MiddleIcon = "rbxassetid://99674539069799",
		TopIcon = "rbxassetid://108409956690521",
		Bottom = { "TokenShards", "Tokens" }
	},
	battlepass_currency = {
		ProductName = "100 Battlepass Currency",
		Quantity = 100,
		Header = ("Earn %*"):format(v2.Singular or "N/A"),
		MiddleIcon = v2.Icon or "",
		TopIcon = v2.Icon or "",
		Bottom = { "BattlepassCurrency" }
	}
}
local v3 = nil
local v4 = nil
local v5 = nil
local v6 = "token_shards"
local v7 = Net:RemoteEvent("PlayVideoAd")
local v8 = Net:RemoteEvent("RelayVideoAd")
local t3 = {}
function t3.Start(p1) --[[ Start | Line: 78 | Upvalues: v1 (ref), Replion (copy), GuiControl (copy), t2 (copy), TokenShardsAd (copy), t3 (copy), v8 (copy), TextNotificationController (copy), v5 (ref), t (copy), TokenShardsAd_2 (copy), v4 (ref) ]]
	v1 = Replion.Client:WaitReplion("Data")
	GuiControl:BeforeHook("TokenShardsAd", function(p1) --[[ Line: 81 | Upvalues: t2 (ref), TokenShardsAd (ref), t3 (ref) ]]
		local v1 = t2[p1]
		if not v1 then
			return
		end
		TokenShardsAd.Container.Top.Frame.VectorFrame.Vector.Image = v1.TopIcon
		TokenShardsAd.Container.Top.Frame.Header.Text = v1.Header
		TokenShardsAd.Container.Inside.Exchange.Vector.Image = v1.MiddleIcon
		TokenShardsAd.Container.Inside.Exchange.Label.Text = ("x%*"):format(v1.Quantity)
		for i, v in ipairs(TokenShardsAd.Container.Bottom:GetChildren()) do
			if v:IsA("Frame") then
				v.Visible = table.find(v1.Bottom, v.Name)
			end
		end
		t3:SetSource(v1.ProductName)
	end)
	v8.OnClientEvent:Connect(function(p1, p2) --[[ Line: 104 | Upvalues: TextNotificationController (ref), v5 (ref), t (ref), t3 (ref) ]]
		if typeof(p2) == "string" then
			TextNotificationController:DeliverNotification({
				Type = "Text",
				Text = ("Unable to play ad: %*"):format(p2),
				TextColor = {
					R = 255,
					G = 0,
					B = 0
				}
			})
			v5 = nil
		else
			local v1 = t[p2]
			if v1 then
				TextNotificationController:DeliverNotification({
					Type = "Text",
					Text = v1,
					TextColor = {
						R = 255,
						G = 0,
						B = 0
					}
				})
			end
			v5 = p2
		end
		t3:Unlock()
		t3:RefreshAdsWatched(false)
	end)
	GuiControl:Hook("Hold Button", TokenShardsAd_2.Close).Clicked:Connect(function() --[[ Line: 130 | Upvalues: v4 (ref), t3 (ref) ]]
		v4 = true
		t3:RefreshAdButton(false)
	end)
	GuiControl:Hook("Hold Button", TokenShardsAd.Container.Inside.WatchAd.WatchAdButton).Clicked:Connect(function() --[[ Line: 135 | Upvalues: t3 (ref) ]]
		t3:PlayAd()
	end)
	v1:OnChange("AdsWatched", function() --[[ Line: 139 | Upvalues: t3 (ref) ]]
		t3:RefreshAdsWatched(true)
	end)
	GuiControl.GuiFocusedSignal:Connect(function(p1) --[[ Line: 143 | Upvalues: TokenShardsAd (ref), t3 (ref) ]]
		if p1 ~= TokenShardsAd then
			return
		end
		t3:RefreshAdsWatched(false)
	end)
end
function t3.Lock(p1) --[[ Lock | Line: 150 | Upvalues: v3 (ref) ]]
	v3 = true
end
function t3.Unlock(p1) --[[ Unlock | Line: 154 | Upvalues: v3 (ref) ]]
	v3 = false
end
function t3.IsLocked(p1) --[[ IsLocked | Line: 158 | Upvalues: v3 (ref) ]]
	return v3
end
function t3.SetSource(p1, p2) --[[ SetSource | Line: 162 | Upvalues: AdsUtility (copy), v6 (ref) ]]
	if not p2 then
		error("No ad source selected!")
	end
	if AdsUtility:GetAdProducts()[p2] ~= nil then
		v6 = p2
		return
	end
	error("No ad product for {newSource} exists!")
end
function t3.CanWatchAds(p1) --[[ CanWatchAds | Line: 175 | Upvalues: AdsUtility (copy) ]]
	local v1, _ = AdsUtility:GetAdAvailability():await()
	return v1 and true or false
end
function t3.RefreshAdButton(p1, p2) --[[ RefreshAdButton | Line: 184 | Upvalues: v1 (ref), v4 (ref), TokenShardsAdFrame (copy), UserPriority (copy) ]]
	v1:GetExpect("AdsWatched")
	local v12 = v1:GetExpect("Level")
	if v4 or not p2 then
		TokenShardsAdFrame.Visible = false
		return
	end
	TokenShardsAdFrame.Visible = if v12 >= 20 then UserPriority:IsTradePlaza() else false
end
function t3.RefreshAdsWatched(p1, p2) --[[ RefreshAdsWatched | Line: 195 | Upvalues: v1 (ref), t3 (copy), AdsUtility (copy), WatchAd (copy), Claimed (copy), Blocked (copy) ]]
	local v12 = v1:GetExpect("AdsWatched")
	local v2 = t3:CanWatchAds()
	if v2 and v12 < AdsUtility.Ads then
		t3:RefreshAdButton(true)
		WatchAd.Visible = true
		Claimed.Visible = false
		Blocked.Visible = false
		return
	end
	t3:RefreshAdButton(false)
	if v2 then
		Claimed.Visible = true
		Blocked.Visible = false
		WatchAd.Visible = false
	else
		Blocked.Visible = true
		WatchAd.Visible = false
		Claimed.Visible = false
	end
end
function t3.PlayAd(p1) --[[ PlayAd | Line: 219 | Upvalues: v6 (ref), v1 (ref), AdsUtility (copy), t3 (copy), v7 (copy) ]]
	if not v6 then
		return
	end
	local UnixTimestamp = DateTime.now().UnixTimestamp
	local v12 = v1:GetExpect("AdsWatched")
	v1:GetExpect("LastAdWatched")
	if AdsUtility.Ads <= v12 then
		t3:SendMessage("Reached daily limit!")
		return
	end
	if not t3:IsLocked() then
		t3:Lock()
		v7:FireServer(v6)
	end
end
function t3.SendMessage(p1, p2) --[[ SendMessage | Line: 246 | Upvalues: TextNotificationController (copy) ]]
	TextNotificationController:DeliverNotification({
		Type = "Text",
		Text = p2
	})
end
function FormatDHMS(p1) --[[ FormatDHMS | Line: 253 ]]
	local v1 = p1 % 86400
	local v2 = math.floor(p1 / 86400)
	local v3 = math.floor(v1 / 3600)
	local v4 = math.floor(v1 % 3600 / 60)
	local v5 = math.floor(p1 % 60)
	if v2 >= 1 then
		return string.format("%02dd %02dh %02dm %02ds", v2, v3, v4, v5)
	end
	if v3 >= 1 then
		return string.format("%02dh %02dm %02ds", v3, v4, v5)
	else
		return string.format("%02dm %02ds", v4, v5)
	end
end
return t3