-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Net = require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Observers = require(ReplicatedStorage.Packages.Observers)
local UserPriority = require(ReplicatedStorage.Shared.UserPriority)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local v1 = nil
local PlayerGui = Players.LocalPlayer.PlayerGui
local v2 = Net:RemoteEvent("FeatureUnlocked")
local v3 = UserPriority:IsTradePlaza()
local t = {}
local v4 = 0
local v5 = 0
local function OnFishCaughtChanged(p1, p2) --[[ OnFishCaughtChanged | Line: 31 | Upvalues: v4 (ref), v1 (ref), t (copy), TextNotificationController (copy), v2 (copy) ]]
	v4 = p1
	v1:GetExpect("Level")
	local v12 = v1:GetExpect("PlayerFeatures")
	if p2 < p1 then
		for i, v in ipairs(t) do
			if not v:GetAttribute("SkipNotification") then
				local v22 = v:GetAttribute("RequiredValue")
				if v22 then
					local v3 = v:GetAttribute("FeatureName")
					local v42 = v:GetAttribute("FeatureDescription")
					local v5 = v:GetAttribute("FeatureTextColor")
					if v5 and (v42 and (v3 and (not table.find(v12, v3) and (v22 <= p1 and p2 < v22)))) then
						TextNotificationController:DeliverNotification({
							Type = "Text",
							CustomDuration = 5,
							Text = ("Unlocked: %*"):format(v42),
							TextColor = {
								R = v5.R * 255,
								G = v5.G * 255,
								B = v5.B * 255
							}
						})
						v2:FireServer(v3)
					end
				end
			end
		end
	end
	for i, v in ipairs(t) do
		local v6 = v:GetAttribute("RequiredValue")
		if v6 then
			v.Visible = v6 <= p1
		end
	end
end
local function UpdateLevel() --[[ UpdateLevel | Line: 81 | Upvalues: t (copy), v5 (ref) ]]
	for i, v in ipairs(t) do
		local v1 = v:GetAttribute("RequiredLevel")
		if v1 then
			v.Visible = v1 <= v5
		end
	end
end
Replion.Client:AwaitReplion("Data", function(p1) --[[ Line: 90 | Upvalues: v1 (ref), OnFishCaughtChanged (copy), v5 (ref), UpdateLevel (copy), Observers (copy), v3 (copy), v4 (ref), t (copy), PlayerGui (copy) ]]
	v1 = p1
	local function FishCaught(p1, p2) --[[ FishCaught | Line: 93 | Upvalues: OnFishCaughtChanged (ref) ]]
		task.wait(5.5)
		OnFishCaughtChanged(p1, p2)
	end
	local function SetLevel() --[[ SetLevel | Line: 98 | Upvalues: v1 (ref), v5 (ref), UpdateLevel (ref) ]]
		v5 = v1:GetExpect("Level")
		UpdateLevel()
	end
	v1:OnChange({ "Statistics", "FishCaught" }, FishCaught)
	v1:OnChange("Level", SetLevel)
	local v12 = v1:GetExpect({ "Statistics", "FishCaught" })
	OnFishCaughtChanged(v12, v12)
	v5 = v1:GetExpect("Level")
	UpdateLevel()
	Observers.observeTag("HideUI", function(p1) --[[ Line: 117 | Upvalues: v3 (ref), v4 (ref), v5 (ref), t (ref) ]]
		if typeof(p1) ~= "Instance" then
			return
		end
		if p1:GetAttribute("NoTradePlaza") and v3 then
			p1.Visible = false
			return
		end
		if p1:GetAttribute("ShowTradePlaza") then
			p1.Visible = v3
			return
		end
		local v1 = p1:GetAttribute("RequiredLevel")
		local v2 = p1:GetAttribute("RequiredValue")
		if v2 then
			p1.Visible = v2 <= v4
		elseif v1 then
			p1.Visible = v1 <= v5
		end
		if table.find(t, p1) == nil then
			table.insert(t, p1)
		end
		return function() --[[ Line: 147 | Upvalues: t (ref), p1 (copy) ]]
			table.remove(t, table.find(t, p1))
		end
	end, { PlayerGui })
end)
return {}