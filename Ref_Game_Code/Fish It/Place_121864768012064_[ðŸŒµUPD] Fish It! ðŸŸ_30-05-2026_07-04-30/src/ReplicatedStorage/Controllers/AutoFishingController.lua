-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Net = require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
require(ReplicatedStorage.Packages.Thread)
local Observers = require(ReplicatedStorage.Packages.Observers)
local spr = require(ReplicatedStorage.Packages.spr)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local ToolTip = require(ReplicatedStorage.Modules.ToolTip)
local Constants = require(ReplicatedStorage.Shared.Constants)
require(ReplicatedStorage.Controllers.PromptController)
local FishingController = require(ReplicatedStorage.Controllers.FishingController)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local UserPriority = require(ReplicatedStorage.Shared.UserPriority)
local AreaUtility = require(ReplicatedStorage.Shared.AreaUtility)
local v1 = Net:RemoteFunction("UpdateAutoFishingState")
local v2 = Net:RemoteFunction("MarkAutoFishingUsed")
local v3 = nil
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local CurrentCamera = workspace.CurrentCamera
local v4 = false
local v5 = false
PlayerGui:WaitForChild("!!! Daily Login")
PlayerGui:WaitForChild("HUD")
local t = {
	Inactive = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromHex("#ff5d60")), ColorSequenceKeypoint.new(1, Color3.fromHex("#ff2256")) }),
	Active = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromHex("#62ffb6")), ColorSequenceKeypoint.new(1, Color3.fromHex("#21ff7d")) })
}
local t2 = {}
function t2.Start(p1) --[[ Start | Line: 61 | Upvalues: v3 (ref), Replion (copy), Observers (copy), t2 (copy), PlayerGui (copy), LocalPlayer (copy), v1 (copy), TextNotificationController (copy), Constants (copy), FishingController (copy), AreaUtility (copy), CurrentCamera (copy), v5 (ref) ]]
	v3 = Replion.Client:WaitReplion("Data")
	Observers.observeTag("AutoFishingButton", function(p1) --[[ Line: 65 | Upvalues: t2 (ref) ]]
		return t2:RegisterAutoFishingButton(p1)
	end, { PlayerGui })
	local v12 = nil
	v3:OnChange("AutoFishing", function(p1) --[[ Line: 72 | Upvalues: LocalPlayer (ref), v12 (ref) ]]
		if p1 then
			local Character = LocalPlayer.Character
			local v1 = if Character then Character:FindFirstChild("HumanoidRootPart") else Character
			if v1 then
				v12 = v1.Position
			end
		else
			v12 = nil
		end
	end)
	task.spawn(function() --[[ Line: 84 | Upvalues: LocalPlayer (ref), v3 (ref), v12 (ref), v1 (ref), TextNotificationController (ref), Constants (ref), FishingController (ref), AreaUtility (ref), CurrentCamera (ref) ]]
		while true do
			local v13, v2, v32
			while true do
				while true do
					while true do
						while true do
							while true do
								while true do
									while true do
										while LocalPlayer:GetAttribute("InCutscene") do
											task.wait(0.5)
										end
										if v3:GetExpect("AutoFishing") then
											break
										end
										v12 = nil
										task.wait(2)
									end
									if v3:GetExpect("EquippedType") == "Fishing Rods" then
										break
									end
									task.wait(2)
								end
								if not (LocalPlayer:GetAttribute("IsTrading") or LocalPlayer:GetAttribute("SellAll")) then
									break
								end
								task.wait(0.1)
							end
							local Character = LocalPlayer.Character
							local v5 = if Character then Character:FindFirstChild("HumanoidRootPart") else Character
							if not v5 then
								break
							end
							if v12 == nil then
								v12 = v5.Position
							end
							if not ((v5.Position - v12).Magnitude >= 8) then
								break
							end
							v1:InvokeServer(false)
							v12 = nil
							TextNotificationController:DeliverNotification({
								Type = "Text",
								Text = "Auto Fishing stopped: You walked away!",
								TextColor = {
									R = 255,
									G = 165,
									B = 0
								}
							})
							task.wait(0.5)
						end
						if Constants:CountInventorySize(v3) >= Constants.MaxInventorySize then
							task.wait(2.5)
							if FishingController:NoInventorySpace() then
								task.wait(0.5)
								if FishingController:OnCooldown() then
									task.wait(0.2)
									continue
								end
								if FishingController:GetCurrentGUID() then
									v13 = LocalPlayer:GetAttribute("SelectedRarity") or 1
									v2 = AreaUtility:GetArea(LocalPlayer:GetAttribute("LocationName") or "Fisherman Island") or {
										ClickPowerMultiplier = 1
									}
									v32 = Constants:GetClickTiming(v13, v2)
									FishingController:RequestFishingMinigameClick()
									task.wait(v32)
									continue
								end
								FishingController:RequestChargeFishingRod(Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y / 2), true)
								task.wait(0.5)
							end
						else
							if FishingController:OnCooldown() then
								task.wait(0.2)
								continue
							end
							if FishingController:GetCurrentGUID() then
								v13 = LocalPlayer:GetAttribute("SelectedRarity") or 1
								v2 = AreaUtility:GetArea(LocalPlayer:GetAttribute("LocationName") or "Fisherman Island") or {
									ClickPowerMultiplier = 1
								}
								v32 = Constants:GetClickTiming(v13, v2)
								FishingController:RequestFishingMinigameClick()
								task.wait(v32)
								continue
							end
							FishingController:RequestChargeFishingRod(Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y / 2), true)
							task.wait(0.5)
						end
					end
				end
				if FishingController:GetCurrentGUID() then
					break
				end
				FishingController:RequestChargeFishingRod(Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y / 2), true)
				task.wait(0.5)
			end
			v13 = LocalPlayer:GetAttribute("SelectedRarity") or 1
			v2 = AreaUtility:GetArea(LocalPlayer:GetAttribute("LocationName") or "Fisherman Island") or {
				ClickPowerMultiplier = 1
			}
			v32 = Constants:GetClickTiming(v13, v2)
			FishingController:RequestFishingMinigameClick()
			task.wait(v32)
		end
	end)
	v5 = true
end
function t2.RegisterAutoFishingButton(p1, p2) --[[ RegisterAutoFishingButton | Line: 170 | Upvalues: UserPriority (copy), v3 (ref), GuiControl (copy), v4 (ref), Constants (copy), v1 (copy), v2 (copy), TextNotificationController (copy), ToolTip (copy) ]]
	if UserPriority:IsTradePlaza() then
		p2.Visible = false
		return
	end
	if v3:Get("AutoFishingUsed") then
		local Gradient = p2:FindFirstChild("Gradient")
		local v12 = Gradient and Gradient:FindFirstChild("ShineEffect")
		if v12 then
			v12:RemoveTag("ShineEffect")
		end
	end
	local v22 = GuiControl:Hook("Hold Button", p2)
	v22.Clicked:Connect(function() --[[ Line: 186 | Upvalues: v4 (ref), UserPriority (ref), v3 (ref), Constants (ref), v1 (ref), v2 (ref), TextNotificationController (ref) ]]
		if v4 then
			return
		end
		v4 = true
		if if UserPriority:IsValidTestSession() then true else v3:GetExpect("Level") >= Constants.AutoFishingLevel then
			v1:InvokeServer(not v3:GetExpect("AutoFishing"))
			if not v3:Get("AutoFishingUsed") then
				v2:InvokeServer()
			end
		else
			TextNotificationController:DeliverNotification({
				Type = "Text",
				Text = ("Reach Level %* to unlock!"):format(Constants.AutoFishingLevel),
				TextColor = {
					R = 255,
					G = 0,
					B = 0
				}
			})
		end
		task.delay(0.75, function() --[[ Line: 216 | Upvalues: v4 (ref) ]]
			v4 = false
		end)
	end)
	ToolTip.observe(p2, v22.Cleaner, function() --[[ Line: 221 ]]
		return {
			Style = "Label",
			Text = "Toggle auto fishing"
		}
	end)
	local v32 = v3:OnChange("EquippedType", OnEquippedTypeChanged(p2))
	local v42 = v3:OnChange("AutoFishing", AutoFishingStateChanged(p2))
	local v5 = v3:OnChange("Level", OnLevelChanged(p2))
	local v6 = v3:OnChange("AutoFishingUsed", OnAutoFishingUsedChanged(p2))
	OnEquippedTypeChanged(p2)(v3:GetExpect("EquippedType"))
	AutoFishingStateChanged(p2)(v3:GetExpect("AutoFishing"))
	OnLevelChanged(p2)(v3:GetExpect("Level"))
	return function() --[[ Line: 239 | Upvalues: v22 (copy), v32 (copy), v42 (copy), v5 (copy), v6 (copy) ]]
		v22:Destroy()
		v32:Disconnect()
		v42:Disconnect()
		v5:Disconnect()
		v6:Disconnect()
	end
end
function IsAutoFishingUnlocked() --[[ IsAutoFishingUnlocked | Line: 250 ]]
	return true
end
function OnEquippedTypeChanged(p1) --[[ OnEquippedTypeChanged | Line: 254 ]]
	return function(p12) --[[ Line: 255 | Upvalues: p1 (copy) ]]
		p1.Visible = p12 == "Fishing Rods" and IsAutoFishingUnlocked()
	end
end
function OnLevelChanged(p1) --[[ OnLevelChanged | Line: 262 | Upvalues: v3 (ref) ]]
	return function(p12) --[[ Line: 263 | Upvalues: v3 (ref), p1 (copy) ]]
		local v1 = IsAutoFishingUnlocked()
		p1.Visible = v3:GetExpect("EquippedType") == "Fishing Rods" and v1
	end
end
function OnAutoFishingUsedChanged(p1) --[[ OnAutoFishingUsedChanged | Line: 272 | Upvalues: v3 (ref) ]]
	return function() --[[ Line: 273 | Upvalues: v3 (ref), p1 (copy) ]]
		if not v3:Get("AutoFishingUsed") then
			return
		end
		local Gradient = p1:FindFirstChild("Gradient")
		local v1 = if Gradient then Gradient:FindFirstChild("ShineEffect") else Gradient
		if not v1 then
			return
		end
		v1:RemoveTag("ShineEffect")
	end
end
function AutoFishingStateChanged(p1) --[[ AutoFishingStateChanged | Line: 285 | Upvalues: t (copy), spr (copy), v5 (ref), TextNotificationController (copy) ]]
	return function(p12) --[[ Line: 286 | Upvalues: t (ref), spr (ref), p1 (copy), v5 (ref), TextNotificationController (ref) ]]
		spr.stop(p1.UIGradient)
		spr.target(p1.UIGradient, 1, 3, {
			Color = p12 and t.Active or t.Inactive
		})
		if not v5 then
			return
		end
		TextNotificationController:DeliverNotification({
			Type = "Text",
			Text = ("Auto Fishing: %*"):format(if p12 then "Enabled" else "Disabled"),
			TextColor = p12 and {
				R = 9,
				G = 255,
				B = 0
			} or {
				R = 255,
				G = 0,
				B = 0
			}
		})
	end
end
return t2