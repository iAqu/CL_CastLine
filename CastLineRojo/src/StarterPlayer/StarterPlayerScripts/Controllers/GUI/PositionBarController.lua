local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerThumbnailUtil = require(ReplicatedStorage.Modules.PlayerThumbnailUtil)
local SurfaceGeometryUtil = require(ReplicatedStorage.Modules.SurfaceGeometryUtil)
local TideConfig = require(ReplicatedStorage.Modules.TideConfig)
local WaterSurfaceUtil = require(ReplicatedStorage.Modules.WaterSurfaceUtil)

local localPlayer = Players.LocalPlayer

local PositionBarController = Knit.CreateController({
	Name = "PositionBarController",
})

local positionBar: Frame? = nil
local playerBar: Frame? = nil
local otherPositionTemplate: ImageLabel? = nil
local myPosition: ImageLabel? = nil
local waterFrame: Frame? = nil
local tidePositionFrame: Frame? = nil
local tsunamiMarker: GuiObject? = nil

local zoneStartZ: number? = nil
local zoneEndZ: number? = nil
local highTideY: number? = nil
local lowTideY: number? = nil
local water: Model? = nil

local playerMarkers: { [number]: ImageLabel } = {}
local earlyUiStarted = false

local function resolveUi(): boolean
	local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
	local homeGui = playerGui and playerGui:FindFirstChild("HomeGui")
	local topFrame = homeGui and homeGui:FindFirstChild("TopFrame")
	local frame = topFrame and topFrame:FindFirstChild("PositionFrame")
	if not frame or not frame:IsA("Frame") then
		warn("PositionBarController: PlayerGui.HomeGui.TopFrame.PositionFrame is missing")
		return false
	end

	local bar = frame:FindFirstChild("PositionBar_1")
	local markerBar = frame:FindFirstChild("PlayerBar")
	if not bar or not bar:IsA("Frame") then
		warn("PositionBarController: PositionFrame.PositionBar_1 is missing")
		return false
	end
	if not markerBar or not markerBar:IsA("Frame") then
		warn("PositionBarController: PositionFrame.PlayerBar is missing")
		return false
	end

	local otherTemplate = markerBar:FindFirstChild("OtherPositionTemplate")
	local localMarker = markerBar:FindFirstChild("MyPosition")
	if not otherTemplate or not otherTemplate:IsA("ImageLabel") then
		warn("PositionBarController: PlayerBar.OtherPositionTemplate is missing")
		return false
	end
	if not localMarker or not localMarker:IsA("ImageLabel") then
		warn("PositionBarController: PlayerBar.MyPosition is missing")
		return false
	end

	positionBar = bar
	playerBar = markerBar
	otherPositionTemplate = otherTemplate
	myPosition = localMarker

	frame.Visible = true
	otherTemplate.Visible = false
	localMarker.Visible = false

	local waterContainer = frame:FindFirstChild("WaterFrame")
	if not waterContainer or not waterContainer:IsA("Frame") then
		warn("PositionBarController: PositionFrame.WaterFrame is missing")
		return true
	end

	local movementFrame = waterContainer:FindFirstChild("PositionFrame")
	local wave = waterContainer:FindFirstChild("Tsunami")
	if not movementFrame or not movementFrame:IsA("Frame") then
		warn("PositionBarController: WaterFrame.PositionFrame is missing")
	end
	if not wave or not wave:IsA("GuiObject") then
		warn("PositionBarController: WaterFrame.Tsunami is missing")
	end
	if wave and wave:IsA("GuiObject") then
		wave.Visible = false
	end
	if movementFrame and movementFrame:IsA("Frame") and wave and wave:IsA("GuiObject") then
		waterFrame = waterContainer
		tidePositionFrame = movementFrame
		tsunamiMarker = wave
	end
	return true
end

local function resolveWorldRange(): boolean
	local areas = Workspace:FindFirstChild("Areas")
	local zone1 = areas and areas:FindFirstChild("Zone_1")
	local lowTideZoneId = TideConfig.LOW_TIDE_ZONE_ID
	local lowTideZone = areas and areas:FindFirstChild(lowTideZoneId)
	local zone1Main = zone1 and zone1:FindFirstChild("MainPart")
	local lowTideZoneMain = lowTideZone and lowTideZone:FindFirstChild("MainPart")
	local highTideMarker = areas and areas:FindFirstChild("WaterSurfacePosition")
	local waterInstance = areas and areas:FindFirstChild("Water")

	if not zone1Main or not zone1Main:IsA("BasePart") then
		warn("PositionBarController: Workspace.Areas.Zone_1.MainPart is missing")
		return false
	end
	if not lowTideZoneMain or not lowTideZoneMain:IsA("BasePart") then
		warn("PositionBarController: Workspace.Areas." .. lowTideZoneId .. ".MainPart is missing")
		return false
	end
	if not highTideMarker or not highTideMarker:IsA("BasePart") then
		warn("PositionBarController: Workspace.Areas.WaterSurfacePosition is missing")
		return false
	end
	if not waterInstance or not waterInstance:IsA("Model") then
		warn("PositionBarController: Workspace.Areas.Water is missing")
		return false
	end

	local startZ = zone1Main.Position.Z - zone1Main.Size.Z / 2
	local endZ = lowTideZoneMain.Position.Z + lowTideZoneMain.Size.Z / 2
	local highY = highTideMarker.Position.Y
	local waterSurfaceY = WaterSurfaceUtil.GetWaterSurfaceY()
	if not waterSurfaceY then
		warn("PositionBarController: Workspace.Areas.Water.Top is missing")
		return false
	end
	local surfaceOffsetY = waterSurfaceY - waterInstance:GetPivot().Position.Y
	local lowY = SurfaceGeometryUtil.GetTopSurfaceLowestY(lowTideZoneMain) - surfaceOffsetY
	if math.abs(endZ - startZ) <= 0.001 then
		warn("PositionBarController: player position range has zero length")
		return false
	end
	if math.abs(highY - lowY) <= 0.001 then
		warn("PositionBarController: tide position range has zero height")
		return false
	end

	zoneStartZ = startZ
	zoneEndZ = endZ
	highTideY = highY
	lowTideY = lowY
	water = waterInstance
	return true
end

local function getPositionBarScreenSpan(): (number?, number?)
	local bar = positionBar
	if not bar then
		return nil, nil
	end

	local leftMost: number? = nil
	local rightMost: number? = nil
	for _, child in bar:GetChildren() do
		if child:IsA("GuiObject") and tonumber(child.Name) then
			local left = child.AbsolutePosition.X
			local right = left + child.AbsoluteSize.X
			if not leftMost or left < leftMost then
				leftMost = left
			end
			if not rightMost or right > rightMost then
				rightMost = right
			end
		end
	end

	if leftMost and rightMost and rightMost > leftMost then
		return leftMost, rightMost
	end
	if bar.AbsoluteSize.X <= 0 then
		return nil, nil
	end
	return bar.AbsolutePosition.X, bar.AbsolutePosition.X + bar.AbsoluteSize.X
end

local function setMarkerProgress(marker: GuiObject, progress: number)
	local parent = marker.Parent
	if not parent or not parent:IsA("GuiObject") or parent.AbsoluteSize.X <= 0 then
		return
	end

	local left, right = getPositionBarScreenSpan()
	if not left or not right then
		return
	end

	local targetScreenX = left + math.clamp(progress, 0, 1) * (right - left)
	local parentScaleX = (targetScreenX - parent.AbsolutePosition.X) / parent.AbsoluteSize.X
	marker.Position = UDim2.new(parentScaleX, 0, marker.Position.Y.Scale, marker.Position.Y.Offset)
end

local function setTsunamiProgress(progress: number): boolean
	local marker = tsunamiMarker
	local container = waterFrame
	local movementFrame = tidePositionFrame
	if not marker or not container or not movementFrame then
		return false
	end
	if container.AbsoluteSize.X <= 0 or marker.AbsoluteSize.X <= 0 then
		return false
	end

	local highTideLeft = movementFrame.AbsolutePosition.X
	local lowTideLeft = container.AbsolutePosition.X + container.AbsoluteSize.X
	local markerLeft = highTideLeft + math.clamp(progress, 0, 1) * (lowTideLeft - highTideLeft)
	local markerAnchorX = markerLeft + marker.AbsoluteSize.X * marker.AnchorPoint.X
	local containerScaleX = (markerAnchorX - container.AbsolutePosition.X) / container.AbsoluteSize.X
	marker.Position = UDim2.new(containerScaleX, 0, marker.Position.Y.Scale, marker.Position.Y.Offset)
	return true
end

local function setThumbnail(player: Player, marker: ImageLabel)
	marker.Image = PlayerThumbnailUtil.GetHeadshot(player.UserId, 60)
end

local function addPlayerMarker(player: Player)
	if playerMarkers[player.UserId] then
		return
	end

	local marker: ImageLabel?
	if player == localPlayer then
		marker = myPosition
	else
		local template = otherPositionTemplate
		local markerParent = playerBar
		if template and markerParent then
			local clone = template:Clone()
			clone.Name = tostring(player.UserId)
			clone.Visible = false
			clone.Parent = markerParent
			marker = clone
		end
	end
	if not marker then
		return
	end

	playerMarkers[player.UserId] = marker
	setThumbnail(player, marker)
end

local function removePlayerMarker(player: Player)
	local marker = playerMarkers[player.UserId]
	playerMarkers[player.UserId] = nil
	if marker and player ~= localPlayer then
		marker:Destroy()
	elseif marker then
		marker.Visible = false
	end
end

local function updatePlayerMarkers()
	local startZ = zoneStartZ
	local endZ = zoneEndZ
	if not startZ or not endZ then
		for _, marker in playerMarkers do
			marker.Visible = false
		end
		return
	end

	for _, player in Players:GetPlayers() do
		addPlayerMarker(player)
		local marker = playerMarkers[player.UserId]
		local character = player.Character
		local rootPart = character and character:FindFirstChild("HumanoidRootPart")
		if marker and rootPart and rootPart:IsA("BasePart") then
			local progress = (rootPart.Position.Z - startZ) / (endZ - startZ)
			setMarkerProgress(marker, progress)
			marker.Visible = true
		elseif marker then
			marker.Visible = false
		end
	end
end

local function updateTsunamiMarker()
	local marker = tsunamiMarker
	local waterModel = water
	local highY = highTideY
	local lowY = lowTideY
	if not marker or not waterModel or not highY or not lowY then
		if marker then
			marker.Visible = false
		end
		return
	end

	local progress = (highY - waterModel:GetPivot().Position.Y) / (highY - lowY)
	marker.Visible = setTsunamiProgress(progress)
end

function PositionBarController:BeginEarlyUi()
	if earlyUiStarted then
		return
	end
	earlyUiStarted = true

	task.spawn(function()
		local playerGui = localPlayer:WaitForChild("PlayerGui", 15)
		if not playerGui then
			warn("PositionBarController: PlayerGui did not replicate in time")
			return
		end
		if not playerGui:WaitForChild("HomeGui", 15) then
			warn("PositionBarController: HomeGui did not replicate in time")
			return
		end
		Workspace:WaitForChild("Areas", 15)

		if not resolveUi() then
			return
		end
		resolveWorldRange()

		for _, player in Players:GetPlayers() do
			addPlayerMarker(player)
		end
		Players.PlayerAdded:Connect(addPlayerMarker)
		Players.PlayerRemoving:Connect(removePlayerMarker)

		RunService.Heartbeat:Connect(function()
			updatePlayerMarkers()
			updateTsunamiMarker()
		end)

		updatePlayerMarkers()
		updateTsunamiMarker()
	end)
end

function PositionBarController:KnitStart()
	self:BeginEarlyUi()
end

return PositionBarController
