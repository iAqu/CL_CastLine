-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HapticService = game:GetService("HapticService")
game:GetService("CollectionService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Lighting")
local Players = game:GetService("Players")
local Replion = require(ReplicatedStorage.Packages.Replion)
local NumberSpinner = require(ReplicatedStorage.Packages.NumberSpinner)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Net = require(ReplicatedStorage.Packages.Net)
require(ReplicatedStorage.Packages.Thread)
local spr = require(ReplicatedStorage.Packages.spr)
local RaycastUtility = require(ReplicatedStorage.Shared.RaycastUtility)
local VFXUtility = require(ReplicatedStorage.Shared.VFXUtility)
local Constants = require(ReplicatedStorage.Shared.Constants)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
require(ReplicatedStorage.Shared.Effects)
require(ReplicatedStorage.Shared.PlayerStatsUtility)
local BlockedHumanoidStates = require(ReplicatedStorage.Shared.BlockedHumanoidStates)
local AreaUtility = require(ReplicatedStorage.Shared.AreaUtility)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
require(ReplicatedStorage.Modules.CameraShaker)
local VFXController = require(ReplicatedStorage.Controllers.VFXController)
local PlayVFX = VFXController.PlayVFX
local PlayEffect = VFXController.PlayEffect
local Device = require(ReplicatedStorage.Modules.Device)
local HUDController = require(ReplicatedStorage.Controllers.HUDController)
local AnimationController = require(ReplicatedStorage.Controllers.AnimationController)
require(ReplicatedStorage.Modules.InputControl)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
require(ReplicatedStorage.Controllers.VendorController)
local InventoryUtility = require(ReplicatedStorage.Controllers.InteractionController.Internal.InventoryUtility)
local InputStates = require(script:WaitForChild("InputStates"))
local WeightRanges = require(script:WaitForChild("WeightRanges"))
local animateBobber = require(script:WaitForChild("Effects"):WaitForChild("animateBobber"))
require(script:WaitForChild("FishCaughtVisual"))
require(script:WaitForChild("FishBaitVisual"))
local RodEffectCallbacks = require(script:WaitForChild("RodEffectCallbacks"))
require(ReplicatedStorage.Types.Fishing)
require(ReplicatedStorage.Types.Modifiers)
require(ReplicatedStorage.Shared.Effects.Types)
local v1 = nil
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local CurrentCamera = workspace.CurrentCamera
Net:RemoteEvent("ReplicateTextEffect")
Net:RemoteFunction("UpdateFishingRadar")
local v2 = Net:RemoteEvent("BaitSpawned")
local v3 = Net:RemoteEvent("FishCaught")
local v4 = Net:RemoteFunction("CancelFishingInputs")
local v5 = Net:RemoteEvent("UpdateChargeState")
local v6 = Net:RemoteFunction("ChargeFishingRod")
local v7 = Net:RemoteFunction("RequestFishingMinigameStarted")
local v8 = Net:RemoteEvent("FishingMinigameChanged")
local v9 = Net:RemoteEvent("FishingStopped")
local v10 = Net:RemoteEvent("CatchFishCompleted")
Net:RemoteEvent("SpawnTotem")
local v11 = Signal.new()
PlayerGui:WaitForChild("!!! Daily Login")
local Charge = PlayerGui:WaitForChild("Charge")
local Indicator = PlayerGui:WaitForChild("Indicator")
local MobileFishingButton = PlayerGui:WaitForChild("HUD"):WaitForChild("MobileFishingButton")
local Fishing = PlayerGui:WaitForChild("Fishing")
local Horizontal = Indicator.Box.Horizontal
local Main = Fishing.Main
local Exit = Main.Exit
local CanvasGroup = Main.Display.CanvasGroup
local TopTop = Main.TopTop
local Top = Main.TopTop.Top
Main.Position = UDim2.fromScale(0.5, 1.5)
Fishing.Enabled = false
local v12 = Trove.new()
local v13 = Trove.new()
local v14 = Trove.new()
local v15 = Signal.new()
local v16 = Signal.new()
local v17 = nil
local v18 = nil
local v19 = nil
local function updateTestServerMode() --[[ updateTestServerMode | Line: 123 | Upvalues: v18 (ref), v19 (ref) ]]
	v18 = workspace:GetAttribute("__GOD_MODE") and game.GameId == 6902403037
	v19 = if v18 then 0.3 else 1
end
v18 = workspace:GetAttribute("__GOD_MODE") and game.GameId == 6902403037
v19 = if v18 then 0.3 else 1
workspace:GetAttributeChangedSignal("__GOD_MODE"):Connect(function() --[[ Line: 129 | Upvalues: v18 (ref), v19 (ref) ]]
	v18 = workspace:GetAttribute("__GOD_MODE") and game.GameId == 6902403037
	v19 = if v18 then 0.3 else 1
end)
local v21 = false
local v22 = false
local v23 = false
local v24 = false
local v25 = false
local v26 = false
local TapScreenHint = PlayerGui:WaitForChild("TapScreenHint")
local Click = TapScreenHint:FindFirstChild("Click")
local Size = Click.Size
local v27 = 0
local v28 = 0
local v29 = 0
local t = { Vector3.new(130, 4.032, 2768), Vector3.new(-62.462, 4.032, 2767.469) }
local function getVolume() --[[ getVolume | Line: 156 | Upvalues: Players (copy), Soundbook (copy) ]]
	if Players.LocalPlayer:GetAttribute("InCutscene") then
		return 0
	else
		return Soundbook.Sounds.Reel.Volume
	end
end
local function isNearFishingHint() --[[ isNearFishingHint | Line: 165 | Upvalues: LocalPlayer (copy), t (copy) ]]
	local Character = LocalPlayer.Character
	if not Character then
		return false
	end
	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	if not HumanoidRootPart then
		return false
	end
	for v1, v2 in t do
		if (HumanoidRootPart.Position - v2).Magnitude <= 10 then
			return true
		end
	end
	return false
end
local v30 = 0
local v31 = NumberSpinner.fromGuiObject(Top.Counter.ClickCount)
v31.Prefix = "("
v31.Suffix = ")"
v31.Decimals = 0
v31.Duration = 0.12
v31.ZeroPadding = 3
v31.Value = 0
local v32 = GuiControl:Hook("Click")
local v33 = false
local v34 = false
local v35 = false
local v36 = nil
local v37 = nil
local v38 = nil
local v39 = 0
local v40 = nil
local v41 = Trove.new()
local v42 = Signal.new()
local _ = { Enum.KeyCode.ButtonB, Enum.KeyCode.ButtonR2 }
local function destroyFirstCastHint() --[[ destroyFirstCastHint | Line: 218 | Upvalues: TapScreenHint (copy), Click (copy), v28 (ref) ]]
	TapScreenHint.Enabled = false
	Click.Visible = false
	v28 = v28 + 1
end
local function stopHintLoop() --[[ stopHintLoop | Line: 224 | Upvalues: v29 (ref), destroyFirstCastHint (ref) ]]
	v29 = v29 + 1
	destroyFirstCastHint()
end
local function cancelIdleHint() --[[ cancelIdleHint | Line: 229 | Upvalues: v27 (ref), v29 (ref), destroyFirstCastHint (ref) ]]
	v27 = v27 + 1
	v29 = v29 + 1
	destroyFirstCastHint()
end
local function placeFirstCastHint(p1) --[[ placeFirstCastHint | Line: 234 | Upvalues: v26 (ref), destroyFirstCastHint (ref), v37 (ref), v1 (ref), v29 (ref), CurrentCamera (copy), TapScreenHint (copy), Click (copy), Size (copy), TweenService (copy), v28 (ref) ]]
	if v26 then
		destroyFirstCastHint()
		return
	end
	if not (p1 or v37) then
		destroyFirstCastHint()
		return
	end
	local v12 = v1 and v1:Get({ "Statistics", "FishCaught" })
	if v12 and v12 > 0 then
		v26 = true
		v29 = v29 + 1
		destroyFirstCastHint()
		return
	end
	local ViewportSize = CurrentCamera.ViewportSize
	local v5 = math.min(200, ViewportSize.X * 0.25)
	local v7 = math.min(140, ViewportSize.Y * 0.25)
	local v8 = ViewportSize.X * 0.5 + math.random(-v5, v5)
	local v9 = ViewportSize.Y * 0.5 + math.random(-v7, v7)
	TapScreenHint.Enabled = true
	Click.Visible = true
	Click.Position = UDim2.fromOffset(v8, v9)
	local v10 = Click
	v10.Size = Size or Click.Size
	local v122 = UDim2.new(Click.Size.X.Scale, Click.Size.X.Offset + 12, Click.Size.Y.Scale, Click.Size.Y.Offset + 12)
	local v13 = TweenService:Create(Click, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = v122
	})
	local v14 = TweenService
	local v15 = Click
	local v16 = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	local t = {}
	t.Size = Size or Click.Size
	local v18 = v14:Create(v15, v16, t)
	v13.Completed:Connect(function() --[[ Line: 278 | Upvalues: v18 (copy) ]]
		v18:Play()
	end)
	v13:Play()
	v28 = v28 + 1
	local v19 = v28
	task.spawn(function() --[[ Line: 285 | Upvalues: v19 (copy), v28 (ref), Click (ref), Size (ref), TweenService (ref) ]]
		while v19 == v28 and (Click and Click.Visible) do
			task.wait(math.random(35, 80) / 100)
			if v19 ~= v28 or not (Click and Click.Visible) then
				break
			end
			local Position = Click.Position
			local v2 = Size or Click.Size
			local v3 = math.random(-5, 5)
			local v4 = math.random(-5, 5)
			local v5 = math.random(-8, 8)
			local v6 = UDim2.new(v2.X.Scale, v2.X.Offset + 8, v2.Y.Scale, v2.Y.Offset + 8)
			local v7 = TweenService:Create(Click, TweenInfo.new(0.12, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
				Position = UDim2.fromOffset(Position.X.Offset + v3, Position.Y.Offset + v4),
				Rotation = v5,
				Size = v6
			})
			local v8 = TweenService:Create(Click, TweenInfo.new(0.12, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
				Rotation = 0,
				Position = Position,
				Size = v2
			})
			v7.Completed:Connect(function() --[[ Line: 313 | Upvalues: v19 (ref), v28 (ref), Click (ref), v8 (copy) ]]
				if v19 ~= v28 or not (Click and Click.Visible) then
					return
				end
				v8:Play()
			end)
			v7:Play()
		end
	end)
end
local function startHintLoop(p1, p2) --[[ startHintLoop | Line: 323 | Upvalues: v29 (ref), isNearFishingHint (copy), v37 (ref), placeFirstCastHint (copy), destroyFirstCastHint (ref) ]]
	v29 = v29 + 1
	local v1 = v29
	task.delay(p2, function() --[[ Line: 326 | Upvalues: v1 (copy), v29 (ref), isNearFishingHint (ref), p1 (copy), v37 (ref), placeFirstCastHint (ref), destroyFirstCastHint (ref) ]]
		if v1 ~= v29 then
			return
		end
		while v1 == v29 do
			if isNearFishingHint() then
				if p1 or v37 then
					placeFirstCastHint(p1)
					local v12 = v29
					task.delay(1, function() --[[ Line: 345 | Upvalues: v12 (copy), v29 (ref), destroyFirstCastHint (ref) ]]
						if v12 ~= v29 then
							return
						end
						destroyFirstCastHint()
					end)
					task.wait(0.75)
					continue
				end
				task.wait(0.25)
				continue
			end
			task.wait(0.25)
		end
	end)
end
local function showIdleRodHint(p1) --[[ showIdleRodHint | Line: 356 | Upvalues: v26 (ref), InventoryUtility (copy), v1 (ref), v29 (ref), destroyFirstCastHint (ref), placeFirstCastHint (copy) ]]
	if v26 then
		return
	end
	local v12 = InventoryUtility:GetItemDataFromEquippedItem(v1, p1)
	if not v12 or v12.Data.Type ~= "Fishing Rods" then
		v29 = v29 + 1
		destroyFirstCastHint()
		return
	end
	local v2 = v1 and v1:Get({ "Statistics", "FishCaught" })
	if v2 and v2 > 0 then
		v26 = true
		destroyFirstCastHint()
	else
		placeFirstCastHint(true)
	end
end
local function scheduleIdleRodHint(p1) --[[ scheduleIdleRodHint | Line: 377 | Upvalues: v27 (ref), showIdleRodHint (copy) ]]
	v27 = v27 + 1
	local v1 = v27
	task.delay(2, function() --[[ Line: 380 | Upvalues: v27 (ref), v1 (copy), showIdleRodHint (ref), p1 (copy) ]]
		if v27 == v1 then
			showIdleRodHint(p1)
		end
	end)
end
workspace:WaitForChild("CosmeticFolder")
workspace:WaitForChild("Characters")
workspace:WaitForChild("Locations")
workspace:WaitForChild("Zones")
local function getZoneParams() --[[ getZoneParams | Line: 395 | Upvalues: RaycastUtility (copy), LocalPlayer (copy) ]]
	local v1 = RaycastUtility:getFilteredTargets(LocalPlayer)
	local v2 = RaycastParams.new()
	v2.IgnoreWater = true
	v2.RespectCanCollide = false
	v2.FilterType = Enum.RaycastFilterType.Exclude
	v2.FilterDescendantsInstances = v1
	return v2
end
local function returnValue(p1) --[[ returnValue | Line: 406 ]]
	return function() --[[ Line: 407 | Upvalues: p1 (copy) ]]
		return p1
	end
end
local t2 = {
	ConfirmInputUpdated = v16,
	ConfirmClick = function(p1) --[[ ConfirmClick | Line: 425 | Upvalues: v37 (ref), v38 (ref), v35 (ref), LocalPlayer (copy), v15 (copy), v14 (copy), v10 (copy) ]]
		if not v37 then
			return
		end
		if not v38 then
			return
		end
		if v35 or v38.ClickInputLocked then
			return
		end
		if LocalPlayer:GetAttribute("IsTrading") or LocalPlayer:GetAttribute("SellAll") then
			return
		end
		local v3 = math.clamp(v38.Progress + v38.FishingClickPower, 0, 1)
		v38.Progress = v3
		local v4 = v38
		v4.Inputs = v4.Inputs + 1
		v15:Fire(v38)
		if not (v3 >= 1) then
			return
		end
		v35 = true
		v14:Clean()
		v10:FireServer()
		v35 = false
	end,
	OnCooldown = function(p1) --[[ OnCooldown | Line: 460 | Upvalues: LocalPlayer (copy), BlockedHumanoidStates (copy) ]]
		local Character = LocalPlayer.Character
		if not Character then
			return true
		end
		local v1 = Character:FindFirstChildWhichIsA("Humanoid")
		if not v1 then
			return true
		end
		if table.find(BlockedHumanoidStates.Fishing, (v1:GetState())) then
			return true
		end
		if v1.FloorMaterial == Enum.Material.Water then
			return true
		else
			return v1.SeatPart and v1.SeatPart:IsDescendantOf(workspace.Vehicles) and true or false
		end
	end,
	SendFishingRequestToServer = function(p1, p2, p3) --[[ SendFishingRequestToServer | Line: 488 | Upvalues: LocalPlayer (copy), InventoryUtility (copy), v1 (ref), Constants (copy), RaycastUtility (copy), AreaUtility (copy), v7 (copy) ]]
		local Character = LocalPlayer.Character
		local v12 = if Character then Character:FindFirstChild("HumanoidRootPart") else Character
		if not v12 then
			return false
		end
		if not InventoryUtility:FishingRodEquipped(v1, v1.Data.EquippedId) then
			return false, "No fishing rod equipped!"
		end
		local v2 = v12.CFrame
		local v4 = workspace
		local v6 = Vector3.new(0, -Constants.FishingDistance, 0)
		local v72 = RaycastUtility:getFilteredTargets(LocalPlayer)
		local v8 = RaycastParams.new()
		v8.IgnoreWater = true
		v8.RespectCanCollide = false
		v8.FilterType = Enum.RaycastFilterType.Exclude
		v8.FilterDescendantsInstances = v72
		local v9 = v4:Raycast(v2.Position + v2.LookVector * (p3 * 15 + 10), v6, v8)
		if not v9 then
			return false, "Failed rod cast!"
		end
		if not v9.Instance then
			return false, "Unable to cast from this far!"
		end
		if AreaUtility:ValidateFishingArea(v9.Instance, v1) == true then
			local v11, v122 = v7:InvokeServer(v9.Position.Y, p3, (workspace:GetServerTimeNow()))
			return v11, v122
		else
			return false, "You do not have this area unlocked!"
		end
	end
}
function t2.RequestFishingMinigameClick(p1) --[[ RequestFishingMinigameClick | Line: 523 | Upvalues: v34 (ref), v37 (ref), v39 (ref), Constants (copy), v38 (ref), Players (copy), Soundbook (copy), v31 (copy), t2 (copy), spr (copy), TopTop (copy), Device (copy), UserInputService (copy), v32 (copy), v40 (ref) ]]
	if v34 then
		return
	end
	if not v37 then
		return
	end
	if tick() - v39 < Constants.ClickDelay then
		return
	end
	v39 = tick()
	local v1 = v38 and v38.Progress < 1
	if v1 and not Players.LocalPlayer:GetAttribute("InCutscene") then
		Soundbook.Sounds.Click:Play()
	end
	if v31 then
		local v2 = v31
		v2.Value = v2.Value + 1
	end
	t2:ConfirmClick()
	if v1 then
		spr.stop(TopTop.UIScale)
		TopTop.UIScale.Scale = 1.5
		spr.target(TopTop.UIScale, 5, 15, {
			Scale = 1
		})
		local v3 = Device:_getDevice()
		if v3 == "Console" or v3 == "PC" then
			v32:Activate((UserInputService:GetMouseLocation()))
		end
	end
	if not v40 then
		return
	end
	local v4 = if v38 then v38.Progress or 0 else 0
	spr.stop(v40)
	spr.target(v40, 50, 100, {
		PlaybackSpeed = math.sqrt(v4 * 0.05) + 1
	})
end
function t2.FishingMinigameChanged(p1, p2, p3) --[[ FishingMinigameChanged | Line: 584 | Upvalues: v38 (ref), v14 (copy), animateBobber (copy), LocalPlayer (copy), v37 (ref), v29 (ref), destroyFirstCastHint (ref), placeFirstCastHint (copy), Main (copy), spr (copy), CanvasGroup (copy), v40 (ref), v15 (copy) ]]
	if not v38 then
		local CosmeticTemplate = p3.CosmeticTemplate
		if CosmeticTemplate and CosmeticTemplate:HasTag("IgnoreWaterBobbing") == nil then
			animateBobber(CosmeticTemplate, function() --[[ Line: 589 | Upvalues: LocalPlayer (ref) ]]
				local Character = LocalPlayer.Character
				local v1 = if Character then Character:FindFirstChild("Torso") else Character
				if v1 then
					return v1.CFrame
				else
					return CFrame.identity
				end
			end, (v14:Extend()))
		end
	end
	if p2 ~= "Stop" then
		v37 = p3.UUID
		v38 = p3
	end
	if p2 == "Stop" then
		v29 = v29 + 1
		destroyFirstCastHint()
	elseif p2 == "Activated" or p2 == "Clicked" then
		placeFirstCastHint(false)
	end
	if p2 == "Clicked" then
		local v1 = math.random(6, 12)
		if math.random() < 0.5 then
			v1 = v1 * -1
		end
		local v2 = 1 + math.random() * 0.5
		Main.Display.Minigame.Mover.Size = UDim2.fromScale(v2, v2)
		spr.stop(Main.Display.Minigame.Mover)
		spr.target(Main.Display.Minigame.Mover, 50, 350, {
			Rotation = v1,
			Size = UDim2.fromScale(1, 1)
		})
		spr.stop(CanvasGroup.Left.Bar.Point)
		spr.stop(CanvasGroup.Right.Bar.Point)
		CanvasGroup.Left.Bar.Point.BackgroundTransparency = 0.1
		CanvasGroup.Right.Bar.Point.BackgroundTransparency = 0.1
		spr.target(CanvasGroup.Left.Bar.Point, 1, 3, {
			BackgroundTransparency = 1
		})
		spr.target(CanvasGroup.Right.Bar.Point, 1, 3, {
			BackgroundTransparency = 1
		})
		if v40 then
			local v3 = if v38 then v38.Progress or 0 else 0
			spr.stop(v40)
			spr.target(v40, 50, 100, {
				PlaybackSpeed = math.sqrt(v3 * 0.05) + 1
			})
		end
	end
	v15:Fire(p3)
end
function t2.Hide(p1, p2) --[[ Hide | Line: 656 | Upvalues: v30 (ref), spr (copy), Main (copy), v19 (ref), Fishing (copy), v12 (copy), v14 (copy), v31 (copy) ]]
	local v1 = tick()
	if v1 - v30 < 0.8 then
		return
	end
	v30 = v1
	spr.stop(Main.Display.Minigame.Mover)
	Main.Display.Minigame.Mover.Size = UDim2.fromScale(1, 1)
	Main.Display.Minigame.Mover.Rotation = 0
	if p2 == 1 then
		spr.stop(Main.Display.AnimationBG.UIGradient)
		Main.Display.AnimationBG.UIGradient.Offset = Vector2.new(-1.5, 0)
		spr.target(Main.Display.AnimationBG.UIGradient, 200, 325, {
			Offset = Vector2.new(1.5, 0)
		})
		task.wait(0.2 * v19)
	else
		Main.Display.AnimationBG.UIGradient.Offset = Vector2.new(1.5, 0)
	end
	if p2 then
		spr.stop(Fishing.Main)
		spr.target(Fishing.Main, 100, 150, {
			Position = UDim2.fromScale(0.5, 0.9)
		})
		task.delay(0.15, function() --[[ Line: 688 | Upvalues: spr (ref), Fishing (ref) ]]
			spr.stop(Fishing.Main)
			spr.target(Fishing.Main, 50, 100, {
				Position = UDim2.fromScale(0.5, 1.5)
			})
		end)
		task.wait(0.6 * v19)
	else
		Fishing.Main.Position = UDim2.fromScale(0.5, 1.5)
	end
	v12:Clean()
	v14:Clean()
	v31.Value = 0
end
function t2.FishingStopped(p1, p2, p3, p4) --[[ FishingStopped | Line: 706 | Upvalues: v34 (ref), v35 (ref), v38 (ref), AnimationController (copy), v13 (copy), v17 (ref), v37 (ref), v39 (ref), LocalPlayer (copy), HUDController (copy), v19 (ref), t2 (copy), GuiControl (copy), v24 (ref), v25 (ref), v29 (ref), destroyFirstCastHint (ref) ]]
	if v34 then
		return
	end
	v34 = true
	v35 = true
	local v1 = v38 and v38.Progress
	if v1 and v1 <= 0 then
		AnimationController:DestroyActiveAnimationTracks()
		AnimationController:PlayAnimation("FishingFailure")
	elseif p2 then
		AnimationController:DestroyActiveAnimationTracks({ "EquipIdle" })
		RefreshIdle()
	end
	v13:Clean()
	v17 = nil
	v37 = nil
	v38 = nil
	v39 = 0
	if not (LocalPlayer:GetAttribute("IgnoreFOV") or LocalPlayer:GetAttribute("InCutscene")) then
		HUDController.SetCameraFOV(65)
	end
	if p4 and p4 > 0 then
		task.wait(p4 * v19)
	end
	if not p3 then
		t2:Hide(1)
	end
	if not GuiControl.Gui then
		GuiControl:SetHUDVisibility(true)
	end
	if not (v1 and v1 <= 0) then
		v34 = false
		v35 = false
		v24 = false
		v25 = false
		v29 = v29 + 1
		destroyFirstCastHint()
		return
	end
	RefreshIdle()
	v34 = false
	v35 = false
	v24 = false
	v25 = false
	v29 = v29 + 1
	destroyFirstCastHint()
end
function t2.FishingRodStarted(p1, p2) --[[ FishingRodStarted | Line: 767 | Upvalues: AnimationController (copy), t2 (copy), placeFirstCastHint (copy), v27 (ref), v29 (ref), destroyFirstCastHint (ref), isNearFishingHint (copy), v37 (ref), Soundbook (copy), v40 (ref), spr (copy), Players (copy), v13 (copy), CanvasGroup (copy), Fishing (copy), GuiControl (copy), LocalPlayer (copy) ]]
	if not (AnimationController:IsDisabled("ReelIntermission") or AnimationController:IsDisabled("AnimationOverride")) then
		AnimationController:StopAnimation("ReelingIdle")
		AnimationController:StopAnimation("ReelStart")
		AnimationController:PlayAnimation("ReelIntermission")
	end
	t2:FishingMinigameChanged("Activated", p2)
	placeFirstCastHint(false)
	v27 = v27 + 1
	v29 = v29 + 1
	destroyFirstCastHint()
	task.defer(function() --[[ Line: 780 | Upvalues: placeFirstCastHint (ref) ]]
		placeFirstCastHint(false)
	end)
	v29 = v29 + 1
	destroyFirstCastHint()
	v29 = v29 + 1
	local v1 = v29
	local v2 = false
	task.delay(0, function() --[[ Line: 326 | Upvalues: v1 (copy), v29 (ref), isNearFishingHint (ref), v2 (copy), v37 (ref), placeFirstCastHint (ref), destroyFirstCastHint (ref) ]]
		if v1 ~= v29 then
			return
		end
		while v1 == v29 do
			if isNearFishingHint() then
				if v2 or v37 then
					placeFirstCastHint(v2)
					local v12 = v29
					task.delay(1, function() --[[ Line: 345 | Upvalues: v12 (copy), v29 (ref), destroyFirstCastHint (ref) ]]
						if v12 ~= v29 then
							return
						end
						destroyFirstCastHint()
					end)
					task.wait(0.75)
					continue
				end
				task.wait(0.25)
				continue
			end
			task.wait(0.25)
		end
	end)
	local Volume = Soundbook.Sounds.Reel.Volume
	local REEL_SOUND = Soundbook.Sounds.Reel:Play()
	REEL_SOUND.Name = "REEL_SOUND"
	v40 = REEL_SOUND
	REEL_SOUND.Volume = 0
	local target = spr.target
	local t = {}
	t.Volume = if Players.LocalPlayer:GetAttribute("InCutscene") then 0 else Soundbook.Sounds.Reel.Volume
	target(REEL_SOUND, 5, 10, t)
	v13:Add(function() --[[ Line: 797 | Upvalues: spr (ref), REEL_SOUND (copy) ]]
		spr.stop(REEL_SOUND)
		spr.target(REEL_SOUND, 5, 10, {
			Volume = 0
		})
		task.wait(0.25)
		REEL_SOUND:Stop()
		REEL_SOUND:Destroy()
	end)
	v13:Add(Players.LocalPlayer:GetAttributeChangedSignal("InCutscene"):Connect(function() --[[ Line: 808 | Upvalues: spr (ref), REEL_SOUND (copy), Players (ref), Soundbook (ref) ]]
		spr.stop(REEL_SOUND)
		REEL_SOUND.Volume = if Players.LocalPlayer:GetAttribute("InCutscene") then 0 else Soundbook.Sounds.Reel.Volume
	end))
	spr.stop(CanvasGroup.Left.Bar)
	spr.stop(CanvasGroup.Right.Bar)
	CanvasGroup.Left.Bar.Size = UDim2.fromScale(0, 1)
	CanvasGroup.Right.Bar.Size = UDim2.fromScale(0, 1)
	spr.stop(Fishing.Main)
	spr.target(Fishing.Main, 50, 250, {
		Position = UDim2.fromScale(0.5, 0.95)
	})
	GuiControl:SetHUDVisibility(false)
	if LocalPlayer:GetAttribute("InCutscene") then
		return
	end
	Fishing.Enabled = true
end
function t2.NoInventorySpace(p1) --[[ NoInventorySpace | Line: 837 | Upvalues: v23 (ref), Net (copy), Soundbook (copy), TextNotificationController (copy) ]]
	if v23 then
		return false
	end
	v23 = true
	local v1 = Net:RemoteFunction("SellAllItems")
	if not v1 then
		v23 = false
		return false
	end
	local v2 = v1:InvokeServer()
	if v2 then
		local v3 = Soundbook.Sounds.CoinsChanged:Play()
		v3.Volume = 0.5
		v3.PlaybackSpeed = 1 + math.random() * 0.5
		TextNotificationController:DeliverNotification({
			Type = "Text",
			Text = "Auto sold items! You had no space left.",
			CustomDuration = 5,
			TextColor = {
				R = 0,
				G = 255,
				B = 255
			}
		})
	else
		TextNotificationController:DeliverNotification({
			Type = "Text",
			Text = "Failed to auto sell items!",
			CustomDuration = 3,
			TextColor = {
				R = 255,
				G = 0,
				B = 0
			}
		})
	end
	v23 = false
	return v2
end
function t2.Log(p1) --[[ Log | Line: 876 ]] end
function t2.RequestChargeFishingRod(p1, p2, p3) --[[ RequestChargeFishingRod | Line: 880 | Upvalues: LocalPlayer (copy), v21 (ref), t2 (copy), v29 (ref), destroyFirstCastHint (ref), v22 (ref), AnimationController (copy), v17 (ref), v11 (copy), v33 (ref), Trove (copy), v16 (copy), v34 (ref), v1 (ref), Constants (copy), InventoryUtility (copy), RodEffectCallbacks (copy), Soundbook (copy), UserInputService (copy), CurrentCamera (copy), GuiControl (copy), HUDController (copy), HapticService (copy), v19 (ref), v41 (copy), v42 (copy), InputStates (copy), TextNotificationController (copy), v36 (ref), v6 (copy), v12 (copy) ]]
	if LocalPlayer:GetAttribute("Loading") == nil then
		return
	end
	local v13 = LocalPlayer:GetAttribute("IsTrading") or LocalPlayer:GetAttribute("SellAll")
	if v13 then
		return
	end
	os.clock()
	if workspace:GetServerTimeNow() < (LocalPlayer:GetAttribute("FishingCooldownTime") or 0) then
		return
	end
	if v21 then
		t2.Log("Input locked")
		return
	end
	v29 = v29 + 1
	destroyFirstCastHint()
	v22 = true
	v21 = true
	local v2 = false
	local v3 = nil
	local v4 = nil
	local v5 = false
	local v62 = nil
	local function destroyClientFishingRequest(p1) --[[ destroyClientFishingRequest | Line: 915 | Upvalues: v5 (ref), AnimationController (ref), v3 (ref), v17 (ref), v62 (ref), v11 (ref), v4 (ref), t2 (ref), v33 (ref), v22 (ref), v21 (ref) ]]
		if v5 then
			return
		end
		v5 = true
		if not p1 then
			AnimationController:StopAnimation("StartRodCharge")
			AnimationController:StopAnimation("LoopedRodCharge")
		end
		v3:Destroy()
		v17 = nil
		if v62 then
			v62:Disconnect()
		end
		if v11 then
			v11:DisconnectAll()
		end
		if not v4 then
			t2:FishingStopped(true)
		end
		if p1 then
			t2:UpdateChargeState(nil)
			v33 = false
			v22 = false
			v21 = false
			return
		end
		RefreshIdle()
		t2:UpdateChargeState(nil)
		v33 = false
		v22 = false
		v21 = false
	end
	local function Run(p1, p2) --[[ Run | Line: 960 | Upvalues: v2 (ref), v11 (ref) ]]
		if p2 or v2 then
			return
		end
		if not v11 then
			return
		end
		v2 = true
		v11:Fire(true)
	end
	v3 = Trove.new()
	v17 = Run
	v16:Fire()
	v3:Add(function() --[[ Line: 976 | Upvalues: destroyClientFishingRequest (copy), v21 (ref), v22 (ref), v17 (ref) ]]
		destroyClientFishingRequest()
		v21 = false
		v22 = false
		v17 = nil
	end)
	if v34 then
		v3:Destroy()
		t2:RequestClientStopFishing(true)
		t2.Log("Fishing still locked")
		return
	end
	if v33 then
		v3:Destroy()
		t2:RequestClientStopFishing(true)
		t2.Log("Charging still locked")
		return
	end
	if t2:OnCooldown() then
		v3:Destroy()
		t2:RequestClientStopFishing(true)
		t2.Log("Fishing still cooling down")
		return
	end
	if not v1 then
		v3:Destroy()
		t2:RequestClientStopFishing(true)
		return
	end
	if Constants:CountInventorySize(v1) >= Constants.MaxInventorySize then
		t2:NoInventorySpace()
		v3:Destroy()
		t2:RequestClientStopFishing(true)
		return
	end
	local v7 = InventoryUtility:GetItemDataFromEquippedItem(v1, (v1:GetExpect("EquippedId")))
	if not v7 or v7 and v7.Data.Type ~= "Fishing Rods" then
		v3:Destroy()
		t2:RequestClientStopFishing(true)
		return
	end
	v33 = true
	v1:GetExpect("AutoFishing")
	task.spawn(function() --[[ Line: 1036 | Upvalues: AnimationController (ref), RodEffectCallbacks (ref), LocalPlayer (ref) ]]
		AnimationController:DestroyActiveAnimationTracks()
		AnimationController:PlayAnimation("StartRodCharge")
		RodEffectCallbacks.FireAndReplicate("StartRodCharge", LocalPlayer.Character)
	end)
	if v2 then
		destroyClientFishingRequest()
		return
	end
	if p3 then
		v2 = true
	end
	local v8 = false
	local function f10(p1) --[[ Line: 1058 | Upvalues: v8 (ref), t2 (ref), v3 (ref), p3 (copy), AnimationController (ref), RodEffectCallbacks (ref), LocalPlayer (ref), Soundbook (ref), UserInputService (ref), CurrentCamera (ref), GuiControl (ref), v4 (ref), v17 (ref), HUDController (ref), HapticService (ref), v19 (ref), v41 (ref), v42 (ref), InputStates (ref), TextNotificationController (ref), v1 (ref), v5 (ref), v62 (ref), v11 (ref), v33 (ref), v22 (ref), v21 (ref) ]]
		if v8 then
			return
		end
		if t2:OnCooldown() then
			v3:Destroy()
			t2:RequestClientStopFishing(true)
			return
		end
		if not p1 then
			v3:Destroy()
			t2:RequestClientStopFishing(true)
			return
		end
		v8 = true
		local v12 = t2:_getPower()
		if p3 then
			v12 = 0.5
		end
		t2:UpdateChargeState(nil)
		AnimationController:DestroyActiveAnimationTracks()
		local _, _2 = AnimationController:PlayAnimation("RodThrow")
		RodEffectCallbacks.FireAndReplicate("RodThrow", LocalPlayer.Character)
		task.spawn(function() --[[ Line: 1093 | Upvalues: Soundbook (ref) ]]
			(Soundbook.Sounds[throwCastName] or Soundbook.Sounds.ThrowCast):Play().Volume = 0.5 + math.random() * 0.75
		end)
		local v2 = if UserInputService.MouseEnabled then UserInputService:GetMouseLocation() else Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y / 2)
		local v52, v6 = t2:SendFishingRequestToServer(v2, v12)
		if not v52 then
			local v7 = true
			task.spawn(function() --[[ Line: 1162 | Upvalues: v41 (ref), UserInputService (ref), v42 (ref), InputStates (ref), v7 (ref), v17 (ref), v6 (copy), TextNotificationController (ref), v1 (ref), GuiControl (ref) ]]
				v41:Add(UserInputService.JumpRequest:Connect(function() --[[ Line: 1163 | Upvalues: v42 (ref) ]]
					v42:Fire()
				end))
				v41:Add(UserInputService.InputBegan:Connect(function(p1, p2) --[[ Line: 1167 | Upvalues: InputStates (ref), v42 (ref) ]]
					if p2 then
						return
					end
					if not table.find(InputStates, p1.UserInputType) then
						return
					end
					v42:Fire()
				end))
				v41:Add(function() --[[ Line: 1177 | Upvalues: v7 (ref), v42 (ref), v17 (ref) ]]
					if not v7 then
						v17 = nil
						return
					end
					v42:Fire()
					v17 = nil
				end)
				if v6 ~= "No fishing power!" and typeof(v6) == "string" then
					TextNotificationController:DeliverNotification({
						Type = "Text",
						CustomDuration = 3.5,
						Text = v6,
						TextColor = {
							R = 255,
							G = 0,
							B = 0
						}
					})
				end
				if v1:GetExpect("AutoFishing") then
					task.delay(0.5, function() --[[ Line: 1198 | Upvalues: v42 (ref) ]]
						v42:Fire()
					end)
					return
				end
				local v2
				if not GuiControl.Gui then
					GuiControl:SetHUDVisibility(true)
				end
				v2 = v1:OnChange("AutoFishing", function(p1) --[[ Line: 1206 | Upvalues: v42 (ref) ]]
					if not p1 then
						return
					end
					v42:Fire()
				end)
				v41:Add(function() --[[ Line: 1212 | Upvalues: v2 (copy) ]]
					v2:Disconnect()
				end)
			end)
			v42:Wait()
			v7 = false
			v41:Clean()
			t2:RequestClientStopFishing(true, function() --[[ Line: 1222 | Upvalues: v5 (ref), v3 (ref), v17 (ref), v62 (ref), v11 (ref), v4 (ref), t2 (ref), v33 (ref), v22 (ref), v21 (ref), v8 (ref) ]]
				if not v5 then
					v5 = true
					v3:Destroy()
					v17 = nil
					if v62 then
						v62:Disconnect()
					end
					if v11 then
						v11:DisconnectAll()
					end
					if not v4 then
						t2:FishingStopped(true)
					end
					t2:UpdateChargeState(nil)
					v33 = false
					v22 = false
					v21 = false
				end
				v8 = false
			end)
			return
		end
		GuiControl:SetHUDVisibility(false)
		v4 = true
		v17 = nil
		if not AnimationController:IsDisabled("ReelStart") then
			AnimationController:StopAnimation("RodThrow")
			AnimationController:StopAnimation("ReelIntermission")
			AnimationController:PlayAnimation("ReelStart")
		end
		HUDController.SetCameraFOV(55)
		local v82 = UserInputService:GetLastInputType()
		local v9 = nil
		if v6.SelectedRarity <= 0.01 then
			Soundbook.Sounds.RareExclaim:Play()
			if HapticService:IsVibrationSupported(v82) then
				v9 = Enum.VibrationMotor.Large
				HapticService:SetMotor(v82, Enum.VibrationMotor.Large, 0.15)
			end
		else
			Soundbook.Sounds.Exclaim:Play()
			if HapticService:IsVibrationSupported(v82) then
				v9 = Enum.VibrationMotor.Small
				HapticService:SetMotor(v82, Enum.VibrationMotor.Small, 0.1)
			end
		end
		task.wait(0.5 * v19)
		if not (HapticService:IsVibrationSupported(v82) and v9) then
			t2:FishingRodStarted(v6)
			return
		end
		HapticService:SetMotor(v82, v9, 0)
		t2:FishingRodStarted(v6)
	end
	local v112 = workspace:GetServerTimeNow()
	v36 = v112
	t2:UpdateChargeState(v112)
	local v122, v132 = v6:InvokeServer(nil, nil, v112, nil)
	if not v122 then
		destroyClientFishingRequest()
		t2:RequestClientStopFishing(true)
		return
	end
	if v132 ~= v112 then
		v36 = v132
		t2:UpdateChargeState(v132)
	end
	v12:Add(function() --[[ Line: 1254 | Upvalues: v5 (ref), v3 (ref), v17 (ref), v62 (ref), v11 (ref), v4 (ref), t2 (ref), v33 (ref), v22 (ref), v21 (ref) ]]
		if v5 then
			return
		end
		v5 = true
		v3:Destroy()
		v17 = nil
		if v62 then
			v62:Disconnect()
		end
		if v11 then
			v11:DisconnectAll()
		end
		if not v4 then
			t2:FishingStopped(true)
		end
		t2:UpdateChargeState(nil)
		v33 = false
		v22 = false
		v21 = false
	end)
	v12:Add(function() --[[ Line: 1258 | Upvalues: v33 (ref) ]]
		v33 = false
	end)
	if v2 then
		f10(true)
	else
		v62 = v11:Connect(function(p1) --[[ Line: 1266 | Upvalues: v2 (ref), f10 (copy) ]]
			v2 = true
			f10(true)
		end)
	end
end
function t2.UpdateChargeState(p1, p2) --[[ UpdateChargeState | Line: 1273 | Upvalues: v12 (copy), t2 (copy), RunService (copy), Charge (copy) ]]
	if p2 then
		v12:Clean()
		t2:_updateChargeFrame()
		v12:Add(RunService.Heartbeat:Connect(function(p1) --[[ Line: 1279 | Upvalues: t2 (ref) ]]
			t2:_updateChargeFrame()
		end))
	end
	Charge.Enabled = typeof(p2) == "number"
end
function t2._getPower(p1) --[[ _getPower | Line: 1287 | Upvalues: v36 (ref), Constants (copy) ]]
	local v1 = v36
	if v1 then
		return Constants:GetPower(v1)
	else
		return 0
	end
end
function t2._updateChargeFrame(p1) --[[ _updateChargeFrame | Line: 1296 | Upvalues: Charge (copy), t2 (copy) ]]
	if Charge.Enabled then
		local v1 = t2:_getPower()
		local v2 = UDim2.fromScale(1, v1)
		local v3 = math.round(v1 * 10) / 10 + 1
		local v4 = 255 - 255 * v1
		Charge.Main.Frame.Top.BaseLuck.TextColor3 = Color3.fromRGB(v4, 255, v4)
		Charge.Main.Frame.Top.UIScale.Scale = 1 + 0.2 * v1
		Charge.Main.Frame.Top.BaseLuck.Text = ("x%* Luck"):format(v3)
		Charge.Main.CanvasGroup.Bar.Size = v2
	end
end
function t2.BaitSpawned(p1, p2, p3, p4, p5) --[[ BaitSpawned | Line: 1319 | Upvalues: VFXUtility (copy), LocalPlayer (copy), v1 (ref), PlayEffect (copy), TierUtility (copy), Soundbook (copy), PlayVFX (copy) ]]
	if VFXUtility:IsSpecialVFX(p3) then
		local v12 = if p2 == LocalPlayer then v1:Get({ "Settings", "Self Rod VFX" }) else false
		if not (v12 or (if p2 == LocalPlayer then false else v1:Get({ "Settings", "Others Rod VFX" }))) then
			return
		end
		PlayEffect:Fire(p3, p4)
	else
		local v3 = "Bait Dive"
		local v4 = "Splash"
		local v5 = ("%* Impact"):format(p3)
		local v6 = if VFXUtility:Contains(v5) then v5 else "Water Impact"
		local v7 = ("%* Dive"):format(p3)
		local v8
		if p5 and (p5.Metadata and p5.Metadata.TridentLevel) then
			local v9 = TierUtility:GetTier((math.clamp(p5.Metadata.TridentLevel, 1, 7)))
			v8 = if v9 then ("%* Trident Dive"):format(v9.Name) else v7
		else
			v8 = v7
		end
		if VFXUtility:Contains(v8) then
			v3 = v8
		end
		local v11 = ("%* Splash"):format(p3)
		if Soundbook:HasSound(v11) then
			v4 = v11
		end
		local v12 = v1:Get({ "Settings", "Self Rod VFX" })
		if p2 == LocalPlayer and v12 or p2 ~= LocalPlayer and v1:Get({ "Settings", "Others Rod VFX" }) then
			PlayVFX:Fire(v3, CFrame.new(p4 + Vector3.new(0, 0.5, 0)))
			PlayVFX:Fire(v6, CFrame.new(p4))
		end
		Soundbook:RenderAt(v4, p4)
	end
end
function t2.FishCaught(p1, p2, p3, p4, p5) --[[ FishCaught | Line: 1372 | Upvalues: v13 (copy), ItemUtility (copy), Soundbook (copy), AnimationController (copy), RodEffectCallbacks (copy), LocalPlayer (copy), t2 (copy), v26 (ref), v29 (ref), destroyFirstCastHint (ref) ]]
	v13:Clean()
	local v1 = 0
	local v2 = ItemUtility:GetItemData(p2)
	if v2 then
		local v3 = v2.Probability or v2.ForcedProbability
		if v3 then
			local v5 = Soundbook.Sounds[if v3.Chance <= 0.001 then "SuperRareCatch" elseif v3.Chance <= 0.004 then "RareCatch" else "Catch"]
			if v5 then
				v5:Play()
			end
		end
	end
	AnimationController:DestroyActiveAnimationTracks()
	local function ResetFishCaughtState() --[[ ResetFishCaughtState | Line: 1392 | Upvalues: AnimationController (ref) ]]
		AnimationController:DestroyActiveAnimationTracks({ "EquipIdle" })
		RefreshIdle()
	end
	if AnimationController:IsDisabled("FishCaught") then
		AnimationController:DestroyActiveAnimationTracks({ "EquipIdle" })
		RefreshIdle()
	else
		local v6, _ = AnimationController:PlayAnimation("FishCaught")
		RodEffectCallbacks.FireAndReplicate("FishCaught", LocalPlayer.Character)
		if v6 then
			if v6.Length > 0 then
				local _2 = v1 + math.min(v6.Length * 0.5, 1)
			end
			v6.Stopped:Once(ResetFishCaughtState)
		else
			local v8, _2 = AnimationController:GetAnimationData("FishCaught")
			local v9
			if v8 and v8.Length then
				v9 = (v8.Length or 0.1) * (v8.PlaybackSpeed or 1)
				local _3 = v1 + math.min(v8.Length * 0.5, 1) * (v8.PlaybackSpeed or 1)
			else
				v9 = nil
			end
			if v9 then
				task.delay(v9 * 0.8, ResetFishCaughtState)
			else
				task.spawn(ResetFishCaughtState)
			end
		end
	end
	t2:Hide(1)
	local sum = 0
	if p5 then
		sum = sum + p5
	end
	t2:FishingStopped(false, true, sum)
	v26 = true
	v29 = v29 + 1
	destroyFirstCastHint()
end
function t2.GetCurrentGUID(p1) --[[ GetCurrentGUID | Line: 1473 | Upvalues: v37 (ref) ]]
	return v37
end
function t2.GetFishingInput(p1) --[[ GetFishingInput | Line: 1477 | Upvalues: v17 (ref) ]]
	return v17
end
function t2.Init(p1) --[[ Init | Line: 1485 | Upvalues: v15 (copy), spr (copy), CanvasGroup (copy), v8 (copy), t2 (copy), v9 (copy), v5 (copy), v3 (copy), v2 (copy), v37 (ref), v38 (ref), LocalPlayer (copy), v1 (ref), TextNotificationController (copy) ]]
	v15:Connect(function(p1) --[[ Line: 1486 | Upvalues: spr (ref), CanvasGroup (ref) ]]
		spr.stop(CanvasGroup.Left.Bar)
		spr.stop(CanvasGroup.Right.Bar)
		local v1 = UDim2.fromScale(p1.Progress, 1)
		spr.target(CanvasGroup.Left.Bar, 1, 3, {
			Size = v1
		})
		spr.target(CanvasGroup.Right.Bar, 1, 3, {
			Size = v1
		})
	end)
	v8.OnClientEvent:Connect(function(...) --[[ Line: 1499 | Upvalues: t2 (ref) ]]
		t2:FishingMinigameChanged(...)
	end)
	v9.OnClientEvent:Connect(function() --[[ Line: 1502 | Upvalues: t2 (ref) ]]
		t2:FishingStopped(true)
	end)
	v5.OnClientEvent:Connect(function(...) --[[ Line: 1507 | Upvalues: t2 (ref) ]]
		t2:UpdateChargeState(...)
	end)
	v3.OnClientEvent:Connect(function(...) --[[ Line: 1512 | Upvalues: t2 (ref) ]]
		t2:FishCaught(...)
	end)
	v2.OnClientEvent:Connect(function(...) --[[ Line: 1515 | Upvalues: t2 (ref) ]]
		t2:BaitSpawned(...)
	end)
	task.spawn(function() --[[ Line: 1519 | Upvalues: v37 (ref), v38 (ref), LocalPlayer (ref), v1 (ref), t2 (ref), TextNotificationController (ref), v15 (ref) ]]
		while true do
			local v12, v2, v3
			repeat
				local v4, v5, v6
				while true do
					local v7, v8
					repeat
						repeat
							repeat
								task.wait(0.03333333333333333)
							until v37
							v4 = v38
						until v38 ~= nil
						v5 = LocalPlayer:GetAttribute("ServerCutsceneBlocker")
						v7 = v1:GetExpect("AutoFishing")
						v6 = if v4.CaughtFish <= 100 then 0.02 else 0
						v12 = workspace:GetServerTimeNow()
						v4.Progress = math.clamp(v4.Progress, v6, 1)
						v8 = if v4.LastShift <= v12 or v4.Inputs > 0 and v4.LastShift == 0 then true else nil
						if v4.Progress >= 1 then
							v8 = false
						end
					until v8
					if v4.Progress ~= 0 or (v7 or v5) then
						break
					end
					t2:RequestClientStopFishing(true, function() --[[ Line: 1553 | Upvalues: TextNotificationController (ref) ]]
						TextNotificationController:DeliverNotification({
							Type = "Text",
							Text = "The fish got away!",
							CustomDuration = 4,
							TextColor = {
								R = 255,
								G = 92,
								B = 72
							}
						})
					end)
					task.wait(0.1)
				end
				local v9 = if v4.CaughtFish < 5 then 0.05 else 0.2
				local Progress = v4.Progress
				v2 = 0.314 * (0.1 + math.random() * 0.9) * (6 - v4.FishStrength)
				local v11 = v9 * (math.random() * 0.15 * v4.FishStrength) * v4.FishingResilience
				if v5 then
					v3 = Progress
					continue
				end
				v3 = math.clamp(Progress - v11, v6, 1)
			until v38
			v38.LastShift = v12 + v2
			v38.Progress = v3
			v15:Fire(v38)
		end
	end)
end
function t2.Start(p1) --[[ Start | Line: 1603 | Upvalues: v1 (ref), Replion (copy), v26 (ref), destroyFirstCastHint (ref), GuiControl (copy), MobileFishingButton (copy), InventoryUtility (copy), v37 (ref), t2 (copy), v17 (ref), CurrentCamera (copy), UserInputService (copy), Device (copy), TopTop (copy), Exit (copy), v27 (ref), showIdleRodHint (copy), v29 (ref), isNearFishingHint (copy), placeFirstCastHint (copy) ]]
	v1 = Replion.Client:WaitReplion("Data")
	local v12 = v1:Get({ "Statistics", "FishCaught" })
	if v12 and v12 > 0 then
		v26 = true
	end
	destroyFirstCastHint()
	GuiControl:Hook("Hold Button", MobileFishingButton).Clicked:Connect(function() --[[ Line: 1612 | Upvalues: v1 (ref), InventoryUtility (ref), v37 (ref), t2 (ref), v17 (ref), CurrentCamera (ref) ]]
		if not InventoryUtility:FishingRodEquipped(v1, (v1:GetExpect("EquippedId"))) then
			return
		end
		if v37 then
			t2:RequestFishingMinigameClick()
			return
		end
		local v12 = v17
		if v12 then
			v12(nil, false)
		else
			t2:RequestChargeFishingRod((Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y / 2)))
		end
	end)
	v1:OnChange("EquippedId", RefreshMobileFishing)
	v1:OnChange("EquippedId", RefreshEquippedId)
	CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(RefreshMobileFishing)
	UserInputService.InputChanged:Connect(RefreshMobileFishing)
	task.defer(function() --[[ Line: 1640 | Upvalues: v1 (ref) ]]
		RefreshEquippedId(v1:GetExpect("EquippedId"))
		RefreshMobileFishing()
	end)
	local v2, v3, v4, v5
	if not Device:IsMobile() then
		v1:OnChange("EquippedType", RefreshIdle)
		v1:OnChange("EquippedSkinUUID", RefreshIdle)
		GuiControl:Hook("Hold Button", Exit).Clicked:Connect(function() --[[ Line: 1715 | Upvalues: v37 (ref), t2 (ref) ]]
			if v37 then
				t2:RequestClientStopFishing(true, nil, true)
			end
		end)
		v2 = v1:GetExpect("EquippedId")
		v27 = v27 + 1
		v3 = v27
		task.delay(2, function() --[[ Line: 380 | Upvalues: v27 (ref), v3 (copy), showIdleRodHint (ref), v2 (copy) ]]
			if v27 == v3 then
				showIdleRodHint(v2)
			end
		end)
		v29 = v29 + 1
		v4 = v29
		v5 = true
		task.delay(2, function() --[[ Line: 326 | Upvalues: v4 (copy), v29 (ref), isNearFishingHint (ref), v5 (copy), v37 (ref), placeFirstCastHint (ref), destroyFirstCastHint (ref) ]]
			if v4 ~= v29 then
				return
			end
			while v4 == v29 do
				if isNearFishingHint() then
					if v5 or v37 then
						placeFirstCastHint(v5)
						local v12 = v29
						task.delay(1, function() --[[ Line: 345 | Upvalues: v12 (copy), v29 (ref), destroyFirstCastHint (ref) ]]
							if v12 ~= v29 then
								return
							end
							destroyFirstCastHint()
						end)
						task.wait(0.75)
						continue
					end
					task.wait(0.25)
					continue
				end
				task.wait(0.25)
			end
		end)
		v1:OnChange("EquippedId", function(p1_2) --[[ Line: 1727 | Upvalues: v29 (ref), destroyFirstCastHint (ref), v27 (ref), showIdleRodHint (ref), isNearFishingHint (ref), v37 (ref), placeFirstCastHint (ref) ]]
			v29 = v29 + 1
			destroyFirstCastHint()
			v27 = v27 + 1
			local v1 = v27
			task.delay(2, function() --[[ Line: 380 | Upvalues: v27 (ref), v1 (copy), showIdleRodHint (ref), p1_2 (copy) ]]
				if v27 == v1 then
					showIdleRodHint(p1_2)
				end
			end)
			v29 = v29 + 1
			local v2 = v29
			local v3 = true
			task.delay(2, function() --[[ Line: 326 | Upvalues: v2 (copy), v29 (ref), isNearFishingHint (ref), v3 (copy), v37 (ref), placeFirstCastHint (ref), destroyFirstCastHint (ref) ]]
				if v2 ~= v29 then
					return
				end
				while v2 == v29 do
					if isNearFishingHint() then
						if v3 or v37 then
							placeFirstCastHint(v3)
							local v12 = v29
							task.delay(1, function() --[[ Line: 345 | Upvalues: v12 (copy), v29 (ref), destroyFirstCastHint (ref) ]]
								if v12 ~= v29 then
									return
								end
								destroyFirstCastHint()
							end)
							task.wait(0.75)
							continue
						end
						task.wait(0.25)
						continue
					end
					task.wait(0.25)
				end
			end)
		end)
		return
	end
	TopTop.Top.Size = UDim2.fromScale(1.2, 1.2)
	v1:OnChange("EquippedType", RefreshIdle)
	v1:OnChange("EquippedSkinUUID", RefreshIdle)
	GuiControl:Hook("Hold Button", Exit).Clicked:Connect(function() --[[ Line: 1715 | Upvalues: v37 (ref), t2 (ref) ]]
		if v37 then
			t2:RequestClientStopFishing(true, nil, true)
		end
	end)
	v2 = v1:GetExpect("EquippedId")
	v27 = v27 + 1
	v3 = v27
	task.delay(2, function() --[[ Line: 380 | Upvalues: v27 (ref), v3 (copy), showIdleRodHint (ref), v2 (copy) ]]
		if v27 == v3 then
			showIdleRodHint(v2)
		end
	end)
	v29 = v29 + 1
	v4 = v29
	v5 = true
	task.delay(2, function() --[[ Line: 326 | Upvalues: v4 (copy), v29 (ref), isNearFishingHint (ref), v5 (copy), v37 (ref), placeFirstCastHint (ref), destroyFirstCastHint (ref) ]]
		if v4 ~= v29 then
			return
		end
		while v4 == v29 do
			if isNearFishingHint() then
				if v5 or v37 then
					placeFirstCastHint(v5)
					local v12 = v29
					task.delay(1, function() --[[ Line: 345 | Upvalues: v12 (copy), v29 (ref), destroyFirstCastHint (ref) ]]
						if v12 ~= v29 then
							return
						end
						destroyFirstCastHint()
					end)
					task.wait(0.75)
					continue
				end
				task.wait(0.25)
				continue
			end
			task.wait(0.25)
		end
	end)
	v1:OnChange("EquippedId", function(p1_2) --[[ Line: 1727 | Upvalues: v29 (ref), destroyFirstCastHint (ref), v27 (ref), showIdleRodHint (ref), isNearFishingHint (ref), v37 (ref), placeFirstCastHint (ref) ]]
		v29 = v29 + 1
		destroyFirstCastHint()
		v27 = v27 + 1
		local v1 = v27
		task.delay(2, function() --[[ Line: 380 | Upvalues: v27 (ref), v1 (copy), showIdleRodHint (ref), p1_2 (copy) ]]
			if v27 == v1 then
				showIdleRodHint(p1_2)
			end
		end)
		v29 = v29 + 1
		local v2 = v29
		local v3 = true
		task.delay(2, function() --[[ Line: 326 | Upvalues: v2 (copy), v29 (ref), isNearFishingHint (ref), v3 (copy), v37 (ref), placeFirstCastHint (ref), destroyFirstCastHint (ref) ]]
			if v2 ~= v29 then
				return
			end
			while v2 == v29 do
				if isNearFishingHint() then
					if v3 or v37 then
						placeFirstCastHint(v3)
						local v12 = v29
						task.delay(1, function() --[[ Line: 345 | Upvalues: v12 (copy), v29 (ref), destroyFirstCastHint (ref) ]]
							if v12 ~= v29 then
								return
							end
							destroyFirstCastHint()
						end)
						task.wait(0.75)
						continue
					end
					task.wait(0.25)
					continue
				end
				task.wait(0.25)
			end
		end)
	end)
end
function RefreshMobileFishing() --[[ RefreshMobileFishing | Line: 1735 | Upvalues: UserInputService (copy), CurrentCamera (copy), v1 (ref), InventoryUtility (copy), MobileFishingButton (copy) ]]
	local v12 = (UserInputService.TouchEnabled or (CurrentCamera.ViewportSize.Y <= 500 or UserInputService:GetLastInputType() == Enum.UserInputType.Touch)) and true or false
	local v2 = v1:GetExpect("EquippedId")
	local v3 = InventoryUtility:FishingRodEquipped(v1, v2)
	local _, v4 = InventoryUtility:GetEquippedInventoryItem(v1, v2)
	if v3 and not (if v4 then v4.Category == "Totems" else v4) then
		MobileFishingButton.Visible = v12
	else
		MobileFishingButton.Visible = false
	end
end
function RefreshEquippedId(p1) --[[ RefreshEquippedId | Line: 1761 | Upvalues: InventoryUtility (copy), v1 (ref), Soundbook (copy), v27 (ref), showIdleRodHint (copy) ]]
	local v12 = InventoryUtility:GetItemDataFromEquippedItem(v1, p1)
	if v12 and v12.Data.Type == "Fishing Rods" then
		local v2 = ("Custom Equip - %*"):format(v12.Data.Name)
		Soundbook.Sounds[if Soundbook:HasSound(v2) then v2 else "Equip - Starter Rod"]:Play().PlaybackSpeed = 0.95 + math.random() * 0.35
	end
	if not InventoryUtility:FishingRodEquipped(v1, p1) then
		RefreshIdle()
		return
	end
	v27 = v27 + 1
	local v4 = v27
	task.delay(2, function() --[[ Line: 380 | Upvalues: v27 (ref), v4 (copy), showIdleRodHint (ref), p1 (copy) ]]
		if v27 == v4 then
			showIdleRodHint(p1)
		end
	end)
	RefreshIdle()
end
function RefreshIdle() --[[ RefreshIdle | Line: 1788 | Upvalues: v1 (ref), Replion (copy), AnimationController (copy), InventoryUtility (copy), ItemUtility (copy), RodEffectCallbacks (copy), LocalPlayer (copy), WeightRanges (copy) ]]
	if not v1 then
		v1 = Replion.Client:WaitReplion("Data")
	end
	AnimationController:DestroyActiveAnimationTracks()
	local v12 = v1:GetExpect("EquippedId")
	local v2, v3 = InventoryUtility:GetEquippedInventoryItem(v1, v12)
	local v5 = if v2 then ItemUtility.GetItemDataFromItemType(if v3 then v3.Category or "Items" else "Items", v2.Id) else v2
	if v12 and string.len(v12) == 0 or not (v2 and v5) then
		return
	end
	if v5.Data.Type == "Totems" then
		AnimationController:PlayAnimation("EquipIdleFake")
		return
	end
	if v5.Data.Type == "Fishing Rods" then
		AnimationController:PlayAnimation("EquipIdle")
		RodEffectCallbacks.FireAndReplicate("EquipIdle", LocalPlayer.Character)
		return
	end
	if v5.GripVersion and (v5.GripVersion >= 1 and v5.GripVersion <= 3) then
		AnimationController:PlayAnimation((("HoldFish%*"):format(v5.GripVersion)))
		return
	end
	local Metadata = v2.Metadata
	local v6 = if Metadata then Metadata.Weight else Metadata
	if not v6 then
		AnimationController:PlayAnimation("HoldFish1")
		return
	end
	local v7 = 1
	for i, v in ipairs(WeightRanges) do
		if v <= v6 then
			v7 = i
		end
	end
	AnimationController:PlayAnimation((("HoldFish%*"):format(v7)))
end
function t2.RequestClientStopFishing(p1, p2, p3, p4) --[[ RequestClientStopFishing | Line: 1845 | Upvalues: v4 (copy), t2 (copy), GuiControl (copy) ]]
	if not v4:InvokeServer(p4) then
		return
	end
	t2:UpdateChargeState(nil)
	t2:FishingStopped(true)
	if p3 then
		p3()
	end
	if GuiControl.Gui then
		return
	end
	GuiControl:SetHUDVisibility(true)
end
return t2