local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Knit = require(ReplicatedStorage.Packages.Knit)
local NumberUtil = require(ReplicatedStorage.Modules.NumberUtil)
local PlotCashCollectFx = require(ReplicatedStorage.Modules.PlotCashCollectFx)
local PlotCashPoolSweepUtil = require(ReplicatedStorage.Modules.PlotCashPoolSweepUtil)
local PlotWorkspaceUtil = require(ReplicatedStorage.Modules.PlotWorkspaceUtil)

local LOCAL_PLAYER = Players.LocalPlayer
local CLIENT_TOUCH_DEBOUNCE_SECONDS = 0.15
local MAX_SWEEP_DISPLACEMENT = 120
local SWEEP_PADDING = Vector3.new(2, 4, 2)

local PlotCashPoolController = Knit.CreateController({
	Name = "PlotCashPoolController",
})

local snapshotBySlot = {}
local boundCashPools: { [Instance]: boolean } = {}
local boundGuiParts: { [BasePart]: boolean } = {}
local touchDebounceBySlot: { [number]: number } = {}
local requestInFlightBySlot: { [number]: boolean } = {}
local previousRootPart: BasePart? = nil
local previousRootPosition: Vector3? = nil

local function getSlot(pedestal: Instance): number?
	local slot = pedestal:GetAttribute("Slot")
	return if typeof(slot) == "number" then slot else tonumber(pedestal.Name:match("_(%d+)$"))
end

local function getPedestal(instance: Instance): Instance?
	local current: Instance? = instance
	while current do
		if current:IsA("Model") and current.Name:match("^Pedestal_%d+$") then
			return current
		end
		current = current.Parent
	end
	return nil
end

local function getPlot(instance: Instance): Instance?
	local current: Instance? = instance
	while current do
		if PlotWorkspaceUtil.isValidPlot(current) then
			return current
		end
		current = current.Parent
	end
	return nil
end

local function getOwnPlot(): Instance?
	for _, plot in ipairs(PlotWorkspaceUtil.getSortedPlots()) do
		if plot:GetAttribute("OwnerUserId") == LOCAL_PLAYER.UserId then
			return plot
		end
	end
	return nil
end

local function hasDisplayedItem(pedestal: Instance): boolean
	return typeof(pedestal:GetAttribute("ItemUid")) == "string" and pedestal:GetAttribute("ItemUid") ~= ""
end

local function setPartVisible(part: Instance?, visible: boolean)
	if part and part:IsA("BasePart") then
		part.LocalTransparencyModifier = if visible then 0 else 1
	end
end

local function refreshCashPoolVisibility(cashPool: Instance)
	local pedestal = getPedestal(cashPool)
	local plot = pedestal and getPlot(pedestal)
	local visible = pedestal ~= nil
		and plot ~= nil
		and plot:GetAttribute("OwnerUserId") == LOCAL_PLAYER.UserId
		and hasDisplayedItem(pedestal)

	setPartVisible(cashPool:FindFirstChild("Part"), visible)
	local guiPart = cashPool:FindFirstChild("GuiPart")
	setPartVisible(guiPart, visible)
	local buttonGui = guiPart and guiPart:FindFirstChild("ButtonGUI")
	if buttonGui and buttonGui:IsA("LayerCollector") then
		buttonGui.Enabled = visible
	end
end

local function refreshPlotCashPoolVisibility(plot: Instance)
	for _, descendant in ipairs(plot:GetDescendants()) do
		if descendant:IsA("Model") and descendant.Name == "CashPool" then
			refreshCashPoolVisibility(descendant)
		end
	end
end

local function getLabels(cashPool: Instance): (TextLabel?, TextLabel?)
	local guiPart = cashPool:FindFirstChild("GuiPart")
	local buttonGui = guiPart and guiPart:FindFirstChild("ButtonGUI")
	local coinsLabel = buttonGui and buttonGui:FindFirstChild("CoinsLabel")
	local offlineLabel = buttonGui and buttonGui:FindFirstChild("OfflineLabel")
	return if coinsLabel and coinsLabel:IsA("TextLabel") then coinsLabel else nil,
		if offlineLabel and offlineLabel:IsA("TextLabel") then offlineLabel else nil
end

local function setCashPoolLabels(cashPool: Instance, total: number, offline: number)
	local coinsLabel, offlineLabel = getLabels(cashPool)
	if coinsLabel then
		coinsLabel.Text = "$" .. NumberUtil.FormatItemPriceCompact(total)
	end
	if offlineLabel then
		offlineLabel.Text = "Offline: $" .. NumberUtil.FormatItemPriceCompact(offline)
		offlineLabel.Visible = offline >= 1
	end
end

local function resetAllCashPools()
	for _, plot in ipairs(PlotWorkspaceUtil.getSortedPlots()) do
		for _, descendant in ipairs(plot:GetDescendants()) do
			if descendant:IsA("Model") and descendant.Name == "CashPool" then
				setCashPoolLabels(descendant, 0, 0)
			end
		end
	end
end

local function applySnapshot(snapshot)
	snapshotBySlot = if typeof(snapshot) == "table" then snapshot else {}
	resetAllCashPools()
	local plot = getOwnPlot()
	local pedestals = plot and plot:FindFirstChild("Pedestals")
	if not pedestals then
		return
	end
	for _, pedestal in ipairs(pedestals:GetChildren()) do
		local slot = getSlot(pedestal)
		local cashPool = pedestal:FindFirstChild("CashPool")
		local state = slot and (snapshotBySlot[slot] or snapshotBySlot[tostring(slot)]) or nil
		if cashPool then
			setCashPoolLabels(
				cashPool,
				math.max(0, math.floor(tonumber(state and state.total) or 0)),
				math.max(0, math.floor(tonumber(state and state.offline) or 0))
			)
		end
	end
end

local function requestSnapshot()
	Knit.GetService("PlotCashPoolService"):RequestSnapshot():andThen(applySnapshot):catch(function(err)
		warn("PlotCashPoolController: snapshot request failed", err)
	end)
end

local function getCachedTotal(slot: number): number
	local state = snapshotBySlot[slot] or snapshotBySlot[tostring(slot)]
	return math.max(0, math.floor(tonumber(state and state.total) or 0))
end

local function collectFromTouch(guiPart: BasePart, hit: BasePart)
	local character = LOCAL_PLAYER.Character
	if not character or not hit:IsDescendantOf(character) then
		return
	end
	local pedestal = getPedestal(guiPart)
	local plot = pedestal and getPlot(pedestal)
	local slot = pedestal and getSlot(pedestal)
	if not pedestal or not plot or not slot or plot:GetAttribute("OwnerUserId") ~= LOCAL_PLAYER.UserId then
		return
	end
	if not hasDisplayedItem(pedestal) or getCachedTotal(slot) < 1 or requestInFlightBySlot[slot] then
		return
	end

	local now = os.clock()
	if touchDebounceBySlot[slot] and now - touchDebounceBySlot[slot] < CLIENT_TOUCH_DEBOUNCE_SECONDS then
		return
	end
	touchDebounceBySlot[slot] = now

	requestInFlightBySlot[slot] = true
	Knit.GetService("PlotCashPoolService"):RequestCollect(slot):andThen(function(response)
		requestInFlightBySlot[slot] = nil
		-- CashCollected and snapshots update the display; a late RPC response must not clear newer income.
		if not response or not response.ok then
			requestSnapshot()
		end
	end):catch(function(err)
		requestInFlightBySlot[slot] = nil
		warn("PlotCashPoolController: collect request failed", err)
		requestSnapshot()
	end)
end

local function collectFromStandingOrSweep()
	local character = LOCAL_PLAYER.Character
	local rootPart = character and character:FindFirstChild("HumanoidRootPart")
	if not rootPart or not rootPart:IsA("BasePart") then
		previousRootPart = nil
		previousRootPosition = nil
		return
	end
	local currentPosition = rootPart.Position
	local startPosition = if previousRootPart == rootPart then previousRootPosition or currentPosition else currentPosition
	previousRootPart = rootPart
	previousRootPosition = currentPosition
	if (currentPosition - startPosition).Magnitude > MAX_SWEEP_DISPLACEMENT then
		startPosition = currentPosition
	end
	local plot = getOwnPlot()
	local pedestals = plot and plot:FindFirstChild("Pedestals")
	if not pedestals then
		return
	end
	for _, pedestal in ipairs(pedestals:GetChildren()) do
		local cashPool = pedestal:FindFirstChild("CashPool")
		local guiPart = cashPool and cashPool:FindFirstChild("GuiPart")
		if guiPart and guiPart:IsA("BasePart") and PlotCashPoolSweepUtil.SegmentIntersectsOrientedBox(
			startPosition, currentPosition, guiPart.CFrame, guiPart.Size, SWEEP_PADDING
		) then
			-- Touches and stationary characters share the same displayed-balance gate.
			collectFromTouch(guiPart, rootPart)
		end
	end
end

local function bindCashPool(cashPool: Instance)
	refreshCashPoolVisibility(cashPool)
	if not boundCashPools[cashPool] then
		boundCashPools[cashPool] = true
		local pedestal = getPedestal(cashPool)
		if pedestal then
			pedestal:GetAttributeChangedSignal("ItemUid"):Connect(function()
				refreshCashPoolVisibility(cashPool)
			end)
		end
	end

	local guiPart = cashPool:FindFirstChild("GuiPart")
	if not guiPart or not guiPart:IsA("BasePart") or boundGuiParts[guiPart] then
		return
	end
	boundGuiParts[guiPart] = true
	setCashPoolLabels(cashPool, 0, 0)
	guiPart.Touched:Connect(function(hit)
		if hit:IsA("BasePart") then
			collectFromTouch(guiPart, hit)
		end
	end)
end

function PlotCashPoolController:KnitStart()
	local areas = Workspace:WaitForChild("Areas")
	local plotRoot = areas:WaitForChild("Plot")
	for _, plot in ipairs(PlotWorkspaceUtil.getSortedPlots()) do
		for _, descendant in ipairs(plot:GetDescendants()) do
			if descendant:IsA("Model") and descendant.Name == "CashPool" then
				bindCashPool(descendant)
			end
		end
		plot:GetAttributeChangedSignal("OwnerUserId"):Connect(function()
			applySnapshot(snapshotBySlot)
			refreshPlotCashPoolVisibility(plot)
			if plot:GetAttribute("OwnerUserId") == LOCAL_PLAYER.UserId then
				requestSnapshot()
			end
		end)
	end
	plotRoot.DescendantAdded:Connect(function(instance)
		if instance:IsA("Model") and instance.Name == "CashPool" then
			bindCashPool(instance)
		end
	end)

	local service = Knit.GetService("PlotCashPoolService")
	service.CashPoolsUpdated:Connect(applySnapshot)
	service.CashCollected:Connect(function(slot, amount)
		if typeof(slot) ~= "number" or typeof(amount) ~= "number" or amount < 1 then
			return
		end
		local plot = getOwnPlot()
		local pedestals = plot and plot:FindFirstChild("Pedestals")
		local pedestal = pedestals and pedestals:FindFirstChild("Pedestal_" .. tostring(slot))
		local cashPool = pedestal and pedestal:FindFirstChild("CashPool")
		local state = snapshotBySlot[slot] or snapshotBySlot[tostring(slot)]
		local cachedRate = tonumber(state and state.rate) or 0
		snapshotBySlot[slot] = { total = 0, offline = 0, rate = cachedRate }
		if cashPool then
			setCashPoolLabels(cashPool, 0, 0)
			PlotCashCollectFx.Play(cashPool, amount)
		end
	end)
	LOCAL_PLAYER:GetAttributeChangedSignal("PlotSlotId"):Connect(requestSnapshot)
	requestSnapshot()
	RunService.Heartbeat:Connect(collectFromStandingOrSweep)
end

return PlotCashPoolController
