local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Modules = ReplicatedStorage.Modules
local Knit = require(ReplicatedStorage.Packages.Knit)
local ButtonAnimation = require(Modules.ButtonAnimation)
local CharacterUtil = require(Modules.CharacterUtil)
local FishingAssets = require(Modules.FishingAssets)
local FishingSpotUtil = require(Modules.FishingSpotUtil)
local GameplayInputGate = require(Modules.GameplayInputGate)
local GuiAnimation = require(Modules.GuiAnimation)
local Notification = require(Modules.NotificationClient)
local Onboarding = require(Modules.FishingOnboarding)
local PlotUtil = require(Modules.PlotWorkspaceUtil)
local RodPopupView = require(Modules.RodPopupView)
local RodShopClientState = require(Modules.RodShopClientState)
local RodUpgradePromptPolicy = require(Modules.RodUpgradePromptPolicy)
local TrainingConfig = require(Modules.TrainingConfig)
local TrainingProgress = require(Modules.TrainingProgress)
local LoadingAttributes = require(ReplicatedFirst.LoadingAttributes)
local dataFolder = ReplicatedFirst:WaitForChild("Data")
local RodsData = require(dataFolder:WaitForChild("RodsData"))
local TrainingData = require(dataFolder:WaitForChild("TrainingData"))
local player = Players.LocalPlayer
local Controller = Knit.CreateController({ Name = "RodPopupController" })

local function getOwnUpgradeAnchor(): BasePart?
	local plot = PlotUtil.getPlotBySlot(player:GetAttribute("PlotSlotId"))
	if not plot or plot:GetAttribute("OwnerUserId") ~= player.UserId then
		return nil
	end
	local anchor = plot:FindFirstChild("TrainingUpgradeAnchor")
	return if anchor and anchor:IsA("BasePart") then anchor else nil
end

local function getLiveCharacter(): (Model?, BasePart?, Humanoid?)
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not root or not root:IsA("BasePart") or root.Anchored or not humanoid or humanoid.Health <= 0 then
		return nil, nil, nil
	end
	return character, root, humanoid
end

local function getUpgradeDestination(anchor: BasePart, character: Model, root: BasePart, humanoid: Humanoid): CFrame?
	local forward = anchor.CFrame.LookVector * Vector3.new(1, 0, 1)
	if forward.Magnitude < 0.01 then
		return nil
	end
	-- The floor marker's local X axis points up.
	local left = -forward.Unit:Cross(Vector3.yAxis)
	local landing = anchor.Position + left * 3
	local excluded = { character, anchor }
	local ray = RaycastParams.new()
	ray.FilterDescendantsInstances = excluded
	ray.IgnoreWater, ray.RespectCanCollide = true, true
	local floor = Workspace:Raycast(landing + Vector3.yAxis * 4, -Vector3.yAxis * 12, ray)
	if not floor or floor.Normal.Y < 0.7 or math.abs(floor.Position.Y - anchor.Position.Y) > 3 then
		return nil
	end

	local footHeight = FishingSpotUtil.GetFootHeight(root, humanoid)
	local position = floor.Position + Vector3.yAxis * (footHeight + 0.1)
	if (position - anchor.Position).Magnitude > TrainingConfig.PromptDistance then
		return nil
	end
	local overlap = OverlapParams.new()
	overlap.FilterDescendantsInstances = excluded
	overlap.RespectCanCollide = true
	local height = footHeight + root.Size.Y / 2 + 1
	local center = floor.Position + Vector3.yAxis * (height / 2 + 0.1)
	local size = Vector3.new(math.max(root.Size.X, 2), height, math.max(root.Size.Z, 2))
	if #Workspace:GetPartBoundsInBox(CFrame.new(center), size, overlap) > 0 then
		return nil
	end

	local rootDestination = CFrame.lookAt(position, position - left)
	return rootDestination * root.CFrame:ToObjectSpace(character:GetPivot())
end

function Controller:KnitStart()
	local started = os.clock()
	local playerGui = player:WaitForChild("PlayerGui")
	local gui = playerGui:WaitForChild("UpgradePopupGui", 15)
	if not gui then
		warn("RodPopupController: UpgradePopupGui is missing")
		return
	end
	gui.ResetOnSpawn, gui.Enabled = false, false
	for _, child in ipairs(gui:GetChildren()) do
		if child:IsA("GuiObject") then
			child.Visible = false
		end
	end
	local policy = RodUpgradePromptPolicy.new(RodsData, function(model)
		return FishingAssets.GetRod(model) ~= nil
	end, started)
	local snapshots = RodShopClientState.new()
	local service = Knit.GetService("RodShopService")
	local playerDataService = Knit.GetService("PlayerDataService")
	local shop = Knit.GetController("RodShopGuiController")
	local training = Knit.GetController("TrainingController")
	local lastTrainingId, nextBarbell
	local cash
	local cashVersion = 0
	local fetching, fetchWarning, actionPending = false, false, false
	local nextFetchAt = 0

	service.InventoryChanged:Connect(function(result)
		snapshots:ApplyEvent(result)
	end)
	playerDataService.WinsChanged:Connect(function(value)
		cashVersion += 1
		cash = value
	end)
	local initialCashVersion = cashVersion
	task.spawn(function()
		local data = Knit.GetController("PlayerDataController"):GetData()
		if cashVersion == initialCashVersion then
			cash = data.Wins
		end
	end)

	local function goToBarbell(active)
		local snapshot = training:GetSnapshot()
		local nextItem = snapshot and TrainingProgress.GetNextEquipment(TrainingData, snapshot.trainingId)
		local character, root, humanoid = getLiveCharacter()
		local anchor = getOwnUpgradeAnchor()
		if
			not nextItem or nextItem.TrainingID ~= active.id or snapshot.trainingId ~= active.trainingId
			or typeof(cash) ~= "number" or cash < nextItem.Price
			or not character or not root or not humanoid or not anchor or not Workspace.CurrentCamera
			or snapshot.active or not GameplayInputGate.IsWorldActionAllowed() or not GuiAnimation.IsAllPopupGuisClosed()
		then
			Notification.RedNotify("The training upgrade is not available right now.")
			return
		end
		local destination = getUpgradeDestination(anchor, character, root, humanoid)
		if not destination then
			Notification.RedNotify("Could not reach the training upgrade. Walk to the upgrade point to continue.")
			return
		end
		CharacterUtil.TeleportTo(character, destination)
	end

	local function bindPopup(kind: "Rod" | "Barbell")
		local popup = gui:FindFirstChild(kind .. "Popup")
		if not popup or not popup:IsA("Frame") then
			warn("RodPopupController: UpgradePopupGui." .. kind .. "Popup is missing")
			return nil
		end
		local view = RodPopupView.new(gui, popup, kind)
		local button = popup.MainFrame.ShopButton
		ButtonAnimation.SetUp(popup.CloseButton)
		ButtonAnimation.SetUp(button)
		popup.CloseButton.Activated:Connect(function()
			if policy.active and policy.active.kind == kind then
				policy:Close(os.clock(), "Close")
				view:Hide()
			end
		end)
		popup.MainFrame.MouseEnter:Connect(function()
			view.hovered = true
		end)
		popup.MainFrame.MouseLeave:Connect(function()
			view.hovered = false
		end)
		button.Activated:Connect(function()
			local active = policy.active
			if actionPending or not active or active.kind ~= kind then
				return
			end
			policy:Close(os.clock(), "Action")
			view:Hide()
			if kind == "Barbell" then
				goToBarbell(active)
			else
				actionPending = true
				shop:OpenForRod(active.id):finally(function()
					actionPending = false
				end)
			end
		end)
		return view
	end
	local rodView = bindPopup("Rod")
	local barbellView = bindPopup("Barbell")
	local activeView

	RunService.Heartbeat:Connect(function()
		local now = os.clock()
		local loaded = player:GetAttribute(LoadingAttributes.LOADING_SCREEN_DONE) == true
			and player:GetAttribute(LoadingAttributes.PLAYER_DATA_LOADED) == true
		if loaded and not snapshots.data and not fetching and now >= nextFetchAt then
			fetching = true
			local token = snapshots:BeginRequest()
			service
				:GetState()
				:andThen(function(result)
					snapshots:ApplyResponse(token, result)
				end)
				:catch(function()
					if not fetchWarning then
						fetchWarning = true
						warn("RodPopupController: could not load rod inventory; will retry")
					end
				end)
				:finally(function()
					fetching = false
					nextFetchAt = os.clock() + 5
				end)
		end
		local hatchGui = playerGui:FindFirstChild("EggHatchResultGui")
		local hatching = hatchGui ~= nil and hatchGui.Enabled
		local longBusy = GameplayInputGate.IsActive("Fishing") or GameplayInputGate.IsActive("Training") or hatching
			or Onboarding.IsActiveStage(player:GetAttribute(Onboarding.StageAttribute))
		local rodGui = playerGui:FindFirstChild("RodShopGui")
		local offlineGui = playerGui:FindFirstChild("OfflineResultGui")
		local blocked = actionPending
			or (activeView ~= nil and activeView.closing)
			or longBusy
			or not GameplayInputGate.IsWorldActionAllowed()
			or not GuiAnimation.IsAllPopupGuisClosed()
			or (offlineGui ~= nil and offlineGui.Enabled)
		local ready = loaded and typeof(cash) == "number"
		local snapshot = training:GetSnapshot()
		local trainingId = snapshot and snapshot.trainingId
		if trainingId ~= lastTrainingId then
			lastTrainingId = trainingId
			nextBarbell = trainingId and TrainingProgress.GetNextEquipment(TrainingData, trainingId)
		end
		local barbellReady = barbellView and ready and nextBarbell and nextBarbell.Price <= cash
			and not snapshot.active and getLiveCharacter() ~= nil and getOwnUpgradeAnchor() ~= nil
		local event, value = policy:Update(now, {
			ready = ready,
			rodReady = ready and rodView ~= nil and snapshots.data ~= nil and shop:IsReady(),
			blocked = blocked,
			longBusy = longBusy,
			shopOpen = rodGui ~= nil and rodGui.Enabled,
			paused = activeView ~= nil and activeView:Paused(),
			owned = if snapshots.data then snapshots.data.ownedRods else {},
			balance = cash or 0,
			trainingId = trainingId,
			barbell = if barbellReady then nextBarbell else nil,
		})
		if event == "Show" then
			if policy.active.kind == "Rod" then
				activeView = rodView
				activeView:Show(RodsData[value])
			else
				activeView = barbellView
				activeView:Show(TrainingData[value])
			end
		elseif event == "Close" then
			activeView:Hide()
		end
		if policy.active then
			activeView:Step(policy.active.remaining)
		end
	end)
end

return Controller
