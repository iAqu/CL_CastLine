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
local encoded = ""
local dataDeadline = os.clock() + 30
repeat
	local chunks = dataFolder:GetChildren()
	table.sort(chunks, function(a, b)
		return a.Name < b.Name
	end)
	local strings = {}
	for _, v in chunks do
		table.insert(strings, v.Value)
	end
	encoded = table.concat(strings)
	assert(os.clock() < dataDeadline, "Geometry audit data did not replicate")
	task.wait()
until #encoded == dataFolder:GetAttribute("ByteLength")
local geometry = game.HttpService:JSONDecode(encoded)
local originalName = settings.FishName
local camera = workspace.CurrentCamera
local savedCamera = { camera.CFrame, camera.FieldOfView, camera.CameraType, camera.Focus }
local folder = Instance.new("Folder")
folder.Name = "_ProcessedFishGameplayQA"
folder.Parent = workspace
local originals = Instance.new("Folder")
originals.Name = "OriginalTemplates"
originals.Parent = folder
local variants = workspace.Fish_Processed:GetChildren()
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
local function measure(fish, data, scale, frame, fov)
	local result = 0
	local count = 0
	local tangent = math.tan(math.rad(fov * 0.5))
	local aspect = camera.ViewportSize.X / math.max(camera.ViewportSize.Y, 1)
	local view = frame:Inverse()
	local function check(world)
		local p = view:PointToWorldSpace(world)
		local ratio = if p.Z >= 0
			then math.huge
			else math.max(math.abs(p.X) / (-p.Z * tangent * aspect), math.abs(p.Y) / (-p.Z * tangent))
		result = math.max(result, ratio)
		count += 1
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
				transforms[i] = b.TransformedWorldCFrame * b.WorldCFrame:Inverse() * p.CFrame
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
	return result, count
end

task.spawn(function()
	for index, template in variants do
		job.current = template.Name
		settings.FishName = template.Name
		local active, bait
		local ok, result = xpcall(function()
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
				statusLabel = {},
				returnLabel = {},
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
			active = Bite.new(owner, 100, 100, Random.new(index))
			owner.bite = active
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
			local framingByPhase = {}
			local samples = 0
			local maxMouthError = 0
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
				end
				if entry[3] then
					active.motion.mirror = entry[3]
				end
				active.timeline:_enter(phase, startedAt, duration)
				local phaseFraming = 0
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
						if sample % 4 == 0 then
							local ratio = measure(
								active.fish,
								geometry[template.Name],
								active.scale,
								camera.CFrame,
								camera.FieldOfView
							)
							phaseFraming = math.max(phaseFraming, ratio)
							maxFraming = math.max(maxFraming, ratio)
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
			for _, name in
				(geometry[template.Name] and geometry[template.Name].bones or settings.Motion.Animation.Bones)
			do
				if name ~= "FishBody" then
					assert(moved[name], "Gameplay did not move " .. name)
				end
			end
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
				visibleParts = partCount,
				clips = clips,
				maxMouthError = maxMouthError,
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
return "Started 28-fish gameplay, mouth, appearance, all clips and skinned-vertex camera validation"
