-- Studio Client: diagonal POV, held bite, and synchronized size-based orbit.
local storage = game:GetService("ReplicatedStorage")
local modules = storage.Modules
local Bite = require(modules.FishingBiteSequence)
local Cast = require(modules.FishingCastSequence)
local Config = require(modules.FishingConfig)
local folder = Instance.new("Folder")
folder.Name, folder.Parent = "FishingRiseApproachValidation", workspace
local active, observer

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
	local incoming = CFrame.lookAt(target - forward * 12 + Vector3.yAxis * 8, target)
	local speedTemplate = storage.Particle.SpeedBoost.WindStreaks.Attachment.ParticleEmitter
	local speedTemplateRate = speedTemplate.Rate
	local orbitSamples, approachCases = 0, 0
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
					cameraFrame = incoming, cameraFov = 60, cameraFocus = target,
					shotMode = "Landing", shotStarted = 99, shotDuration = 0, shotFrom = incoming, fovFrom = 60,
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
				local view = { ViewportSize = viewport }
				local previousY, rollChanges, previousSign = -math.huge, 0, 0
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
					assert(emitter.Enabled and emitter.LockedToPart and emitter.Texture == speedTemplate.Texture,
						"POV did not use the existing screen effect")
					local offset = view.CFrame:PointToObjectSpace(effect.Position)
					assert((offset - Vector3.new(0, 0, -5)).Magnitude < 0.002, "Speed lines stopped following the POV")
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
	local cancelFolder = Instance.new("Folder")
	cancelFolder.Parent = folder
	local cancelled = setmetatable({ folder = cancelFolder }, Cast)
	cancelled:_updateDeepCatchSpeedLines(incoming)
	local cancelledEffect = assert(cancelled.deepCatchSpeedLines, "Cancel fixture did not start the effect")
	cancelled:Destroy()
	assert(cancelled.deepCatchSpeedLines == nil and cancelledEffect.Parent == nil, "Speed lines survived cancellation")
	assert(speedTemplate.Rate == speedTemplateRate, "POV modified the shared template")
	assert(maxRadiusError < 0.002 and maxContactError < 0.002, "Shared orbit or attachment drifted")
	return { cases = approachCases, orbitSamples = orbitSamples, radiusError = maxRadiusError, contactError = maxContactError }
end, debug.traceback)
if active then
	active:Destroy()
end
if observer then
	observer:Destroy()
end
folder:Destroy()
assert(ok, result)
return result
