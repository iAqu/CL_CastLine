local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local BackpackSlotObserver = require(ReplicatedStorage.Modules.BackpackSlotObserver)
local Constants = require(ReplicatedStorage.Modules.Constants)
local ItemToolUtil = require(ReplicatedStorage.Modules.ItemToolUtil)
local Knit = require(ReplicatedStorage.Packages.Knit)
local Signal = require(ReplicatedStorage.Packages.Signal)
local TutorialConfig = require(ReplicatedStorage.Modules.TutorialConfig)
local TutorialHighlightUI = require(ReplicatedStorage.Modules.TutorialHighlightUI)

local LOCAL_PLAYER = Players.LocalPlayer
local PLAYER_GUI = LOCAL_PLAYER:WaitForChild("PlayerGui")
local HOME_GUI = PLAYER_GUI:WaitForChild("HomeGui") :: ScreenGui
local TOP_FRAME = HOME_GUI:WaitForChild("TopFrame") :: Frame
local TUTORIAL_FRAME = TOP_FRAME:WaitForChild("TutorialFrame") :: Frame
local HINT_LABEL = TUTORIAL_FRAME.ContainerFrame.HintLabel :: TextLabel
local TUTORIAL_FOLDER = Workspace:WaitForChild("Tutorial")
local BEAM_HOLDER = TUTORIAL_FOLDER:WaitForChild("Beam Holder") :: BasePart
local BEAM_PART = TUTORIAL_FOLDER:WaitForChild("Beam Part") :: BasePart

local DEFAULT_OVERLAY_DISPLAY_ORDER = 1
local TUTORIAL_GENERATED_FOLDER_NAME = "TutorialGeneratedItems"
local TUTORIAL_OWNER_ATTRIBUTE = "TutorialOwnerUserId"

type TutorialState = {
	version: number,
	step: number,
	completed: boolean,
	duckInstanceId: string,
	tidePhase: string?,
	digOpensAt: number?,
	canDig: boolean,
	returnedToDigZone: boolean,
	secondItemInstanceId: string,
	secondItemPlaced: boolean,
	cashPoolSlot: number,
	cashCollected: boolean,
	backpackUpgraded: boolean,
	backpackEligible: boolean,
}

local HINTS = {
	[TutorialConfig.STEP.WAIT_FOR_LOW_TIDE] = "Wait for low tide",
	[TutorialConfig.STEP.DIG_DUCK] = "Dig up an item",
	[TutorialConfig.STEP.RETURN_HOME] = "Return to safe zone",
	[TutorialConfig.STEP.SELL_DUCK] = "Sell your item",
	[TutorialConfig.STEP.BUY_SHOVEL] = "Buy a better shovel",
}

local TutorialController = Knit.CreateController({
	Name = "TutorialController",
	CompleteTutorialSignal = Signal.new(),
})

local tutorialState: TutorialState? = nil
local hasInitialState = false
local beamConnection: RBXScriptConnection? = nil
local countdownConnection: RBXScriptConnection? = nil
local lastCountdownSeconds: number? = nil
local targetResolver: (() -> Vector3?)? = nil
local refreshQueued = false

local function getInstancePosition(instance: Instance?): Vector3?
	if not instance then return nil end
	if instance:IsA("Attachment") then return instance.WorldPosition end
	if instance:IsA("BasePart") then return instance.Position end
	if instance:IsA("Model") then return instance:GetPivot().Position end
	local part = instance:FindFirstChildWhichIsA("BasePart", true)
	return part and part.Position or nil
end

local function findAncestorScreenGui(guiObject: GuiObject?): ScreenGui?
	local current: Instance? = guiObject
	while current do
		if current:IsA("ScreenGui") then return current end
		current = current.Parent
	end
	return nil
end

local function setUiHighlight(target: GuiObject?)
	if target then
		local screenGui = findAncestorScreenGui(target)
		local overlayOrder = if screenGui then screenGui.DisplayOrder + 1 else DEFAULT_OVERLAY_DISPLAY_ORDER
		TutorialHighlightUI(target, overlayOrder)
	else
		TutorialHighlightUI(nil)
	end
end

local function hideBeam()
	if beamConnection then
		beamConnection:Disconnect()
		beamConnection = nil
	end
	targetResolver = nil
	BEAM_HOLDER.Parent = nil
	BEAM_PART.Parent = nil
end

local function stopCountdown()
	if countdownConnection then
		countdownConnection:Disconnect()
		countdownConnection = nil
	end
	lastCountdownSeconds = nil
end

local function showBeam(resolver: () -> Vector3?)
	setUiHighlight(nil)
	hideBeam()
	targetResolver = resolver
	local function updateBeam()
		local character = LOCAL_PLAYER.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		local target = targetResolver and targetResolver()
		if not root or not root:IsA("BasePart") or not target then
			-- Keep the resolver connected while a character or target is loading.
			BEAM_HOLDER.Parent = nil
			BEAM_PART.Parent = nil
			return
		end
		BEAM_HOLDER.Position = root.Position
		BEAM_PART.Position = target
		BEAM_HOLDER.Parent = TUTORIAL_FOLDER
		BEAM_PART.Parent = TUTORIAL_FOLDER
	end
	updateBeam()
	beamConnection = RunService.RenderStepped:Connect(updateBeam)
end

local function findTool(instanceId: string): Tool?
	if instanceId == "" then return nil end
	for _, container in ipairs({ LOCAL_PLAYER:FindFirstChildOfClass("Backpack"), LOCAL_PLAYER.Character }) do
		if container then
			for _, child in ipairs(container:GetChildren()) do
				if child:IsA("Tool") and ItemToolUtil.GetInstanceId(child) == instanceId then
					return child
				end
			end
		end
	end
	return nil
end

local function findBackpackSlotForTool(tool: Tool?): GuiObject?
	if not tool then return nil end
	local backpackGui = PLAYER_GUI:FindFirstChild("BackpackGui")
	if not backpackGui or not backpackGui:IsA("ScreenGui") or not backpackGui.Enabled then return nil end
	for _, descendant in ipairs(backpackGui:GetDescendants()) do
		if descendant:IsA("ObjectValue") and descendant.Name == "ToolReference" and descendant.Value == tool then
			local slot = descendant.Parent
			if slot and slot:IsA("GuiObject") and slot.Visible then return slot end
		end
	end
	return nil
end

local function getLocalPlot(): Model?
	local areas = Workspace:FindFirstChild("Areas")
	local plots = areas and areas:FindFirstChild("Plot")
	if not plots then return nil end
	for _, plot in ipairs(plots:GetChildren()) do
		if plot:IsA("Model") and plot:GetAttribute("OwnerUserId") == LOCAL_PLAYER.UserId then
			return plot
		end
	end
	return nil
end

local function getFirstEmptyPedestal(): Model?
	local plot = getLocalPlot()
	local folder = plot and plot:FindFirstChild("Pedestals")
	if not folder then return nil end
	local candidates = {}
	for _, child in ipairs(folder:GetChildren()) do
		if child:IsA("Model") and child:GetAttribute("Owned") ~= false then
			local slot = tonumber(child.Name:match("_(%d+)$"))
			if slot and (child:GetAttribute("ItemUid") == nil or child:GetAttribute("ItemUid") == "") then
				table.insert(candidates, { slot = slot, pedestal = child })
			end
		end
	end
	table.sort(candidates, function(left, right)
		return left.slot < right.slot
	end)
	return candidates[1] and candidates[1].pedestal or nil
end

local function getCashPoolTarget(slot: number): BasePart?
	if slot < 1 then return nil end
	local plot = getLocalPlot()
	local pedestals = plot and plot:FindFirstChild("Pedestals")
	local pedestal = pedestals and pedestals:FindFirstChild("Pedestal_" .. tostring(slot))
	local cashPool = pedestal and pedestal:FindFirstChild("CashPool")
	local guiPart = cashPool and cashPool:FindFirstChild("GuiPart")
	return if guiPart and guiPart:IsA("BasePart") then guiPart else nil
end

local function getTutorialDigSite(): Model?
	local areas = Workspace:FindFirstChild("Areas")
	local zone = areas and areas:FindFirstChild(TutorialConfig.GUIDED_ZONE_ID)
	local folder = zone and zone:FindFirstChild(TUTORIAL_GENERATED_FOLDER_NAME)
	if not folder then return nil end
	for _, child in ipairs(folder:GetChildren()) do
		if child:IsA("Model") and child:GetAttribute(TUTORIAL_OWNER_ATTRIBUTE) == LOCAL_PLAYER.UserId then
			return child
		end
	end
	return nil
end

local function getHomeTarget(): Instance?
	local plot = getLocalPlot()
	return (plot and plot:FindFirstChild("AreaSpawnPoint")) or Workspace:FindFirstChild("SpawnLocation")
end

local function findShovelBuyButton(): GuiObject?
	local gui = PLAYER_GUI:FindFirstChild("ShovelShop")
	if not gui or not gui:IsA("ScreenGui") or not gui.Enabled then return nil end
	local frame = gui:FindFirstChild(TutorialConfig.GUIDED_SHOVEL_ID, true)
	local button = frame and frame:FindFirstChild("BuyButton")
	return if button and button:IsA("GuiObject") and button.Visible then button else nil
end

local function findShovelCloseButton(): GuiObject?
	local gui = PLAYER_GUI:FindFirstChild("ShovelShop")
	if not gui or not gui:IsA("ScreenGui") or not gui.Enabled then return nil end
	local main = gui:FindFirstChild("Main")
	local top = main and main:FindFirstChild("Top")
	local button = top and top:FindFirstChild("CloseButton")
	return if button and button:IsA("GuiObject") and button.Visible then button else nil
end

local function findBackpackUpgradeButton(): GuiObject?
	local gui = PLAYER_GUI:FindFirstChild("UpgradeGui")
	if not gui or not gui:IsA("ScreenGui") or not gui.Enabled then return nil end
	local backpackFrame = gui:FindFirstChild("Backpack", true)
	local button = backpackFrame and backpackFrame:FindFirstChild("Buy1")
	return if button and button:IsA("GuiObject") and button.Visible then button else nil
end

local function getShop(name: string): Instance?
	local areas = Workspace:FindFirstChild("Areas")
	local items = areas and areas:FindFirstChild("Items")
	return items and items:FindFirstChild(name) or nil
end

local function getDigZoneTarget(): Vector3?
	local areas = Workspace:FindFirstChild("Areas")
	local zone = areas and areas:FindFirstChild(TutorialConfig.GUIDED_ZONE_ID)
	local mainPart = zone and zone:FindFirstChild("MainPart")
	if not mainPart or not mainPart:IsA("BasePart") then return nil end
	return mainPart.CFrame:PointToWorldSpace(Vector3.new(0, mainPart.Size.Y * 0.5, 0))
end

local function stopGuide()
	TUTORIAL_FRAME.Visible = false
	stopCountdown()
	hideBeam()
	setUiHighlight(nil)
end

local function showHint(text: string)
	TUTORIAL_FRAME.Visible = true
	HINT_LABEL.Text = text
end

local function showFindAnotherItem()
	showHint("Find another item")
	if LOCAL_PLAYER:GetAttribute("IsInDigZone") == true then
		hideBeam()
		setUiHighlight(nil)
	else
		showBeam(getDigZoneTarget)
	end
end

local function showWaitForLowTide(state: TutorialState)
	hideBeam()
	setUiHighlight(nil)
	if typeof(state.digOpensAt) ~= "number" then
		stopCountdown()
		showHint(HINTS[TutorialConfig.STEP.WAIT_FOR_LOW_TIDE])
		return
	end

	local function updateCountdown()
		local seconds = math.max(0, math.ceil((state.digOpensAt :: number) - Workspace:GetServerTimeNow()))
		if seconds ~= lastCountdownSeconds then
			lastCountdownSeconds = seconds
			showHint(`{HINTS[TutorialConfig.STEP.WAIT_FOR_LOW_TIDE]} ({seconds}s)`)
		end
	end

	stopCountdown()
	updateCountdown()
	countdownConnection = RunService.Heartbeat:Connect(updateCountdown)
end

local function refreshGuide()
	local state = tutorialState
	if not Constants.TUTORIAL_ENABLED or not state then
		stopGuide()
		return
	end

	if not state.completed then
		if state.step == TutorialConfig.STEP.WAIT_FOR_LOW_TIDE
			or state.step == TutorialConfig.STEP.DIG_DUCK
		then
			if state.step == TutorialConfig.STEP.DIG_DUCK and state.tidePhase == "Rising" then
				if LOCAL_PLAYER:GetAttribute("IsInDigZone") == true then
					stopCountdown()
					showHint("The tide is rising! Get to safety!")
					showBeam(function()
						return getInstancePosition(getHomeTarget())
					end)
				else
					showWaitForLowTide(state)
				end
			elseif state.canDig then
				stopCountdown()
				showHint(HINTS[TutorialConfig.STEP.DIG_DUCK])
				showBeam(function()
					return getInstancePosition(getTutorialDigSite())
				end)
			else
				showWaitForLowTide(state)
			end
		elseif state.step == TutorialConfig.STEP.RETURN_HOME then
			stopCountdown()
			showHint(HINTS[state.step])
			showBeam(function()
				return getInstancePosition(getHomeTarget())
			end)
		elseif state.step == TutorialConfig.STEP.SELL_DUCK then
			stopCountdown()
			showHint(HINTS[state.step])
			showBeam(function()
				return getInstancePosition(getShop("SellShop"))
			end)
		elseif state.step == TutorialConfig.STEP.BUY_SHOVEL then
			stopCountdown()
			showHint(HINTS[state.step])
			local target = findShovelBuyButton()
			if target then
				hideBeam()
				setUiHighlight(target)
			else
				showBeam(function()
					return getInstancePosition(getShop("ShovelShop"))
				end)
			end
		end
		return
	end
	stopCountdown()

	if not state.returnedToDigZone then
		local closeButton = findShovelCloseButton()
		if closeButton then
			showHint("Close the shop")
			hideBeam()
			setUiHighlight(closeButton)
		else
			showFindAnotherItem()
		end
		return
	end

	if not state.secondItemPlaced then
		if state.secondItemInstanceId == "" then
			showFindAnotherItem()
			return
		end
		showHint("Place for Cash and Luck")
		local tool = findTool(state.secondItemInstanceId)
		if tool and tool.Parent ~= LOCAL_PLAYER.Character then
			local target = findBackpackSlotForTool(tool)
			hideBeam()
			setUiHighlight(target)
		else
			showBeam(function()
				return getInstancePosition(getFirstEmptyPedestal())
			end)
		end
	elseif not state.cashCollected then
		showHint("Collect your Cash")
		showBeam(function()
			return getInstancePosition(getCashPoolTarget(state.cashPoolSlot))
		end)
	elseif state.backpackEligible and not state.backpackUpgraded then
		showHint("Upgrade your backpack")
		local target = findBackpackUpgradeButton()
		if target then
			hideBeam()
			setUiHighlight(target)
		else
			showBeam(function()
				return getInstancePosition(getShop("UpgradeShop"))
			end)
		end
	else
		stopGuide()
	end
end

local function queueGuideRefresh()
	if refreshQueued then return end
	refreshQueued = true
	task.defer(function()
		refreshQueued = false
		refreshGuide()
	end)
end

local function applyState(state: TutorialState)
	local previousState = tutorialState
	tutorialState = state
	Knit.GetController("DigController"):SetTutorialDigEnabled(state.canDig)
	refreshGuide()
	if hasInitialState
		and previousState ~= nil
		and previousState.returnedToDigZone ~= true
		and state.returnedToDigZone == true
	then
		TutorialController.CompleteTutorialSignal:Fire()
	end
	if state.completed
		and not state.returnedToDigZone
		and LOCAL_PLAYER:GetAttribute("IsInDigZone") == true
	then
		Knit.GetService("TutorialService"):ReportEnteredDigZone()
	end
end

function TutorialController:KnitInit()
	stopGuide()
end

function TutorialController:KnitStart()
	if not Constants.TUTORIAL_ENABLED then
		stopGuide()
		return
	end

	for _, guiName in ipairs({ "ShovelShop", "UpgradeGui", "BackpackGui" }) do
		local gui = PLAYER_GUI:FindFirstChild(guiName)
		if gui and gui:IsA("ScreenGui") then
			gui:GetPropertyChangedSignal("Enabled"):Connect(queueGuideRefresh)
			gui.DescendantAdded:Connect(queueGuideRefresh)
		end
	end
	PLAYER_GUI.ChildAdded:Connect(function(child)
		if child.Name == "BackpackGui" then
			queueGuideRefresh()
		end
	end)

	BackpackSlotObserver.new({
		player = LOCAL_PLAYER,
		playerGui = PLAYER_GUI,
		isRelevantTool = function(tool: Tool): boolean return ItemToolUtil.IsItemTool(tool) end,
		onSlotAdded = queueGuideRefresh,
		onSlotTextChanged = queueGuideRefresh,
		onSlotRemoving = queueGuideRefresh,
		onToolAdded = queueGuideRefresh,
		onToolRemoved = queueGuideRefresh,
	})

	LOCAL_PLAYER:GetAttributeChangedSignal("IsInDigZone"):Connect(function()
		local state = tutorialState
		if state and state.step == TutorialConfig.STEP.RETURN_HOME
			and LOCAL_PLAYER:GetAttribute("IsInDigZone") ~= true
		then
			Knit.GetService("TutorialService"):ReportReturnedHome()
		elseif state and state.completed
			and not state.returnedToDigZone
			and LOCAL_PLAYER:GetAttribute("IsInDigZone") == true
		then
			Knit.GetService("TutorialService"):ReportEnteredDigZone()
		end
		queueGuideRefresh()
	end)
	LOCAL_PLAYER.CharacterAdded:Connect(function(character)
		character.ChildAdded:Connect(queueGuideRefresh)
		character.ChildRemoved:Connect(queueGuideRefresh)
		queueGuideRefresh()
	end)
	if LOCAL_PLAYER.Character then
		LOCAL_PLAYER.Character.ChildAdded:Connect(queueGuideRefresh)
		LOCAL_PLAYER.Character.ChildRemoved:Connect(queueGuideRefresh)
	end

	local service = Knit.GetService("TutorialService")
	service.TutorialStateChanged:Connect(function(state: TutorialState)
		applyState(state)
		hasInitialState = true
	end)
	service:GetTutorialState():andThen(function(state: TutorialState)
		if not hasInitialState then
			applyState(state)
		end
		hasInitialState = true
	end):catch(function(err)
		warn("TutorialController: failed to get tutorial state", err)
		stopGuide()
	end)
end

return TutorialController
