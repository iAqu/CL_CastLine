-- Studio Client: diagonal POV, held bite, and synchronized size-based orbit.
local storage = game:GetService("ReplicatedStorage")
local modules = storage.Modules
local Bite = require(modules.FishingBiteSequence)
local Cast = require(modules.FishingCastSequence)
local Config = require(modules.FishingConfig)
local folder = Instance.new("Folder")
folder.Name, folder.Parent = "FishingRiseApproachValidation", workspace
local active, observer, wall

local function center(view, worldPoint)
	local point = view.CFrame:PointToObjectSpace(worldPoint)
	assert(point.Z < 0, "Point behind the camera")
	local halfHeight = -point.Z * math.tan(math.rad(view.FieldOfView * 0.5))
	return Vector2.new(point.X / (halfHeight * view.ViewportSize.X / view.ViewportSize.Y), point.Y / halfHeight)
end

local ok, result = xpcall(function()
	local settings = Config.DeepCatch
	local target = Vector3.new(0, 1000, 0)
	local surface = target + Vector3.yAxis * Config.Landing.FishingDepth
	local forward = Vector3.zAxis
	local right = forward:Cross(Vector3.yAxis)
	local biteAt = 100 + settings.EntranceTime
	local hookAt = biteAt + 0.65
	local landingPitch = math.rad(70)
	local landingRay = -Vector3.zAxis * math.cos(landingPitch) + Vector3.yAxis * math.sin(landingPitch)
	local incoming = CFrame.lookAt(surface + landingRay * 17, surface)
	local landingFov = 72
	local speedTemplate = storage.Particle.SpeedBoost.WindStreaks.Attachment.ParticleEmitter
	local speedTemplateRate = speedTemplate.Rate
	local orbitSamples, approachCases, diveSamples = 0, 0, 0
	local maxRadiusError, maxContactError = 0, 0
	for _, name in { "GreenSeahorse", "ElderFish", "MechaWhale" } do
		local template = storage.Models.Fish[name]
		local bodySize = template:GetAttribute("FishBodySize") or template.PrimaryPart.Size
		local length = if name == "MechaWhale" then 42 elseif name == "ElderFish" then 10 else 2
		local fishConfig = {
			DefaultWeight = 1,
			ModelDefaultScale = length / bodySize.Z,
		}
		for _, seed in { 4, 5 } do
			for _, viewport in { Vector2.new(1600, 900), Vector2.new(900, 1600) } do
				local bait = storage.Models.FishBait["1"]["1"]:Clone()
				bait.Anchored, bait.Parent = true, folder
				local highlight = Instance.new("Highlight")
				highlight.Adornee, highlight.OutlineColor = bait, Color3.new(1, 1, 1)
				highlight.DepthMode, highlight.Parent = Enum.HighlightDepthMode.AlwaysOnTop, bait
				local cues = 0
				local owner = setmetatable({
					folder = folder, forward = forward, bait = bait, fishingDepth = Config.Landing.FishingDepth,
					spin = math.rad(28),
					baitHighlight = highlight, baitAppearance = { [bait] = bait.Transparency },
					waitingBaitFill = Color3.fromRGB(125, 225, 236), bitingBaitFill = Color3.new(1, 0, 0),
					root = { CFrame = CFrame.identity }, continueLabel = {}, impulses = {},
					cameraFrame = incoming, cameraFov = landingFov, cameraFocus = surface,
					shotMode = "Landing", shotStarted = 98.3, shotDuration = 0.4, shotFrom = incoming, fovFrom = landingFov,
					landedAt = 98.3, shotFocusFrom = surface,
					_waterTarget = function() return surface end,
					_waterFeedback = function() end,
					_nibbleRipple = function() end, _nibbleFeedback = function() end, _sound = function() end,
					_playWaterVFX = function(_, _, effectName)
						if effectName == Config.WaterVFX.Heavy then
							cues += 1
						end
					end,
					_setPhase = function() end,
				}, Cast)
				local view = { ViewportSize = viewport }
				owner:_lockLandingView(owner.landedAt)
				local receiptAt = owner.landedAt + (if seed == 4 then 0.2 else 1.55)
				local previousY = math.huge
				local aligned = false
				for index = 0, 101 do
					local now = owner.landedAt + (100 - owner.landedAt) * (index / 102)
					if now >= receiptAt and not aligned then
						local before = owner:_diveOffset(now)
						owner:_alignLandingDive(now, 100)
						assert(math.abs(owner:_diveOffset(now) - before) < 1e-6, "Round receipt jumped depth")
						aligned = true
					end
					owner:_updateCamera(now, 1 / 60, view)
					local at = owner:_landingPosition(now, surface)
					assert(view.CFrame.Rotation:FuzzyEq(incoming.Rotation, 0.0001) and view.FieldOfView == landingFov,
						"Landing view tilted or zoomed during descent")
					assert((view.CFrame.Position - at - landingRay * 17).Magnitude < 0.001,
						"Camera did not translate with the bait")
					assert(at.Y <= previousY + 0.001 and not owner.deepCatchSpeedLines,
						"Descent reversed or showed speed lines before the POV")
					previousY = at.Y
					diveSamples += 1
				end
				assert(aligned and math.abs(owner:_diveOffset(100) + Config.Landing.FishingDepth) < 1e-6,
					"Descent did not arrive at the POV deadline")
				active = Bite.new(owner, 100, 100, Random.new(seed), Random.new(11), template, fishConfig, "Fish", false, 1)
				owner.bite = active
				active:SetDeepCatch("Rise", biteAt, seed)
				observer = Bite.newObserver({ folder = folder, forward = forward, baitBaseSize = owner.baitBaseSize, spin = owner.spin }, {
					round = 1, seed = seed, motionSeed = 11, scale = active.scale,
					entrance = "Rise", startedAt = 100, readyAt = 100, biteAt = biteAt,
				}, template, fishConfig)
				local sign = if seed % 2 == 0 then -1 else 1
				assert(active.spawnDirection == observer.spawnDirection and active.spawnDirection:Dot(right) == sign,
					"Observer and player did not select the same sway direction")
				previousY = -math.huge
				local rollChanges, previousSign = 0, 0
				local effect
				for index = 0, 96 do
					local elapsed = (settings.EntranceTime - 0.001) * index / 96
					local now = 100 + elapsed
					assert(active:Update(now, true) == "Approaching", "First bite triggered early")
					owner:_updateCamera(now, 1 / 60, view)
					active:Present(view.CFrame.Position)
					local mouth = active.lastMouthPosition
					assert(mouth.Y > previousY and mouth.Y < target.Y, "Mouth did not rise from below the bait")
					previousY = mouth.Y
					local _, observerMouth = observer:GetDeepCatchApproach(target, elapsed)
					assert((mouth - observerMouth).Magnitude < 0.002, "Observer sampled a different approach")
					assert(view.CFrame.LookVector.Y > 0.58 and view.CFrame.LookVector.Y < 0.84
						and view.FieldOfView >= 64 and view.FieldOfView <= 76, "First person lost the diagonal trajectory")
					assert(center(view, target).Magnitude < 0.001, "POV lost the bait")
					assert(highlight.Enabled and highlight.OutlineTransparency == 0
						and highlight.OutlineColor == Color3.new(1, 1, 1), "POV lost the bait outline")
					effect = effect or owner.deepCatchSpeedLines
					assert(effect and owner.deepCatchSpeedLines == effect and effect.Parent == folder,
						"POV did not reuse one speed-line clone")
					local emitter = effect.Attachment.ParticleEmitter
					assert(emitter.Enabled and emitter.LockedToPart and emitter.Texture == speedTemplate.Texture
						and emitter.Rate == speedTemplateRate,
						"POV did not use the existing screen effect")
					local offset = view.CFrame:PointToObjectSpace(effect.Position)
					assert((offset - Vector3.new(0, 0, -8)).Magnitude < 0.002
						and effect.CFrame.Rotation:FuzzyEq(view.CFrame.Rotation, 0.0001), "Speed lines lost the screen plane")
					local height = 2 * 8 * math.tan(math.rad(view.FieldOfView / 2)) * 1.25
					local size = Vector3.new(height * viewport.X / viewport.Y, height, speedTemplate.Parent.Parent.Size.Z)
					assert((effect.Size - size).Magnitude < 0.001, "Screen plane missed the viewport or FOV change")
					local neutral = CFrame.lookAt(view.CFrame.Position, target)
					local rolled = view.CFrame.UpVector:Dot(neutral.RightVector)
					assert(math.abs(rolled) <= math.sin(math.rad(5)) + 0.001, "POV sway exceeded five degrees")
					if math.abs(rolled) > 0.001 then
						local rollSign = math.sign(rolled)
						if previousSign ~= 0 and previousSign ~= rollSign then
							rollChanges += 1
						end
						previousSign = rollSign
					end
				end
				assert(rollChanges == 7, "Expected four first-person sway cycles")
				local beforeBite = active.lastMouthPosition
				assert(active:Update(biteAt, true) == "Bite", "First bite did not hold the bait")
				assert(active.timeline.completedNibbles == 0 and cues == 1, "Fake or duplicate bite")
				local contact = active.lastMouthPosition
				assert(contact.Y < target.Y and (contact - beforeBite).Magnitude < 0.08, "The mouth jumped on contact")
				owner:_updateCamera(biteAt, 1 / 60, view)
				active:Present(view.CFrame.Position)
				local localContact = bait.CFrame:PointToObjectSpace(contact) / (bait.Size * 0.5)
				local surfaceDistance = math.max(math.abs(localContact.X), math.abs(localContact.Y), math.abs(localContact.Z))
				assert(math.abs(surfaceDistance - 1) < 0.002, "Diagonal bite missed the bait surface")
				assert(view.CFrame.LookVector.Y < 0 and owner.cameraFrame:FuzzyEq(owner.struggleView.frame, 0.0001),
					"Contact did not cut straight to the overhead view")
				assert(view.FieldOfView == landingFov and owner.cameraFrame.Rotation:FuzzyEq(incoming.Rotation, 0.0001)
					and (owner.cameraFrame.Position - target - landingRay * 20).Magnitude < 0.001,
					"Struggle view did not pull back three studs along the landing ray")
				assert(owner.deepCatchSpeedLines == nil and effect.Parent == nil, "Speed lines survived the cut")
				assert((bait.Position - target).Magnitude < 0.002, "The bait snapped at contact")
				local biteFrame = active.displayFrame
				local trembled = false
				for index = 1, 39 do
					local now = biteAt + index / 60
					assert(active:Update(now, true) == "Bite", "Fish rotated before input")
					owner:_updateCamera(now, 1 / 60, view)
					active:Present(view.CFrame.Position)
					local observerBait = observer:UpdateObserver(now, target)
					assert(observer.timeline.phase == "Bite" and (observerBait.Position - bait.Position).Magnitude < 0.002,
						"Observer started the orbit before the tap")
					assert((active.lastMouthPosition - contact).Magnitude < 0.002, "Held fish slipped off the bait")
					assert(owner.cameraFrame:FuzzyEq(owner.struggleView.frame, 0.0001), "Camera followed the held fish")
					trembled = trembled or not active.displayFrame.Rotation:FuzzyEq(biteFrame.Rotation, 0.001)
				end
				assert(trembled, "Held fish did not tremble")
				local anchor = owner.struggleView.frame
				assert(active:TryHook(hookAt, nil, true), "First tap did not start the struggle")
				assert(not active:TryHook(hookAt + 0.01, nil, true), "Duplicate click restarted the struggle")
				observer.observedRound.hookedAt = hookAt
				local expectedRadius = math.clamp(active.halfLength * active.scale, 2, 8)
				assert(math.abs(expectedRadius - (if name == "MechaWhale" then 8 elseif name == "ElderFish" then 5 else 2)) < 0.002,
					"Fixture did not exercise the desired radius for " .. name)
				local maxTurn = 0
				for index = 1, 120 do
					local elapsed = index / 60
					local now = hookAt + elapsed
					assert(active:Update(now, true) == "Struggling", "The catch left struggle before confirmation")
					owner:_updateCamera(now, 1 / 60, view)
					active:Present(view.CFrame.Position)
					if elapsed > Config.Camera.Struggle.EntryBlendTime then
						local mouth = active.displayFrame:PointToWorldSpace(active.mouthOffset * active.scale)
						local edge = bait.CFrame:PointToWorldSpace(Vector3.xAxis * (bait.Size.X * 0.5))
						maxRadiusError = math.max(maxRadiusError, math.abs((mouth - target).Magnitude - expectedRadius))
						maxContactError = math.max(maxContactError, (mouth - edge).Magnitude)
						assert(math.abs(mouth.Y - target.Y) < 0.002, "Mouth drifted vertically during the orbit")
						assert((owner.cameraFrame.Position - anchor.Position).Magnitude < 0.001, "Camera translated with the orbit")
						assert(math.abs(owner.cameraFrame.LookVector.Y - incoming.LookVector.Y) < 0.0001,
							"Yaw tracking changed the landing pitch")
						local _, turn = anchor.Rotation:ToObjectSpace(owner.cameraFrame.Rotation):ToAxisAngle()
						maxTurn = math.max(maxTurn, math.deg(turn))
						orbitSamples += 1
					end
				end
				assert(maxTurn > 0.25 and maxTurn <= Config.Camera.Struggle.FollowDegrees + 0.01, "Camera following exceeded its limit")
				local observerBait = observer:UpdateObserver(hookAt + 1, target)
				local _, playerBait = active:_basePose("Struggling", 1, target)
				assert((observerBait.Position - playerBait).Magnitude < 0.002, "Observer disagreed about the orbit")
				assert(cues == 1, "The true bite replayed")
				observer:Destroy()
				active:Destroy()
				bait:Destroy()
				observer, active = nil, nil
				approachCases += 1
				task.wait()
			end
		end
	end
	local wide = { ViewportSize = Vector2.new(1600, 900) }
	local settingsStruggle = Config.Camera.Struggle
	local probe = setmetatable({
		folder = folder, forward = forward, bait = { Position = target }, fishingDepth = Config.Landing.FishingDepth,
		root = { CFrame = CFrame.identity }, shotMode = "Landing", shotStarted = 99, shotDuration = 0,
		landingView = { rotation = incoming.Rotation, distance = 23, fov = landingFov },
		bite = { timeline = { phase = "Struggling", deepCatch = true, startedAt = hookAt } },
		_waterTarget = function() return surface end,
		_sampleImpulses = function() return 10, -10, 1, 1, 1, 8 end,
	}, Cast)
	probe:_updateCamera(hookAt, 1 / 60, wide)
	assert(math.abs((probe.cameraFrame.Position - target).Magnitude - (24 - settingsStruggle.MaxShakeOffset)) < 0.001,
		"Maximum range did not reserve space for shake")
	assert((wide.CFrame.Position - target).Magnitude <= 24.001, "Rendered camera exceeded maximum range")
	wall = Instance.new("Part")
	wall.Name, wall.Anchored, wall.Size = "DeepStruggleWall", true, Vector3.new(36, 36, 0.5)
	wall.CFrame = CFrame.new(target + landingRay * 9) * incoming.Rotation
	wall.Parent = workspace
	probe.struggleView = nil
	probe:_updateCamera(hookAt + 0.02, 1 / 60, wide)
	assert((wide.CFrame.Position - target):Dot(landingRay) < 8.7, "Rendered camera crossed the wall")
	assert(probe.cameraFrame.Rotation:FuzzyEq(incoming.Rotation, 0.0001)
		and (probe.cameraFrame.Position - target).Unit:Dot(landingRay) > 0.9999,
		"Wall protection changed the shared angle")
	local cancelFolder = Instance.new("Folder")
	cancelFolder.Parent = folder
	local cancelled = setmetatable({ folder = cancelFolder }, Cast)
	cancelled:_updateDeepCatchSpeedLines({ CFrame = incoming, FieldOfView = landingFov, ViewportSize = Vector2.new(900, 1600) })
	local cancelledEffect = assert(cancelled.deepCatchSpeedLines, "Cancel fixture did not start the effect")
	cancelled:Destroy()
	assert(cancelled.deepCatchSpeedLines == nil and cancelledEffect.Parent == nil, "Speed lines survived cancellation")
	assert(speedTemplate.Rate == speedTemplateRate, "POV modified the shared template")
	assert(maxRadiusError < 0.002 and maxContactError < 0.002, "Shared orbit or attachment drifted")
	return { cases = approachCases, diveSamples = diveSamples, orbitSamples = orbitSamples,
		radiusError = maxRadiusError, contactError = maxContactError }
end, debug.traceback)
if active then
	active:Destroy()
end
if observer then
	observer:Destroy()
end
if wall then
	wall:Destroy()
end
folder:Destroy()
assert(ok, result)
return result
