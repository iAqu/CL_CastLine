local ContentProvider = game:GetService("ContentProvider")
local Config = require(script.Parent.FishingConfig)

local Presentation = {}
local warnedSpecial = false

local function warnFallback()
	if not warnedSpecial then
		warnedSpecial = true
		warn("FishingCastPresentation: SpecialCastRod unavailable; retiming CastRod for GODLIKE")
	end
end

function Presentation.Prepare(owner, animator, animation, specialAnimation)
	owner.castTracks = {}
	owner.track = animator:LoadAnimation(animation)
	owner.castTracks.Normal = owner.track
	if specialAnimation and specialAnimation:IsA("Animation") then
		local ok, track = pcall(animator.LoadAnimation, animator, specialAnimation)
		if ok then
			owner.castTracks.Godlike = track
		end
	end
	for _, track in pairs(owner.castTracks) do
		track.Priority, track.Looped = Enum.AnimationPriority.Action, false
	end
	-- Both assets begin loading during meter preparation. No completion callback can start a stale cast.
	owner.castPreloadTask = task.spawn(function()
		pcall(function()
			ContentProvider:PreloadAsync(if specialAnimation then { animation, specialAnimation } else { animation })
		end)
	end)
end

function Presentation.Select(owner, rating)
	owner.castProfile = Config.GetCastProfile(rating)
	if owner.castTracks then
		owner.track = owner.castTracks[owner.castProfile.Id] or owner.castTracks.Normal
		owner.specialFallback = owner.castProfile.Id == "Godlike" and not owner.castTracks.Godlike
		if owner.specialFallback then
			warnFallback()
		end
	end
end

function Presentation.Ready(owner, now)
	if owner.track.Length > 0 then
		return true
	end
	if now - owner.castClickedAt < Config.AnimationLoadTimeout then
		return false
	end
	if owner.castProfile.Id == "Godlike" and owner.castTracks and not owner.specialFallback then
		owner.track, owner.specialFallback = owner.castTracks.Normal, true
		warnFallback()
		if owner.track.Length > 0 then
			return true
		end
	end
	error("CastRod failed to load before timeout")
end

function Presentation.Play(owner)
	for _, track in pairs(owner.castTracks or {}) do
		if track ~= owner.track then
			track:Stop(0)
		end
	end
	local speed = if owner.specialFallback
		then Config.CastProfiles.Normal.ReleaseTime / owner.castProfile.ReleaseTime
		else 1
	owner.track:Play(0.05, 1, speed)
end

-- The source clip points the rod below the standing floor during its flips.
-- Lift only the presentation clone; preserve the authored animation and its 1x timing.
function Presentation.GroundClearance(owner)
	local previous = owner.castVisualLift or 0
	local floor = owner.castGroundY
	local lowest = owner.tip.WorldPosition.Y - 0.7
	for _, name in ipairs({ "LeftFoot", "RightFoot" }) do
		local foot = owner.rig:FindFirstChild(name)
		if foot then
			local half = foot.Size * 0.5
			local frame = foot.CFrame
			local radius = math.abs(frame.RightVector.Y) * half.X
				+ math.abs(frame.UpVector.Y) * half.Y
				+ math.abs(frame.LookVector.Y) * half.Z
			lowest = math.min(lowest, foot.Position.Y - radius)
		end
	end
	local lift = math.max(0, floor + 0.04 - (lowest - previous))
	owner.rig:PivotTo(owner.rig:GetPivot() + Vector3.yAxis * (lift - previous))
	owner.castVisualLift = lift
end

function Presentation.Camera(owner, elapsed, viewport)
	local settings = owner.castProfile.Camera
	local nodes = settings.Nodes
	local from, to = nodes[1], nodes[#nodes]
	for index = 2, #nodes do
		if elapsed <= nodes[index][1] then
			from, to = nodes[index - 1], nodes[index]
			break
		end
	end
	local alpha = math.clamp((elapsed - from[1]) / math.max(to[1] - from[1], 0.001), 0, 1)
	alpha = alpha * alpha * (3 - 2 * alpha)
	local function sample(index)
		return from[index] + (to[index] - from[index]) * alpha
	end
	local fov, angle, distance, height = sample(2), math.rad(sample(3)), sample(4), sample(5)
	local torso = owner.rig:FindFirstChild("UpperTorso") or owner.root
	local focus = torso.Position
	-- Root yaw defines the orbit; the animated torso supplies translation only, never camera roll.
	local direction = owner.root.CFrame:VectorToWorldSpace(Vector3.new(math.sin(angle), 0, math.cos(angle)))
	direction = (direction + Vector3.yAxis * (height / distance)).Unit
	local basis = CFrame.lookAt(focus + direction, focus, Vector3.yAxis)
	local points = { owner.tip.WorldPosition }
	if owner.characterVFX then
		owner.characterVFX:AppendTrailBounds(points, owner.actionStarted + elapsed)
	end
	local trailHalf = owner.castProfile.Trails.Rod.Width * 0.5 + owner.castProfile.Trails.Rod.EdgeWidth
	table.insert(points, owner.tip.WorldPosition + basis.RightVector * trailHalf)
	table.insert(points, owner.tip.WorldPosition - basis.RightVector * trailHalf)
	for _, name in ipairs({ "Head", "UpperTorso", "LowerTorso", "LeftHand", "RightHand", "LeftFoot", "RightFoot" }) do
		local part = owner.rig:FindFirstChild(name)
		if part and part:IsA("BasePart") then
			for _, x in ipairs({ -0.5, 0.5 }) do
				for _, y in ipairs({ -0.5, 0.5 }) do
					for _, z in ipairs({ -0.5, 0.5 }) do
						table.insert(points, part.CFrame:PointToWorldSpace(part.Size * Vector3.new(x, y, z)))
					end
				end
			end
		end
	end
	local minX, maxX, minY, maxY = math.huge, -math.huge, math.huge, -math.huge
	for _, point in ipairs(points) do
		local delta = point - focus
		local x, y = delta:Dot(basis.RightVector), delta:Dot(basis.UpVector)
		minX, maxX, minY, maxY = math.min(minX, x), math.max(maxX, x), math.min(minY, y), math.max(maxY, y)
	end
	focus += basis.RightVector * ((minX + maxX) * 0.5) + basis.UpVector * ((minY + maxY) * 0.5)
	local tangent = math.tan(math.rad(fov * 0.5)) * settings.SafeFraction
	local aspect = viewport.X / math.max(viewport.Y, 1)
	for _, point in ipairs(points) do
		local delta = point - focus
		distance = math.max(
			distance,
			delta:Dot(direction)
				+ math.max(
					math.abs(delta:Dot(basis.RightVector)) / (tangent * aspect),
					math.abs(delta:Dot(basis.UpVector)) / tangent
				)
		)
	end
	distance = math.min(distance, settings.MaxDistance)
	-- When the distance cap is reached on a portrait screen, widen only as much as fitting requires.
	local fitTangent = math.tan(math.rad(fov * 0.5))
	for _, point in ipairs(points) do
		local delta = point - focus
		local depth = math.max(distance - delta:Dot(direction), 0.1)
		fitTangent = math.max(
			fitTangent,
			math.abs(delta:Dot(basis.RightVector)) / (depth * settings.SafeFraction * aspect),
			math.abs(delta:Dot(basis.UpVector)) / (depth * settings.SafeFraction)
		)
	end
	fov = math.min(settings.MaxFitFov, math.deg(math.atan(fitTangent)) * 2)
	return CFrame.lookAt(focus + direction * distance, focus, Vector3.yAxis), fov, focus
end

function Presentation.Destroy(owner)
	if owner.castPreloadTask then
		pcall(task.cancel, owner.castPreloadTask)
		owner.castPreloadTask = nil
	end
	for _, track in pairs(owner.castTracks or (owner.track and { owner.track } or {})) do
		pcall(function()
			track:Stop(0)
			track:Destroy()
		end)
	end
	owner.castTracks, owner.track = nil, nil
end

return Presentation
