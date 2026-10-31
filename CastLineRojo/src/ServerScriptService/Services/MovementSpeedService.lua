local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Zone = require(ReplicatedStorage.Libs.Zone)
local MovementSpeedUtil = require(ReplicatedStorage.Modules.MovementSpeedUtil)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)

type ActiveZones = { [string]: boolean }

local ZONE_DETECTION_HEIGHT = 30

local function createZoneDetector(mainPart: BasePart)
	local detectorCFrame = mainPart.CFrame
		* CFrame.new(0, mainPart.Size.Y / 2 + ZONE_DETECTION_HEIGHT / 2, 0)
	local detectorSize = Vector3.new(mainPart.Size.X, ZONE_DETECTION_HEIGHT, mainPart.Size.Z)
	local zone = Zone.fromRegion(detectorCFrame, detectorSize)
	zone:setDetection("Centre")
	return zone
end

local function getFallbackActiveZoneId(activeZones: ActiveZones): string?
	local fallbackZoneId: string? = nil
	local fallbackZoneIndex = -math.huge
	for zoneId in pairs(activeZones) do
		local zoneIndex = tonumber(string.match(zoneId, "^Zone_(%d+)$"))
		if zoneIndex and zoneIndex > fallbackZoneIndex then
			fallbackZoneId = zoneId
			fallbackZoneIndex = zoneIndex
		elseif not fallbackZoneId then
			fallbackZoneId = zoneId
		end
	end
	return fallbackZoneId
end

local MovementSpeedService = Knit.CreateService({
	Name = "MovementSpeedService",
	Client = {},
	_ActiveZonesByPlayer = {} :: { [Player]: ActiveZones },
	_BoundZoneRoots = {} :: { [Instance]: any },
})

function MovementSpeedService:_getZoneWalkSpeedPercent(player: Player, playerData): number
	local activeZones = self._ActiveZonesByPlayer[player]
	if not activeZones then
		return 1
	end

	local percent = 1
	for zoneId in pairs(activeZones) do
		percent = math.min(percent, MovementSpeedUtil.GetZoneWalkSpeedPercent(playerData, zoneId))
	end
	return percent
end

function MovementSpeedService:RefreshPlayer(player: Player)
	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		return
	end

	local activeZones = self._ActiveZonesByPlayer[player]
	local isInDigZone = activeZones ~= nil and next(activeZones) ~= nil
	local percent = self:_getZoneWalkSpeedPercent(player, profile.Data)
	player:SetAttribute(MovementSpeedUtil.ZONE_WALK_SPEED_PERCENT_ATTRIBUTE, percent)
	player:SetAttribute(MovementSpeedUtil.IS_IN_DIG_ZONE_ATTRIBUTE, isInDigZone)
	if not isInDigZone then
		player:SetAttribute(MovementSpeedUtil.CURRENT_DIG_ZONE_ATTRIBUTE, nil)
	end

	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return
	end
	if Knit.GetService("DigItemService"):IsPlayerDigging(player) then
		return
	end

	humanoid.WalkSpeed = MovementSpeedUtil.CalculateWalkSpeed(profile.Data, percent)
end

function MovementSpeedService:_setPlayerZoneState(player: Player, zoneId: string, isInside: boolean)
	local activeZones = self._ActiveZonesByPlayer[player]
	if not activeZones then
		activeZones = {}
		self._ActiveZonesByPlayer[player] = activeZones
	end

	if isInside then
		activeZones[zoneId] = true
		-- 重叠区以最后进入的 Zone 作为玩家当前所在区。
		player:SetAttribute(MovementSpeedUtil.CURRENT_DIG_ZONE_ATTRIBUTE, zoneId)
	else
		activeZones[zoneId] = nil
		if player:GetAttribute(MovementSpeedUtil.CURRENT_DIG_ZONE_ATTRIBUTE) == zoneId then
			player:SetAttribute(
				MovementSpeedUtil.CURRENT_DIG_ZONE_ATTRIBUTE,
				getFallbackActiveZoneId(activeZones)
			)
		end
	end

	self:RefreshPlayer(player)
end

function MovementSpeedService:_bindZone(zoneRoot: Instance)
	if self._BoundZoneRoots[zoneRoot] or not MovementSpeedUtil.HasZoneConfig(zoneRoot.Name) then
		return
	end

	local mainPart = zoneRoot:FindFirstChild("MainPart")
	if not mainPart or not mainPart:IsA("BasePart") then
		warn("MovementSpeedService: configured zone is missing MainPart", zoneRoot:GetFullName())
		return
	end

	local zone = createZoneDetector(mainPart)
	self._BoundZoneRoots[zoneRoot] = zone

	zone.playerEntered:Connect(function(player: Player)
		self:_setPlayerZoneState(player, zoneRoot.Name, true)
	end)
	zone.playerExited:Connect(function(player: Player)
		self:_setPlayerZoneState(player, zoneRoot.Name, false)
	end)

	zoneRoot.AncestryChanged:Connect(function()
		if zoneRoot:IsDescendantOf(Workspace) then
			return
		end
		if self._BoundZoneRoots[zoneRoot] == zone then
			self._BoundZoneRoots[zoneRoot] = nil
			zone:Destroy()
		end
	end)
end

function MovementSpeedService:_bindWorkspaceZones()
	local areas = Workspace:WaitForChild("Areas")
	for _, child in ipairs(areas:GetChildren()) do
		self:_bindZone(child)
	end
	areas.ChildAdded:Connect(function(child)
		self:_bindZone(child)
	end)
end

function MovementSpeedService:_registerPlayer(player: Player)
	self._ActiveZonesByPlayer[player] = {}
	player:SetAttribute(MovementSpeedUtil.ZONE_WALK_SPEED_PERCENT_ATTRIBUTE, 1)
	player:SetAttribute(MovementSpeedUtil.IS_IN_DIG_ZONE_ATTRIBUTE, false)
	player:SetAttribute(MovementSpeedUtil.CURRENT_DIG_ZONE_ATTRIBUTE, nil)

	player.CharacterAdded:Connect(function(character: Model)
		self._ActiveZonesByPlayer[player] = {}
		player:SetAttribute(MovementSpeedUtil.IS_IN_DIG_ZONE_ATTRIBUTE, false)
		player:SetAttribute(MovementSpeedUtil.CURRENT_DIG_ZONE_ATTRIBUTE, nil)
		task.spawn(function()
			character:WaitForChild("Humanoid", 5)
			self:RefreshPlayer(player)
		end)
	end)

	if player.Character then
		self:RefreshPlayer(player)
	end
end

function MovementSpeedService:KnitStart()
	Knit.GetService("EventService").StateChangedServerEvent:Connect(function()
		for _, player in Players:GetPlayers() do
			self:RefreshPlayer(player)
		end
	end)
	for _, player in ipairs(Players:GetPlayers()) do
		self:_registerPlayer(player)
	end
	Players.PlayerAdded:Connect(function(player)
		self:_registerPlayer(player)
	end)
	Players.PlayerRemoving:Connect(function(player)
		self._ActiveZonesByPlayer[player] = nil
	end)

	PlayerDataService.ProfileLoaded:Connect(function(player: Player)
		self:RefreshPlayer(player)
	end)

	task.spawn(function()
		self:_bindWorkspaceZones()
	end)
end

return MovementSpeedService
