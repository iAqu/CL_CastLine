-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Observers = require(ReplicatedStorage.Packages.Observers)
local Net = require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Signal = require(ReplicatedStorage.Packages.Signal)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local Device = require(ReplicatedStorage.Modules.Device)
local InputControl = require(ReplicatedStorage.Modules.InputControl)
local Constants = require(ReplicatedStorage.Shared.Constants)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
local FishingController = require(ReplicatedStorage.Controllers.FishingController)
require(ReplicatedStorage.Controllers.WarpController)
local InventoryUtility = require(script.Internal.InventoryUtility)
require(ReplicatedStorage.Types.Modifiers)
local UserPriority = require(ReplicatedStorage.Shared.UserPriority)
local v1 = Net:RemoteEvent("SpawnCustomBoatNearby")
local v2 = Net:RemoteEvent("SpawnTotem")
local Gears = script:WaitForChild("Gears")
local Backpack = Players.LocalPlayer.PlayerGui:WaitForChild("Backpack")
local v3 = nil
local v4 = Signal.new()
local v5 = Trove.new()
local v6 = nil
local t = {}
local v7 = false
local v8 = nil
local v9 = nil
local t2 = { Enum.KeyCode.ButtonB, Enum.KeyCode.ButtonR2 }
local t3 = {
	MB1 = {
		PC = {},
		Mobile = {}
	}
}
local v10 = nil
local v11 = nil
local CurrentCamera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local Indicator = PlayerGui:WaitForChild("Indicator")
local t4 = {}
local function SpawnCustomBoatNearby(p1) --[[ SpawnCustomBoatNearby | Line: 74 | Upvalues: LocalPlayer (copy), UserPriority (copy), ReplicatedStorage (copy), v1 (copy) ]]
	if not LocalPlayer.Character then
		return
	end
	if UserPriority:IsTradePlaza() then
		require(ReplicatedStorage.Controllers.TextNotificationController):DeliverNotification({
			Type = "Text",
			Text = "Cannot spawn this here!"
		})
	else
		v1:FireServer(p1)
	end
end
local function GetEquippedFish() --[[ GetEquippedFish | Line: 93 | Upvalues: v10 (ref), PlayerStatsUtility (copy), ItemUtility (copy) ]]
	local v1 = v10:GetExpect("EquippedId")
	if string.len(v1) == 0 then
		return
	end
	local v2 = PlayerStatsUtility:GetItemFromInventory(v10, function(p1) --[[ Line: 99 | Upvalues: v1 (copy) ]]
		return p1.UUID == v1
	end, "Items")
	if not v2 then
		return
	end
	local v3 = ItemUtility:GetItemData(v2.Id)
	if v3 and v3.Data.Type == "Fish" then
		return v2, v3
	end
end
local function GetFishTier(p1) --[[ GetFishTier | Line: 115 | Upvalues: TierUtility (copy) ]]
	if p1.Probability then
		return TierUtility:GetTierFromRarity(p1.Probability.Chance).Tier
	else
		return p1.Data.Tier or 1
	end
end
local function GetFishZoomMultiplier(p1, p2) --[[ GetFishZoomMultiplier | Line: 123 ]]
	if not p2.Weight then
		return 1
	end
	local Metadata = p1.Metadata
	local v1 = if Metadata then Metadata.Weight else Metadata
	if v1 then
		return math.clamp(math.sqrt(math.max(math.clamp(v1, p2.Weight.Default.Min, p2.Weight.Default.Max), 1000) / 1000) + 4, 4, 10)
	else
		return 1
	end
end
local function GetFishZoomDistance() --[[ GetFishZoomDistance | Line: 140 | Upvalues: GetEquippedFish (copy) ]]
	local CameraMaxZoomDistance = game.StarterPlayer.CameraMaxZoomDistance
	local v1, v2 = GetEquippedFish()
	if not (v1 and v2) then
		return CameraMaxZoomDistance
	end
	local v3
	if v2.Weight then
		local Metadata = v1.Metadata
		local v4 = if Metadata then Metadata.Weight else Metadata
		v3 = if v4 then math.clamp(math.sqrt(math.max(math.clamp(v4, v2.Weight.Default.Min, v2.Weight.Default.Max), 1000) / 1000) + 4, 4, 10) else 1
	else
		v3 = 1
	end
	return CameraMaxZoomDistance * v3
end
local function GetZoomController() --[[ GetZoomController | Line: 150 | Upvalues: v9 (ref), LocalPlayer (copy) ]]
	if v9 then
		return v9
	end
	local PlayerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
	local v1 = if PlayerScripts then PlayerScripts:FindFirstChild("PlayerModule") else PlayerScripts
	local v2 = if v1 then v1:FindFirstChild("CameraModule") else v1
	local v3 = if v2 then v2:FindFirstChild("ZoomController") else v2
	if not (v3 and v3:IsA("ModuleScript")) then
		return v9
	end
	v9 = require(v3)
	return v9
end
local function SetCameraZoomDistance(p1, p2) --[[ SetCameraZoomDistance | Line: 167 | Upvalues: GetZoomController (copy), LocalPlayer (copy) ]]
	local v1 = GetZoomController()
	if v1 then
		v1.SetZoomParameters(p1, p2)
	else
		local CameraMinZoomDistance = LocalPlayer.CameraMinZoomDistance
		local v2 = LocalPlayer
		local CameraMaxZoomDistance = LocalPlayer.CameraMaxZoomDistance
		v2.CameraMaxZoomDistance = math.max(CameraMaxZoomDistance, p1)
		local v3 = LocalPlayer
		local CameraMaxZoomDistance_2 = LocalPlayer.CameraMaxZoomDistance
		v3.CameraMinZoomDistance = math.min(p1, CameraMaxZoomDistance_2)
		task.defer(function() --[[ Line: 178 | Upvalues: LocalPlayer (ref), CameraMinZoomDistance (copy) ]]
			LocalPlayer.CameraMinZoomDistance = CameraMinZoomDistance
		end)
	end
end
local function DeactivateFishZoom() --[[ DeactivateFishZoom | Line: 183 | Upvalues: v7 (ref), SetCameraZoomDistance (copy), LocalPlayer (copy) ]]
	if v7 then
		v7 = false
		SetCameraZoomDistance(math.min(12.5, LocalPlayer.CameraMaxZoomDistance), -1)
	end
end
local function UpdateFishZoomButton() --[[ UpdateFishZoomButton | Line: 192 | Upvalues: v8 (ref), v10 (ref), GetEquippedFish (copy), TierUtility (copy), v7 (ref), SetCameraZoomDistance (copy), LocalPlayer (copy) ]]
	local v1 = v8
	if not v1 then
		return
	end
	local v2 = v10:GetExpect("EquippedType")
	local v3, v4 = GetEquippedFish()
	local v5
	if v2 == "Fish" and (v3 and v4) then
		local v6 = false
		if (if v4.Probability then TierUtility:GetTierFromRarity(v4.Probability.Chance).Tier else v4.Data.Tier or 1) >= 7 then
			local CameraMaxZoomDistance = game.StarterPlayer.CameraMaxZoomDistance
			local v82, v9 = GetEquippedFish()
			local v102
			if v82 and v9 then
				local v11
				if v9.Weight then
					local Metadata = v82.Metadata
					local v12 = if Metadata then Metadata.Weight else Metadata
					v11 = if v12 then math.clamp(math.sqrt(math.max(math.clamp(v12, v9.Weight.Default.Min, v9.Weight.Default.Max), 1000) / 1000) + 4, 4, 10) else 1
				else
					v11 = 1
				end
				v102 = CameraMaxZoomDistance * v11
			else
				v102 = CameraMaxZoomDistance
			end
			v6 = if game.StarterPlayer.CameraMaxZoomDistance < v102 then true else false
		end
		v5 = v6
	else
		v5 = false
	end
	v1.Visible = v5
	local Label = v1:FindFirstChild("Label")
	if Label and Label:IsA("TextLabel") then
		Label.Text = if v7 then "ZOOM IN" else "ZOOM OUT"
	end
	if v5 or not v7 then
		return
	end
	if not v7 then
		return
	end
	v7 = false
	SetCameraZoomDistance(math.min(12.5, LocalPlayer.CameraMaxZoomDistance), -1)
end
local function CreateFishZoomButton() --[[ CreateFishZoomButton | Line: 218 | Upvalues: v8 (ref), Backpack (copy) ]]
	if v8 then
		return v8
	end
	local v1 = Backpack:FindFirstChild("RideFishButton") or Backpack:FindFirstChild("AutoFishingButton")
	if not (v1 and v1:IsA("ImageButton")) then
		return
	end
	local FishZoomButton = v1:Clone()
	FishZoomButton.Name = "FishZoomButton"
	FishZoomButton.Visible = false
	FishZoomButton.LayoutOrder = v1.LayoutOrder + 1
	FishZoomButton:RemoveTag("RideFishButton")
	FishZoomButton:RemoveTag("AutoFishingButton")
	FishZoomButton.Parent = Backpack
	local Label = FishZoomButton:FindFirstChild("Label")
	if not (Label and Label:IsA("TextLabel")) then
		v8 = FishZoomButton
		return FishZoomButton
	end
	Label.Text = "ZOOM OUT"
	v8 = FishZoomButton
	return FishZoomButton
end
function t4.Init(p1) --[[ Init | Line: 294 | Upvalues: t4 (copy), FishingController (copy), UserInputService (copy) ]]
	t4:RegisterM1("PC", "Fishing Rods", function(p1, p2) --[[ Line: 296 | Upvalues: FishingController (ref), UserInputService (ref) ]]
		if FishingController:GetCurrentGUID() then
			FishingController:RequestFishingMinigameClick()
		else
			FishingController:RequestChargeFishingRod((UserInputService:GetMouseLocation()))
		end
	end)
	t4:RegisterM1("PC", "Gears", ActivateGear)
	t4:RegisterM1("PC", "Totems", ActivateTotem)
	t4:RegisterM1("PC", "Fish", ActivateFishSFX)
	t4:RegisterM1("Mobile", "Fishing Rods", function(p1, p2) --[[ Line: 312 | Upvalues: FishingController (ref) ]]
		if not FishingController:GetCurrentGUID() then
			return
		end
		FishingController:RequestFishingMinigameClick()
	end)
	t4:RegisterM1("Mobile", "Gears", ActivateGear)
	t4:RegisterM1("Mobile", "Totems", ActivateTotem)
	t4:RegisterM1("Mobile", "Fish", ActivateFishSFX)
end
function t4.Start(p1) --[[ Start | Line: 325 | Upvalues: v10 (ref), Replion (copy), InputControl (copy), UserInputService (copy), t2 (copy), InventoryUtility (copy), FishingController (copy), CurrentCamera (copy), v4 (copy), v3 (ref), t4 (copy), RunService (copy), v5 (copy), v11 (ref), Observers (copy), LocalPlayer (copy), PlayerGui (copy), CreateFishZoomButton (copy) ]]
	v10 = Replion.Client:WaitReplion("Data")
	InputControl:RegisterMouseInput(1, function(p1) --[[ Line: 330 ]]
		ActivateMB1("PC")
	end)
	UserInputService.TouchTapInWorld:Connect(function(p1, p2) --[[ Line: 335 ]]
		if not p2 then
			task.wait(0.1)
			ActivateMB1("Mobile")
		end
	end)
	UserInputService.InputBegan:Connect(function(p1, p2) --[[ Line: 345 | Upvalues: t2 (ref), v10 (ref), InventoryUtility (ref), FishingController (ref), CurrentCamera (ref) ]]
		if p2 then
			return
		end
		if not table.find(t2, p1.KeyCode) then
			return
		end
		if InventoryUtility:FishingRodEquipped(v10, (v10:GetExpect("EquippedId"))) then
			if p1.KeyCode == Enum.KeyCode.ButtonR2 then
				if FishingController:GetCurrentGUID() then
					FishingController:RequestFishingMinigameClick()
					return
				end
				local v1 = FishingController:GetFishingInput()
				if v1 then
					v1()
				else
					FishingController:RequestChargeFishingRod((Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y / 2)))
				end
			else
				if p1.KeyCode ~= Enum.KeyCode.ButtonB then
					return
				end
				FishingController:RequestClientStopFishing(true)
			end
		else
			if p1.KeyCode ~= Enum.KeyCode.ButtonR2 then
				return
			end
			ActivateMB1("PC")
		end
	end)
	v4:Connect(function() --[[ Line: 386 | Upvalues: v3 (ref), t4 (ref), RunService (ref) ]]
		if v3 then
			t4:Run()
		else
			t4:Stop()
			t4:HideVisual()
			RunService.Heartbeat:Once(function() --[[ Line: 393 | Upvalues: t4 (ref) ]]
				t4:HideVisual()
			end)
		end
	end)
	v4:Connect(function() --[[ Line: 399 | Upvalues: v3 (ref), v5 (ref) ]]
		if v3 == "Fishing Rods" then
			return
		end
		v5:Clean()
	end)
	FishingController.ConfirmInputUpdated:Connect(function() --[[ Line: 405 | Upvalues: FishingController (ref), InputControl (ref), UserInputService (ref), v5 (ref) ]]
		local v1 = FishingController:GetFishingInput()
		if not v1 then
			return
		end
		local v2 = InputControl:RegisterMouseReleased(1, v1)
		local v3 = UserInputService.TouchEnded:Connect(function(p1, p2) --[[ Line: 409 | Upvalues: v1 (copy) ]]
			v1(nil, p2)
		end)
		v5:Add(function() --[[ Line: 413 | Upvalues: v2 (copy), v3 (copy) ]]
			v2:Disconnect()
			v3:Disconnect()
		end)
	end)
	v11 = require(script.Interactions)
	for k, v in pairs(v11) do
		v:Start()
	end
	v10:OnChange("EquippedId", t4._onEquipsChanged)
	t4._onEquipsChanged()
	Observers.observeSpecificCharacter(LocalPlayer, function(p1) --[[ Line: 428 | Upvalues: t4 (ref), v10 (ref) ]]
		local Humanoid = p1:WaitForChild("Humanoid")
		if Humanoid then
			local v1 = Humanoid:GetPropertyChangedSignal("SeatPart"):Connect(function() --[[ Line: 434 | Upvalues: t4 (ref) ]]
				t4._updateCameraMaxZoomDistance()
			end)
			local v2 = v10:OnChange("EquippedId", t4._updateCameraMaxZoomDistance)
			t4._updateCameraMaxZoomDistance()
			return function() --[[ Line: 441 | Upvalues: v2 (copy), v1 (copy) ]]
				v2:Disconnect()
				v1:Disconnect()
			end
		end
	end)
	Observers.observeTag("RideFishButton", t4._registerRideFishButton, { PlayerGui })
	local v1 = CreateFishZoomButton()
	if not v1 then
		return
	end
	t4._registerFishZoomButton(v1)
end
function t4._registerRideFishButton(p1) --[[ _registerRideFishButton | Line: 455 | Upvalues: GuiControl (copy), v10 (ref), PlayerStatsUtility (copy), ItemUtility (copy), TierUtility (copy), SpawnCustomBoatNearby (copy) ]]
	local v1 = GuiControl:Hook("Hold Button", p1)
	local function refreshButton() --[[ refreshButton | Line: 459 | Upvalues: v10 (ref), PlayerStatsUtility (ref), ItemUtility (ref), TierUtility (ref), p1 (copy) ]]
		v10:GetExpect("LastBoatId")
		local v1 = v10:GetExpect("EquippedId")
		local v2 = false
		if string.len(v1) > 0 then
			local v3 = PlayerStatsUtility:GetItemFromInventory(v10, function(p1) --[[ Line: 466 | Upvalues: v1 (copy) ]]
				return p1.UUID == v1
			end, "Items")
			if v3 then
				local v4 = ItemUtility.GetItemDataFromItemType("Fish", v3.Id)
				v2 = (if v4 and v4.Probability then TierUtility:GetTierFromRarity(v4.Probability.Chance).Tier elseif v4 then v4.Data.Tier else 1) == 8
			end
		end
		p1.Visible = v2
	end
	v1.Clicked:Connect(function() --[[ Line: 481 | Upvalues: v10 (ref), SpawnCustomBoatNearby (ref) ]]
		SpawnCustomBoatNearby((v10:GetExpect("EquippedId")))
	end)
	local v2 = v10:OnChange("LastBoatId", refreshButton)
	local v3 = v10:OnChange("EquippedId", refreshButton)
	refreshButton()
	return function() --[[ Line: 490 | Upvalues: v2 (copy), v3 (copy), v1 (copy) ]]
		v2:Disconnect()
		v3:Disconnect()
		v1:Destroy()
	end
end
function t4._registerFishZoomButton(p1) --[[ _registerFishZoomButton | Line: 497 | Upvalues: GuiControl (copy), GetEquippedFish (copy), TierUtility (copy), v7 (ref), t4 (copy), SetCameraZoomDistance (copy), LocalPlayer (copy), UpdateFishZoomButton (copy), v10 (ref) ]]
	local v1 = GuiControl:Hook("Hold Button", p1)
	v1.Clicked:Connect(function() --[[ Line: 500 | Upvalues: GetEquippedFish (ref), TierUtility (ref), v7 (ref), t4 (ref), SetCameraZoomDistance (ref), LocalPlayer (ref), UpdateFishZoomButton (ref) ]]
		local v1, v2 = GetEquippedFish()
		if not (v1 and v2) then
			return
		end
		if (if v2.Probability then TierUtility:GetTierFromRarity(v2.Probability.Chance).Tier else v2.Data.Tier or 1) < 7 then
			return
		end
		v7 = not v7
		t4._updateCameraMaxZoomDistance()
		if v7 then
			local CameraMaxZoomDistance = game.StarterPlayer.CameraMaxZoomDistance
			local v5, v6 = GetEquippedFish()
			local v72
			if v5 and v6 then
				local v8
				if v6.Weight then
					local Metadata = v5.Metadata
					local v9 = if Metadata then Metadata.Weight else Metadata
					v8 = if v9 then math.clamp(math.sqrt(math.max(math.clamp(v9, v6.Weight.Default.Min, v6.Weight.Default.Max), 1000) / 1000) + 4, 4, 10) else 1
				else
					v8 = 1
				end
				v72 = CameraMaxZoomDistance * v8
			else
				v72 = CameraMaxZoomDistance
			end
			SetCameraZoomDistance(v72, 1)
		else
			SetCameraZoomDistance(math.min(12.5, LocalPlayer.CameraMaxZoomDistance), -1)
		end
		UpdateFishZoomButton()
	end)
	local v2 = v10:OnChange("EquippedType", function() --[[ Line: 518 | Upvalues: v7 (ref), SetCameraZoomDistance (ref), LocalPlayer (ref), UpdateFishZoomButton (ref) ]]
		if not v7 then
			UpdateFishZoomButton()
			return
		end
		v7 = false
		SetCameraZoomDistance(math.min(12.5, LocalPlayer.CameraMaxZoomDistance), -1)
		UpdateFishZoomButton()
	end)
	local v3 = v10:OnChange("EquippedId", function() --[[ Line: 522 | Upvalues: v7 (ref), SetCameraZoomDistance (ref), LocalPlayer (ref), UpdateFishZoomButton (ref) ]]
		if not v7 then
			UpdateFishZoomButton()
			return
		end
		v7 = false
		SetCameraZoomDistance(math.min(12.5, LocalPlayer.CameraMaxZoomDistance), -1)
		UpdateFishZoomButton()
	end)
	UpdateFishZoomButton()
	return function() --[[ Line: 529 | Upvalues: v2 (copy), v3 (copy), v1 (copy) ]]
		v2:Disconnect()
		v3:Disconnect()
		v1:Destroy()
	end
end
function t4._updateCameraMaxZoomDistance() --[[ _updateCameraMaxZoomDistance | Line: 536 | Upvalues: v10 (ref), GetEquippedFish (copy), Players (copy), LocalPlayer (copy), UpdateFishZoomButton (copy) ]]
	local v1 = v10:GetExpect("LastBoatId")
	local v2 = v10:GetExpect("EquippedId")
	local CameraMaxZoomDistance = game.StarterPlayer.CameraMaxZoomDistance
	local v3 = 1
	local v4 = 0
	if string.len(v2) > 0 then
		local v5, v6 = GetEquippedFish()
		if v5 and v6 and v6.Weight then
			local Metadata = v5.Metadata
			local v7 = if Metadata then Metadata.Weight else Metadata
			v3 = if v7 then math.clamp(math.sqrt(math.max(math.clamp(v7, v6.Weight.Default.Min, v6.Weight.Default.Max), 1000) / 1000) + 4, 4, 10) else 1
		elseif v5 and v6 then
			v3 = 1
		end
	end
	local Character = Players.LocalPlayer.Character
	local v12 = if Character then Character:FindFirstChildWhichIsA("Humanoid") else Character
	if v12 and v12.SeatPart then
		v4 = if v1 == -1 then v4 + 70 else v4 + 20
	end
	LocalPlayer.CameraMaxZoomDistance = (CameraMaxZoomDistance + v4) * v3
	UpdateFishZoomButton()
end
function t4._onEquipsChanged() --[[ _onEquipsChanged | Line: 565 | Upvalues: v10 (ref), v11 (ref), t4 (copy), InventoryUtility (copy), ItemUtility (copy) ]]
	local v1 = v10:GetExpect("EquippedId")
	local v2 = v10:GetExpect("EquippedType")
	local v3 = nil
	if string.len(v1) == 0 or string.len(v2) == 0 then
		v3 = nil
	else
		local v4 = v11[v2]
		if v4 then
			v3 = if v4.Before and not v4:Before(v1) then nil else v2
		end
	end
	if v3 then
		t4:SetMode(v3)
	else
		t4:RemoveMode()
	end
	if v2 == "Gears" and string.len(v1) > 0 then
		local v5, _ = InventoryUtility:GetEquippedInventoryItem(v10, v1)
		if not v5 then
			return
		end
		local v6 = ItemUtility.GetItemDataFromItemType("Gears", v5.Id)
		if not v6 then
			return
		end
		if not LastEquippedGearItem then
			LastEquippedGearItem = {
				itemData = v6,
				inventoryItem = v5
			}
			EquipGear(v6, v5)
			return
		end
		UnequipGear(LastEquippedGearItem.itemData, LastEquippedGearItem.inventoryItem)
		LastEquippedGearItem = {
			itemData = v6,
			inventoryItem = v5
		}
		EquipGear(v6, v5)
		return
	end
	if not LastEquippedGearItem then
		return
	end
	UnequipGear(LastEquippedGearItem.itemData, LastEquippedGearItem.inventoryItem)
	LastEquippedGearItem = nil
end
function t4.UpdateVisual(p1, p2) --[[ UpdateVisual | Line: 611 | Upvalues: Indicator (copy), Device (copy) ]]
	local AbsoluteSize = Indicator.Box.AbsoluteSize
	local AbsoluteSize_2 = Indicator.Box.Horizontal.AbsoluteSize
	local Label = Indicator.Box.Horizontal.Label
	local v1
	if Device:_getDevice() == "Console" then
		Label.DeviceImage.Visible = true
		v1 = UDim2.fromOffset(p2.X - AbsoluteSize_2.X * 0.75, p2.Y - AbsoluteSize_2.Y * 0.5 - 14)
	else
		Label.DeviceImage.Visible = false
		local v3 = Vector2.new(0, 4)
		v1 = UDim2.fromOffset(p2.X + AbsoluteSize.X * 0.1 + v3.X, p2.Y + AbsoluteSize.Y * 0.5 + v3.Y)
	end
	Indicator.Box.Position = v1
	Indicator.Enabled = true
end
function t4.HideVisual(p1) --[[ HideVisual | Line: 638 | Upvalues: Indicator (copy) ]]
	Indicator.Enabled = false
end
function t4.Stop(p1) --[[ Stop | Line: 642 | Upvalues: RunService (copy) ]]
	RunService:UnbindFromRenderStep("UpdateMouseIndicator")
end
function t4.Run(p1) --[[ Run | Line: 646 | Upvalues: RunService (copy), v3 (ref), t4 (copy), v11 (ref), UserInputService (copy), Constants (copy) ]]
	RunService:BindToRenderStep("UpdateMouseIndicator", Enum.RenderPriority.Camera.Value + 1, function(p1) --[[ Line: 647 | Upvalues: v3 (ref), t4 (ref), v11 (ref), UserInputService (ref), Constants (ref) ]]
		local v1 = v3
		if not v1 then
			t4:HideVisual()
			return
		end
		local v2 = v11[v1]
		if not v2 then
			t4:HideVisual()
			return
		end
		local v32 = UserInputService:GetMouseLocation()
		local v4 = UserInputService:GetLastInputType()
		local v5, v6
		if v2:CanRaycast() then
			local v7 = v2:GetParams()
			local v8 = v2:GetRay(v32, v4)
			local v9 = workspace:Raycast(v8.Origin, v8.Direction * Constants.FishingDistance, v7)
			v2.State.Ray = v8
			v2.State.RaycastResult = v9
			v5 = v9
			v6 = v8
		else
			v5 = nil
			v6 = nil
		end
		if v5 then
			if v2.Success then
				v2:Success(v6, v5)
			end
		elseif v2.Exception then
			v2:Exception()
		else
			t4:HideVisual()
		end
		if v2.ShowVisual then
			t4:UpdateVisual(v32)
		else
			t4:HideVisual()
		end
	end)
end
function t4.SetMode(p1, p2) --[[ SetMode | Line: 695 | Upvalues: v3 (ref), v11 (ref), v4 (copy) ]]
	local v1 = v3
	if p2 == v1 then
		return
	end
	local v2 = v11[v1]
	if (v11[p2].Priority or 0) < (if v2 then v2.Priority or 0 else 0) then
		return
	end
	v3 = p2
	if v1 == p2 then
		return
	end
	v4:Fire()
end
function t4.RemoveMode(p1) --[[ RemoveMode | Line: 716 | Upvalues: v3 (ref), v4 (copy) ]]
	local v1 = v3
	v3 = nil
	if v1 == nil then
		return
	end
	v4:Fire()
end
function t4.RegisterM1(p1, p2, p3, p4) --[[ RegisterM1 | Line: 725 | Upvalues: t3 (copy) ]]
	t3.MB1[p2][p3] = p4
end
function ActivateTotem(p1, p2) --[[ ActivateTotem | Line: 729 | Upvalues: v2 (copy) ]]
	v2:FireServer(p2.UUID)
end
function ActivateFishSFX(p1, p2) --[[ ActivateFishSFX | Line: 733 | Upvalues: Soundbook (copy), v6 (ref), t (copy) ]]
	local FishSFX = p1.FishSFX
	if not (FishSFX and Soundbook:HasSound(FishSFX)) then
		return
	end
	local v1 = os.clock()
	if v6 and v1 - v6 < 0.2 then
		return
	end
	local v2 = t[FishSFX]
	if not (v2 and (v2.Parent and v2.Playing)) then
		v6 = v1
		local v3 = Soundbook.Sounds[FishSFX]:Play()
		t[FishSFX] = v3
		v3.Destroying:Once(function() --[[ Line: 754 | Upvalues: t (ref), FishSFX (copy), v3 (copy) ]]
			if t[FishSFX] ~= v3 then
				return
			end
			t[FishSFX] = nil
		end)
	end
end
function ActivateGear(p1, p2) --[[ ActivateGear | Line: 761 | Upvalues: Gears (copy), LocalPlayer (copy) ]]
	local v1 = Gears:FindFirstChild(p1.Data.Name)
	if not v1 then
		return
	end
	local Character = LocalPlayer.Character
	local v2 = if Character then Character:FindFirstChild("!!!EQUIPPED_TOOL!!!") else Character
	local v3, v4 = xpcall(require, warn, v1)
	if not v3 then
		return
	end
	local v5 = if type(v4) == "table" then v4.OnActivate else v4
	if not v5 then
		return
	end
	v5(p1, p2, v2)
end
function EquipGear(p1, p2) --[[ EquipGear | Line: 787 | Upvalues: Gears (copy) ]]
	if GearEquipCleanup then
		GearEquipCleanup()
		GearEquipCleanup = nil
	end
	local v1 = Gears:FindFirstChild(p1.Data.Name)
	if not v1 then
		return
	end
	local v2, v3 = xpcall(require, warn, v1)
	if not v2 or type(v3) ~= "table" then
		return
	end
	if not v3.OnEquip then
		return
	end
	GearEquipCleanup = v3.OnEquip(p1, p2)
end
function UnequipGear(p1, p2) --[[ UnequipGear | Line: 808 | Upvalues: Gears (copy) ]]
	if GearEquipCleanup then
		GearEquipCleanup()
		GearEquipCleanup = nil
	end
	local v1 = Gears:FindFirstChild(p1.Data.Name)
	if not v1 then
		return
	end
	local v2, v3 = xpcall(require, warn, v1)
	if not v2 or type(v3) ~= "table" then
		return
	end
	if not v3.OnUnequip then
		return
	end
	v3.OnUnequip(p1, p2)
end
function ActivateMB1(p1, ...) --[[ ActivateMB1 | Line: 829 | Upvalues: t3 (copy), v10 (ref), InventoryUtility (copy), ItemUtility (copy) ]]
	local v1 = t3.MB1[p1]
	if not v1 then
		return
	end
	local v2 = v10:GetExpect("EquippedId")
	if string.len(v2) == 0 then
		return
	end
	local v3, v4 = InventoryUtility:GetEquippedInventoryItem(v10, v2)
	if not v3 then
		return
	end
	local v6 = ItemUtility.GetItemDataFromItemType(if v4 then v4.Category or "Items" else "Items", v3.Id)
	if not v6 then
		return
	end
	local v7 = v1[v6.Data.Type]
	if not v7 then
		return
	end
	v7(v6, v3)
end
return t4