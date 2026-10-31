local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Signal = require(ReplicatedStorage.Packages.Signal)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)
local PlotWorkspaceUtil = require(ReplicatedStorage.Modules.PlotWorkspaceUtil)

local function getSortedSlotIds(slots: { [number]: Instance }): { number }
	local ids = {}
	for slotId in pairs(slots) do
		table.insert(ids, slotId)
	end
	table.sort(ids)
	return ids
end

local PlotSlotService = Knit.CreateService({
	Name = "PlotSlotService",
	Client = {
		PlotSlotAssigned = Knit.CreateSignal(),
	},

	_PlotSlots = {}, -- [slotId] = plot instance
	_PlayerToSlot = {}, -- [player] = slotId
	_SlotToPlayer = {}, -- [slotId] = player
	SlotReleased = Signal.new(), -- (plot: Instance) 服务端槽位释放信号
	SlotAssigned = Signal.new(), -- (player: Player, slotId: number) 服务端槽位分配信号
})

function PlotSlotService:_refreshPlotSlots()
	self._PlotSlots = {}

	local plots = PlotWorkspaceUtil.getSortedPlots()
	if #plots == 0 then
		warn("[PlotSlotService] No valid plots found under Workspace.Areas.Plot")
		return
	end

	for _, plot in ipairs(plots) do
		local slotId = PlotWorkspaceUtil.getSlotId(plot)
		if not slotId then
			continue
		end
		self._PlotSlots[slotId] = plot
		plot:SetAttribute("PlotSlotId", slotId)
		if plot:GetAttribute("OwnerUserId") == nil then
			plot:SetAttribute("OwnerUserId", 0)
		end
		if plot:GetAttribute("OwnerName") == nil then
			plot:SetAttribute("OwnerName", "")
		end
	end
end

function PlotSlotService:_setPlotOwner(slotId: number, player: Player?)
	local plot = self._PlotSlots[slotId]
	if not plot then
		return
	end

	if player then
		plot:SetAttribute("OwnerUserId", player.UserId)
		plot:SetAttribute("OwnerName", player.Name)
	else
		plot:SetAttribute("OwnerUserId", 0)
		plot:SetAttribute("OwnerName", "")
	end
end

function PlotSlotService:AssignPlayerSlot(player: Player): number?
	if self._PlayerToSlot[player] then
		return self._PlayerToSlot[player]
	end

	for _, slotId in ipairs(getSortedSlotIds(self._PlotSlots)) do
		if not self._SlotToPlayer[slotId] then
			self._SlotToPlayer[slotId] = player
			self._PlayerToSlot[player] = slotId
			player:SetAttribute("PlotSlotId", slotId)
			player:SetAttribute("FarmSlotId", nil)
			self:_setPlotOwner(slotId, player)

			local profile = PlayerDataService:GetProfile(player)
			if profile then
				profile.Data.LastPlotSlotId = slotId
			end

			self.SlotAssigned:Fire(player, slotId)
			self.Client.PlotSlotAssigned:Fire(player, slotId)
			return slotId
		end
	end

	return nil
end

function PlotSlotService:EnsurePlayerSlot(player: Player): number?
	local slotId = self._PlayerToSlot[player]
	if slotId then
		return slotId
	end
	if next(self._PlotSlots) == nil then
		self:_refreshPlotSlots()
	end
	return self:AssignPlayerSlot(player)
end

function PlotSlotService:ReleasePlayerSlot(player: Player)
	local slotId = self._PlayerToSlot[player]
	if not slotId then
		return
	end

	local plot = self._PlotSlots[slotId]

	self._PlayerToSlot[player] = nil
	if self._SlotToPlayer[slotId] == player then
		self._SlotToPlayer[slotId] = nil
	end
	self:_setPlotOwner(slotId, nil)
	player:SetAttribute("PlotSlotId", nil)

	if plot then
		self.SlotReleased:Fire(plot)
	end
end

function PlotSlotService:GetAllPlots(): { Instance }
	local plots: { Instance } = {}
	for _, plot in ipairs(PlotWorkspaceUtil.getSortedPlots()) do
		if plot then
			table.insert(plots, plot)
		end
	end
	return plots
end

function PlotSlotService:GetPlayerPlotSlotId(player: Player): number?
	return self._PlayerToSlot[player]
end

function PlotSlotService:GetPlayerPlot(player: Player): Instance?
	local slotId = self:GetPlayerPlotSlotId(player)
	if not slotId then
		return nil
	end
	return self._PlotSlots[slotId]
end

function PlotSlotService:IsPlayerPlotPart(player: Player, instance: Instance?): boolean
	if not instance then
		return false
	end
	local plot = self:GetPlayerPlot(player)
	if not plot then
		return false
	end
	return instance:IsDescendantOf(plot)
end

function PlotSlotService:KnitInit()
	self:_refreshPlotSlots()
	for slotId in pairs(self._PlotSlots) do
		self:_setPlotOwner(slotId, nil)
	end

	Players.PlayerRemoving:Connect(function(player: Player)
		self:ReleasePlayerSlot(player)
	end)
end

function PlotSlotService:KnitStart()
	for _, player in ipairs(Players:GetPlayers()) do
		self:EnsurePlayerSlot(player)
	end

	Players.PlayerAdded:Connect(function(player: Player)
		self:EnsurePlayerSlot(player)
	end)
end

return PlotSlotService
