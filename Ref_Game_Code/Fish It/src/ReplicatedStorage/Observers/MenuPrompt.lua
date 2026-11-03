-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Observers = require(ReplicatedStorage.Packages.Observers)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Net = require(ReplicatedStorage.Packages.Net)
local spr = require(ReplicatedStorage.Packages.spr)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local DialogueController = require(ReplicatedStorage.Controllers.DialogueController)
local v1 = nil
local v2 = Net:RemoteEvent("TrackTutorialShopAB")
local WorldSetup = workspace:WaitForChild("WorldSetup")
local t = {
	["Rod Shop"] = true,
	["Bait Shop"] = true
}
local t2 = {}
local t3 = {}
local v3 = nil
local function getDataReplion() --[[ getDataReplion | Line: 31 | Upvalues: v3 (ref), Replion (copy) ]]
	if not v3 or v3.Destroyed then
		v3 = Replion.Client:GetReplion("Data")
	end
	return v3
end
local function getTutorialShopVariant(p1) --[[ getTutorialShopVariant | Line: 40 | Upvalues: t (copy), v3 (ref), Replion (copy), Players (copy) ]]
	if not (p1 and t[p1]) then
		return nil
	end
	if not v3 or v3.Destroyed then
		v3 = Replion.Client:GetReplion("Data")
	end
	local v1 = v3
	if not v1 then
		return nil
	end
	local v2 = v1:Get("PlayerOnboarding")
	local v32 = v1:Get("OnboardingStep")
	if v2 ~= true or (typeof(v32) ~= "number" or v32 >= 6) then
		return nil
	end
	local v4 = Players.LocalPlayer:GetAttribute("AB_TutorialShopVariant")
	if v4 == "A" or v4 == "B" then
		return v4
	else
		local v5 = Players.LocalPlayer:GetAttribute("AB_TutorialShopAutoOpen")
		if v5 == true then
			return "A"
		end
		if v5 == false then
			return "B"
		else
			return nil
		end
	end
end
local function trackTutorialShop(p1, p2) --[[ trackTutorialShop | Line: 71 | Upvalues: v2 (copy) ]]
	v2:FireServer(p1, p2)
end
local function onTutorialShopPromptShown(p1) --[[ onTutorialShopPromptShown | Line: 75 | Upvalues: getTutorialShopVariant (copy), t2 (copy), v2 (copy), t3 (copy), GuiControl (copy) ]]
	local v1 = getTutorialShopVariant(p1)
	if not v1 then
		return
	end
	if not t2[p1] then
		t2[p1] = true
		v2:FireServer(p1, "zone_enter")
	end
	if v1 ~= "A" then
		return
	end
	local v22 = workspace:GetServerTimeNow()
	if v22 < (t3[p1] or 0) then
		return
	end
	if not GuiControl:IsOpen(p1) then
		t3[p1] = v22 + 1
		v2:FireServer(p1, "ui_open_auto")
		GuiControl:Open(p1, nil, "ui_open_auto")
	end
end
local function onTutorialShopManualOpen(p1) --[[ onTutorialShopManualOpen | Line: 105 | Upvalues: getTutorialShopVariant (copy), v2 (copy) ]]
	if getTutorialShopVariant(p1) then
		v2:FireServer(p1, "ui_open_manual")
	end
end
local function addHighlight(p1) --[[ addHighlight | Line: 113 | Upvalues: spr (copy) ]]
	local Highlight = Instance.new("Highlight")
	Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	Highlight.FillColor = Color3.fromRGB(0, 0, 0)
	Highlight.OutlineTransparency = 1
	Highlight.FillTransparency = 1
	Highlight.Adornee = p1
	Highlight.Parent = script
	spr.target(Highlight, 1, 3, {
		OutlineTransparency = 0,
		FillTransparency = 0.9
	})
	return Highlight
end
local function errorMessage(p1) --[[ errorMessage | Line: 130 | Upvalues: v1 (ref), ReplicatedStorage (copy) ]]
	if v1 then
		v1:DeliverNotification({
			Type = "Text",
			Text = p1,
			TextColor = {
				R = 255,
				G = 0,
				B = 0
			}
		})
		return
	end
	v1 = require(ReplicatedStorage.Controllers.TextNotificationController)
	v1:DeliverNotification({
		Type = "Text",
		Text = p1,
		TextColor = {
			R = 255,
			G = 0,
			B = 0
		}
	})
end
Observers.observeTag("MenuPrompt", function(p1) --[[ Line: 143 | Upvalues: onTutorialShopPromptShown (copy), Players (copy), Replion (copy), errorMessage (copy), GuiControl (copy), getTutorialShopVariant (copy), v2 (copy), WorldSetup (copy), CollectionService (copy) ]]
	local v1 = p1:GetAttribute("IgnoreLock")
	local v22 = p1:GetAttribute("Context")
	local v3 = p1:GetAttribute("Gui")
	if not v3 then
		return
	end
	local v4 = p1:GetAttribute("ActionText") or "View"
	local v5 = p1:GetAttribute("Range") or 20
	local v6 = 0
	local ProximityPrompt = Instance.new("ProximityPrompt")
	ProximityPrompt.ObjectText = ""
	ProximityPrompt.ActionText = v4
	ProximityPrompt.ClickablePrompt = true
	ProximityPrompt.RequiresLineOfSight = false
	ProximityPrompt.MaxActivationDistance = v5
	ProximityPrompt.GamepadKeyCode = Enum.KeyCode.DPadDown
	ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom
	ProximityPrompt.Parent = p1
	local v7 = ProximityPrompt.PromptShown:Connect(function() --[[ Line: 166 | Upvalues: onTutorialShopPromptShown (ref), v3 (copy) ]]
		onTutorialShopPromptShown(v3)
	end)
	local v8 = ProximityPrompt.Triggered:Connect(function(p12) --[[ Line: 170 | Upvalues: Players (ref), p1 (copy), Replion (ref), errorMessage (ref), v6 (ref), GuiControl (ref), v3 (copy), getTutorialShopVariant (ref), v2 (ref), v1 (copy), v22 (copy) ]]
		if p12 ~= Players.LocalPlayer then
			return
		end
		local v12 = p1:GetAttribute("RequiredLevel")
		if v12 then
			local v23 = Replion.Client:GetReplion("Data")
			if not v23 then
				return
			end
			if v23:GetExpect("Level") < v12 then
				errorMessage((("You must be Lvl %*!"):format(v12)))
				return
			end
		end
		if workspace:GetServerTimeNow() < v6 then
			return
		end
		if GuiControl:IsOpen(v3) then
			return
		end
		v6 = workspace:GetServerTimeNow() + 1
		local v32 = v3
		if getTutorialShopVariant(v32) then
			v2:FireServer(v32, "ui_open_manual")
		end
		GuiControl:Open(v3, v1, v22)
	end)
	local BoatSpawnRegions = WorldSetup:WaitForChild("BoatSpawnRegions")
	local v9, v10
	if BoatSpawnRegions and p1:IsDescendantOf(BoatSpawnRegions) then
		local function refreshTag() --[[ refreshTag | Line: 206 | Upvalues: p1 (copy), ProximityPrompt (copy) ]]
			ProximityPrompt.Enabled = not p1:HasTag("BusyRegion")
		end
		v9 = CollectionService:GetInstanceAddedSignal("BusyRegion"):Connect(refreshTag)
		v10 = CollectionService:GetInstanceRemovedSignal("BusyRegion"):Connect(refreshTag)
	else
		v9 = nil
		v10 = nil
	end
	return function() --[[ Line: 217 | Upvalues: v7 (copy), v9 (ref), v10 (ref), v8 (copy), ProximityPrompt (copy) ]]
		v7:Disconnect()
		if v9 then
			v9:Disconnect()
		end
		if not v10 then
			v8:Disconnect()
			ProximityPrompt:Destroy()
			return
		end
		v10:Disconnect()
		v8:Disconnect()
		ProximityPrompt:Destroy()
	end
end)
Observers.observeTag("HighlightNPC", function(p1) --[[ Line: 232 | Upvalues: addHighlight (copy), spr (copy), Players (copy), DialogueController (copy), GuiControl (copy), getTutorialShopVariant (copy), v2 (copy), onTutorialShopPromptShown (copy) ]]
	local v1 = p1.Name
	local v22 = p1:GetAttribute("Gui")
	local Head = p1:FindFirstChild("Head")
	if not Head then
		return
	end
	local HumanoidRootPart = p1:FindFirstChild("HumanoidRootPart")
	if HumanoidRootPart then
		local v3 = p1:GetAttribute("ActionText") or "Talk"
		local v4 = p1:GetAttribute("Range") or 20
		local v5 = nil
		local Attachment = Instance.new("Attachment")
		Attachment.Parent = Head
		Attachment.WorldCFrame = HumanoidRootPart.CFrame
		local ProximityPrompt = Instance.new("ProximityPrompt")
		ProximityPrompt.ObjectText = ""
		ProximityPrompt.ActionText = v3
		ProximityPrompt.ClickablePrompt = true
		ProximityPrompt.RequiresLineOfSight = false
		ProximityPrompt.MaxActivationDistance = v4
		ProximityPrompt.GamepadKeyCode = Enum.KeyCode.DPadDown
		ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom
		ProximityPrompt.Parent = Attachment
		local function highlightNPC() --[[ highlightNPC | Line: 265 | Upvalues: v5 (ref), addHighlight (ref), p1 (copy) ]]
			if v5 then
				return
			end
			v5 = addHighlight(p1)
		end
		local function unhighlightNPC() --[[ unhighlightNPC | Line: 271 | Upvalues: v5 (ref), spr (ref) ]]
			local v1 = v5
			v5 = nil
			if v1 then
				spr.stop(v1)
				spr.target(v1, 1, 3, {
					OutlineTransparency = 1,
					FillTransparency = 1
				})
				task.delay(0.4, function() --[[ Line: 282 | Upvalues: v1 (ref) ]]
					v1:Destroy()
					v1 = nil
				end)
			end
		end
		local function triggerPrompt(p12) --[[ triggerPrompt | Line: 289 | Upvalues: Players (ref), DialogueController (ref), v1 (copy), p1 (copy), v22 (copy), GuiControl (ref), getTutorialShopVariant (ref), v2 (ref) ]]
			if p12 ~= Players.LocalPlayer then
				return
			end
			if not DialogueController:New(v1, p1) then
				return
			end
			if not v22 or GuiControl:IsOpen(v22) then
				return
			end
			local v12 = v22
			if getTutorialShopVariant(v12) then
				v2:FireServer(v12, "ui_open_manual")
			end
			GuiControl:Open(v22, nil, (("npc_%*"):format((v1:gsub(" ", "_")))))
		end
		task.defer(highlightNPC)
		local v6 = ProximityPrompt.PromptShown:Connect(function() --[[ Line: 308 | Upvalues: v5 (ref), addHighlight (ref), p1 (copy), v22 (copy), onTutorialShopPromptShown (ref) ]]
			if not v5 then
				v5 = addHighlight(p1)
			end
			if not v22 then
				return
			end
			onTutorialShopPromptShown(v22)
		end)
		local v7 = ProximityPrompt.PromptHidden:Connect(unhighlightNPC)
		local v8 = ProximityPrompt.Triggered:Connect(triggerPrompt)
		return function() --[[ Line: 318 | Upvalues: v6 (copy), v7 (copy), v8 (copy), ProximityPrompt (copy), Attachment (copy), unhighlightNPC (copy) ]]
			v6:Disconnect()
			v7:Disconnect()
			v8:Disconnect()
			ProximityPrompt:Destroy()
			Attachment:Destroy()
			unhighlightNPC()
		end
	end
end)
return {}