local TweenService = game:GetService("TweenService")

local DigSilhouetteUtil = {}

export type SilhouetteSession = {
	model: Model,
	buriedCFrame: CFrame,
	emergedCFrame: CFrame,
	sourceRotation: CFrame,
	upVector: Vector3,
	maxHalf: number,
	kickStartedAt: number,
	kickDepth: number,
	Destroy: (self: SilhouetteSession) -> (),
	SetProgress: (self: SilhouetteSession, progress: number) -> (),
	Kick: (self: SilhouetteSession, strength: number) -> (),
	Reveal: (
		self: SilhouetteSession,
		outlineColor: Color3?,
		outlineTransparency: number?,
		alwaysOnTop: boolean?
	) -> Model,
}

local PROGRESS_POWER = 1.25
local KICK_DURATION = 0.28
local KICK_DIP_RATIO = 0.35
local REVEAL_FILL_DURATION = 0.4

local function sampleKickDip(elapsed: number, depth: number): number
	if elapsed <= 0 or elapsed >= KICK_DURATION or depth <= 0 then
		return 0
	end

	local alpha = elapsed / KICK_DURATION
	if alpha < KICK_DIP_RATIO then
		local t = TweenService:GetValue(alpha / KICK_DIP_RATIO, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		return depth * t
	end

	local t = TweenService:GetValue(
		(alpha - KICK_DIP_RATIO) / (1 - KICK_DIP_RATIO),
		Enum.EasingStyle.Back,
		Enum.EasingDirection.Out
	)
	return depth * (1 - t)
end

local function stripNonVisual(model: Model)
	for _, descendant in model:GetDescendants() do
		if descendant:IsA("BaseScript")
			or descendant:IsA("ProximityPrompt")
			or descendant:IsA("Highlight")
			or descendant:IsA("BillboardGui")
			or descendant.Name == "DigAnchor"
		then
			descendant:Destroy()
		end
	end
end

local function prepareVisualClone(sourceModel: Model): Model
	local clone = sourceModel:Clone()
	local authoredPivot = clone:GetPivot()
	stripNonVisual(clone)

	if not clone.PrimaryPart then
		local primaryPart = clone:FindFirstChildWhichIsA("BasePart", true)
		if primaryPart then
			primaryPart.PivotOffset = primaryPart.CFrame:ToObjectSpace(authoredPivot)
			clone.PrimaryPart = primaryPart
		end
	end

	for _, descendant in clone:GetDescendants() do
		if descendant:IsA("BasePart") then
			descendant.Anchored = true
			descendant.CanCollide = false
			descendant.CanQuery = false
			descendant.CanTouch = false
		elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Light") or descendant:IsA("Beam") then
			descendant.Enabled = false
		end
	end

	return clone
end

local function createSilhouetteHighlight(model: Model): Highlight
	local highlight = Instance.new("Highlight")
	highlight.Name = "DigSilhouetteHighlight"
	highlight.FillColor = Color3.new(0, 0, 0)
	highlight.OutlineColor = Color3.new(1, 1, 1)
	highlight.FillTransparency = 0
	highlight.OutlineTransparency = 0
	highlight.DepthMode = Enum.HighlightDepthMode.Occluded
	highlight.Adornee = model
	highlight.Parent = model
	return highlight
end

local function pivotToBoundingBoxCenter(clone: Model): Vector3
	local bboxCFrame, size = clone:GetBoundingBox()
	local primaryPart = clone.PrimaryPart
	if primaryPart then
		primaryPart.PivotOffset = primaryPart.PivotOffset
			* CFrame.new(clone:GetPivot():ToObjectSpace(bboxCFrame).Position)
	end
	return size
end

-- DigClean CFrameUtils.emergeOrientation：长轴对齐到略歪的上方向。
local function emergeOrientation(upVector: Vector3, size: Vector3): CFrame
	local tilt = math.rad(6 + math.random() * 14)
	local spin = math.random() * math.pi * 2
	local tangentSeed = Vector3.new(math.cos(spin), 0, math.sin(spin))
	local tangent = tangentSeed - upVector * tangentSeed:Dot(upVector)
	if tangent.Magnitude < 0.01 then
		tangent = Vector3.new(1, 0, 0) - upVector * Vector3.new(1, 0, 0):Dot(upVector)
	end

	local tiltedUp = (upVector * math.cos(tilt) + tangent.Unit * math.sin(tilt)).Unit
	local yaw = math.random() * math.pi * 2
	local yawSeed = Vector3.new(math.cos(yaw), 0, math.sin(yaw))
	local right = yawSeed - tiltedUp * yawSeed:Dot(tiltedUp)
	if right.Magnitude < 0.01 then
		right = tiltedUp:Cross(Vector3.new(1, 0, 0))
	end

	local orientation = CFrame.fromMatrix(Vector3.zero, right.Unit, tiltedUp, right.Unit:Cross(tiltedUp))
	if size.X >= size.Y and size.X >= size.Z then
		return orientation * CFrame.Angles(0, 0, math.pi / 2)
	end
	if size.Z >= size.Y and size.Z >= size.X then
		return orientation * CFrame.Angles(-math.pi / 2, 0, 0)
	end
	return orientation
end

local function computeBuriedFrames(
	clone: Model,
	surfacePosition: Vector3,
	upVector: Vector3
): (CFrame, CFrame, number)
	local size = pivotToBoundingBoxCenter(clone)
	local up = if upVector.Magnitude > 0.001 then upVector.Unit else Vector3.yAxis
	local orientation = emergeOrientation(up, size)
	local maxHalf = math.max(size.X, size.Y, size.Z) * 0.5
	local extra = math.max(0.4, (size.X + size.Y + size.Z) / 3 * 0.08)
	local buriedPosition = surfacePosition - up * (maxHalf + extra)
	local emergedPosition = surfacePosition + up * (maxHalf * 0.6)
	return CFrame.new(buriedPosition) * orientation, CFrame.new(emergedPosition) * orientation, maxHalf
end

function DigSilhouetteUtil.Create(
	sourceModel: Model,
	surfacePosition: Vector3,
	upVector: Vector3?
): SilhouetteSession?
	local clone = prepareVisualClone(sourceModel)
	if not clone.PrimaryPart then
		clone:Destroy()
		return nil
	end

	local up = upVector or Vector3.yAxis
	local sourcePivot = sourceModel:GetPivot()
	local sourceRotation = sourcePivot - sourcePivot.Position
	local buriedCFrame, emergedCFrame, maxHalf = computeBuriedFrames(clone, surfacePosition, up)
	clone:PivotTo(buriedCFrame)

	local highlight = createSilhouetteHighlight(clone)

	local session = {
		model = clone,
		buriedCFrame = buriedCFrame,
		emergedCFrame = emergedCFrame,
		sourceRotation = sourceRotation,
		upVector = if up.Magnitude > 0.001 then up.Unit else Vector3.yAxis,
		maxHalf = maxHalf,
		kickStartedAt = 0,
		kickDepth = 0,
		_highlight = highlight,
		_revealTween = nil :: Tween?,
	} :: SilhouetteSession & { _highlight: Highlight, _revealTween: Tween? }

	function session:SetProgress(progress: number)
		local normalized = math.clamp(progress, 0, 1)
		local eased = normalized ^ PROGRESS_POWER
		local baseCFrame = self.buriedCFrame:Lerp(self.emergedCFrame, eased)
		local dip = 0
		if self.kickStartedAt > 0 then
			dip = sampleKickDip(os.clock() - self.kickStartedAt, self.kickDepth)
		end
		self.model:PivotTo(baseCFrame - self.upVector * dip)
	end

	function session:Kick(strength: number)
		local scale = math.clamp(strength, 0.2, 1.5)
		self.kickStartedAt = os.clock()
		self.kickDepth = 0.10 + scale * 0.12
	end

	function session:Reveal(outlineColor: Color3?, outlineTransparency: number?, alwaysOnTop: boolean?): Model
		if self._revealTween then
			self._revealTween:Cancel()
			self._revealTween = nil
		end

		local silhouetteHighlight = self._highlight
		if silhouetteHighlight and silhouetteHighlight.Parent then
			silhouetteHighlight.FillColor = Color3.new(1, 1, 1)
			silhouetteHighlight.FillTransparency = 0
			silhouetteHighlight.OutlineColor = Color3.new(1, 1, 1)
			silhouetteHighlight.OutlineTransparency = 0
			silhouetteHighlight.DepthMode = if alwaysOnTop
				then Enum.HighlightDepthMode.AlwaysOnTop
				else Enum.HighlightDepthMode.Occluded
			local tween = TweenService:Create(
				silhouetteHighlight,
				TweenInfo.new(REVEAL_FILL_DURATION, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{
					FillTransparency = 1,
					OutlineColor = outlineColor or Color3.new(1, 1, 1),
					OutlineTransparency = outlineTransparency or 1,
				}
			)
			self._revealTween = tween
			tween:Play()
		end

		return self.model
	end

	function session:Destroy()
		if self._revealTween then
			self._revealTween:Cancel()
			self._revealTween = nil
		end
		if self.model.Parent then
			self.model:Destroy()
		end
	end

	return session
end

function DigSilhouetteUtil.PlayRevealFlash(duration: number?, tint: Color3?, brightness: number?)
	local lighting = game:GetService("Lighting")
	local existing = lighting:FindFirstChild("DigRevealFlash")
	if existing then
		existing:Destroy()
	end

	local cc = Instance.new("ColorCorrectionEffect")
	cc.Name = "DigRevealFlash"
	cc.Brightness = brightness or 0.35
	cc.TintColor = tint or Color3.new(1, 1, 1)
	cc.Parent = lighting

	local tween = TweenService:Create(
		cc,
		TweenInfo.new(duration or 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ Brightness = 0 }
	)
	tween:Play()
	tween.Completed:Connect(function()
		cc:Destroy()
	end)
end

return DigSilhouetteUtil
