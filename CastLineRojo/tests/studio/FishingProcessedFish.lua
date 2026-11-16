-- Studio Client batch validation. Replacements below exist only in this Play session.
local storage = game:GetService("ReplicatedStorage")
local Bite = require(storage.Modules.FishingBiteSequence)
local Cast = require(storage.Modules.FishingCastSequence)
local config = require(storage.Modules.FishingConfig)
local settings = config.Bite
local job = { done = false, results = {}, errors = {} }
-- selene: allow(global_usage)
_G.FishGameplayJob = job
local dataFolder = storage:WaitForChild("_FishGeometryQA")
local function decode(folder)
	local chunks = folder:GetChildren()
	table.sort(chunks, function(a, b)
		return a.Name < b.Name
	end)
	local strings = {}
	for _, value in chunks do
		table.insert(strings, value.Value)
	end
	return table.concat(strings)
end
local function replicated(folder)
	local deadline = os.clock() + 60
	repeat
		local encoded = decode(folder)
		if #encoded == folder:GetAttribute("ByteLength") then
			return encoded
		end
		assert(os.clock() < deadline, "Geometry audit data did not replicate")
		task.wait()
	until false
end
local geometry = {}
if not dataFolder:GetAttribute("CompressedPerFish") then
	geometry = game.HttpService:JSONDecode(replicated(dataFolder))
end
local function fishGeometry(name)
	if not dataFolder:GetAttribute("CompressedPerFish") then
		return geometry[name]
	end
	local row = assert(dataFolder:WaitForChild(name, 60), "Missing geometry for " .. name)
	local encoding = game:GetService("EncodingService")
	local packed = encoding:Base64Decode(buffer.fromstring(replicated(row)))
	return game.HttpService:JSONDecode(
		buffer.tostring(encoding:DecompressBuffer(packed, Enum.CompressionAlgorithm.Zstd))
	)
end
local originalName = settings.FishName
local camera = workspace.CurrentCamera
local savedCamera = { camera.CFrame, camera.FieldOfView, camera.CameraType, camera.Focus }
local folder = Instance.new("Folder")
folder.Name = "_ProcessedFishGameplayQA"
folder.Parent = workspace
local originals = Instance.new("Folder")
originals.Name = "OriginalTemplates"
originals.Parent = folder
<<<<<<< Updated upstream
local v2 = workspace:FindFirstChild("_RigV2Stage")
local variants = (v2 or workspace.Fish_Processed):GetChildren()
local staged = not v2 and workspace:FindFirstChild("_FishRace_Staging")
=======
local variants = workspace.Fish_Processed:GetChildren()
local staged = workspace:FindFirstChild("_FishNewFish_Staging") or workspace:FindFirstChild("_FishRace_Staging")
>>>>>>> Stashed changes
if staged then
	for _, fish in staged:GetChildren() do
		table.insert(variants, fish)
	end
end
table.sort(variants, function(a, b)
	return a.Name < b.Name
end)
local swaps = {}
for _, f in variants do
	local old = storage.Models.Fish:FindFirstChild(f.Name)
	if old then
		old.Parent = originals
	end
	local replacement = f:Clone()
	replacement.Parent = storage.Models.Fish
	table.insert(swaps, { old, replacement })
end
local function projection(frame, fov, viewport)
	local tangent = math.tan(math.rad(fov * 0.5))
	return {
		view = frame:Inverse(),
		tangent = tangent,
		horizontalTangent = tangent * viewport.X / math.max(viewport.Y, 1),
	}
end

local function measure(fish, data, scale, projections)
	local result = 0
	local lowest = math.huge
	local function check(world)
		lowest = math.min(lowest, world.Y)
		for _, shot in projections do
			local p = shot.view:PointToWorldSpace(world)
			local ratio = if p.Z >= 0
				then math.huge
				else math.max(math.abs(p.X) / (-p.Z * shot.horizontalTangent), math.abs(p.Y) / (-p.Z * shot.tangent))
			result = math.max(result, ratio)
		end
	end
	if not data then
		for _, p in fish:GetDescendants() do
			if p:IsA("BasePart") and p.Transparency < 1 and p.Name ~= "CameraPart" then
				for x = -1, 1, 2 do
					for y = -1, 1, 2 do
						for z = -1, 1, 2 do
							check(p.CFrame:PointToWorldSpace(p.Size * Vector3.new(x, y, z) * 0.5))
						end
					end
				end
			end
		end
	else
		for _, spec in data.parts do
			local p = fish:FindFirstChild(spec.name, true)
			local transforms = {}
			for i, name in data.bones do
				local b = p:FindFirstChild(name, true)
				local bind, parent = b.CFrame, b.Parent
				while parent:IsA("Bone") do
					bind, parent = parent.CFrame * bind, parent.Parent
				end
				transforms[i] = b.TransformedWorldCFrame * bind:Inverse()
			end
			for vi, v in spec.vertices do
				local pos = Vector3.new(v[1], v[2], v[3]) * scale
				local world = Vector3.zero
				local weight = spec.weights[vi]
				for j, bi in weight[1] do
					world += transforms[bi + 1]:PointToWorldSpace(pos) * weight[2][j]
				end
				check(world)
			end
		end
	end
	assert(lowest < math.huge, "Fish has no visible geometry")
	return result, lowest
end

task.spawn(function()
	for index, template in variants do
		job.current = template.Name
		settings.FishName = template.Name
		local active, bait
		local ok, result = xpcall(function()
			local bodyGeometry = fishGeometry(template.Name)
			bait = storage.Models.FishBait["1"]["1"]:Clone()
			bait.Anchored = true
			bait.Transparency = 1
			bait.Parent = folder
			local target = Vector3.new(0, 1000, 0)
			local initial = CFrame.lookAt(target + Vector3.new(0, 18, -28), target)
			local owner = setmetatable({
				folder = folder,
				forward = Vector3.zAxis,
				bait = bait,
					continueLabel = {},
				root = { CFrame = CFrame.identity },
				impulses = {},
				spin = 0,
				cameraFrame = initial,
				cameraFov = 60,
				shotMode = "Bite",
				shotStarted = 100,
				shotDuration = 0,
				shotFrom = initial,
				fovFrom = 60,
				_waterTarget = function()
					return target
				end,
				_presentBait = function() end,
				_waterFeedback = function() end,
				_playWaterVFX = function() end,
				_playRarityVFX = function() end,
				_nibbleRipple = function() end,
				_nibbleFeedback = function() end,
				_sound = function() end,
				_impulse = function() end,
				_setPhase = function() end,
			}, Cast)
			active = Bite.new(owner, 100, 100, Random.new(index), nil, storage.Models.Fish[template.Name], {
				DefaultWeight = 1,
			})
			owner.bite = active
			local bodySize = template:GetAttribute("FishBodySize") or template.PrimaryPart.Size
			assert(math.abs(active.halfLength - bodySize.Z * 0.5) < 0.0001, "Whole-fish length ignored")
			assert(
				(active.mouthOffset - template.PrimaryPart.MouthAttachment.Position).Magnitude < 0.0001,
				"MouthAttachment ignored"
			)
			local deadline = os.clock() + 15
			while active.animation.loading and os.clock() < deadline do
				task.wait(0.05)
			end
			assert(not active.animation.loading and not active.animation.failed, "Animation load failed")
			local clips = {}
			local moved = {}
			local maxFraming = 0
			local minClearance = math.huge
			local framedSamples = 0
			local framingByPhase = {}
			local samples = 0
			local maxMouthError = 0
			local idleSamples = 0
			for name, track in active.animation.tracks do
				assert(track.Length > 0, "Empty " .. name)
			end
			local phases = {
				{ "Approaching", settings.ApproachTime },
				{ "Holding", 1 },
				{ "Nibbling", settings.NibbleTime },
				{ "Bite", settings.HookWindow },
				{ "Struggling", settings.StruggleTime, 1 },
				{ "Struggling", settings.StruggleTime, -1 },
				{ "Lifting", settings.LiftTime },
				{ "Caught", 1.2 },
			}
			local startedAt = 101
			for _, entry in phases do
				local phase, duration = entry[1], entry[2]
				if phase == "Nibbling" then
					active.timeline.nibbleIndex = 1
					duration = active.timeline:GetNibbleTiming().duration
				elseif phase == "Lifting" then
					active:SetCaughtWeight(1e9)
					assert(active.catchScale == active.catchScaleLimit, "Showcase QA did not use the maximum fish scale")
				end
				if entry[3] then
					active.motion.mirror = entry[3]
				end
				active.timeline:_enter(phase, startedAt, duration)
				local phaseFraming = 0
				local settledEye
				for sample = 0, 19 do
					local elapsed = duration * sample / 20
					local now = startedAt + elapsed
					active:Update(now, true)
					owner:_updateCamera(now, duration / 20)
					active:Present(camera.CFrame.Position)
					task.wait(0.025)
					local body = active.fish.PrimaryPart
					local mouth = body.MouthAttachment.WorldPosition
					assert(
						(mouth - body.CFrame:PointToWorldSpace(active.mouthOffset * active.scale)).Magnitude < 0.002,
						"Scaled attachment mismatch"
					)
					for _, b in active.fish:GetDescendants() do
						if b:IsA("Bone") then
							local _, angle = b.Transform:ToAxisAngle()
							if b.Name == "FishBody" then
								assert(math.abs(angle) < 0.0001, "Head moved")
							elseif math.abs(angle) > 0.001 then
								moved[b.Name] = true
							end
						end
					end
					if active.animation.active then
						clips[active.animation.active.name] = true
						if phase == "Caught" and active.animation.active.token == "ShowcaseIdle" then
							idleSamples += 1
							assert(active.drip and #active.drip.emitters == 24, "Showcase idle lost drip points")
						end
					end
					if phase == "Bite" and elapsed >= settings.BiteSinkTime then
						local yaw = active:_feedingState("Bite", elapsed)
						local error = (mouth - (bait.Position + active:_contactOffset(yaw, bait.Size))).Magnitude
						maxMouthError = math.max(error, maxMouthError)
						assert(error < 0.002, "Mouth lost bait")
					end
					if phase == "Lifting" or phase == "Caught" then
						assert(
							(mouth - Vector3.yAxis * settings.ShowcaseLineMouthDrop - active.linePosition).Magnitude
								< 0.002,
							"Line lost mouth"
						)
						local closeupEntry, pullback = owner:_showcaseProgress(now)
						if closeupEntry == 1 and pullback == 0 then
							assert(
								math.abs((camera.CFrame.Position - active.showcasePosition).Magnitude
									- settings.ShowcaseCloseupDistance) < 0.1,
								"Fish size pushed the fixed closeup camera away"
							)
						end
						if phase == "Caught" and pullback == 1 then
							settledEye = settledEye or owner.cameraFrame.Position
							assert(
								(owner.cameraFrame.Position - settledEye).Magnitude < 0.001,
								"Fish motion changed the base showcase camera distance"
							)
						end
						local apexSample = phase == "Lifting" and sample == math.ceil(settings.LiftRiseEnd * 20)
						if sample % 2 == 0 or apexSample then
							local projections = { projection(camera.CFrame, camera.FieldOfView, camera.ViewportSize) }
							if phase == "Caught" then
								for _, viewport in { Vector2.new(390, 844), Vector2.new(1877, 1240) } do
									local view = owner:_showcaseCamera(target, viewport)
									table.insert(projections, projection(view, settings.ShowcaseFov, viewport))
								end
							end
							local ratio, lowest = measure(active.fish, bodyGeometry, active.scale, projections)
							if pullback == 1 then
								assert(ratio < 1, "Showcase clipped the fish after pulling back")
								framedSamples += 1
								phaseFraming = math.max(phaseFraming, ratio)
								maxFraming = math.max(maxFraming, ratio)
							end
							if phase == "Caught" or apexSample or elapsed / settings.LiftTime >= settings.LiftRiseEnd then
								local clearance = lowest - target.Y
								assert(clearance >= settings.WaterClearance - 0.001, "Showcase fish dipped into the water")
								minClearance = math.min(minClearance, clearance)
							end
						end
					end
					samples += 1
				end
				framingByPhase[phase] = math.max(framingByPhase[phase] or 0, phaseFraming)
				startedAt += duration + 0.001
			end
			for name in settings.Motion.Animation.Clips do
				assert(clips[name], "Gameplay missed " .. name)
			end
			assert(framedSamples > 0, "Showcase never completed its pullback")
			for _, name in (bodyGeometry and bodyGeometry.bones or settings.Motion.Animation.Bones) do
				if name ~= "FishBody" then
					assert(moved[name], "Gameplay did not move " .. name)
				end
			end
			assert(idleSamples > 0, "Showcase did not settle into continuous tail motion")
			local partCount = 0
			for p in active.originals do
				local original = template:FindFirstChild(p.Name, true)
				assert(original, "Missing source part")
				assert(
					p.Material == original.Material and p.Color == original.Color,
					"Appearance not restored " .. p.Name
				)
				if p:IsA("MeshPart") then
					assert(p.TextureID == original.TextureID, "Texture not restored")
				end
				partCount += 1
			end
			active:Destroy()
			active = nil
			return {
				name = template.Name,
				passed = true,
				samples = samples,
				idleSamples = idleSamples,
				visibleParts = partCount,
				clips = clips,
				maxMouthError = maxMouthError,
				minWaterClearance = minClearance,
				framingByPhase = framingByPhase,
				maxFramingRatio = maxFraming,
				framingPassed = maxFraming < 0.98,
			}
		end, debug.traceback)
		if active then
			active:Destroy()
		end
		if bait then
			bait:Destroy()
		end
		if ok then
			table.insert(job.results, result)
		else
			table.insert(job.errors, { name = template.Name, error = result })
		end
		task.wait()
	end
	settings.FishName = originalName
	for _, pair in swaps do
		pair[2]:Destroy()
		if pair[1] then
			pair[1].Parent = storage.Models.Fish
		end
	end
	folder:Destroy()
	camera.CFrame, camera.FieldOfView, camera.CameraType, camera.Focus = table.unpack(savedCamera)
	job.done = true
end)
return "Started " .. #variants .. "-fish gameplay, mouth, appearance, all clips and skinned-vertex camera validation"
