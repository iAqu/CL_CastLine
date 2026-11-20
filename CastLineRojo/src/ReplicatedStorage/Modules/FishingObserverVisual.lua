local Workspace = game:GetService("Workspace")
local Modules = script.Parent
local BaitMotion = require(Modules.BaitElasticMotion)
local CastPresentation = require(Modules.FishingCastPresentation)
local Config = require(Modules.FishingConfig)
local FishAnimation = require(Modules.FishAnimationController)
local FishingCharacterVFX = require(Modules.FishingCharacterVFX)
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
		self.characterVFX = FishingCharacterVFX.new(rig, folder)
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

function FishingObserverVisual:_cast(state, now, target)
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
	local height = Config.BaitElastic.IdleHeight * math.sin(landedFor * Config.BaitElastic.IdleFrequency)
	BaitMotion.Apply(
		self,
		CFrame.new(target + Vector3.yAxis * height) * CFrame.Angles(0, state.initialYaw + duration * 7, 0),
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
	for _, part in ipairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Anchored, part.CanCollide, part.CanTouch, part.CanQuery = true, false, false, false
		elseif part:IsA("BaseScript") then
			part:Destroy()
		end
	end
	self.fish = model
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
	local duration = FishingLiftMotion.Timing(Config.Bite, isEgg).duration
	local alpha = math.clamp(elapsed / duration, 0, 1)
	local grip = CFrame.new(self.grip.WorldPosition) * self.root.CFrame.Rotation * CARRY_ROTATION
	local goal = grip * CFrame.new(-self.belly)
	local origin = target + Vector3.yAxis * math.max(0, -self.belly.Y)
	local arc = ProjectileMath.CreateArc(origin, goal.Position, duration)
	local position = arc:PositionAt(elapsed)
	local rotation = CFrame.lookAt(Vector3.zero, self.forward).Rotation:Lerp(goal.Rotation, alpha)
	if self.shoulder then
		self.shoulder.C0 = self.readyShoulder * CFrame.Angles(math.rad(-25) * alpha, 0, 0)
	end
	self.fish:PivotTo(CFrame.new(position) * rotation * self.bodyToPivot)
	if not self.fish.Parent then
		self.fish.Parent = self.folder
		if not isEgg then
			self.fishAnimation = FishAnimation.new(self.fish, now)
		end
	end
	if self.fishAnimation then
		local animationPhase = if alpha < 1 then "Lifting" else "Caught"
		local phaseStarted = if alpha < 1 then state.startedAt else state.startedAt + duration
		self.fishAnimation:Update(animationPhase, phaseStarted, now, nil, nil, nil, nil, duration)
	end
	if elapsed <= EFFECT_WINDOW and not self.catchExitPlayed then
		self.catchExitPlayed = true
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
	if alpha >= 1 and not self.catchLanded then
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

function FishingObserverVisual:Update(state, now, waterY, asset, catchConfig)
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
			self:_cast(state, now, self:_waterTarget(state, waterY))
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
	for index = #(self.waterVFX or {}), 1, -1 do
		local effect = self.waterVFX[index]
		if now >= effect.expiresAt then
			effect.model:Destroy()
			table.remove(self.waterVFX, index)
		else
			WaterEffects.Update(effect, now)
		end
	end
end

function FishingObserverVisual:Destroy()
	CastPresentation.Destroy(self)
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
