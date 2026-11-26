local Workspace = game:GetService("Workspace")
local Modules = script.Parent
local BaitMotion = require(Modules.BaitElasticMotion)
local CastPresentation = require(Modules.FishingCastPresentation)
local Config = require(Modules.FishingConfig)
local FishAnimation = require(Modules.FishAnimationController)
local Assets = require(Modules.FishingAssets)
local BiteSequence = require(Modules.FishingBiteSequence)
local FishingCharacterVFX = require(Modules.FishingCharacterVFX)
local FishingCatchTrail = require(Modules.FishingCatchTrail)
local FishingLiftMotion = require(Modules.FishingLiftMotion)
local ObserverState = require(Modules.FishingObserverState)
local RarityVFX = require(Modules.FishingRarityVFX)
local ShowcaseVFX = require(Modules.FishingShowcaseVFX)
local ItemStatUtil = require(Modules.ItemStatUtil)
local MutationVisualUtil = require(Modules.MutationVisualUtil)
local ProjectileMath = require(Modules.FishingProjectileMath)
local RigUtil = require(Modules.FishingRigUtil)
local Visibility = require(Modules.FishingVisibility)
local WaterEffects = require(Modules.FishingWaterEffects)

local FishingObserverVisual = {}
FishingObserverVisual.__index = FishingObserverVisual

local EFFECT_WINDOW = 0.45
local CARRY_ROTATION = CFrame.Angles(0, math.pi / 2, 0)
local FISH_FLIGHT = Config.Bite.ObserverFishLift

local function createLine(folder, tip)
	local endpoint = Instance.new("Part")
	endpoint.Name, endpoint.Size, endpoint.Transparency = "LineEnd", Vector3.one * 0.1, 1
	endpoint.Anchored, endpoint.CanCollide, endpoint.CanTouch, endpoint.CanQuery = true, false, false, false
	endpoint.Parent = folder
	local attachment = Instance.new("Attachment")
	attachment.Parent = endpoint
	local beam = Instance.new("Beam")
	beam.Name, beam.Attachment0, beam.Attachment1 = "FishingLine", tip, attachment
	beam.Width0, beam.Width1 = 0.07, 0.07
	beam.Transparency, beam.FaceCamera, beam.Enabled = NumberSequence.new(0.15), true, false
	beam.Parent = endpoint
	return beam, endpoint
end

function FishingObserverVisual.new(player, character, part, template, rod, animation, specialAnimation)
	local folder = Instance.new("Folder")
	folder.Name = "FishingObserver_" .. player.UserId
	local self = setmetatable({
		folder = folder,
		launch = part.Position,
		visibility = Visibility.new(),
	}, FishingObserverVisual)
	local ok, err = pcall(function()
		local rig = RigUtil.Create(template, character, rod)
		self.rig = rig
		rig.Parent = folder
		self.root = rig.PrimaryPart
		local _, forward, groundY = RigUtil.PlaceAtFishingSpot(rig, part)
		self.forward, self.castGroundY = forward, groundY
		self.rod = assert(rig:FindFirstChild("HeldFishingRod"), "Fishing observer rod is missing")
		local tip = self.rod:FindFirstChild("Top", true)
		assert(tip and tip:IsA("Attachment"), "Fishing observer rod tip is missing")
		self.tip = tip
		self.grip = assert(rig.RightHand:FindFirstChild("RightGripAttachment"), "Fishing observer grip is missing")
		self.shoulder = rig:FindFirstChild("RightShoulder", true)
		self.readyShoulder = self.shoulder and self.shoulder.C0
		self.line, self.endpoint = createLine(folder, self.tip)
		folder.Parent = Workspace
		local humanoid = rig:FindFirstChildOfClass("Humanoid")
		local animator = humanoid:FindFirstChildOfClass("Animator")
		if not animator then
			animator = Instance.new("Animator")
			animator.Parent = humanoid
		end
		CastPresentation.Prepare(self, animator, animation, specialAnimation)
		self.characterVFX = FishingCharacterVFX.new(rig, folder, groundY)
		self.visibility:HideCharacter(character)
	end)
	if not ok then
		self:Destroy()
		error(err, 0)
	end
	return self
end

function FishingObserverVisual:_waterTarget(state, waterY)
	local target = self.launch + self.forward * state.distance
	return Vector3.new(target.X, waterY, target.Z)
end

function FishingObserverVisual:_holdBait(state, elapsed, length)
	local offset, scale = BaitMotion.Sample("Preparing", elapsed)
	local position = self.tip.WorldPosition - Vector3.yAxis * (length - self.baitBaseSize.Y * offset)
	BaitMotion.Apply(self, CFrame.new(position) * CFrame.Angles(0, state.initialYaw, 0), scale)
end

function FishingObserverVisual:_finishCast(now)
	if self.actionStopped then
		return
	end
	self.actionStopped = true
	self.track:Stop(0)
	if self.castVisualLift then
		self.rig:PivotTo(self.rig:GetPivot() - Vector3.yAxis * self.castVisualLift)
	end
	RigUtil.ApplyReadyPose(self.rig)
	self.characterVFX:StopFlight(now)
end

function FishingObserverVisual:ClearFishShadow()
	if self.shadow then
		self.shadow:Destroy()
		self.shadow = nil
	end
	if self.shadowOwner then
		self.shadowOwner.folder:Destroy()
		self.shadowOwner = nil
	end
end

function FishingObserverVisual:_updateFishShadow(round, fishConfig, now, target, spin)
	if not fishConfig or now < round.readyAt or now >= (round.liftAt or round.retryAt or math.huge) then
		self:ClearFishShadow()
		return nil
	end
	if self.shadow and self.shadow.observedRound ~= round then
		self:ClearFishShadow()
	end
	if not self.shadow then
		local template = Assets.GetFish(fishConfig.Model)
		if not template then
			return nil
		end
		local folder = Instance.new("Folder")
		folder.Name, folder.Parent = "FishShadowEffects", self.folder
		self.warnedWaterVFX = self.warnedWaterVFX or {}
		self.shadowOwner = {
			folder = folder,
			forward = self.forward,
			spin = spin,
			baitBaseSize = BaitMotion.BaseSize(self) * Config.BaitFlightScale,
			warnedWaterVFX = self.warnedWaterVFX,
		}
		self.shadow = BiteSequence.newObserver(self.shadowOwner, round, template, fishConfig)
	end
	return self.shadow:UpdateObserver(now, target)
end

function FishingObserverVisual:_cast(state, now, target, fishConfig)
	if not self.castProfile then
		CastPresentation.Select(self, state.castRating)
		if self.castProfile.Id == "Godlike" then
			self.characterVFX:Configure(self.castProfile, self.tip)
		end
	end
	local profile = self.castProfile
	local actionElapsed = now - state.startedAt - profile.LeadTime
	local flightElapsed = actionElapsed - profile.ReleaseTime
	local duration = ProjectileMath.FlightTime(state.distance)
	local heldLength = if profile.Id == "Godlike" then 0.4 else 1.5
	if flightElapsed < duration then
		if
			actionElapsed >= EFFECT_WINDOW
			and not self.actionPlayed
			and self.track.Length == 0
			and self.castTracks.Normal.Length > 0
		then
			self.track, self.specialFallback = self.castTracks.Normal, true
		end
		if actionElapsed >= 0 and not self.actionPlayed and self.track.Length > 0 then
			self.actionPlayed = true
			RigUtil.RestoreReadyPose(self.rig)
			CastPresentation.Play(self)
			local speed = if self.specialFallback
				then Config.CastProfiles.Normal.ReleaseTime / profile.ReleaseTime
				else 1
			self.track.TimePosition = math.min(actionElapsed * speed, self.track.Length)
			if actionElapsed <= EFFECT_WINDOW then
				self.characterVFX:Start(now)
			end
		end
		if self.actionPlayed and actionElapsed < profile.Duration then
			CastPresentation.GroundClearance(self)
		end
		if actionElapsed >= profile.ImpactTime and actionElapsed <= profile.ImpactTime + EFFECT_WINDOW then
			self.characterVFX:BeginSwing(now)
		end
		if flightElapsed < 0 then
			self:_holdBait(state, math.max(0, actionElapsed), heldLength)
			return
		end
		if not self.arc or self.flightTarget ~= target then
			self.releasePosition = self.releasePosition or self.tip.WorldPosition - Vector3.yAxis * heldLength
			self.arc = ProjectileMath.CreateArc(self.releasePosition, target, duration)
			self.flightTarget = target
		end
		local spin = flightElapsed * 7
		local rotation = CFrame.Angles(0, state.initialYaw, 0) * CFrame.Angles(spin * 0.7, spin, spin * 0.3)
		local _, scale = BaitMotion.Sample("Flying", flightElapsed, duration)
		BaitMotion.Apply(
			self,
			CFrame.new(self.arc:PositionAt(flightElapsed)) * rotation,
			scale * BaitMotion.SampleFlightGrowth(flightElapsed / duration)
		)
		return
	end

	self:_finishCast(now)
	local landedFor = flightElapsed - duration
	if landedFor <= EFFECT_WINDOW and not self.splashed then
		self.splashed = true
		WaterEffects.Play(self, now, "WaterVFX", Config.WaterVFX.Entry, target)
	end
	local spin = state.initialYaw + duration * 7
	local shadowBait, shadowBaitScale = self:_updateFishShadow(state.bite, fishConfig, now, target, spin)
	if shadowBait then
		BaitMotion.Apply(self, shadowBait, shadowBaitScale * Config.BaitFlightScale)
		return
	end
	local height = Config.BaitElastic.IdleHeight * math.sin(landedFor * Config.BaitElastic.IdleFrequency)
	BaitMotion.Apply(
		self,
		CFrame.new(target + Vector3.yAxis * height) * CFrame.Angles(0, spin, 0),
		Vector3.one * Config.BaitFlightScale
	)
end

function FishingObserverVisual:_makeCatch(state, config, template)
	local model = template:Clone()
	local isEgg = state.catchKind == "Egg"
	local scale = if isEgg then 1 else ItemStatUtil.GetScaleRatio(config, state.weight, template)
	local bounds = ItemStatUtil.GetModelBounds(template)
	model:ScaleTo(template:GetScale() * scale)
	model.Name = "CaughtFish"
	local trail = if not isEgg then {
		fish = model,
		owner = self,
		scale = scale,
		originals = {},
		mutationId = state.mutationId,
	} else nil
	for _, part in ipairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Anchored, part.CanCollide, part.CanTouch, part.CanQuery = true, false, false, false
			if trail and part.Transparency < 1 and part.Name ~= "CameraPart" then
				trail.originals[part] = true
			end
		elseif part:IsA("BaseScript") then
			part:Destroy()
		end
	end
	self.fish = model
	self.catchTrail = trail
	self.bodyToPivot = model.PrimaryPart.CFrame:ToObjectSpace(model:GetPivot())
	local center = (bounds.minimum + bounds.maximum) * 0.5
	self.belly = Vector3.new(center.X, bounds.minimum.Y, center.Z) * scale
	self.diameter = 2 * bounds.framingRadius * scale
	local highlight = Instance.new("Highlight")
	highlight.Adornee, highlight.FillTransparency = model, 1
	highlight.OutlineColor, highlight.DepthMode = Color3.new(0, 0, 0), Enum.HighlightDepthMode.Occluded
	highlight.Parent = model
	self.highlight = highlight
	if not isEgg then
		MutationVisualUtil.Apply(model, state.mutationId, template.Name)
	end
end

function FishingObserverVisual:_fishCatchPose(target, elapsed, config)
	local carryRotation = self.root.CFrame.Rotation * CARRY_ROTATION
	local bellyOffset = carryRotation:VectorToWorldSpace(self.belly)
	if not self.catchMotion then
		local hand = self.grip.WorldPosition
		local shoulder = self.shoulder
		if shoulder and shoulder.Part0 then
			self.catchShoulderFrom = shoulder.C0
			self.catchShoulderGoal = self.readyShoulder * CFrame.Angles(math.rad(-25), 0, 0)
			-- 抬手时沿用同一条曲线，预先计算最终握点。
			local joint = shoulder.Part0.CFrame
			local handOffset = (joint * self.catchShoulderFrom):PointToObjectSpace(hand)
			hand = (joint * self.catchShoulderGoal):PointToWorldSpace(handOffset)
		end
		local goal = hand - bellyOffset
		local oldOrigin = target + Vector3.yAxis * math.max(0, -self.belly.Y)
		local oldArc = ProjectileMath.CreateArc(oldOrigin, goal, FishingLiftMotion.Timing(Config.Bite, false).duration)
		local initialSpeed = oldArc:VelocityAt(0).Y
		local finalSpeed = oldArc:VelocityAt(oldArc.Duration).Y
		local oldApexTime = oldArc.Duration * math.clamp(initialSpeed / (initialSpeed - finalSpeed), 0, 1)
		local distance = ((goal - target) * Vector3.new(1, 0, 1)).Magnitude
		self.catchGoal = goal
		self.catchUpright = FishingLiftMotion.UprightRotation(self.forward, config.DisplayFacing)
		self.catchMotion = FishingLiftMotion.NewObserver(
			FISH_FLIGHT, target.Y, goal.Y, distance, self.diameter, oldArc:PositionAt(oldApexTime).Y
		)
	end

	local height, progress, turn = FishingLiftMotion.SampleObserver(self.catchMotion, elapsed)
	if self.catchShoulderGoal then
		self.shoulder.C0 = self.catchShoulderFrom:Lerp(self.catchShoulderGoal, turn)
	end
	if elapsed >= FISH_FLIGHT.Duration then
		return self.grip.WorldPosition - bellyOffset, carryRotation
	end
	local position = target:Lerp(self.catchGoal, progress)
	local rotation = if elapsed < FISH_FLIGHT.RiseTime
		then FishingLiftMotion.RiseRotation(self.catchUpright, elapsed / FISH_FLIGHT.RiseTime, Config.Bite.LiftSpinTurns)
		else self.catchUpright:Lerp(carryRotation, turn)
	return Vector3.new(position.X, height, position.Z), rotation
end

function FishingObserverVisual:_catch(state, now, target, config, template)
	self:_finishCast(now)
	self.line.Enabled = false
	if self.baitVisual then
		self.baitVisual:Destroy()
		self.baitVisual = nil
	end
	if not self.fish then
		self:_makeCatch(state, config, template)
	end

	local elapsed = now - state.startedAt
	local isEgg = state.catchKind == "Egg"
	local duration = if isEgg then FishingLiftMotion.Timing(Config.Bite, true).duration else FISH_FLIGHT.Duration
	local landed = elapsed >= duration
	local position, rotation
	if isEgg then
		local alpha = math.clamp(elapsed / duration, 0, 1)
		local grip = CFrame.new(self.grip.WorldPosition) * self.root.CFrame.Rotation * CARRY_ROTATION
		local goal = grip * CFrame.new(-self.belly)
		local origin = target + Vector3.yAxis * math.max(0, -self.belly.Y)
		position = ProjectileMath.CreateArc(origin, goal.Position, duration):PositionAt(elapsed)
		rotation = CFrame.lookAt(Vector3.zero, self.forward).Rotation:Lerp(goal.Rotation, alpha)
		if self.shoulder then
			self.shoulder.C0 = self.readyShoulder * CFrame.Angles(math.rad(-25) * alpha, 0, 0)
		end
	else
		position, rotation = self:_fishCatchPose(target, elapsed, config)
	end
	self.fish:PivotTo(CFrame.new(position) * rotation * self.bodyToPivot)
	if not self.fish.Parent then
		self.fish.Parent = self.folder
		if not isEgg then
			self.fishAnimation = FishAnimation.new(self.fish, now)
		end
	end
	if self.fishAnimation then
		local animationPhase = if landed then "Caught" else "Lifting"
		local phaseStarted = if landed then state.startedAt + duration else state.startedAt
		self.fishAnimation:Update(animationPhase, phaseStarted, now, nil, nil, nil, nil, duration)
	end
	if self.catchTrail then
		local rising = elapsed >= 0 and elapsed < FISH_FLIGHT.RiseTime
		FishingCatchTrail.Update(self.catchTrail, now, rising, self.fish.PrimaryPart.Position.Y >= target.Y)
	end
	if elapsed >= 0 and not self.catchExitPlayed then
		self.catchExitPlayed = true
		if elapsed <= EFFECT_WINDOW then
			WaterEffects.Play(
				self,
				now,
				"WaterVFX",
				Config.WaterVFX.Exit,
				target,
				nil,
				math.clamp(self.diameter / 12, 1, 3)
			)
			if not isEgg then
				self.exitEffect = RarityVFX.Play(self, now, position, config.Rarity, self.diameter, "Exit")
			end
		end
	end
	if landed and not self.catchLanded then
		self.catchLanded = true
		self.rod.Parent = nil
		if not isEgg and elapsed <= duration + EFFECT_WINDOW then
			self.catchRarity = RarityVFX.Play(self, now, position, config.Rarity, self.diameter, "Showcase")
			self.showcase = ShowcaseVFX.new({
				owner = self,
				fish = self.fish,
				highlight = self.highlight,
				fishConfig = config,
				mutationId = state.mutationId,
				isNewDiscovery = state.isNewDiscovery,
			}, now, true)
		end
	end
	if self.exitEffect and not self.exitEffect:Update(now, position, self.diameter) then
		self.exitEffect = nil
	end
	if self.catchRarity and not self.catchRarity:Update(now, position, self.diameter) then
		self.catchRarity = nil
	end
	if self.showcase and not self.showcase:Update(now) then
		self.showcase = nil
	end
end

function FishingObserverVisual:_emptyReel(state, now, target)
	self:_finishCast(now)
	if self.baitVisual then
		self.baitVisual:Destroy()
		self.baitVisual = nil
	end
	local alpha = math.clamp((now - state.startedAt) / ObserverState.EmptyReelDuration, 0, 1)
	if self.shoulder then
		self.shoulder.C0 = self.readyShoulder * CFrame.Angles(math.rad(-35) * math.sin(alpha * math.pi), 0, 0)
	end
	local tip = self.tip.WorldPosition
	self.line.Enabled = alpha < 1
	self.endpoint.Position = target:Lerp(tip, alpha * (2 - alpha)) + Vector3.yAxis * (4 * math.sin(alpha * math.pi))
end

local function updateWaterEffects(owner, now)
	for index = #(owner.waterVFX or {}), 1, -1 do
		local effect = owner.waterVFX[index]
		if now >= effect.expiresAt then
			effect.model:Destroy()
			table.remove(owner.waterVFX, index)
		else
			WaterEffects.Update(effect, now)
		end
	end
end

function FishingObserverVisual:Update(state, now, waterY, asset, catchConfig, shadowConfig)
	if state.phase ~= "Cast" or not shadowConfig then
		self:ClearFishShadow()
	end
	if state.phase == "Selecting" then
		return
	end
	if state.phase == "Preparing" or state.phase == "Cast" then
		if not self.baitVisual then
			self.baitVisual = BaitMotion.CloneVisual(self, asset)
		end
		if state.phase == "Preparing" then
			self:_holdBait(state, math.max(0, now - state.startedAt), 1.5)
		else
			self:_cast(state, now, self:_waterTarget(state, waterY), shadowConfig)
		end
		if not self.baitVisual.Parent then
			self.baitVisual.Parent = self.folder
		end
		self.endpoint.Position = if self.baitTop then self.baitTop.WorldPosition else self.bait.Position
		self.line.Enabled = true
	elseif state.phase == "Catch" then
		self:_catch(state, now, self:_waterTarget(state, waterY), catchConfig, asset)
	elseif state.phase == "EmptyReel" then
		self:_emptyReel(state, now, self:_waterTarget(state, waterY))
	end
	self.characterVFX:Update(now)
	updateWaterEffects(self, now)
	if self.shadowOwner then
		updateWaterEffects(self.shadowOwner, now)
	end
end

function FishingObserverVisual:Destroy()
	self:ClearFishShadow()
	CastPresentation.Destroy(self)
	if self.catchTrail then
		FishingCatchTrail.Destroy(self.catchTrail)
		self.catchTrail = nil
	end
	if self.fishAnimation then
		self.fishAnimation:Destroy()
	end
	if self.characterVFX then
		self.characterVFX:Destroy()
	end
	self.visibility:Destroy()
	-- The held rod can be detached once the catch is in hand.
	if self.rod then
		self.rod:Destroy()
	end
	if self.fish then
		self.fish:Destroy()
	end
	if self.baitVisual then
		self.baitVisual:Destroy()
	end
	self.folder:Destroy()
end

return FishingObserverVisual
