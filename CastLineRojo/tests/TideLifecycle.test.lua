local function read(path: string): string
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local config = read("src/ReplicatedStorage/Modules/TideConfig.lua")
assert(config:find('FULL = "Full"', 1, true), "TideConfig must define the Full phase")
assert(config:find('RECEDING = "Receding"', 1, true), "TideConfig must define the Receding phase")
assert(config:find('LOW = "Low"', 1, true), "TideConfig must define the Low phase")
assert(config:find('RISING = "Rising"', 1, true), "TideConfig must define the Rising phase")
assert(config:find("FULL_DURATION = 10", 1, true), "Full tide must last ten seconds")
assert(config:find("LOW_DURATION = 10", 1, true), "Low tide must last ten seconds")
assert(config:find("GATE_REVEAL_DELAY = 2", 1, true), "Gate reveal must be delayed by two seconds")
assert(config:find("WATER_SPEED = 15", 1, true), "Water must move at fifteen studs per second")
assert(config:find('LOW_TIDE_ZONE_ID = "Zone_10"', 1, true), "Zone_10 must define the low tide target")
assert(config:find("DIG_ZONE_COUNT = 10", 1, true), "Tide warnings must use all ten dig zones")
assert(
	config:find("PROXIMITY_WARNING_ZONE_DISTANCE = 3", 1, true),
	"The proximity warning must begin strictly within three zones"
)
assert(config:find('IS_PAUSED = "IsPaused"', 1, true), "Tide state must replicate whether the debug cycle is paused")

local service = read("src/ServerScriptService/Services/TideService.lua")
assert(service:find('Name = "TideService"', 1, true), "The production TideService must be registered")
assert(service:find("StateChanged = Knit.CreateSignal()", 1, true), "Tide state changes must replicate to every client")
assert(service:find("StateChangedServerEvent = Signal.new()", 1, true), "Server systems must receive tide state changes")
assert(service:find("function TideService:GetStateSnapshot", 1, true), "Server systems must read the current tide snapshot")
assert(service:find("function TideService.Client:GetStateSnapshot", 1, true), "Late clients must be able to request a snapshot")
assert(service:find("lowTideEndsAt: number?", 1, true), "Tide snapshots must include the low-tide deadline")
assert(service:find("cycleEndsAt: number?", 1, true), "Tide snapshots must include the full-cycle deadline")
assert(
	service:find("lowTideEndsAt = lowTideEndsAt", 1, true),
	"The server must replicate the shared low-tide deadline"
)
assert(
	service:find("cycleEndsAt = cycleEndsAt", 1, true),
	"The server must replicate the shared full-cycle deadline"
)
assert(
	service:find("_getTravelDurationBetween(lowTideY, highTideY)", 1, true),
	"The full-cycle deadline must include the return trip from low tide to high tide"
)
assert(
	service:find("SurfaceGeometryUtil.GetTopSurfaceLowestY(zonePart)", 1, true)
		and service:find("return zoneTopLowestY - surfaceOffsetY", 1, true),
	"Low tide must place Water.Top at Zone_10's top-surface lowest Y"
)
assert(
	service:find("WaterSurfaceUtil.GetWaterSurfaceY()", 1, true),
	"Low tide must calculate the water-surface offset from the Water model pivot"
)

local surfaceGeometryUtil = read("src/ReplicatedStorage/Modules/SurfaceGeometryUtil.lua")
assert(
	surfaceGeometryUtil:find("halfSize.Y", 1, true)
		and surfaceGeometryUtil:find("halfSize.X * xSign", 1, true)
		and surfaceGeometryUtil:find("halfSize.Z * zSign", 1, true),
	"Top-surface target must consider all four MainPart top corners"
)
assert(service:find("function TideService:ForceTideTarget", 1, true), "Studio tide controls must restart the state machine")
assert(service:find("function TideService:ForceInstantTideTarget", 1, true), "Studio tide controls must support instant tide targets")
assert(service:find("function TideService:TogglePause", 1, true), "Studio tide controls must toggle the paused state")
assert(service:find("function TideService:_pauseTide", 1, true), "Pausing must capture the current tide phase")
assert(service:find("function TideService:_resumeTide", 1, true), "Resuming must restart from the captured tide phase")
assert(service:find("self:_cancelActiveAnimation()", 1, true), "A restarted tide run must cancel the previous animation")
assert(service:find("phaseRemaining = math.max(0", 1, true), "Full and low tide pauses must preserve their remaining duration")
assert(service:find("self:_startAtLowTide(runRevision)", 1, true), "A paused receding tide must continue toward low tide")
assert(service:find("self:_startAtHighTide(runRevision, true)", 1, true), "A paused rising tide must continue toward high tide")
assert(service:find("refreshWhenAlreadyHigh", 1, true), "Resuming after a just-completed rise must not skip the item refresh")
assert(service:find("self._IsPaused = false", 1, true), "Forced high or low tide must clear a paused state")
assert(service:find("self:_pivotWaterToY(self:_getHighTideY())", 1, true), "Instant high tide must move water directly to the high target")
assert(service:find("self:_pivotWaterToY(self:_getLowTideY())", 1, true), "Instant low tide must move water directly to the low target")
assert(service:find("self:_refreshDigItemsAfterHighTide(runRevision)", 1, true), "Instant high tide must refresh dig items once")
assert(
	service:find("function TideService:_refreshDigItemsAfterHighTide", 1, true),
	"TideService must own the full-tide item refresh trigger"
)
assert(
	service:find('Knit.GetService("DigItemService"):RefreshAllZones()', 1, true),
	"Reaching high tide must refresh all generated dig items"
)

local debugServer = read("src/ServerScriptService/TideDebug.server.lua")
assert(debugServer:find('tide == "TogglePause"', 1, true), "The debug remote must accept tide pause requests")
assert(debugServer:find("TideService:TogglePause()", 1, true), "The debug remote must delegate pause requests to TideService")
assert(debugServer:find('tide == "InstantHigh"', 1, true), "The debug remote must accept instant high tide requests")
assert(debugServer:find('tide == "InstantLow"', 1, true), "The debug remote must accept instant low tide requests")
assert(debugServer:find('TideService:ForceInstantTideTarget("High")', 1, true), "Instant high requests must reach TideService")
assert(debugServer:find('TideService:ForceInstantTideTarget("Low")', 1, true), "Instant low requests must reach TideService")

local debugPanel = read("src/StarterPlayer/StarterPlayerScripts/TideDebugPanel.client.lua")
assert(debugPanel:find('FindFirstChild("PauseTideButton")', 1, true), "TestGui must look up the pause button")
assert(debugPanel:find('tideRemote:FireServer("TogglePause")', 1, true), "The pause button must send the toggle request")
assert(debugPanel:find('"Resume Tide"', 1, true) and debugPanel:find('"Pause Tide"', 1, true), "The pause button label must mirror the shared pause state")
assert(debugPanel:find('FindFirstChild("HomeButton")', 1, true), "TestGui must look up the home button")
assert(debugPanel:find('Workspace:FindFirstChild("SpawnLocation")', 1, true), "The home button must target Workspace.SpawnLocation")
assert(debugPanel:find("CharacterUtil.TeleportTo(character, spawnLocation.CFrame * HOME_SPAWN_OFFSET)", 1, true), "The home button must use the shared character teleport utility")
assert(debugPanel:find('FindFirstChild("InstantFullTideButton")', 1, true), "TestGui must look up the instant high tide button")
assert(debugPanel:find('FindFirstChild("InstantLowTideButton")', 1, true), "TestGui must look up the instant low tide button")
assert(debugPanel:find('tideRemote:FireServer("InstantHigh")', 1, true), "The instant high tide button must send the instant high request")
assert(debugPanel:find('tideRemote:FireServer("InstantLow")', 1, true), "The instant low tide button must send the instant low request")

local fullPhase = assert(service:find("TideConfig.PHASE.FULL", 1, true))
local recedingPhase = assert(service:find("TideConfig.PHASE.RECEDING", fullPhase + 1, true))
local lowPhase = assert(service:find("TideConfig.PHASE.LOW", recedingPhase + 1, true))
local risingPhase = assert(service:find("TideConfig.PHASE.RISING", lowPhase + 1, true))
assert(fullPhase < recedingPhase and recedingPhase < lowPhase and lowPhase < risingPhase, "The tide phases must run in order")

local highTideMove = assert(service:find("self:_moveWaterTo(runRevision, self:_getHighTideY())", lowPhase + 1, true))
local refreshAfterHighTide = assert(service:find("self:_refreshDigItemsAfterHighTide(runRevision)", highTideMove + 1, true))
assert(highTideMove < refreshAfterHighTide, "Items must refresh only after the water reaches high tide")

local movementUtil = read("src/ReplicatedStorage/Modules/MovementSpeedUtil.lua")
local movementService = read("src/ServerScriptService/Services/MovementSpeedService.lua")
assert(
	movementUtil:find('IS_IN_DIG_ZONE_ATTRIBUTE = "IsInDigZone"', 1, true),
	"The shared dig-zone attribute must be defined"
)
assert(
	movementUtil:find('CURRENT_DIG_ZONE_ATTRIBUTE = "CurrentDigZone"', 1, true),
	"The shared current dig-zone attribute must be defined"
)
assert(
	movementService:find("activeZones ~= nil and next(activeZones) ~= nil", 1, true),
	"The player must remain inside while any overlapping dig zone is active"
)
assert(
	movementService:find("MovementSpeedUtil.CURRENT_DIG_ZONE_ATTRIBUTE, zoneId", 1, true)
		and movementService:find("getFallbackActiveZoneId(activeZones)", 1, true),
	"The server must publish the last-entered zone and fall back to an overlapping zone on exit"
)
assert(
	movementService:find("MovementSpeedUtil.CURRENT_DIG_ZONE_ATTRIBUTE, nil", 1, true),
	"The current dig zone must clear outside dig zones and across respawns"
)

local controller = read("src/StarterPlayer/StarterPlayerScripts/Controllers/TideController.lua")
local positionBarController = read("src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/PositionBarController.lua")
local footprintController = read("src/StarterPlayer/StarterPlayerScripts/Controllers/FootprintController.lua")
assert(controller:find('setTopText("Waiting for low tide")', 1, true), "Full tide UI text must be displayed")
assert(
	controller:find('string.format("%02d:%02d.%03d", minutes, seconds, milliseconds)', 1, true),
	"Low tide must use MM:SS.mmm countdown format"
)
assert(
	controller:find("formatCountdownWithMilliseconds(cycleEndsAt - now)", 1, true),
	"Receding, low-tide, and rising countdowns must use the shared full-cycle deadline"
)
assert(
	controller:find('FindFirstChild("TideLabel")', 1, true),
	"Rising tide must use the Studio-configured TideLabel"
)
assert(controller:find("tideLabel.Visible = false", 1, true), "TideLabel must be hidden outside rising tide")
assert(controller:find("tideLabel.Visible = true", 1, true), "TideLabel must be shown during rising tide")
assert(not controller:find("TideWarningScale", 1, true), "TideLabel must not create a scale animation")
assert(controller:find("stopRisingWarning()", 1, true), "Leaving rising tide must hide the warning")
assert(
	controller:find("function isRisingTextWarningActive()", 1, true)
		and controller:find("localPlayer:GetAttribute(MovementSpeedUtil.IS_IN_DIG_ZONE_ATTRIBUTE) == true", 1, true)
		and controller:find("isRisingForAlivePlayer()", 1, true),
	"TideLabel must remain active throughout rising tide while an alive player is in any dig zone"
)
assert(
	controller:find("if isRisingTextWarningActive() then", 1, true),
	"TideLabel must use its independent text-warning condition"
)
assert(controller:find('FindFirstChild("VignetteFrame")', 1, true), "Rising tide must use the HomeGui vignette frame")
assert(
	controller:find("function TideController:IsRisingProximityWarningActive()", 1, true)
		and controller:find("updateRisingVignette(isProximityWarningActive)", 1, true),
	"The vignette must use the independent proximity-warning condition"
)
assert(
	controller:find("WaterSurfaceUtil.GetWaterSurfaceY()", 1, true)
		and controller:find("SurfaceGeometryUtil.GetTopSurfaceLowestY(mainPart)", 1, true),
	"The tide front must be derived from the live water surface and each zone's top surface"
)
assert(
	controller:find("for zoneIndex = 1, TideConfig.DIG_ZONE_COUNT do", 1, true),
	"Tide warnings must inspect every configured dig zone"
)
assert(
	positionBarController:find("local lowTideZoneId = TideConfig.LOW_TIDE_ZONE_ID", 1, true)
		and positionBarController:find("SurfaceGeometryUtil.GetTopSurfaceLowestY(lowTideZoneMain)", 1, true),
	"The position bar must use the configured low-tide zone as its endpoint"
)
assert(
	footprintController:find("for zoneIndex = 1, TideConfig.DIG_ZONE_COUNT do", 1, true),
	"Footprints must collect surfaces from every configured dig zone"
)
assert(
	controller:find("waterZoneIndex - playerZoneIndex < TideConfig.PROXIMITY_WARNING_ZONE_DISTANCE", 1, true),
	"The proximity warning must start at one or two zones away and remain active after the tide reaches the player"
)
assert(controller:find("isLocalCharacterAlive()", 1, true), "The vignette must stop for dead characters")
assert(
	controller:find("VIGNETTE_PULSE_TWEEN_INFO", 1, true)
		and controller:find("-1, true", 1, true),
	"The vignette must use a repeating yoyo tween"
)
assert(
	controller:find('FindFirstChild("ImageLabel")', 1, true)
		and controller:find("TweenService:Create(image, VIGNETTE_PULSE_TWEEN_INFO", 1, true),
	"The vignette must animate VignetteFrame.ImageLabel rather than its outer container"
)
assert(
	controller:find("ImageTransparency = VIGNETTE_PULSE_DIM_TRANSPARENCY", 1, true),
	"The vignette pulse must animate the image transparency"
)
assert(controller:find("function stopRisingVignette()", 1, true), "The vignette must have a cleanup path")
assert(
	controller:find("localPlayer.CharacterRemoving:Connect(function()", 1, true)
		and controller:find("stopRisingWarning()", 1, true)
		and controller:find("stopRisingVignette()", 1, true)
		and controller:find("setRisingProximityWarningState(false)", 1, true),
	"Both warning effects must clear on respawn"
)
assert(
	controller:find("gateInstance.Transparency = 1", 1, true)
		and controller:find("gateInstance.CanCollide = false", 1, true),
	"Gate must remain permanently hidden and non-collidable"
)
assert(
	controller:find("local function setGateSurfaceGuiVisible", 1, true)
		and controller:find('FindFirstChild("HintFame")', 1, true)
		and controller:find("gateCountdownFrame.Visible = isCountdownVisible", 1, true)
		and controller:find("gateHintFrame.Visible = not isCountdownVisible", 1, true)
		and controller:find("gateSurfaceGui.Enabled = true", 1, true)
		and controller:find("setGateSurfaceGuiVisible(true)", 1, true)
		and controller:find("setGateTimeText", 1, true),
	"Gate countdown Frame and HintFame must toggle exclusively while SurfaceGui stays enabled"
)
assert(
	not controller:find("gateSurfaceGui.Enabled = isVisible", 1, true)
		and not controller:find("gateSurfaceGui.Enabled = isCountdownVisible", 1, true),
	"Gate SurfaceGui must not be disabled when the countdown is hidden"
)
assert(
	not controller:find("now >= gateRevealAt", 1, true)
		and not controller:find("and not isInDigZone", 1, true),
	"Gate SurfaceGui must not wait for a reveal deadline or depend on the player's zone"
)
assert(
	not controller:find("gate.Transparency = if isVisible", 1, true)
		and not controller:find("gate.CanCollide = isVisible", 1, true),
	"SurfaceGui visibility changes must not restore Gate visibility or collision"
)
assert(controller:find("typedSnapshot.revision < currentRevision", 1, true), "Stale snapshots must be ignored")
assert(controller:find('setTopText("Tide paused")', 1, true), "Paused tide must stop the live countdown presentation")
assert(controller:find("and not snapshot.isPaused", 1, true), "Paused rising tides must stop danger effects")

print("TideLifecycle.test.lua passed")
