local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local GuiUtil = require(script.Parent.GuiUtil)
local RarityRevealConfig = require(script.Parent.RarityRevealConfig)

local RarityBeamUtil = {}

export type BeamSession = {
	anchor: BasePart,
	SetVisible: (self: BeamSession, visible: boolean) -> (),
	fadeOut: (self: BeamSession) -> (),
	Destroy: (self: BeamSession) -> (),
}

local FADE_DURATION = 0.55
local ROOT_EDGE_RATIO = 0.92

type BeamState = {
	beam: Beam,
	tip: Attachment,
	basePosition: Vector3,
	direction: Vector3,
	height: number,
	width: number,
	emergeStart: number,
	emergeDuration: number,
	swayPhase: number,
	swayFrequency: number,
	swayAmplitude: number,
	pulsePhase: number,
	pulseFrequency: number,
	flickerPhase: number,
	flickerFrequency: number,
}

local function getBeamTemplate(): Beam?
	local vfxFolder = ReplicatedStorage:FindFirstChild("VFX")
	local rarityFolder = vfxFolder and vfxFolder:FindFirstChild("RarityBeam")
	local template = rarityFolder and rarityFolder:FindFirstChild("RarityBeam")
	if template and template:IsA("Beam") then
		return template
	end

	warn("[RarityBeamUtil] Missing ReplicatedStorage.VFX.RarityBeam.RarityBeam")
	return nil
end

function RarityBeamUtil.Create(
	position: Vector3,
	parent: Instance,
	rarity: string?,
	itemBounds: Vector3?,
	rootRadii: Vector2
): BeamSession?
	local beamTemplate = getBeamTemplate()
	if not beamTemplate then
		return nil
	end
	local resolvedRarity = RarityRevealConfig.ResolveRarity(rarity)
	local style = RarityRevealConfig.GetStyle(resolvedRarity)
	local sizeScale = RarityRevealConfig.GetSizeScale(itemBounds)
	local beamCount = math.random(style.minBeams, style.maxBeams)

	local anchor = Instance.new("Part")
	anchor.Name = "RarityBeams"
	anchor.Anchored = true
	anchor.CanCollide = false
	anchor.CanQuery = false
	anchor.CanTouch = false
	anchor.CastShadow = false
	anchor.Transparency = 1
	anchor.Size = Vector3.new(1, 1, 1)
	anchor.CFrame = CFrame.new(position)
	anchor.Parent = parent

	local startedAt = os.clock()
	local beams: { BeamState } = table.create(beamCount)
	local rarityColor = GuiUtil.GetRarityGradientColor(resolvedRarity)

	for _ = 1, beamCount do
		local angle = math.random() * math.pi * 2
		local radiusScale = ROOT_EDGE_RATIO * math.sqrt(math.random())
		local basePosition = Vector3.new(
			math.cos(angle) * rootRadii.X * radiusScale,
			-0.2,
			math.sin(angle) * rootRadii.Y * radiusScale
		)

		local rootAttachment = Instance.new("Attachment")
		rootAttachment.Position = basePosition
		rootAttachment.Parent = anchor

		local tipAttachment = Instance.new("Attachment")
		tipAttachment.Position = basePosition
		tipAttachment.Parent = anchor

		local beam = beamTemplate:Clone()
		beam.Attachment0 = rootAttachment
		beam.Attachment1 = tipAttachment
		beam.Width0 = 0
		beam.Width1 = 0
		beam.LightEmission = 0.55
		beam.Brightness = style.brightness
		if rarityColor then
			beam.Color = ColorSequence.new(rarityColor)
		end
		beam.Enabled = true
		beam.Parent = anchor

		local tilt = math.random() * 0.3839724354387525
		local spin = math.random() * math.pi * 2
		local direction = Vector3.new(
			math.sin(tilt) * math.cos(spin),
			math.cos(tilt),
			math.sin(tilt) * math.sin(spin)
		)

		table.insert(beams, {
			beam = beam,
			tip = tipAttachment,
			basePosition = basePosition,
			direction = direction,
			height = (style.minHeight + math.random() * (style.maxHeight - style.minHeight)) * sizeScale,
			width = (style.minWidth + math.random() * (style.maxWidth - style.minWidth)) * sizeScale,
			emergeStart = startedAt + math.random() * 0.35,
			emergeDuration = 0.45 + math.random() * 0.3,
			swayPhase = math.random() * math.pi * 2,
			swayFrequency = 0.6 + math.random() * 0.8,
			swayAmplitude = 0.15 + math.random() * 0.3,
			pulsePhase = math.random() * math.pi * 2,
			pulseFrequency = 2 + math.random() * 2,
			flickerPhase = math.random() * math.pi * 2,
			flickerFrequency = 6 + math.random() * 5,
		})
	end

	local fadeStartedAt: number? = nil
	local heartbeatConn: RBXScriptConnection? = nil
	local isVisible = true

	local function updateBeams(now: number, fadeAlpha: number)
		for _, state in beams do
			local emergeAlpha = 1 - (1 - math.clamp((now - state.emergeStart) / state.emergeDuration, 0, 1)) ^ 3
			local strength = emergeAlpha * fadeAlpha

			state.tip.Position = state.basePosition
				+ state.direction * (state.height * strength)
				+ Vector3.new(
					math.sin(now * state.swayFrequency + state.swayPhase),
					0,
					math.cos(now * state.swayFrequency * 0.83 + state.swayPhase)
				) * (state.swayAmplitude * strength)

			local pulse = math.sin(now * state.pulseFrequency + state.pulsePhase) * 0.14 + 1
			state.beam.Width0 = strength * 0.3 * sizeScale
			state.beam.Width1 = state.width * strength * pulse

			local flicker = math.sin(now * state.flickerFrequency + state.flickerPhase) * 0.28
			state.beam.Brightness = style.brightness
				* (flicker * math.sin(now * state.flickerFrequency * 1.71 + state.flickerPhase * 1.37) + 0.72)
		end
	end

	local function teardown()
		if heartbeatConn then
			heartbeatConn:Disconnect()
			heartbeatConn = nil
		end
		if anchor.Parent then
			anchor:Destroy()
		end
	end

	heartbeatConn = RunService.Heartbeat:Connect(function()
		local now = os.clock()
		local fadeAlpha = 1

		if fadeStartedAt then
			local fadeProgress = math.clamp((now - fadeStartedAt) / FADE_DURATION, 0, 1)
			if fadeProgress >= 1 then
				teardown()
				return
			end
			fadeAlpha = 1 - fadeProgress * fadeProgress
		end

		updateBeams(now, fadeAlpha)
	end)

	local session: BeamSession = {
		anchor = anchor,
		SetVisible = function(_self: BeamSession, visible: boolean)
			if isVisible == visible then
				return
			end
			isVisible = visible
			for _, state in beams do
				state.beam.Enabled = visible
			end
		end,
		fadeOut = function(_self: BeamSession)
			if fadeStartedAt then
				return
			end
			fadeStartedAt = os.clock()
		end,
		Destroy = function(_self: BeamSession)
			teardown()
		end,
	}

	return session
end

return RarityBeamUtil
