-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Net = require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Observers = require(ReplicatedStorage.Packages.Observers)
local spr = require(ReplicatedStorage.Packages.spr)
local Emotes = require(ReplicatedStorage.Emotes)
local EmoteCrates = require(ReplicatedStorage.EmoteCrates)
local ParticleEmitter = require(ReplicatedStorage.Modules.ParticleEmitter)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local PromptController = require(ReplicatedStorage.Controllers.PromptController)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local EmoteLootboxController = require(script.Parent.EmoteLootboxController)
local InventoryController = require(script.Parent.InventoryController)
local FishingController = require(script.Parent.FishingController)
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local EmoteWheel = PlayerGui:WaitForChild("EmoteWheel")
local Inventory = PlayerGui:WaitForChild("Inventory")
local EmoteLootbox = PlayerGui:WaitForChild("EmoteLootbox")
local WheelImage = EmoteWheel:WaitForChild("WheelImage")
local EmoteNameLabel = WheelImage:WaitForChild("EmoteNameLabel")
local Highlight = WheelImage:WaitForChild("Highlight")
local SelectedEmote = WheelImage:WaitForChild("SelectedEmote")
local Icons = WheelImage:WaitForChild("Icons")
local AddEmotes = WheelImage:WaitForChild("AddEmotes")
local BuyEmotes = WheelImage:WaitForChild("BuyEmotes")
local EditEmotes = WheelImage:WaitForChild("EditEmotes")
local v1 = Net:RemoteFunction("RequestPlayEmote")
local v2 = Net:RemoteFunction("RespondToSyncEmoteRequest")
local v3 = Net:RemoteEvent("PromptSyncEmoteRequest")
local v4 = Net:RemoteEvent("RequestStopEmote")
local v5 = Net:RemoteEvent("ReplicateEmoteState")
local v6 = Net:RemoteEvent("UnequipToolFromHotbar")
local EmoteHumanoids = ReplicatedStorage.Assets:FindFirstChild("EmoteHumanoids")
local t = {}
local t2 = {}
local t3 = {}
local t4 = {}
local v7 = nil
local v8 = nil
local v9 = nil
local v10 = Trove.new()
local t5 = {}
local t6 = {}
local v11 = nil
local ImageTransparency = Highlight.ImageTransparency
local ImageTransparency_2 = SelectedEmote.ImageTransparency
local v12 = nil
local v13 = nil
local zero = Vector2.zero
local zero_2 = Vector2.zero
local v14 = 0
local t7 = {}
local v15 = false
local v16 = false
local v17 = false
local t8 = {}
local function normalizeName(p1) --[[ normalizeName | Line: 102 ]]
	return string.lower((p1:gsub("%W", "")))
end
local function isWheelOpen() --[[ isWheelOpen | Line: 106 | Upvalues: EmoteWheel (copy), WheelImage (copy) ]]
	return EmoteWheel.Enabled and WheelImage.Visible
end
local function getDefaultEmoteLabelText() --[[ getDefaultEmoteLabelText | Line: 110 | Upvalues: v8 (ref), Players (copy) ]]
	if v8 and v8:IsDescendantOf(Players) then
		return "Select\nSync\nEmote"
	else
		return "Select\nAn\nEmote"
	end
end
local function toGuiPosition(p1) --[[ toGuiPosition | Line: 118 | Upvalues: UserInputService (copy), EmoteWheel (copy), GuiService (copy) ]]
	if UserInputService.TouchEnabled and EmoteWheel.IgnoreGuiInset then
		return p1
	end
	return p1 - GuiService:GetGuiInset()
end
local function getNearestRotation(p1, p2) --[[ getNearestRotation | Line: 127 ]]
	return p1 + ((p2 - p1 + 180) % 360 - 180)
end
local function notifyError(p1) --[[ notifyError | Line: 132 | Upvalues: TextNotificationController (copy) ]]
	TextNotificationController:DeliverNotification({
		Type = "Text",
		CustomDuration = 3.5,
		Text = p1,
		TextColor = {
			R = 255,
			G = 0,
			B = 0
		}
	})
end
local function notifyHint(p1) --[[ notifyHint | Line: 141 | Upvalues: TextNotificationController (copy) ]]
	TextNotificationController:DeliverNotification({
		Type = "Text",
		CustomDuration = 3.5,
		Text = p1,
		TextColor = {
			R = 255,
			G = 255,
			B = 255
		}
	})
end
local function unequipHeldToolIfEquipped() --[[ unequipHeldToolIfEquipped | Line: 150 | Upvalues: v6 (copy) ]]
	v6:FireServer()
end
local function prepareWheelInteraction() --[[ prepareWheelInteraction | Line: 154 | Upvalues: v6 (copy) ]]
	v6:FireServer()
end
local function getHumanoid(p1) --[[ getHumanoid | Line: 158 ]]
	local Character = p1.Character
	if Character then
		return Character:FindFirstChildWhichIsA("Humanoid")
	end
end
local function getCharacterRootPart(p1, p2) --[[ getCharacterRootPart | Line: 167 ]]
	local HumanoidRootPart = p1:FindFirstChild("HumanoidRootPart")
	if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
		return HumanoidRootPart
	end
	local PrimaryPart = p1.PrimaryPart
	if PrimaryPart then
		return PrimaryPart
	end
	local v1 = p1:FindFirstChildWhichIsA("Humanoid")
	if v1 and v1.RootPart then
		return v1.RootPart
	end
	if not (p2 and p2 > 0) then
		return nil
	end
	local HumanoidRootPart_2 = p1:WaitForChild("HumanoidRootPart", p2)
	if HumanoidRootPart_2 and HumanoidRootPart_2:IsA("BasePart") then
		return HumanoidRootPart_2
	else
		return nil
	end
end
local function getHumanoidRootPart(p1) --[[ getHumanoidRootPart | Line: 193 ]]
	local Character = p1.Character
	if not Character then
		return
	end
	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
		return HumanoidRootPart
	end
	local PrimaryPart = Character.PrimaryPart
	if PrimaryPart then
		return PrimaryPart
	end
	local v1 = Character:FindFirstChildWhichIsA("Humanoid")
	if v1 and v1.RootPart then
		return v1.RootPart
	else
		return nil
	end
end
local function isHumanoidMoving(p1) --[[ isHumanoidMoving | Line: 202 ]]
	return p1.MoveDirection.Magnitude > 0.05
end
local function getAnimator(p1) --[[ getAnimator | Line: 206 ]]
	local Character = p1.Character
	local v1 = if Character then Character:FindFirstChildWhichIsA("Humanoid") else nil
	if v1 and not (v1.Health <= 0) then
		return v1:FindFirstChildWhichIsA("Animator")
	end
end
local function getBlockedReason() --[[ getBlockedReason | Line: 215 | Upvalues: FishingController (copy), LocalPlayer (copy) ]]
	if FishingController:GetCurrentGUID() then
		return "You cannot emote while fishing."
	end
	local Character = LocalPlayer.Character
	local v1 = if Character then Character:FindFirstChildWhichIsA("Humanoid") else nil
	if not v1 then
		return "You cannot emote right now."
	end
	if v1.Health <= 0 or v1:GetState() == Enum.HumanoidStateType.Dead then
		return "You cannot emote right now."
	end
	local SeatPart = v1.SeatPart
	local Vehicles = workspace:FindFirstChild("Vehicles")
	if SeatPart and (Vehicles and SeatPart:IsDescendantOf(Vehicles)) then
		return "You cannot emote while in a boat."
	end
	if LocalPlayer:GetAttribute("Underwater") == true then
		return "You cannot emote while swimming."
	end
	if v1:GetState() == Enum.HumanoidStateType.Swimming or v1.FloorMaterial == Enum.Material.Water then
		return "You cannot emote while swimming."
	else
		return nil
	end
end
local function setWheelButtonText(p1, p2) --[[ setWheelButtonText | Line: 247 ]]
	if p1:IsA("TextButton") then
		p1.Text = p2
	end
	local v1 = p1:FindFirstChildWhichIsA("TextLabel")
	if not v1 then
		return
	end
	v1.Text = p2
end
local function getEmoteIcon(p1) --[[ getEmoteIcon | Line: 258 | Upvalues: Emotes (copy) ]]
	if not p1 then
		return nil
	end
	local v1 = Emotes[p1]
	if not v1 then
		return nil
	end
	local Icon = v1.Data.Icon
	if typeof(Icon) == "string" and Icon ~= "" then
		return Icon
	else
		return nil
	end
end
local function setWheelSlotIcon(p1, p2) --[[ setWheelSlotIcon | Line: 276 | Upvalues: Icons (copy), Emotes (copy) ]]
	local v1 = Icons:FindFirstChild((tostring(p1)))
	if not v1 then
		return
	end
	if not (v1:IsA("ImageLabel") or v1:IsA("ImageButton")) then
		return
	end
	local v2
	if p2 then
		local v3 = Emotes[p2]
		if v3 then
			local Icon = v3.Data.Icon
			v2 = if typeof(Icon) == "string" and Icon ~= "" then Icon else nil
		else
			v2 = nil
		end
	else
		v2 = nil
	end
	v1:SetAttribute("EmoteName", p2)
	local _ = v1:IsA("ImageLabel")
	v1.Image = v2 or ""
end
local function getWheelSlotAction(p1) --[[ getWheelSlotAction | Line: 295 | Upvalues: t6 (copy) ]]
	local v1 = t6[p1]
	if v1 then
		return "Emote", v1
	end
	if #t6 >= 8 then
		return "Empty", nil
	end
	if p1 == 8 then
		return "Buy", nil
	else
		return "Add", nil
	end
end
local function getSlotButtonTransform(p1) --[[ getSlotButtonTransform | Line: 312 | Upvalues: WheelImage (copy) ]]
	local AbsoluteSize = WheelImage.AbsoluteSize
	local v1 = math.min(AbsoluteSize.X, AbsoluteSize.Y) / 2
	if v1 <= 0 then
		return UDim2.new(0.5, 0, 0.5, 0), Vector2.new(0.5, 0.5)
	else
		local v2 = math.rad((p1 - 0.5) * 45 + -112.5)
		local v3 = math.cos(v2) * 0.6825 * v1
		return UDim2.new(0.5, v3, 0.5, math.sin(v2) * 0.6825 * v1), Vector2.new(0.5, 0.5)
	end
end
local function clearAddEmoteButtons() --[[ clearAddEmoteButtons | Line: 329 | Upvalues: t7 (copy), AddEmotes (copy) ]]
	for i, v in ipairs(t7) do
		if v ~= AddEmotes and v.Parent then
			v:Destroy()
		end
	end
	table.clear(t7)
end
local function updateNoEmoteButtons() --[[ updateNoEmoteButtons | Line: 338 | Upvalues: clearAddEmoteButtons (copy), AddEmotes (copy), BuyEmotes (copy), EmoteNameLabel (copy), t6 (copy), t7 (copy), WheelImage (copy), getSlotButtonTransform (copy) ]]
	clearAddEmoteButtons()
	AddEmotes.Visible = false
	BuyEmotes.Visible = false
	EmoteNameLabel.Visible = true
	if #t6 >= 8 then
		return
	end
	for i = 1, 8 do
		local v1
		local v2 = if t6[i] then "Emote" elseif #t6 >= 8 then "Empty" elseif i == 8 then "Buy" else "Add"
		if v2 == "Add" then
			if #t7 == 0 then
				v1 = AddEmotes
			else
				local v3 = AddEmotes:Clone()
				v3.Name = ("AddEmotes_%*"):format(i)
				v3.Parent = WheelImage
				v1 = v3
			end
			local v4, v5 = getSlotButtonTransform(i)
			v1.Position = v4
			v1.AnchorPoint = v5
			v1.Visible = true
			v1:SetAttribute("OpenAddEmotes", true)
			v1:SetAttribute("OpenBuyEmotes", false)
			v1:SetAttribute("EmoteName", nil)
			table.insert(t7, v1)
			continue
		end
		if v2 == "Buy" then
			local v7, v8 = getSlotButtonTransform(i)
			BuyEmotes.Position = v7
			BuyEmotes.AnchorPoint = v8
			BuyEmotes.Visible = true
			BuyEmotes:SetAttribute("OpenAddEmotes", false)
			BuyEmotes:SetAttribute("OpenBuyEmotes", true)
			BuyEmotes:SetAttribute("EmoteName", nil)
		end
	end
end
local function getDefaultEmoteCrateName() --[[ getDefaultEmoteCrateName | Line: 380 | Upvalues: EmoteCrates (copy) ]]
	local v1 = (1 / 0)
	local v2 = nil
	for v3, v4 in EmoteCrates do
		if v4.Order < v1 then
			v1 = v4.Order
			v2 = v3
		end
	end
	return v2
end
local function openEmoteInventory(p1) --[[ openEmoteInventory | Line: 394 | Upvalues: EmoteWheel (copy), WheelImage (copy), v15 (ref), InventoryController (copy), GuiControl (copy) ]]
	v15 = if p1 == true then true else EmoteWheel.Enabled and WheelImage.Visible
	InventoryController:SetPage("Items")
	InventoryController:SetCategory("Emotes")
	InventoryController.InventoryStateChanged:Fire("Emotes")
	GuiControl:Open("Inventory", false)
end
local function openEmoteShop(p1) --[[ openEmoteShop | Line: 404 | Upvalues: EmoteWheel (copy), WheelImage (copy), v16 (ref), EmoteCrates (copy), notifyError (copy), EmoteLootboxController (copy) ]]
	v16 = if p1 == true then true else EmoteWheel.Enabled and WheelImage.Visible
	local v2 = (1 / 0)
	local v3 = nil
	for v4, v5 in EmoteCrates do
		if v5.Order < v2 then
			v2 = v5.Order
			v3 = v4
		end
	end
	if v3 then
		EmoteLootboxController:Open(v3)
	else
		notifyError("Emote shop is unavailable right now.")
	end
end
local function updateWheelSlotButtons() --[[ updateWheelSlotButtons | Line: 417 | Upvalues: updateNoEmoteButtons (copy), t6 (copy), setWheelSlotIcon (copy), WheelImage (copy) ]]
	updateNoEmoteButtons()
	for i = 1, 8 do
		local v1 = t6[i]
		local v2 = if v1 then v1 else nil
		setWheelSlotIcon(i, v2)
		local v3 = WheelImage:FindFirstChild((tostring(i)))
		if v3 and v3:IsA("GuiButton") then
			v3:SetAttribute("EmoteName", v2)
			v3:SetAttribute("OpenAddEmotes", false)
			v3:SetAttribute("OpenBuyEmotes", false)
			local v4 = if v2 then v2 else tostring(i)
			if v3:IsA("TextButton") then
				v3.Text = v4
			end
			local v5 = v3:FindFirstChildWhichIsA("TextLabel")
			if v5 then
				v5.Text = v4
			end
		end
	end
end
local function getHoveredWheelSlot(p1) --[[ getHoveredWheelSlot | Line: 434 | Upvalues: WheelImage (copy) ]]
	local AbsoluteSize = WheelImage.AbsoluteSize
	if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
		return nil
	end
	local AbsolutePosition = WheelImage.AbsolutePosition
	local v1 = math.min(AbsoluteSize.X, AbsoluteSize.Y) / 2
	if v1 <= 0 then
		return nil
	end
	local v4 = p1.X - (AbsolutePosition.X + AbsoluteSize.X / 2)
	local v5 = p1.Y - (AbsolutePosition.Y + AbsoluteSize.Y / 2)
	local v6 = math.sqrt(v4 * v4 + v5 * v5) / v1
	if v6 < 0.38 or v6 > 0.985 then
		return nil
	end
	local v8 = (math.deg((math.atan2(v5, v4))) - -112.5) % 360
	local v9 = v8 % 45
	if v9 <= 0.6 or v9 >= 44.4 then
		return nil
	end
	local v10 = math.floor(v8 / 45) + 1
	if v10 < 1 or v10 > 8 then
		return nil
	else
		return v10
	end
end
local function getHoveredWheelSlotFromGamepad() --[[ getHoveredWheelSlotFromGamepad | Line: 474 | Upvalues: zero_2 (ref), zero (ref), WheelImage (copy), getHoveredWheelSlot (copy) ]]
	local v1 = if zero_2.Magnitude > zero.Magnitude then zero_2 else zero
	if v1.Magnitude < 0.35 then
		return nil
	end
	local AbsoluteSize = WheelImage.AbsoluteSize
	local v2 = math.min(AbsoluteSize.X, AbsoluteSize.Y) / 2
	if v2 <= 0 then
		return nil
	end
	local AbsolutePosition = WheelImage.AbsolutePosition
	local v3 = Vector2.new(AbsolutePosition.X + AbsoluteSize.X / 2, AbsolutePosition.Y + AbsoluteSize.Y / 2)
	local v4 = Vector2.new(v1.X, -v1.Y)
	if v4.Magnitude <= 0 then
		return nil
	else
		return getHoveredWheelSlot(v3 + v4.Unit * (v2 * 0.6825))
	end
end
local function updateWheelHoverPresentation(p1) --[[ updateWheelHoverPresentation | Line: 501 | Upvalues: spr (copy), Highlight (copy), SelectedEmote (copy), v14 (ref), WheelImage (copy), ImageTransparency (copy), ImageTransparency_2 (copy), t6 (copy), EmoteNameLabel (copy), v8 (ref), Players (copy) ]]
	local function animateMarkers(p1, p2, p3, p4, p5, p6) --[[ animateMarkers | Line: 502 | Upvalues: spr (ref), Highlight (ref), SelectedEmote (ref) ]]
		spr.stop(Highlight)
		spr.stop(SelectedEmote)
		local t = {
			ImageTransparency = p3
		}
		if p1 then
			t.Position = p1
		end
		if p5 then
			local Rotation = Highlight.Rotation
			t.Rotation = Rotation + ((p5 - Rotation + 180) % 360 - 180)
		end
		local t2 = {
			ImageTransparency = p4
		}
		if p2 then
			t2.Position = p2
		end
		if p6 then
			local Rotation = SelectedEmote.Rotation
			t2.Rotation = Rotation + ((p6 - Rotation + 180) % 360 - 180)
		end
		spr.target(Highlight, 1, 14, t)
		spr.target(SelectedEmote, 1, 14, t2)
	end
	local function hideMarkers() --[[ hideMarkers | Line: 533 | Upvalues: v14 (ref), animateMarkers (copy), Highlight (ref), SelectedEmote (ref) ]]
		v14 = v14 + 1
		local v1 = v14
		animateMarkers(nil, nil, 1, 1, nil, nil)
		task.delay(0.12, function() --[[ Line: 537 | Upvalues: v14 (ref), v1 (copy), Highlight (ref), SelectedEmote (ref) ]]
			if v14 == v1 then
				Highlight.Visible = false
				SelectedEmote.Visible = false
			end
		end)
	end
	v14 = v14 + 1
	if p1 then
		local v1 = -112.5 + (p1 - 0.5) * 45
		local v2 = math.rad(v1)
		local v3 = math.cos(v2)
		local v4 = math.sin(v2)
		local AbsoluteSize = WheelImage.AbsoluteSize
		local AbsolutePosition = WheelImage.AbsolutePosition
		local v5 = math.min(AbsoluteSize.X, AbsoluteSize.Y) / 2
		local v6 = AbsolutePosition.X + AbsoluteSize.X / 2
		local v7 = AbsolutePosition.Y + AbsoluteSize.Y / 2
		if v5 > 0 then
			local v82 = v1 + 90
			local v9 = math.clamp(v5 / 240 * 10, 4, 16)
			local v10 = v9 / v5 + 0.6825
			local v11 = UDim2.fromOffset(v6 + v3 * v10 * v5 - AbsolutePosition.X, v7 + v4 * v10 * v5 - AbsolutePosition.Y)
			SelectedEmote.Visible = true
			local v12 = 0.6825 - v9 / v5
			local v13 = UDim2.fromOffset(v6 + v3 * v12 * v5 - AbsolutePosition.X, v7 + v4 * v12 * v5 - AbsolutePosition.Y)
			Highlight.Visible = true
			animateMarkers(v13, v11, ImageTransparency, ImageTransparency_2, v82, v82)
		else
			local v142 = v14
			animateMarkers(nil, nil, 1, 1, nil, nil)
			task.delay(0.12, function() --[[ Line: 537 | Upvalues: v14 (ref), v142 (copy), Highlight (ref), SelectedEmote (ref) ]]
				if v14 == v142 then
					Highlight.Visible = false
					SelectedEmote.Visible = false
				end
			end)
		end
		local v15 = t6[p1]
		local v16, v17
		if v15 then
			v16 = "Emote"
			v17 = v15
		else
			v16 = if #t6 >= 8 then "Empty" elseif p1 == 8 then "Buy" else "Add"
			v17 = nil
		end
		if v16 == "Emote" and v17 then
			EmoteNameLabel.Text = v17
			return
		end
		if v16 == "Add" then
			EmoteNameLabel.Text = "Add Emotes"
			return
		end
		if v16 == "Buy" then
			EmoteNameLabel.Text = "Buy Emotes"
		else
			EmoteNameLabel.Text = "None"
		end
	else
		local v18 = v14
		animateMarkers(nil, nil, 1, 1, nil, nil)
		task.delay(0.12, function() --[[ Line: 537 | Upvalues: v14 (ref), v18 (copy), Highlight (ref), SelectedEmote (ref) ]]
			if v14 == v18 then
				Highlight.Visible = false
				SelectedEmote.Visible = false
			end
		end)
		EmoteNameLabel.Text = if v8 and v8:IsDescendantOf(Players) then "Select\nSync\nEmote" else "Select\nAn\nEmote"
	end
end
local function hasEquippedSyncEmote() --[[ hasEquippedSyncEmote | Line: 609 | Upvalues: t6 (copy) ]]
	return #t6 > 0
end
local function getSyncPromptDisabledReason() --[[ getSyncPromptDisabledReason | Line: 613 | Upvalues: t6 (copy), v9 (ref) ]]
	if not (#t6 > 0) then
		return "Equip an emote in your wheel first."
	end
	if not v9 then
		return nil
	end
	local v2 = v9:Get("EquippedType")
	if typeof(v2) == "string" and v2 ~= "" then
		return "Put away your held item before syncing an emote."
	else
		return nil
	end
end
local function updateSyncPromptStates() --[[ updateSyncPromptStates | Line: 628 | Upvalues: t6 (copy), v9 (ref), t8 (copy), Players (copy) ]]
	local v2
	if #t6 > 0 then
		if v9 then
			local v3 = v9:Get("EquippedType")
			v2 = if typeof(v3) == "string" and v3 ~= "" then "Put away your held item before syncing an emote." else nil
		else
			v2 = nil
		end
	else
		v2 = "Equip an emote in your wheel first."
	end
	local v4 = v2 == nil
	for k, v in pairs(t8) do
		if k:IsDescendantOf(Players) and v.Parent then
			v.Enabled = v4
		end
	end
end
local function refreshEquippedEmoteNames() --[[ refreshEquippedEmoteNames | Line: 637 | Upvalues: t5 (copy), t6 (copy), v9 (ref), updateWheelSlotButtons (copy), updateWheelHoverPresentation (copy), v11 (ref), ItemUtility (copy), updateSyncPromptStates (copy) ]]
	table.clear(t5)
	table.clear(t6)
	if not v9 then
		updateWheelSlotButtons()
		updateWheelHoverPresentation(v11)
		return
	end
	local v1 = v9:Get("Inventory")
	local v2 = v9:Get("EquippedEmotes")
	if typeof(v1) ~= "table" or typeof(v2) ~= "table" then
		updateWheelSlotButtons()
		updateWheelHoverPresentation(v11)
		return
	end
	local Emotes = v1.Emotes
	if typeof(Emotes) ~= "table" then
		updateWheelSlotButtons()
		updateWheelHoverPresentation(v11)
		return
	end
	local t = {}
	for i, v in ipairs(Emotes) do
		if typeof(v) == "table" and (typeof(v.UUID) == "string" and typeof(v.Id) == "number") then
			t[v.UUID] = v.Id
		end
	end
	for i, v in ipairs(v2) do
		local v3 = t[v]
		if v3 then
			local v4 = ItemUtility:GetEmoteData(v3)
			if v4 then
				local v5 = v4.Data.Name
				t5[v5] = true
				table.insert(t6, v5)
			end
		end
	end
	updateWheelSlotButtons()
	updateWheelHoverPresentation(v11)
	updateSyncPromptStates()
end
local function isEmoteEquipped(p1) --[[ isEmoteEquipped | Line: 686 | Upvalues: t5 (copy) ]]
	return t5[p1] == true
end
local function createBurstEmitter(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11) --[[ createBurstEmitter | Line: 690 ]]
	local Attachment = Instance.new("Attachment")
	Attachment.Parent = p1
	local ParticleEmitter = Instance.new("ParticleEmitter")
	ParticleEmitter.Parent = Attachment
	ParticleEmitter.Rate = 0
	ParticleEmitter.LightEmission = 0.65
	ParticleEmitter.Color = ColorSequence.new(p2)
	ParticleEmitter.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.05), NumberSequenceKeypoint.new(1, 1) })
	ParticleEmitter.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, p6), NumberSequenceKeypoint.new(1, p7) })
	ParticleEmitter.Lifetime = NumberRange.new(p8, p9)
	ParticleEmitter.Speed = NumberRange.new(p4 * 0.75, p4 * 1.25)
	ParticleEmitter.SpreadAngle = Vector2.new(p5, p5)
	ParticleEmitter.Drag = p11 or 2
	if p10 then
		ParticleEmitter.Acceleration = p10
	end
	ParticleEmitter:Emit(p3)
	task.delay(math.max(p9 + 0.25, 0.5), function() --[[ Line: 718 | Upvalues: Attachment (copy) ]]
		if not Attachment.Parent then
			return
		end
		Attachment:Destroy()
	end)
end
local function createGlow(p1, p2, p3, p4, p5) --[[ createGlow | Line: 725 ]]
	local PointLight = Instance.new("PointLight")
	PointLight.Color = p2
	PointLight.Brightness = p3
	PointLight.Range = p4
	PointLight.Shadows = false
	PointLight.Parent = p1
	task.delay(p5, function() --[[ Line: 733 | Upvalues: PointLight (copy) ]]
		if not PointLight.Parent then
			return
		end
		PointLight:Destroy()
	end)
end
local function playEmoteEffect(p1, p2, p3) --[[ playEmoteEffect | Line: 740 | Upvalues: Emotes (copy), getHumanoidRootPart (copy), createBurstEmitter (copy), createGlow (copy) ]]
	local v1 = Emotes[p3]
	if not v1 then
		return
	end
	local EffectCallback = v1.EffectCallback
	if typeof(EffectCallback) == "function" then
		return EffectCallback({
			ActorPlayer = p1,
			TargetPlayer = p2,
			GetHumanoidRootPart = getHumanoidRootPart,
			CreateBurstEmitter = createBurstEmitter,
			CreateGlow = createGlow
		})
	end
end
local function clearVFXForUser(p1) --[[ clearVFXForUser | Line: 758 | Upvalues: t4 (copy) ]]
	local v1 = t4[p1]
	if not v1 then
		return
	end
	t4[p1] = nil
	for i, v in ipairs(v1) do
		if v.Parent then
			v:Destroy()
		end
	end
end
local function resolveEmoteModelName(p1) --[[ resolveEmoteModelName | Line: 772 | Upvalues: Emotes (copy) ]]
	local v1 = Emotes[p1]
	if not v1 then
		return p1
	end
	local v2 = v1.Data.Name
	if typeof(v2) == "string" and v2 ~= "" then
		return v2
	else
		return p1
	end
end
local function playEmoteSoundForPlayer(p1, p2) --[[ playEmoteSoundForPlayer | Line: 786 | Upvalues: Emotes (copy), Soundbook (copy) ]]
	local v1 = Emotes[p2]
	local v2
	if v1 then
		local v3 = v1.Data.Name
		v2 = if typeof(v3) == "string" then if v3 == "" then p2 else v3 else p2
	else
		v2 = p2
	end
	if not Soundbook:HasSound(v2) then
		return nil
	end
	local v4 = Soundbook.Sounds[v2]
	if not v4 then
		return nil
	end
	local Character = p1.Character
	local v5
	if Character then
		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
		if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
			v5 = HumanoidRootPart
		else
			local PrimaryPart = Character.PrimaryPart
			if PrimaryPart then
				v5 = PrimaryPart
			else
				local v6 = Character:FindFirstChildWhichIsA("Humanoid")
				v5 = if v6 and v6.RootPart then v6.RootPart else nil
			end
		end
	else
		v5 = nil
	end
	if not v5 then
		return nil
	end
	local v7 = v4:Play(v5)
	if v7 and v7:IsA("Sound") then
		return v7
	else
		return nil
	end
end
local function getVFXStartDelay(p1) --[[ getVFXStartDelay | Line: 810 | Upvalues: Emotes (copy) ]]
	local v1 = Emotes[p1]
	if not v1 then
		return 0
	end
	local VFXStartDelay = v1.VFXStartDelay
	if typeof(VFXStartDelay) == "number" then
		return math.max(VFXStartDelay, 0)
	else
		return 0
	end
end
local function getVFXStageDelay(p1, p2) --[[ getVFXStageDelay | Line: 824 | Upvalues: Emotes (copy) ]]
	local v1 = Emotes[p1]
	if not v1 then
		return nil
	end
	local VFXStages = v1.VFXStages
	if typeof(VFXStages) ~= "table" then
		return nil
	end
	local v2 = VFXStages[p2]
	if typeof(v2) == "number" then
		return math.max(v2, 0)
	else
		return nil
	end
end
local function hasVFXStages(p1) --[[ hasVFXStages | Line: 843 | Upvalues: Emotes (copy) ]]
	local v1 = Emotes[p1]
	if not v1 then
		return false
	end
	return typeof(v1.VFXStages) == "table"
end
local function forEachParticleEmitter(p1, p2) --[[ forEachParticleEmitter | Line: 852 ]]
	if p1:IsA("ParticleEmitter") then
		p2(p1)
	end
	for i, v in ipairs(p1:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			p2(v)
		end
	end
end
local function disableParticleEmitters(p1) --[[ disableParticleEmitters | Line: 864 | Upvalues: forEachParticleEmitter (copy) ]]
	forEachParticleEmitter(p1, function(p1_2_2_2_2) --[[ Line: 865 ]]
		p1_2_2_2_2.Enabled = false
	end)
end
local function emitParticleEmitters(p1) --[[ emitParticleEmitters | Line: 870 | Upvalues: forEachParticleEmitter (copy) ]]
	forEachParticleEmitter(p1, function(p1_2_2) --[[ Line: 871 ]]
		local v1 = p1_2_2:GetAttribute("EmitCount")
		if typeof(v1) ~= "number" then
			v1 = tonumber(p1_2_2.Name) or 1
		end
		p1_2_2.Enabled = false
		p1_2_2:Emit(v1)
		task.defer(function() --[[ Line: 879 | Upvalues: p1_2_2 (copy) ]]
			if not p1_2_2.Parent then
				return
			end
			p1_2_2.Enabled = false
		end)
	end)
end
local function emitStagedEmoteVFXChild(p1, p2, p3, p4, p5) --[[ emitStagedEmoteVFXChild | Line: 887 | Upvalues: Emotes (copy), t3 (copy), t4 (copy), forEachParticleEmitter (copy) ]]
	local v1 = p3.Name
	local v2 = Emotes[p2]
	local v3
	if v2 then
		local VFXStages = v2.VFXStages
		if typeof(VFXStages) == "table" then
			local v4 = VFXStages[v1]
			v3 = if typeof(v4) == "number" then math.max(v4, 0) else nil
		else
			v3 = nil
		end
	else
		v3 = nil
	end
	if v3 then
		task.delay(v3, function() --[[ Line: 893 | Upvalues: t3 (ref), p1 (copy), p2 (copy), t4 (ref), p5 (copy), p4 (copy), p3 (copy), forEachParticleEmitter (ref) ]]
			local v1 = t3[p1]
			if not v1 or v1.EmoteName ~= p2 then
				return
			end
			if t4[p1] ~= p5 or not p4.Parent then
				return
			end
			local v2 = p3:Clone()
			forEachParticleEmitter(v2, function(p1_2_2_2_2) --[[ Line: 865 ]]
				p1_2_2_2_2.Enabled = false
			end)
			v2.Parent = p4
			forEachParticleEmitter(v2, function(p1_2_2_2_2) --[[ Line: 865 ]]
				p1_2_2_2_2.Enabled = false
			end)
			if t4[p1] == p5 then
				table.insert(p5, v2)
				forEachParticleEmitter(v2, function(p1_2_2) --[[ Line: 871 ]]
					local v1 = p1_2_2:GetAttribute("EmitCount")
					if typeof(v1) ~= "number" then
						v1 = tonumber(p1_2_2.Name) or 1
					end
					p1_2_2.Enabled = false
					p1_2_2:Emit(v1)
					task.defer(function() --[[ Line: 879 | Upvalues: p1_2_2 (copy) ]]
						if not p1_2_2.Parent then
							return
						end
						p1_2_2.Enabled = false
					end)
				end)
				return
			end
			if not v2.Parent then
				return
			end
			v2:Destroy()
		end)
	end
end
local function emitVFXForUser(p1, p2) --[[ emitVFXForUser | Line: 920 | Upvalues: EmoteHumanoids (copy), Emotes (copy), Players (copy), clearVFXForUser (copy), t4 (copy), t3 (copy), forEachParticleEmitter (copy), ParticleEmitter (copy) ]]
	if not (EmoteHumanoids and EmoteHumanoids:IsA("Folder")) then
		return
	end
	local v1 = Emotes[p2]
	local v2
	if v1 then
		local v3 = v1.Data.Name
		v2 = if typeof(v3) == "string" then if v3 == "" then p2 else v3 else p2
	else
		v2 = p2
	end
	local v4 = EmoteHumanoids:FindFirstChild(v2)
	if not (v4 and v4:IsA("Model")) then
		return
	end
	local EmoteVFX = v4:FindFirstChild("EmoteVFX")
	if not (EmoteVFX and EmoteVFX:IsA("Folder")) then
		return
	end
	local v5 = EmoteVFX:GetAttribute("AttachPart")
	if typeof(v5) ~= "string" or v5 == "" then
		return
	end
	local v6 = Players:GetPlayerByUserId(p1)
	local v7 = if v6 then v6.Character else v6
	if not v7 then
		return
	end
	local v8 = v7:FindFirstChild(v5, true)
	if not (v8 and v8:IsA("BasePart")) then
		return
	end
	clearVFXForUser(p1)
	local v9 = Emotes[p2]
	if if v9 then if typeof(v9.VFXStages) == "table" then true else false else false then
		local t = {}
		t4[p1] = t
		for i, v in ipairs(EmoteVFX:GetChildren()) do
			local v11
			local v12 = v.Name
			local v13 = Emotes[p2]
			if v13 then
				local VFXStages = v13.VFXStages
				if typeof(VFXStages) == "table" then
					local v14 = VFXStages[v12]
					v11 = if typeof(v14) == "number" then math.max(v14, 0) else nil
				else
					v11 = nil
				end
			else
				v11 = nil
			end
			if v11 then
				task.delay(v11, function() --[[ Line: 893 | Upvalues: t3 (ref), p1 (copy), p2 (copy), t4 (ref), t (copy), v8 (copy), v (copy), forEachParticleEmitter (ref) ]]
					local v1 = t3[p1]
					if not v1 or v1.EmoteName ~= p2 then
						return
					end
					if t4[p1] ~= t or not v8.Parent then
						return
					end
					local v2 = v:Clone()
					forEachParticleEmitter(v2, function(p1_2_2_2_2) --[[ Line: 865 ]]
						p1_2_2_2_2.Enabled = false
					end)
					v2.Parent = v8
					forEachParticleEmitter(v2, function(p1_2_2_2_2) --[[ Line: 865 ]]
						p1_2_2_2_2.Enabled = false
					end)
					if t4[p1] == t then
						table.insert(t, v2)
						forEachParticleEmitter(v2, function(p1_2_2) --[[ Line: 871 ]]
							local v1 = p1_2_2:GetAttribute("EmitCount")
							if typeof(v1) ~= "number" then
								v1 = tonumber(p1_2_2.Name) or 1
							end
							p1_2_2.Enabled = false
							p1_2_2:Emit(v1)
							task.defer(function() --[[ Line: 879 | Upvalues: p1_2_2 (copy) ]]
								if not p1_2_2.Parent then
									return
								end
								p1_2_2.Enabled = false
							end)
						end)
						return
					end
					if not v2.Parent then
						return
					end
					v2:Destroy()
				end)
			end
		end
	else
		local v16 = EmoteVFX:Clone()
		local t = {}
		for i, v in ipairs(v16:GetChildren()) do
			v.Parent = v8
			ParticleEmitter.emitContainer(v)
			table.insert(t, v)
		end
		v16:Destroy()
		if not (#t > 0) then
			return
		end
		t4[p1] = t
	end
end
local function emitVFXForUserAfterDelay(p1, p2) --[[ emitVFXForUserAfterDelay | Line: 978 | Upvalues: Emotes (copy), emitVFXForUser (copy), t3 (copy) ]]
	local v1 = Emotes[p2]
	if if v1 then if typeof(v1.VFXStages) == "table" then true else false else false then
		return
	end
	local v3 = Emotes[p2]
	local v4
	if v3 then
		local VFXStartDelay = v3.VFXStartDelay
		v4 = if typeof(VFXStartDelay) == "number" then math.max(VFXStartDelay, 0) else 0
	else
		v4 = 0
	end
	if v4 <= 0 then
		emitVFXForUser(p1, p2)
	else
		task.delay(v4, function() --[[ Line: 989 | Upvalues: t3 (ref), p1 (copy), p2 (copy), emitVFXForUser (ref) ]]
			local v1 = t3[p1]
			if v1 and v1.EmoteName == p2 then
				emitVFXForUser(p1, p2)
			end
		end)
	end
end
local function stopAnimatorTracksForUser(p1, p2) --[[ stopAnimatorTracksForUser | Line: 999 | Upvalues: Players (copy) ]]
	if #p2 == 0 then
		return
	end
	local v1 = Players:GetPlayerByUserId(p1)
	if not v1 then
		return
	end
	local Character = v1.Character
	local v2 = if Character then Character:FindFirstChildWhichIsA("Humanoid") else nil
	local v4 = if v2 and not (v2.Health <= 0) then v2:FindFirstChildWhichIsA("Animator") else nil
	if not v4 then
		return
	end
	local t = {}
	for i, v in ipairs(p2) do
		if v ~= "" then
			t[v] = true
		end
	end
	if next(t) == nil then
		return
	end
	for i, v in ipairs(v4:GetPlayingAnimationTracks()) do
		local Animation = v.Animation
		if Animation and t[Animation.AnimationId] then
			pcall(function() --[[ Line: 1028 | Upvalues: v (copy) ]]
				v:Stop(0.1)
			end)
		end
	end
end
local function stopTrackForUser(p1) --[[ stopTrackForUser | Line: 1035 | Upvalues: t3 (copy), LocalPlayer (copy), v7 (ref), stopAnimatorTracksForUser (copy) ]]
	local v1 = t3[p1]
	if not v1 then
		return
	end
	t3[p1] = nil
	if p1 == LocalPlayer.UserId then
		v7 = nil
	end
	stopAnimatorTracksForUser(p1, v1.AnimationIds)
	v1.Trove:Destroy()
end
local function stopLocalActiveEmote() --[[ stopLocalActiveEmote | Line: 1050 | Upvalues: v7 (ref), LocalPlayer (copy), t3 (copy), stopAnimatorTracksForUser (copy), v4 (copy) ]]
	if not v7 then
		return
	end
	local UserId = LocalPlayer.UserId
	local v1 = t3[UserId]
	if v1 then
		t3[UserId] = nil
		if UserId == LocalPlayer.UserId then
			v7 = nil
		end
		stopAnimatorTracksForUser(UserId, v1.AnimationIds)
		v1.Trove:Destroy()
	end
	v4:FireServer()
end
local function playTrackForUser(p1, p2, p3, p4) --[[ playTrackForUser | Line: 1059 | Upvalues: Emotes (copy), Players (copy), t3 (copy), LocalPlayer (copy), v7 (ref), stopAnimatorTracksForUser (copy), Trove (copy), playEmoteSoundForPlayer (copy), v4 (copy), emitVFXForUserAfterDelay (copy), emitVFXForUser (copy), getHumanoidRootPart (copy), createBurstEmitter (copy), createGlow (copy) ]]
	local v1 = Emotes[p2]
	if not v1 then
		return
	end
	local v2 = Players:GetPlayerByUserId(p1)
	if v2 then
		local Character = v2.Character
		local v3 = if Character then Character:FindFirstChildWhichIsA("Humanoid") else nil
		local v42 = if v3 and not (v3.Health <= 0) then v3:FindFirstChildWhichIsA("Animator") else nil
		if v42 or p4 then
			local v5 = t3[p1]
			if v5 then
				t3[p1] = nil
				if p1 == LocalPlayer.UserId then
					v7 = nil
				end
				stopAnimatorTracksForUser(p1, v5.AnimationIds)
				v5.Trove:Destroy()
			end
			local v6 = Trove.new()
			local v72 = nil
			local v8 = true
			local function playOrRestartEmoteSound() --[[ playOrRestartEmoteSound | Line: 1082 | Upvalues: v72 (ref), playEmoteSoundForPlayer (ref), v2 (copy), p2 (copy) ]]
				if v72 and v72.Parent then
					v72:Destroy()
				end
				v72 = playEmoteSoundForPlayer(v2, p2)
			end
			if v72 and v72.Parent then
				v72:Destroy()
			end
			v72 = playEmoteSoundForPlayer(v2, p2)
			v6:Add(function() --[[ Line: 1090 | Upvalues: v8 (ref), v72 (ref) ]]
				if v8 and (v72 and v72.Parent) then
					v72:Destroy()
				end
				v72 = nil
			end)
			local v9 = nil
			local v10 = nil
			local t = { v1.AnimationId }
			if v1.TargetAnimationId then
				table.insert(t, v1.TargetAnimationId)
			end
			if not p4 then
				v10 = Instance.new("Animation")
				v10.AnimationId = v1.AnimationId
				local v11, v12 = pcall(function() --[[ Line: 1109 | Upvalues: v42 (copy), v10 (ref) ]]
					return v42:LoadAnimation(v10)
				end)
				if v11 then
					v9 = v12
					v9.Priority = v1.AnimationPriority or Enum.AnimationPriority.Action2
					v9.Looped = if v1.Looped == true then true else false
					v9:Play(0.1, 1, v1.PlaybackSpeed or 1)
					v6:Add(function() --[[ Line: 1126 | Upvalues: v9 (ref), v10 (ref) ]]
						pcall(function() --[[ Line: 1127 | Upvalues: v9 (ref) ]]
							if not v9.IsPlaying then
								return
							end
							v9:Stop(0.1)
						end)
						pcall(function() --[[ Line: 1132 | Upvalues: v9 (ref) ]]
							v9:Destroy()
						end)
						if not v10 or v10.Parent == nil then
							return
						end
						v10:Destroy()
					end)
					v6:Add(v9.Stopped:Connect(function() --[[ Line: 1140 | Upvalues: v1 (copy), t3 (ref), p1 (copy), v9 (ref), v8 (ref), LocalPlayer (ref), v4 (ref), v7 (ref), stopAnimatorTracksForUser (ref) ]]
						if v1.Looped then
							return
						end
						local v12 = t3[p1]
						if not v12 or v12.Track ~= v9 then
							return
						end
						if v9.Length > 0 and v9.Length - v9.TimePosition <= 0.05 then
							v8 = false
						end
						if v1.SwapHumanoidDescriptions then
							return
						end
						if p1 == LocalPlayer.UserId then
							v4:FireServer()
						end
						local v3 = p1
						local v42 = t3[v3]
						if not v42 then
							return
						end
						t3[v3] = nil
						if v3 == LocalPlayer.UserId then
							v7 = nil
						end
						stopAnimatorTracksForUser(v3, v42.AnimationIds)
						v42.Trove:Destroy()
					end))
					if v1.Looped then
						v6:Add(v9.DidLoop:Connect(function() --[[ Line: 1162 | Upvalues: t3 (ref), p1 (copy), v9 (ref), v72 (ref), playEmoteSoundForPlayer (ref), v2 (copy), p2 (copy), emitVFXForUserAfterDelay (ref) ]]
							local v1 = t3[p1]
							if not v1 or v1.Track ~= v9 then
								return
							end
							if v72 and v72.Parent then
								v72:Destroy()
							end
							v72 = playEmoteSoundForPlayer(v2, p2)
							emitVFXForUserAfterDelay(p1, p2)
						end))
					end
				else
					if v10.Parent == nil then
						v6:Destroy()
						return
					end
					v10:Destroy()
					v6:Destroy()
					return
				end
			end
			t3[p1] = {
				Track = v9,
				Animation = v10,
				Trove = v6,
				EmoteName = p2,
				AnimationIds = t
			}
			if p1 == LocalPlayer.UserId then
				v7 = p2
			end
			local v15 = Emotes[p2]
			if if v15 then if typeof(v15.VFXStages) == "table" then true else false else false then
				emitVFXForUser(p1, p2)
			end
			local AutoStopDuration = v1.AutoStopDuration
			if AutoStopDuration and (AutoStopDuration > 0 and v9) then
				task.delay(AutoStopDuration, function() --[[ Line: 1192 | Upvalues: t3 (ref), p1 (copy), v9 (ref), LocalPlayer (ref), v7 (ref), stopAnimatorTracksForUser (ref) ]]
					local v1 = t3[p1]
					if not v1 or v1.Track ~= v9 then
						return
					end
					local v2 = p1
					local v3 = t3[v2]
					if not v3 then
						return
					end
					t3[v2] = nil
					if v2 == LocalPlayer.UserId then
						v7 = nil
					end
					stopAnimatorTracksForUser(v2, v3.AnimationIds)
					v3.Trove:Destroy()
				end)
			end
			local v17 = if p3 then Players:GetPlayerByUserId(p3) else nil
			local v18 = Emotes[p2]
			local v19
			if v18 then
				local EffectCallback = v18.EffectCallback
				v19 = if typeof(EffectCallback) == "function" then EffectCallback({
	ActorPlayer = v2,
	TargetPlayer = v17,
	GetHumanoidRootPart = getHumanoidRootPart,
	CreateBurstEmitter = createBurstEmitter,
	CreateGlow = createGlow
}) else nil
			else
				v19 = nil
			end
			if typeof(v19) ~= "function" then
				return
			end
			v6:Add(v19)
		else
			local v21 = t3[p1]
			if not v21 then
				return
			end
			t3[p1] = nil
			if p1 ~= LocalPlayer.UserId then
				stopAnimatorTracksForUser(p1, v21.AnimationIds)
				v21.Trove:Destroy()
				return
			end
			v7 = nil
			stopAnimatorTracksForUser(p1, v21.AnimationIds)
			v21.Trove:Destroy()
		end
	else
		local v22 = t3[p1]
		if not v22 then
			return
		end
		t3[p1] = nil
		if p1 ~= LocalPlayer.UserId then
			stopAnimatorTracksForUser(p1, v22.AnimationIds)
			v22.Trove:Destroy()
			return
		end
		v7 = nil
		stopAnimatorTracksForUser(p1, v22.AnimationIds)
		v22.Trove:Destroy()
	end
end
local function getNearestPlayerInfo(p1) --[[ getNearestPlayerInfo | Line: 1207 | Upvalues: LocalPlayer (copy), Players (copy) ]]
	local Character = LocalPlayer.Character
	local v1
	if Character then
		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
		if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
			v1 = HumanoidRootPart
		else
			local PrimaryPart = Character.PrimaryPart
			if PrimaryPart then
				v1 = PrimaryPart
			else
				local v2 = Character:FindFirstChildWhichIsA("Humanoid")
				v1 = if v2 and v2.RootPart then v2.RootPart else nil
			end
		end
	else
		v1 = nil
	end
	if not v1 then
		return nil, nil
	end
	local v3 = nil
	local v4 = nil
	for i, v in ipairs(Players:GetPlayers()) do
		local v5
		if v ~= LocalPlayer then
			local Character_2 = v.Character
			if Character_2 then
				local HumanoidRootPart = Character_2:FindFirstChild("HumanoidRootPart")
				if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
					v5 = HumanoidRootPart
				else
					local PrimaryPart = Character_2.PrimaryPart
					if PrimaryPart then
						v5 = PrimaryPart
					else
						local v6 = Character_2:FindFirstChildWhichIsA("Humanoid")
						v5 = if v6 and v6.RootPart then v6.RootPart else nil
					end
				end
			else
				v5 = nil
			end
			if v5 then
				local Magnitude = (v1.Position - v5.Position).Magnitude
				if Magnitude <= p1 and (not v3 or Magnitude <= v3) then
					v3 = Magnitude
					v4 = v
				end
			end
		end
	end
	return v4, v3
end
local function getNearestPlayer(p1) --[[ getNearestPlayer | Line: 1236 | Upvalues: getNearestPlayerInfo (copy) ]]
	return getNearestPlayerInfo(p1)
end
local function getPromptTargetPlayer(p1) --[[ getPromptTargetPlayer | Line: 1241 | Upvalues: v8 (ref), Players (copy), LocalPlayer (copy) ]]
	local v1 = v8
	if not v1 or (not v1:IsDescendantOf(Players) or v1 == LocalPlayer) then
		return nil
	end
	local Character = LocalPlayer.Character
	local v2
	if Character then
		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
		if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
			v2 = HumanoidRootPart
		else
			local PrimaryPart = Character.PrimaryPart
			if PrimaryPart then
				v2 = PrimaryPart
			else
				local v3 = Character:FindFirstChildWhichIsA("Humanoid")
				v2 = if v3 and v3.RootPart then v3.RootPart else nil
			end
		end
	else
		v2 = nil
	end
	local Character_2 = v1.Character
	local v4
	if Character_2 then
		local HumanoidRootPart = Character_2:FindFirstChild("HumanoidRootPart")
		if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
			v4 = HumanoidRootPart
		else
			local PrimaryPart = Character_2.PrimaryPart
			if PrimaryPart then
				v4 = PrimaryPart
			else
				local v5 = Character_2:FindFirstChildWhichIsA("Humanoid")
				v4 = if v5 and v5.RootPart then v5.RootPart else nil
			end
		end
	else
		v4 = nil
	end
	if not (v2 and v4) then
		return nil
	end
	if p1 < (v2.Position - v4.Position).Magnitude then
		return nil
	else
		return v1
	end
end
local function resolveEmoteName(p1) --[[ resolveEmoteName | Line: 1260 | Upvalues: Emotes (copy) ]]
	local v1 = p1:GetAttribute("EmoteName")
	if typeof(v1) == "string" and Emotes[v1] then
		return v1
	end
	local list = { p1.Name }
	if p1:IsA("TextButton") then
		table.insert(list, p1.Text)
	end
	local v2 = p1:FindFirstChildWhichIsA("TextLabel")
	if v2 then
		table.insert(list, v2.Text)
	end
	for i, v in ipairs(list) do
		if Emotes[v] then
			return v
		end
	end
	for i, v in ipairs(list) do
		local v3 = string.lower((v:gsub("%W", "")))
		if #v3 ~= 0 then
			for v4 in Emotes do
				local v5 = string.lower((v4:gsub("%W", "")))
				if v3 == v5 then
					return v4
				end
				if string.find(v3, v5, 1, true) then
					return v4
				end
				if string.find(v5, v3, 1, true) then
					return v4
				end
			end
		end
	end
	return nil
end
local function playSelectedEmote(p1, p2) --[[ playSelectedEmote | Line: 1305 | Upvalues: notifyError (copy), Emotes (copy), v7 (ref), LocalPlayer (copy), t3 (copy), stopAnimatorTracksForUser (copy), v4 (copy), v8 (ref), getPromptTargetPlayer (copy), getNearestPlayerInfo (copy), GuiControl (copy), t (copy), updateWheelHoverPresentation (copy), v11 (ref) ]]
	if p1 then
		local v1 = Emotes[p1]
		if not v1 then
			return false
		end
		if v7 == p1 then
			if not v7 then
				return true
			end
			local UserId = LocalPlayer.UserId
			local v2 = t3[UserId]
			if v2 then
				t3[UserId] = nil
				if UserId == LocalPlayer.UserId then
					v7 = nil
				end
				stopAnimatorTracksForUser(UserId, v2.AnimationIds)
				v2.Trove:Destroy()
			end
			v4:FireServer()
			return true
		else
			local v3 = nil
			if v8 then
				local v42 = getPromptTargetPlayer(v1.MaxDistance or 15)
				if not v42 and v8 then
					v8 = nil
					notifyError("Move closer to that player to use this emote.")
					return false
				end
				v3 = v42
			elseif v1.RequiresTarget then
				local v5 = getNearestPlayerInfo(v1.MaxDistance or 15)
				if not v5 then
					notifyError("Move closer to another player to use this emote.")
					return false
				end
				v3 = v5
			end
			if v8 and not v3 then
				v8 = nil
				notifyError("Move closer to that player to use this emote.")
				return false
			end
			GuiControl:Close()
			local v6 = t:PlayEmote(p1, v3)
			v8 = nil
			updateWheelHoverPresentation(v11)
			return v6
		end
	else
		if not p2 then
			return false
		end
		notifyError("No emote equipped in this slot.")
		return false
	end
end
local function tryPlaySlot(p1) --[[ tryPlaySlot | Line: 1353 | Upvalues: v6 (copy), t6 (copy), v15 (ref), InventoryController (copy), GuiControl (copy), v16 (ref), EmoteCrates (copy), notifyError (copy), EmoteLootboxController (copy), playSelectedEmote (copy) ]]
	if p1 < 1 or p1 > 8 then
		return false
	end
	v6:FireServer()
	local v1 = t6[p1]
	local v2, v3
	if v1 then
		v2 = "Emote"
		v3 = v1
	else
		v2 = if #t6 >= 8 then "Empty" elseif p1 == 8 then "Buy" else "Add"
		v3 = nil
	end
	if v2 == "Add" then
		v15 = true
		InventoryController:SetPage("Items")
		InventoryController:SetCategory("Emotes")
		InventoryController.InventoryStateChanged:Fire("Emotes")
		GuiControl:Open("Inventory", false)
		return true
	end
	if v2 ~= "Buy" then
		return playSelectedEmote(v3, true)
	end
	v16 = true
	local v4 = (1 / 0)
	local v5 = nil
	for v62, v7 in EmoteCrates do
		if v7.Order < v4 then
			v4 = v7.Order
			v5 = v62
		end
	end
	if v5 then
		EmoteLootboxController:Open(v5)
	else
		notifyError("Emote shop is unavailable right now.")
	end
	return true
end
local function tryPlayButton(p1) --[[ tryPlayButton | Line: 1374 | Upvalues: v6 (copy), resolveEmoteName (copy), WheelImage (copy), playSelectedEmote (copy) ]]
	v6:FireServer()
	local v1 = resolveEmoteName(p1)
	playSelectedEmote(v1, p1.Parent == WheelImage)
end
local function bindButton(p1) --[[ bindButton | Line: 1381 | Upvalues: t2 (copy), AddEmotes (copy), v10 (copy), v6 (copy), v15 (ref), InventoryController (copy), GuiControl (copy), BuyEmotes (copy), v16 (ref), EmoteCrates (copy), notifyError (copy), EmoteLootboxController (copy), EditEmotes (copy), v4 (copy), resolveEmoteName (copy), WheelImage (copy), playSelectedEmote (copy) ]]
	if t2[p1] then
		return
	end
	t2[p1] = true
	if p1 == AddEmotes then
		v10:Add(p1.Activated:Connect(function() --[[ Line: 1389 | Upvalues: v6 (ref), v15 (ref), InventoryController (ref), GuiControl (ref) ]]
			v6:FireServer()
			v15 = true
			InventoryController:SetPage("Items")
			InventoryController:SetCategory("Emotes")
			InventoryController.InventoryStateChanged:Fire("Emotes")
			GuiControl:Open("Inventory", false)
		end))
		return
	end
	if p1 == BuyEmotes then
		v10:Add(p1.Activated:Connect(function() --[[ Line: 1397 | Upvalues: v6 (ref), v16 (ref), EmoteCrates (ref), notifyError (ref), EmoteLootboxController (ref) ]]
			v6:FireServer()
			v16 = true
			local v1 = (1 / 0)
			local v2 = nil
			for v3, v4 in EmoteCrates do
				if v4.Order < v1 then
					v1 = v4.Order
					v2 = v3
				end
			end
			if v2 then
				EmoteLootboxController:Open(v2)
			else
				notifyError("Emote shop is unavailable right now.")
			end
		end))
		return
	end
	if p1 == EditEmotes then
		v10:Add(GuiControl:Hook("Hold Button", p1).Clicked:Connect(function() --[[ Line: 1406 | Upvalues: v6 (ref), v15 (ref), InventoryController (ref), GuiControl (ref) ]]
			v6:FireServer()
			v15 = true
			InventoryController:SetPage("Items")
			InventoryController:SetCategory("Emotes")
			InventoryController.InventoryStateChanged:Fire("Emotes")
			GuiControl:Open("Inventory", false)
		end))
		return
	end
	local v2 = string.lower((p1.Name:gsub("%W", "")))
	if p1:GetAttribute("StopEmote") == true or (v2 == "stopemote" or v2 == "stop") then
		v10:Add(p1.Activated:Connect(function() --[[ Line: 1415 | Upvalues: v6 (ref), v4 (ref) ]]
			v6:FireServer()
			v4:FireServer()
		end))
	else
		v10:Add(p1.Activated:Connect(function() --[[ Line: 1422 | Upvalues: v6 (ref), p1 (copy), v15 (ref), InventoryController (ref), GuiControl (ref), v16 (ref), EmoteCrates (ref), notifyError (ref), EmoteLootboxController (ref), resolveEmoteName (ref), WheelImage (ref), playSelectedEmote (ref) ]]
			v6:FireServer()
			if p1:GetAttribute("OpenAddEmotes") == true then
				v15 = true
				InventoryController:SetPage("Items")
				InventoryController:SetCategory("Emotes")
				InventoryController.InventoryStateChanged:Fire("Emotes")
				GuiControl:Open("Inventory", false)
				return
			end
			if p1:GetAttribute("OpenBuyEmotes") == true then
				v16 = true
				local v1 = (1 / 0)
				local v2 = nil
				for v3, v4 in EmoteCrates do
					if v4.Order < v1 then
						v1 = v4.Order
						v2 = v3
					end
				end
				if v2 then
					EmoteLootboxController:Open(v2)
				else
					notifyError("Emote shop is unavailable right now.")
				end
			else
				local v5 = p1
				v6:FireServer()
				local v62 = resolveEmoteName(v5)
				playSelectedEmote(v62, v5.Parent == WheelImage)
			end
		end))
	end
end
function t.PlayEmote(p1, p2, p3) --[[ PlayEmote | Line: 1439 | Upvalues: Emotes (copy), notifyError (copy), t5 (copy), getBlockedReason (copy), notifyHint (copy), v1 (copy) ]]
	if typeof(p2) ~= "string" then
		return false
	end
	if not Emotes[p2] then
		notifyError("Invalid emote.")
		return false
	end
	if not (if t5[p2] == true then true else false) then
		notifyError("Equip this emote in Inventory first.")
		return false
	end
	local v2 = getBlockedReason()
	if v2 then
		notifyError(v2)
		return false
	end
	local v3 = if p3 then p3.UserId else nil
	if p3 then
		notifyHint((("Waiting on %*\'s confirmation."):format(p3.DisplayName)))
	end
	local v4, v5, v6 = pcall(function() --[[ Line: 1465 | Upvalues: v1 (ref), p2 (copy), v3 (copy) ]]
		return v1:InvokeServer(p2, v3)
	end)
	if not v4 then
		notifyError("Unable to play emote right now.")
		return false
	end
	if v5 ~= true then
		notifyError(v6 or "Unable to play emote right now.")
		return false
	end
	if not p3 then
		return true
	end
	notifyHint((("%* accepted your sync request."):format(p3.DisplayName)))
	return true
end
function t.StopEmote(p1) --[[ StopEmote | Line: 1486 | Upvalues: v7 (ref), LocalPlayer (copy), t3 (copy), stopAnimatorTracksForUser (copy), v4 (copy) ]]
	if not v7 then
		return
	end
	local UserId = LocalPlayer.UserId
	local v1 = t3[UserId]
	if v1 then
		t3[UserId] = nil
		if UserId == LocalPlayer.UserId then
			v7 = nil
		end
		stopAnimatorTracksForUser(UserId, v1.AnimationIds)
		v1.Trove:Destroy()
	end
	v4:FireServer()
end
function t.Start(p1) --[[ Start | Line: 1490 | Upvalues: v9 (ref), Replion (copy), refreshEquippedEmoteNames (copy), v10 (copy), v3 (copy), Players (copy), v2 (copy), PromptController (copy), Observers (copy), LocalPlayer (copy), getCharacterRootPart (copy), t6 (copy), t8 (copy), notifyError (copy), v6 (copy), EmoteWheel (copy), WheelImage (copy), GuiControl (copy), v8 (ref), notifyHint (copy), updateWheelHoverPresentation (copy), v11 (ref), Inventory (copy), v15 (ref), EmoteLootbox (copy), v16 (ref), updateSyncPromptStates (copy), v7 (ref), t3 (copy), stopAnimatorTracksForUser (copy), v4 (copy), FishingController (copy), RunService (copy), UserInputService (copy), v12 (ref), v13 (ref), GuiService (copy), zero (ref), zero_2 (ref), v17 (ref), getHoveredWheelSlot (copy), getHoveredWheelSlotFromGamepad (copy), bindButton (copy), v5 (copy), clearVFXForUser (copy), emitVFXForUserAfterDelay (copy), playTrackForUser (copy), tryPlaySlot (copy) ]]
	v9 = Replion.Client:WaitReplion("Data")
	refreshEquippedEmoteNames()
	v10:Add(v3.OnClientEvent:Connect(function(p1, p2, p3) --[[ Line: 1494 | Upvalues: Players (ref), v2 (ref), PromptController (ref) ]]
		if typeof(p1) ~= "string" then
			return
		end
		if p2 and (p2:IsDescendantOf(Players) and typeof(p3) == "string") then
			local v1, v22 = PromptController:FirePrompt(("Accept <b>%*</b> sync request from: %*?"):format(p3, p2.DisplayName), true):await()
			pcall(function() --[[ Line: 1511 | Upvalues: v2 (ref), p1 (copy), v1 (copy), v22 (copy) ]]
				v2:InvokeServer(p1, v1 and v22 == true)
			end)
		else
			pcall(function() --[[ Line: 1500 | Upvalues: v2 (ref), p1 (copy) ]]
				v2:InvokeServer(p1, false)
			end)
		end
	end))
	v10:Add(Observers.observeCharacter(function(p1, p2) --[[ Line: 1516 | Upvalues: LocalPlayer (ref), getCharacterRootPart (ref), t6 (ref), v9 (ref), t8 (ref), notifyError (ref), v6 (ref), EmoteWheel (ref), WheelImage (ref), GuiControl (ref), v8 (ref), notifyHint (ref), updateWheelHoverPresentation (ref), v11 (ref) ]]
		if p1 == LocalPlayer then
			return
		end
		local v1 = getCharacterRootPart(p2, 5)
		if not v1 then
			return
		end
		local SyncEmotePrompt = Instance.new("ProximityPrompt")
		SyncEmotePrompt.Name = "SyncEmotePrompt"
		SyncEmotePrompt.Style = Enum.ProximityPromptStyle.Custom
		SyncEmotePrompt.KeyboardKeyCode = Enum.KeyCode.E
		SyncEmotePrompt.GamepadKeyCode = Enum.KeyCode.ButtonX
		SyncEmotePrompt.ActionText = "Sync Emote"
		SyncEmotePrompt.ObjectText = p1.DisplayName
		SyncEmotePrompt.RequiresLineOfSight = false
		SyncEmotePrompt.MaxActivationDistance = 15
		local v2 = #t6 > 0
		local v3
		if v2 then
			if v9 then
				local v4 = v9:Get("EquippedType")
				v3 = if typeof(v4) == "string" and v4 ~= "" then "Put away your held item before syncing an emote." else nil
			else
				v3 = nil
			end
		else
			v3 = "Equip an emote in your wheel first."
		end
		SyncEmotePrompt.Enabled = if v3 == nil then true else false
		SyncEmotePrompt.Parent = v1
		t8[p1] = SyncEmotePrompt
		local v62 = SyncEmotePrompt.Triggered:Connect(function(p12) --[[ Line: 1540 | Upvalues: LocalPlayer (ref), t6 (ref), v9 (ref), notifyError (ref), v6 (ref), EmoteWheel (ref), WheelImage (ref), GuiControl (ref), v8 (ref), p1 (copy), notifyHint (ref), updateWheelHoverPresentation (ref), v11 (ref) ]]
			if p12 ~= LocalPlayer then
				return
			end
			local v2
			if #t6 > 0 then
				if v9 then
					local v3 = v9:Get("EquippedType")
					v2 = if typeof(v3) == "string" and v3 ~= "" then "Put away your held item before syncing an emote." else nil
				else
					v2 = nil
				end
			else
				v2 = "Equip an emote in your wheel first."
			end
			if v2 then
				notifyError(v2)
				return
			end
			v6:FireServer()
			if not (EmoteWheel.Enabled and WheelImage.Visible) then
				GuiControl:Open("EmoteWheel")
			end
			v8 = p1
			notifyHint((("Select an emote to sync with %*."):format(p1.DisplayName)))
			updateWheelHoverPresentation(v11)
		end)
		return function() --[[ Line: 1560 | Upvalues: v62 (copy), t8 (ref), p1 (copy), v8 (ref), updateWheelHoverPresentation (ref), v11 (ref), SyncEmotePrompt (copy) ]]
			v62:Disconnect()
			t8[p1] = nil
			if v8 == p1 then
				v8 = nil
				updateWheelHoverPresentation(v11)
			end
			if not SyncEmotePrompt.Parent then
				return
			end
			SyncEmotePrompt:Destroy()
		end
	end))
	v10:Add(GuiControl.GuiUnfocusedSignal:Connect(function(p1) --[[ Line: 1573 | Upvalues: EmoteWheel (ref), v8 (ref), updateWheelHoverPresentation (ref), v11 (ref), Inventory (ref), v15 (ref), EmoteLootbox (ref), v16 (ref), GuiControl (ref) ]]
		if p1 == EmoteWheel then
			v8 = nil
			updateWheelHoverPresentation(v11)
		end
		local v1 = false
		if p1 == Inventory and v15 then
			v15 = false
			v1 = true
		elseif p1 == EmoteLootbox and v16 then
			v16 = false
			v1 = true
		end
		if v1 then
			task.defer(function() --[[ Line: 1592 | Upvalues: GuiControl (ref) ]]
				if GuiControl.Gui == nil then
					GuiControl:Open("EmoteWheel")
				end
			end)
		end
	end))
	if v9 then
		v10:Add(v9:OnChange("EquippedEmotes", function() --[[ Line: 1602 | Upvalues: refreshEquippedEmoteNames (ref) ]]
			refreshEquippedEmoteNames()
		end))
		v10:Add(v9:OnChange({ "Inventory", "Emotes" }, function() --[[ Line: 1605 | Upvalues: refreshEquippedEmoteNames (ref) ]]
			refreshEquippedEmoteNames()
		end))
		v10:Add(v9:OnChange("EquippedType", function(p1, p2) --[[ Line: 1608 | Upvalues: updateSyncPromptStates (ref), v7 (ref), LocalPlayer (ref), t3 (ref), stopAnimatorTracksForUser (ref), v4 (ref) ]]
			if p1 == p2 then
				return
			end
			updateSyncPromptStates()
			if p1 ~= "Fishing Rods" and p2 ~= "Fishing Rods" or not v7 then
				return
			end
			if not v7 then
				return
			end
			local UserId = LocalPlayer.UserId
			local v1 = t3[UserId]
			if v1 then
				t3[UserId] = nil
				if UserId == LocalPlayer.UserId then
					v7 = nil
				end
				stopAnimatorTracksForUser(UserId, v1.AnimationIds)
				v1.Trove:Destroy()
			end
			v4:FireServer()
		end))
		v10:Add(v9:OnChange("EquippedId", function(p1, p2) --[[ Line: 1619 | Upvalues: v9 (ref), v7 (ref), LocalPlayer (ref), t3 (ref), stopAnimatorTracksForUser (ref), v4 (ref) ]]
			if p1 == p2 then
				return
			end
			if v9:Get("EquippedType") ~= "Fishing Rods" or not v7 then
				return
			end
			if not v7 then
				return
			end
			local UserId = LocalPlayer.UserId
			local v1 = t3[UserId]
			if v1 then
				t3[UserId] = nil
				if UserId == LocalPlayer.UserId then
					v7 = nil
				end
				stopAnimatorTracksForUser(UserId, v1.AnimationIds)
				v1.Trove:Destroy()
			end
			v4:FireServer()
		end))
	end
	local v1 = FishingController:GetCurrentGUID() ~= nil
	v10:Add(RunService.Heartbeat:Connect(function() --[[ Line: 1632 | Upvalues: FishingController (ref), v1 (ref), v7 (ref), LocalPlayer (ref), t3 (ref), stopAnimatorTracksForUser (ref), v4 (ref) ]]
		local v12 = FishingController:GetCurrentGUID() ~= nil
		if v12 and (not v1 and (v7 and v7)) then
			local UserId = LocalPlayer.UserId
			local v2 = t3[UserId]
			if v2 then
				t3[UserId] = nil
				if UserId == LocalPlayer.UserId then
					v7 = nil
				end
				stopAnimatorTracksForUser(UserId, v2.AnimationIds)
				v2.Trove:Destroy()
			end
			v4:FireServer()
		end
		if v7 then
			local Character = LocalPlayer.Character
			local v3 = if Character then Character:FindFirstChildWhichIsA("Humanoid") else nil
			if v3 and (v3.MoveDirection.Magnitude > 0.05 and v7) then
				local UserId = LocalPlayer.UserId
				local v6 = t3[UserId]
				if v6 then
					t3[UserId] = nil
					if UserId == LocalPlayer.UserId then
						v7 = nil
					end
					stopAnimatorTracksForUser(UserId, v6.AnimationIds)
					v6.Trove:Destroy()
				end
				v4:FireServer()
			end
		end
		v1 = v12
	end))
	local function setHoveredWheelSlot(p1) --[[ setHoveredWheelSlot | Line: 1648 | Upvalues: v11 (ref), updateWheelHoverPresentation (ref) ]]
		if v11 ~= p1 then
			v11 = p1
			updateWheelHoverPresentation(p1)
		end
	end
	v10:Add(UserInputService.InputChanged:Connect(function(p1, p2) --[[ Line: 1657 | Upvalues: v12 (ref), v13 (ref), UserInputService (ref), EmoteWheel (ref), GuiService (ref), zero (ref), zero_2 (ref) ]]
		if p1.UserInputType == Enum.UserInputType.Touch then
			if v12 ~= p1 then
				return
			end
			local v1 = Vector2.new(p1.Position.X, p1.Position.Y)
			v13 = if UserInputService.TouchEnabled and EmoteWheel.IgnoreGuiInset then v1 else v1 - GuiService:GetGuiInset()
		else
			if p1.UserInputType ~= Enum.UserInputType.Gamepad1 then
				return
			end
			if p1.KeyCode == Enum.KeyCode.Thumbstick1 then
				zero = Vector2.new(p1.Position.X, p1.Position.Y)
				return
			end
			if p1.KeyCode ~= Enum.KeyCode.Thumbstick2 then
				return
			end
			zero_2 = Vector2.new(p1.Position.X, p1.Position.Y)
		end
	end))
	v10:Add(UserInputService.InputEnded:Connect(function(p1, p2) --[[ Line: 1674 | Upvalues: v12 (ref), v13 (ref) ]]
		if p1.UserInputType ~= Enum.UserInputType.Touch or v12 ~= p1 then
			return
		end
		v12 = nil
		v13 = nil
	end))
	v10:Add(RunService.RenderStepped:Connect(function() --[[ Line: 1681 | Upvalues: EmoteWheel (ref), WheelImage (ref), v17 (ref), v6 (ref), v11 (ref), updateWheelHoverPresentation (ref), v13 (ref), getHoveredWheelSlot (ref), getHoveredWheelSlotFromGamepad (ref), UserInputService (ref), GuiService (ref) ]]
		local v1 = EmoteWheel.Enabled and WheelImage.Visible
		if v1 and not v17 then
			v6:FireServer()
		end
		v17 = v1
		if v1 then
			local v2
			if v13 then
				v2 = getHoveredWheelSlot(v13)
			else
				local v4 = getHoveredWheelSlotFromGamepad()
				if v4 then
					v2 = v4
				else
					local v5 = UserInputService:GetMouseLocation()
					v2 = getHoveredWheelSlot(if UserInputService.TouchEnabled and EmoteWheel.IgnoreGuiInset then v5 else v5 - GuiService:GetGuiInset())
				end
			end
			if v11 ~= v2 then
				v11 = v2
				updateWheelHoverPresentation(v2)
			end
		elseif v11 ~= nil then
			v11 = nil
			updateWheelHoverPresentation(v11)
		end
	end))
	for i, v in ipairs(EmoteWheel:GetDescendants()) do
		if v:IsA("GuiButton") then
			bindButton(v)
		end
	end
	v10:Add(EmoteWheel.DescendantAdded:Connect(function(p1) --[[ Line: 1715 | Upvalues: bindButton (ref) ]]
		if not p1:IsA("GuiButton") then
			return
		end
		bindButton(p1)
	end))
	v10:Add(v5.OnClientEvent:Connect(function(p1, p2, p3, p4, p5) --[[ Line: 1721 | Upvalues: t3 (ref), LocalPlayer (ref), v7 (ref), stopAnimatorTracksForUser (ref), clearVFXForUser (ref), emitVFXForUserAfterDelay (ref), playTrackForUser (ref) ]]
		if p1 == "Stop" then
			local v1 = t3[p2]
			if v1 then
				t3[p2] = nil
				if p2 == LocalPlayer.UserId then
					v7 = nil
				end
				stopAnimatorTracksForUser(p2, v1.AnimationIds)
				v1.Trove:Destroy()
			end
			clearVFXForUser(p2)
		else
			if p1 == "EmitVFX" and p3 then
				emitVFXForUserAfterDelay(p2, p3)
				return
			end
			if p1 ~= "Play" or not p3 then
				return
			end
			playTrackForUser(p2, p3, p4, p5)
		end
	end))
	v10:Add(Players.PlayerRemoving:Connect(function(p1) --[[ Line: 1738 | Upvalues: t3 (ref), LocalPlayer (ref), v7 (ref), stopAnimatorTracksForUser (ref), clearVFXForUser (ref) ]]
		local UserId = p1.UserId
		local v1 = t3[UserId]
		if v1 then
			t3[UserId] = nil
			if UserId == LocalPlayer.UserId then
				v7 = nil
			end
			stopAnimatorTracksForUser(UserId, v1.AnimationIds)
			v1.Trove:Destroy()
		end
		clearVFXForUser(p1.UserId)
	end))
	v10:Add(LocalPlayer.CharacterRemoving:Connect(function() --[[ Line: 1743 | Upvalues: LocalPlayer (ref), t3 (ref), v7 (ref), stopAnimatorTracksForUser (ref), clearVFXForUser (ref) ]]
		local UserId = LocalPlayer.UserId
		local v1 = t3[UserId]
		if v1 then
			t3[UserId] = nil
			if UserId == LocalPlayer.UserId then
				v7 = nil
			end
			stopAnimatorTracksForUser(UserId, v1.AnimationIds)
			v1.Trove:Destroy()
		end
		clearVFXForUser(LocalPlayer.UserId)
	end))
	v10:Add(UserInputService.InputBegan:Connect(function(p1, p2) --[[ Line: 1748 | Upvalues: EmoteWheel (ref), WheelImage (ref), v11 (ref), tryPlaySlot (ref), UserInputService (ref), GuiService (ref), getHoveredWheelSlot (ref), v12 (ref), v13 (ref), v7 (ref), LocalPlayer (ref), t3 (ref), stopAnimatorTracksForUser (ref), v4 (ref) ]]
		if p2 then
			return
		end
		if p1.KeyCode == Enum.KeyCode.ButtonA and (EmoteWheel.Enabled and WheelImage.Visible and v11) then
			tryPlaySlot(v11)
			return
		end
		if p1.UserInputType == Enum.UserInputType.MouseButton1 and (EmoteWheel.Enabled and WheelImage.Visible) then
			local v3 = UserInputService:GetMouseLocation()
			local v5 = getHoveredWheelSlot(if UserInputService.TouchEnabled and EmoteWheel.IgnoreGuiInset then v3 else v3 - GuiService:GetGuiInset())
			if not v5 or v5 ~= v11 then
				return
			end
			tryPlaySlot(v5)
			return
		end
		if p1.UserInputType == Enum.UserInputType.Touch then
			if v12 == nil then
				v12 = p1
			end
			if v12 == p1 then
				local v6 = Vector2.new(p1.Position.X, p1.Position.Y)
				v13 = if UserInputService.TouchEnabled and EmoteWheel.IgnoreGuiInset then v6 else v6 - GuiService:GetGuiInset()
			end
		end
		if p1.KeyCode ~= Enum.KeyCode.X then
			return
		end
		if not v7 then
			return
		end
		local UserId = LocalPlayer.UserId
		local v8 = t3[UserId]
		if v8 then
			t3[UserId] = nil
			if UserId == LocalPlayer.UserId then
				v7 = nil
			end
			stopAnimatorTracksForUser(UserId, v8.AnimationIds)
			v8.Trove:Destroy()
		end
		v4:FireServer()
	end))
	v10:Add(UserInputService.TouchTap:Connect(function(p1, p2) --[[ Line: 1782 | Upvalues: EmoteWheel (ref), WheelImage (ref), v11 (ref), v13 (ref), getHoveredWheelSlot (ref), UserInputService (ref), GuiService (ref), updateWheelHoverPresentation (ref), tryPlaySlot (ref) ]]
		if p2 then
			return
		end
		if not (EmoteWheel.Enabled and WheelImage.Visible) then
			return
		end
		for i, v in ipairs(p1) do
			local v2 = v11
			if not v2 and v13 then
				v2 = getHoveredWheelSlot(v13)
			end
			if not v2 then
				local v4 = getHoveredWheelSlot(v)
				v2 = v4 or getHoveredWheelSlot(if UserInputService.TouchEnabled and EmoteWheel.IgnoreGuiInset then v else v - GuiService:GetGuiInset())
			end
			if v2 then
				if v11 == v2 then
					tryPlaySlot(v2)
					return
				end
				v11 = v2
				updateWheelHoverPresentation(v2)
				tryPlaySlot(v2)
				return
			end
		end
	end))
end
return t