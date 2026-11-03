-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
game:GetService("RunService")
local Net = require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Trove = require(ReplicatedStorage.Packages.Trove)
local spr = require(ReplicatedStorage.Packages.spr)
local InventoryMapping = require(ReplicatedStorage.Shared.InventoryMapping)
local LeviathanUtility = require(ReplicatedStorage.Shared.LeviathanUtility)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local v1 = nil
local v2 = nil
local v3 = Net:RemoteEvent("PlaceLeviathanPressureItem")
local v4 = Net:RemoteEvent("PlayLeviathanSequence")
local function RunUpdate() --[[ RunUpdate | Line: 28 | Upvalues: Players (copy) ]]
	local v1 = Players.LocalPlayer:GetAttribute("LocationName")
	return if v1 == "Pirate Cove" or (v1 == "Leviathan\'s Den" or v1 == "Secret Passage") then true else v1 == "Maze Room"
end
local function ChangedPressurePlate(p1, p2) --[[ ChangedPressurePlate | Line: 34 | Upvalues: LeviathanUtility (copy), v1 (ref), Players (copy), spr (copy), Soundbook (copy) ]]
	local v12 = LeviathanUtility.TOME_POSITIONS[p1]
	if not v12 then
		return
	end
	local MOVE_PART = p2:WaitForChild("MOVE_PART")
	local ACCENT = MOVE_PART:WaitForChild("ACCENT")
	if not MOVE_PART then
		return
	end
	if not ACCENT then
		return
	end
	local v2 = ACCENT:GetAttribute("OriginalColor")
	if not v2 then
		v2 = ACCENT.Color
		ACCENT:SetAttribute("OriginalColor", ACCENT.Color)
	end
	local v3 = MOVE_PART:GetAttribute("OriginalCFrame")
	if not v3 then
		local v4 = MOVE_PART:GetPivot()
		MOVE_PART:SetAttribute("OriginalCFrame", MOVE_PART:GetPivot())
		v3 = v4
	end
	local v5, v6
	if v1:Find("PressurePlates", p1) then
		v5 = v12.Color
		v6 = v3 - Vector3.new(0, 0.2, 0)
	else
		v6 = v3
		v5 = v2
	end
	local v7 = Players.LocalPlayer:GetAttribute("LocationName")
	if if v7 == "Pirate Cove" or (v7 == "Leviathan\'s Den" or v7 == "Secret Passage") then true else v7 == "Maze Room" then
		spr.target(MOVE_PART, 1, 3, {
			Pivot = v6
		})
		spr.target(ACCENT, 0.5, 1, {
			Color = v5
		})
		Soundbook:RenderAt("Leviathan Relic", v6.Position)
	else
		MOVE_PART:PivotTo(v6)
		ACCENT.Color = v5
	end
end
local function ChangeDoor(p1, p2) --[[ ChangeDoor | Line: 83 | Upvalues: Players (copy), spr (copy) ]]
	local v1 = p1:GetAttribute("Goal")
	if not v1 then
		return
	end
	local v2 = p1:GetAttribute("OriginalCFrame")
	if not v2 then
		local v3 = p1:GetPivot()
		p1:SetAttribute("OriginalCFrame", v3)
		v2 = v3
	end
	local v4 = if p2 and v1 then v1 else v2
	local v5 = Players.LocalPlayer:GetAttribute("LocationName")
	if if v5 == "Pirate Cove" or (v5 == "Leviathan\'s Den" or v5 == "Secret Passage") then true else v5 == "Maze Room" then
		spr.target(p1, 0.6, 0.15, {
			Pivot = v4
		})
	else
		p1:PivotTo(v4)
	end
end
Replion.Client:AwaitReplion("Data", function(p1) --[[ Line: 106 | Upvalues: v2 (ref), v1 (ref), Replion (copy), ReplicatedStorage (copy), Observers (copy), ChangeDoor (copy), Players (copy), Soundbook (copy), LeviathanUtility (copy), Trove (copy), ChangedPressurePlate (copy), ItemUtility (copy), InventoryMapping (copy), PlayerStatsUtility (copy), v3 (copy), v4 (copy), spr (copy) ]]
	v2 = p1
	v1 = Replion.Client:WaitReplion("LeviathanEvent")
	local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
	local VFXController = require(ReplicatedStorage.Controllers.VFXController)
	Observers.observeTag("LeviathanGate", function(p1) --[[ Line: 116 | Upvalues: v1 (ref), ChangeDoor (ref), Players (ref), Soundbook (ref) ]]
		local Left = p1:WaitForChild("Left")
		local Right = p1:WaitForChild("Right")
		if Left and Right then
			local function UpdateDoor() --[[ UpdateDoor | Line: 121 | Upvalues: v1 (ref), ChangeDoor (ref), Left (copy), Right (copy), Players (ref), p1 (copy), Soundbook (ref) ]]
				local v12 = v1:GetExpect("Event")
				ChangeDoor(Left, v12)
				ChangeDoor(Right, v12)
				local v2 = Players.LocalPlayer:GetAttribute("LocationName")
				if not ((if v2 == "Pirate Cove" or (v2 == "Leviathan\'s Den" or v2 == "Secret Passage") then true else v2 == "Maze Room") and v12) then
					return
				end
				local Part = p1:WaitForChild("Middle"):WaitForChild("Part")
				if not Part then
					return
				end
				Soundbook:RenderAt("Leviathan Door", Part.Position)
			end
			v1:OnChange("Event", UpdateDoor)
			UpdateDoor()
		end
	end, { workspace })
	Observers.observeTag("LeviathanPressurePlate", function(p1) --[[ Line: 141 | Upvalues: LeviathanUtility (ref), Trove (ref), v1 (ref), ChangedPressurePlate (ref), TextNotificationController (copy), ItemUtility (ref), InventoryMapping (ref), PlayerStatsUtility (ref), v2 (ref), v3 (ref) ]]
		local v12 = p1.Parent
		local v32 = tonumber(v12.Name)
		if not v32 then
			return
		end
		local v4 = LeviathanUtility.TOME_POSITIONS[v32]
		if not v4 then
			return
		end
		local v5 = Trove.new()
		local ProximityPrompt = p1:FindFirstChild("ProximityPrompt")
		if not ProximityPrompt then
			ProximityPrompt = Instance.new("ProximityPrompt")
			ProximityPrompt.ObjectText = ""
			ProximityPrompt.ActionText = "Place Item"
			ProximityPrompt.ClickablePrompt = true
			ProximityPrompt.RequiresLineOfSight = false
			ProximityPrompt.MaxActivationDistance = 15
			ProximityPrompt.GamepadKeyCode = Enum.KeyCode.DPadDown
			ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom
			ProximityPrompt.Parent = p1
		end
		local function PlatesChanged() --[[ PlatesChanged | Line: 165 | Upvalues: v1 (ref), v32 (copy), ProximityPrompt (ref), ChangedPressurePlate (ref), v12 (copy) ]]
			local v13 = v1:GetExpect("Event")
			ProximityPrompt.Enabled = not (v13 or table.find(v1:GetExpect("PressurePlates"), v32))
			ChangedPressurePlate(v32, v12)
		end
		v5:Add(v1:OnChange("Event", PlatesChanged))
		v5:Add(v1:OnChange("PressurePlates", PlatesChanged))
		local v6 = v1:GetExpect("Event")
		local v7 = v1:GetExpect("PressurePlates")
		ProximityPrompt.Enabled = not (v6 or table.find(v7, v32))
		ChangedPressurePlate(v32, v12)
		local function RunPrompt() --[[ RunPrompt | Line: 188 | Upvalues: v1 (ref), TextNotificationController (ref), v32 (copy), ItemUtility (ref), v4 (copy), InventoryMapping (ref), PlayerStatsUtility (ref), v2 (ref), v3 (ref) ]]
			if v1:GetExpect("Event") then
				TextNotificationController:DeliverNotification({
					Type = "Text",
					Text = "This event is already active!",
					CustomDuration = 3,
					TextColor = {
						R = 255,
						G = 0,
						B = 0
					}
				})
				return
			end
			if not v1:GetExpect("Lobby") then
				TextNotificationController:DeliverNotification({
					Type = "Text",
					Text = "Leviathan Hunt is not active!",
					CustomDuration = 3,
					TextColor = {
						R = 255,
						G = 0,
						B = 0
					}
				})
				return
			end
			if v1:Find("PressurePlates", v32) then
				return
			end
			local v12 = ItemUtility.GetItemDataFromItemType(v4.Type, v4.Identifier)
			if not v12 then
				return
			end
			local v22 = PlayerStatsUtility:GetItemFromInventory(v2, function(p1) --[[ Line: 223 | Upvalues: v12 (copy) ]]
				return p1.Id == v12.Data.Id
			end, InventoryMapping[v4.Type])
			if v22 then
				v3:FireServer(v22.UUID, v32)
			else
				TextNotificationController:DeliverNotification({
					Type = "Text",
					CustomDuration = 3,
					Text = ("You need a %*!"):format(v12.Data.Name),
					TextColor = {
						R = 255,
						G = 0,
						B = 0
					}
				})
			end
		end
		v5:Add(ProximityPrompt.Triggered:Connect(RunPrompt))
	end)
	Observers.observeTag("DenRoom", function(p1) --[[ Line: 246 | Upvalues: Trove (ref), v4 (ref), VFXController (copy), spr (ref), Soundbook (ref), v1 (ref) ]]
		p1:WaitForChild("LeviathanHead")
		local v12 = Trove.new()
		v4.OnClientEvent:Connect(function(p1) --[[ Line: 251 | Upvalues: v12 (copy), VFXController (ref), spr (ref), Soundbook (ref), v1 (ref) ]]
			v12:Clean()
			task.spawn(function() --[[ Line: 256 | Upvalues: VFXController (ref) ]]
				VFXController:RenderAtPoint("LeviathanRageFire", CFrame.new(3497.541, -275.278, 3537.801))
			end)
			for i, v in ipairs(p1) do
				local v13 = v:FindFirstChildWhichIsA("Texture")
				local v2 = v:FindFirstChildWhichIsA("SelectionBox")
				local function hide() --[[ hide | Line: 265 | Upvalues: spr (ref), v (copy), v13 (copy), v2 (copy) ]]
					spr.stop(v)
					v.Transparency = 1
					if v13 then
						spr.stop(v13)
						v13.Transparency = 1
					end
					if not v2 then
						return
					end
					spr.stop(v2)
					v2.Transparency = 1
				end
				local function show(p1) --[[ show | Line: 280 | Upvalues: spr (ref), v (copy), v2 (copy), v13 (copy) ]]
					spr.target(v, 0.6, 0.3, {
						Transparency = p1.PartTransparency
					})
					if v2 then
						spr.target(v2, 0.6, 0.3, {
							Transparency = p1.SelectionBoxTransparency
						})
					end
					if not v13 then
						return
					end
					spr.target(v13, 0.6, 0.3, {
						Transparency = p1.TextureTransparency
					})
				end
				spr.stop(v)
				v.Transparency = 1
				if v13 then
					spr.stop(v13)
					v13.Transparency = 1
				end
				if v2 then
					spr.stop(v2)
					v2.Transparency = 1
				end
				task.delay(i * 0.5 + 0.5, function() --[[ Line: 302 | Upvalues: show (copy) ]]
					show({
						PartTransparency = 0.6,
						SelectionBoxTransparency = 0,
						TextureTransparency = 0
					})
				end)
				task.delay(i * 0.5, function() --[[ Line: 311 | Upvalues: VFXController (ref), v (copy), Soundbook (ref) ]]
					VFXController:RenderAtPoint("LeviathanRageSplash", CFrame.new(v.Position))
					Soundbook:RenderAt("Leviathan Spit", v.Position)
				end)
				local v3 = nil
				v3 = v12:Add(v1:OnChange("Boosted", function(p1) --[[ Line: 319 | Upvalues: v12 (ref), v3 (ref), show (copy) ]]
					if p1 then
						return
					end
					v12:Remove(v3)
					show({
						PartTransparency = 1,
						SelectionBoxTransparency = 1,
						TextureTransparency = 1
					})
				end))
			end
		end)
	end)
end)
return {}