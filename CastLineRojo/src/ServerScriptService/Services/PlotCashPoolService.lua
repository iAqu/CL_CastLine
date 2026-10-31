local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")

local ItemsData = require(ReplicatedFirst.Data.ItemsData)
local Knit = require(ReplicatedStorage.Packages.Knit)
local MutationDataUtil = require(ReplicatedStorage.Modules.MutationDataUtil)
local PlotCashPoolUtil = require(ReplicatedStorage.Modules.PlotCashPoolUtil)
local PlotPlacementUtil = require(ReplicatedStorage.Modules.PlotPlacementUtil)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)

local COLLECT_COOLDOWN_SECONDS = 1
local MAX_COLLECT_DISTANCE = 50

type PoolState = {
	PendingCash: number,
	OfflineCash: number,
}

type RuntimeSlot = {
	NextProductionAt: number,
}

local PlotCashPoolService = Knit.CreateService({
	Name = "PlotCashPoolService",
	Client = {
		CashPoolsUpdated = Knit.CreateSignal(),
		CashCollected = Knit.CreateSignal(),
	},
	_InitializedPlayers = {},
	_Runtime = {},
	_LastCollectAt = {},
})

local function result(ok: boolean, amount: number, message: string?)
	return {
		ok = ok,
		amount = amount,
		message = message,
	}
end

local function getPedestals(plot: Instance): { Instance }
	local folder = plot:FindFirstChild("Pedestals")
	if not folder then
		return {}
	end

	local pedestals = {}
	for _, child in ipairs(folder:GetChildren()) do
		if child:IsA("Model") and child.Name:match("^Pedestal_%d+$") then
			local slot = tonumber(child.Name:match("_(%d+)$"))
			if slot then
				if child:GetAttribute("Slot") ~= slot then
					child:SetAttribute("Slot", slot)
				end
				table.insert(pedestals, child)
			end
		end
	end
	table.sort(pedestals, function(left, right)
		return (left:GetAttribute("Slot") or 0) < (right:GetAttribute("Slot") or 0)
	end)
	return pedestals
end

local function getPedestalBySlot(plot: Instance, slot: number): Instance?
	local folder = plot:FindFirstChild("Pedestals")
	local pedestal = folder and folder:FindFirstChild("Pedestal_" .. tostring(slot))
	if pedestal and pedestal:IsA("Model") then
		if pedestal:GetAttribute("Slot") ~= slot then
			pedestal:SetAttribute("Slot", slot)
		end
		return pedestal
	end
	return nil
end

local function getCashPoolGuiPart(pedestal: Instance): BasePart?
	local cashPool = pedestal:FindFirstChild("CashPool")
	local guiPart = cashPool and cashPool:FindFirstChild("GuiPart")
	return if guiPart and guiPart:IsA("BasePart") then guiPart else nil
end

local function ensurePoolTable(profile): { [number]: PoolState }
	if typeof(profile.Data.PlotCashPools) ~= "table" then
		profile.Data.PlotCashPools = {}
	end
	return profile.Data.PlotCashPools
end

local function ensurePoolState(profile, slot: number): PoolState
	local pools = ensurePoolTable(profile)
	local state = pools[slot]
	if typeof(state) ~= "table" then
		state = {}
		pools[slot] = state
	end
	state.PendingCash = PlotCashPoolUtil.NormalizeBalance(state.PendingCash)
	state.OfflineCash = PlotCashPoolUtil.NormalizeBalance(state.OfflineCash)
	return state :: PoolState
end

local function getPlacedRate(profile, slot: number): number
	local placements = profile.Data.PlotPlacements
	if typeof(placements) ~= "table" then
		return 0
	end
	local itemUid = PlotPlacementUtil.GetItemUid(placements, slot)
	local record = typeof(itemUid) == "string" and profile.Data.Items[itemUid] or nil
	local itemData = typeof(record) == "table" and ItemsData[record.ItemId] or nil
	local mutationId = typeof(record) == "table" and record.MutationId or nil
	return PlotCashPoolUtil.GetCpsPrice(itemData, MutationDataUtil.GetEarnCashRate(mutationId))
end

function PlotCashPoolService:_getOwnedPlotAndPedestal(player: Player, slot: number): (Instance?, Instance?)
	local plot = Knit.GetService("PlotSlotService"):GetPlayerPlot(player)
	if not plot or plot:GetAttribute("OwnerUserId") ~= player.UserId then
		return nil, nil
	end
	local pedestal = getPedestalBySlot(plot, slot)
	if not pedestal or pedestal:GetAttribute("Owned") == false then
		return plot, nil
	end
	return plot, pedestal
end

function PlotCashPoolService:_isNearCashPool(player: Player, pedestal: Instance): boolean
	local character = player.Character
	local rootPart = character and character:FindFirstChild("HumanoidRootPart")
	local guiPart = getCashPoolGuiPart(pedestal)
	if not rootPart or not rootPart:IsA("BasePart") or not guiPart then
		return false
	end
	return (rootPart.Position - guiPart.Position).Magnitude <= MAX_COLLECT_DISTANCE
end

function PlotCashPoolService:_accrueSlot(player: Player, slot: number, now: number?)
	local profile = PlayerDataService:GetProfile(player)
	local runtimeBySlot = self._Runtime[player]
	local runtime = runtimeBySlot and runtimeBySlot[slot]
	if not profile or not runtime then
		return
	end

	local currentTime = now or Workspace:GetServerTimeNow()
	if currentTime < runtime.NextProductionAt then
		return
	end
	local interval = PlotCashPoolUtil.PRODUCTION_INTERVAL_SECONDS
	local cycles = math.floor((currentTime - runtime.NextProductionAt) / interval) + 1
	runtime.NextProductionAt += cycles * interval
	local rate = getPlacedRate(profile, slot)
	if rate <= 0 then
		return
	end
	local state = ensurePoolState(profile, slot)
	state.PendingCash += rate * cycles
end

function PlotCashPoolService:_buildSnapshot(player: Player)
	local snapshot = {}
	local profile = PlayerDataService:GetProfile(player)
	local plot = Knit.GetService("PlotSlotService"):GetPlayerPlot(player)
	if not profile or not plot or plot:GetAttribute("OwnerUserId") ~= player.UserId then
		return snapshot
	end

	for _, pedestal in ipairs(getPedestals(plot)) do
		local slot = pedestal:GetAttribute("Slot")
		if typeof(slot) == "number" then
			local state = ensurePoolState(profile, slot)
			local offline = state.OfflineCash
			snapshot[slot] = {
				total = state.PendingCash + offline,
				offline = offline,
				rate = getPlacedRate(profile, slot),
			}
		end
	end
	return snapshot
end

function PlotCashPoolService:_pushSnapshot(player: Player)
	if player:IsDescendantOf(Players) and PlayerDataService:GetProfile(player) then
		self.Client.CashPoolsUpdated:Fire(player, self:_buildSnapshot(player))
	end
end

function PlotCashPoolService:_initializePlayer(player: Player)
	if self._InitializedPlayers[player] then
		return
	end
	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		return
	end
	local plotSlotService = Knit.GetService("PlotSlotService")
	plotSlotService:EnsurePlayerSlot(player)
	local plot = plotSlotService:GetPlayerPlot(player)
	if not plot then
		return
	end

	self._InitializedPlayers[player] = true
	local now = Workspace:GetServerTimeNow()
	local offlineSeconds = math.max(0, os.time() - (tonumber(profile.Data.LastOnlineTime) or os.time()))
	local runtimeBySlot: { [number]: RuntimeSlot } = {}
	self._Runtime[player] = runtimeBySlot
	for _, pedestal in ipairs(getPedestals(plot)) do
		local slot = pedestal:GetAttribute("Slot")
		if typeof(slot) == "number" then
			local state = ensurePoolState(profile, slot)
			local rate = getPlacedRate(profile, slot)
			if rate > 0 then
				state.OfflineCash += PlotCashPoolUtil.ComputeOfflineCash(rate, offlineSeconds)
			else
				state.PendingCash = 0
				state.OfflineCash = 0
			end
			runtimeBySlot[slot] = { NextProductionAt = now + PlotCashPoolUtil.PRODUCTION_INTERVAL_SECONDS }
		end
	end
	self:_pushSnapshot(player)
end

function PlotCashPoolService:_collect(
	player: Player,
	slot: number,
	requireProximity: boolean,
	enforceCooldown: boolean,
	qualifiesForTutorial: boolean
)
	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		return result(false, 0, "Cash data is unavailable")
	end
	local _, pedestal = self:_getOwnedPlotAndPedestal(player, slot)
	if not pedestal then
		return result(false, 0, "Invalid pedestal")
	end
	if requireProximity and not self:_isNearCashPool(player, pedestal) then
		return result(false, 0, "Too far from the cash pool")
	end

	self:_accrueSlot(player, slot)
	local state = ensurePoolState(profile, slot)
	local amount = PlotCashPoolUtil.NormalizeBalance(state.PendingCash + state.OfflineCash)
	if amount < 1 then
		return result(not requireProximity, 0, if requireProximity then "Nothing to collect" else nil)
	end

	local now = os.clock()
	local lastCollectBySlot = self._LastCollectAt[player]
	if typeof(lastCollectBySlot) ~= "table" then
		lastCollectBySlot = {}
		self._LastCollectAt[player] = lastCollectBySlot
	end
	local lastCollectAt = lastCollectBySlot[slot]
	if enforceCooldown and lastCollectAt and now - lastCollectAt < COLLECT_COOLDOWN_SECONDS then
		return result(false, 0, "Please wait")
	end

	local pendingCash = state.PendingCash
	local offlineCash = state.OfflineCash
	state.PendingCash = 0
	state.OfflineCash = 0
	if not PlayerDataService:AdjustWins(player, amount, false) then
		state.PendingCash = pendingCash
		state.OfflineCash = offlineCash
		return result(false, 0, "Could not add cash")
	end
	if enforceCooldown then
		lastCollectBySlot[slot] = now
	end
	if qualifiesForTutorial then
		Knit.GetService("TutorialService"):OnCashCollected(player, slot, amount)
	end
	self.Client.CashCollected:Fire(player, slot, amount)
	self:_pushSnapshot(player)
	return result(true, amount)
end

function PlotCashPoolService:CollectForPlacementChange(player: Player, slot: number)
	if typeof(slot) ~= "number" or slot % 1 ~= 0 then
		return result(false, 0, "Invalid pedestal")
	end
	return self:_collect(player, slot, false, false, false)
end

function PlotCashPoolService:OnPlacementChanged(player: Player, slot: number)
	local profile = PlayerDataService:GetProfile(player)
	local runtimeBySlot = self._Runtime[player]
	if not profile or not runtimeBySlot or not runtimeBySlot[slot] then
		return
	end
	local state = ensurePoolState(profile, slot)
	state.PendingCash = 0
	state.OfflineCash = 0
	runtimeBySlot[slot].NextProductionAt = Workspace:GetServerTimeNow()
		+ PlotCashPoolUtil.PRODUCTION_INTERVAL_SECONDS
	local lastCollectBySlot = self._LastCollectAt[player]
	if typeof(lastCollectBySlot) == "table" then
		lastCollectBySlot[slot] = nil
	end
	self:_pushSnapshot(player)
end

function PlotCashPoolService.Client:RequestCollect(player: Player, slot: unknown)
	if typeof(slot) ~= "number" or slot % 1 ~= 0 then
		return result(false, 0, "Invalid pedestal")
	end
	return PlotCashPoolService:_collect(player, slot, true, true, true)
end

function PlotCashPoolService.Client:RequestSnapshot(player: Player)
	PlotCashPoolService:_initializePlayer(player)
	return PlotCashPoolService:_buildSnapshot(player)
end

function PlotCashPoolService:KnitStart()
	PlayerDataService.ProfileLoaded:Connect(function(player: Player)
		self:_initializePlayer(player)
	end)
	for _, player in ipairs(Players:GetPlayers()) do
		self:_initializePlayer(player)
	end

	Players.PlayerRemoving:Connect(function(player: Player)
		local runtimeBySlot = self._Runtime[player]
		if runtimeBySlot then
			for slot in pairs(runtimeBySlot) do
				self:_accrueSlot(player, slot)
			end
		end
		self._InitializedPlayers[player] = nil
		self._Runtime[player] = nil
		self._LastCollectAt[player] = nil
	end)

	task.spawn(function()
		while true do
			task.wait(PlotCashPoolUtil.PRODUCTION_INTERVAL_SECONDS)
			local now = Workspace:GetServerTimeNow()
			for player, runtimeBySlot in pairs(self._Runtime) do
				for slot in pairs(runtimeBySlot) do
					self:_accrueSlot(player, slot, now)
				end
				self:_pushSnapshot(player)
			end
		end
	end)
end

return PlotCashPoolService
