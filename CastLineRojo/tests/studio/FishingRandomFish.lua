-- Studio Client：真实鱼种抽取、整轮身份、嘴部连接、动画、展示取景和清理。
local storage = game:GetService("ReplicatedStorage")
local Bite = require(storage.Modules.FishingBiteSequence)
local Cast = require(storage.Modules.FishingCastSequence)
local settings = require(storage.Modules.FishingConfig).Bite
local originalName, originalSelector = settings.FishName, Bite.SelectFishTemplate
local camera = workspace.CurrentCamera
local savedCamera = { camera.CFrame, camera.Focus, camera.FieldOfView, camera.CameraType }
local folder = Instance.new("Folder")
folder.Name, folder.Parent = "FishingRandomFishValidation", workspace
local active, selected
local selections = 0
Bite.SelectFishTemplate = function(...)
	selections += 1
	selected = originalSelector(...)
	return selected
end

local ok, result = xpcall(function()
	local templates = {}
	for _, template in storage.Models.Fish:GetChildren() do
		if template:IsA("Model") and template.PrimaryPart then
			table.insert(templates, template)
		end
	end
	table.sort(templates, function(a, b)
		return a.Name < b.Name
	end)
	assert(#templates > 1, "Random fish validation needs multiple templates")
	local bait = storage.Models.FishBait["1"]["1"]:Clone()
	bait.Anchored, bait.Parent = true, folder
	local target = Vector3.new(0, 1000, 0)
	local initial = CFrame.lookAt(target + Vector3.new(0, 18, -28), target)
	local owner = setmetatable({
		folder = folder, bait = bait, forward = Vector3.zAxis, spin = 0,
		continueLabel = {}, impulses = {},
		root = { CFrame = CFrame.identity },
		cameraFrame = initial, cameraFov = 60,
		shotMode = "Bite", shotStarted = 100, shotDuration = 0, shotFrom = initial, fovFrom = 60,
		_waterTarget = function() return target end,
		_presentBait = function() end, _waterFeedback = function() end,
		_playWaterVFX = function() end, _playRarityVFX = function() end,
		_nibbleRipple = function() end, _nibbleFeedback = function() end,
		_sound = function() end, _impulse = function() end, _setPhase = function() end,
	}, Cast)
	local samples, randomSpecies = 0, {}
	for round = 1, #templates + 12 do
		settings.FishName = if round <= #templates then templates[round].Name else nil
		active = Bite.new(owner, 100, 100, Random.new(round), Random.new(round + 100))
		owner.bite = active
		local fish, template, count = active.fish, selected, selections
		assert(count == round, "A round must select exactly one fish")
		local expected = Bite.NewTimeline(100, Random.new(round), 100)
		assert(active.timeline.nibbles == expected.nibbles and active.timeline.appearAt == expected.appearAt,
			"Fish selection consumed the gameplay random stream")
		assert(fish.PrimaryPart.MeshId == template.PrimaryPart.MeshId, "Selected fish was not cloned")
		assert((active.mouthOffset - template.PrimaryPart.MouthAttachment.Position).Magnitude < 0.0001,
			"Selected fish mouth attachment was ignored")
		if round > #templates then
			randomSpecies[template.Name] = true
		end
		-- 后续状态不能再读取指定鱼种或重新抽取。
		settings.FishName = nil
		local deadline = os.clock() + 12
		while active.animation.loading and os.clock() < deadline do
			task.wait(0.05)
		end
		assert(not active.animation.loading and not active.animation.failed, "Fish animations failed: " .. template.Name)
		for name in pairs(settings.Motion.Animation.Clips) do
			assert(active.animation.tracks[name] and active.animation.tracks[name].Length > 0,
				"Missing fish animation: " .. template.Name .. "/" .. name)
		end
		local startedAt = 101
		for _, entry in ipairs({
			{ "Approaching", settings.ApproachTime }, { "Holding", 1 },
			{ "Nibbling", settings.NibbleTime }, { "Bite", settings.HookWindow },
			{ "Struggling", settings.StruggleTime }, { "Lifting", settings.LiftTime },
			{ "Caught", 1.2 },
		}) do
			local phase, duration = entry[1], entry[2]
			if phase == "Nibbling" then
				active.timeline.nibbleIndex = 1
				duration = active.timeline:GetNibbleTiming().duration
			end
			active.timeline:_enter(phase, startedAt, duration)
			for _, fraction in ipairs({ 0, 0.5, 0.95 }) do
				local now = startedAt + duration * fraction
				active:Update(now, true)
				owner:_updateCamera(now, 1 / 60)
				active:Present(camera.CFrame.Position)
				task.wait()
				assert(active.fish == fish and selections == count, "Fish changed during a round")
				local body = fish.PrimaryPart
				local mouth = body.CFrame:PointToWorldSpace(active.mouthOffset * active.scale)
				if phase == "Bite" and duration * fraction >= settings.BiteSinkTime then
					local yaw = active:_feedingState(phase, duration * fraction)
					assert((mouth - bait.Position - active:_contactOffset(yaw, bait.Size)).Magnitude < 0.001,
						"Biting mouth detached: " .. template.Name)
				end
				if phase == "Lifting" or phase == "Caught" then
					assert((mouth - Vector3.yAxis * settings.ShowcaseLineMouthDrop - active.linePosition).Magnitude < 0.001,
						"Showcase line detached: " .. template.Name)
				end
				if phase == "Caught" then
					for _, viewport in ipairs({ Vector2.new(390, 844), Vector2.new(1877, 1240) }) do
						local view = owner:_showcaseCamera(target, viewport)
						local tangent = math.tan(math.rad(settings.ShowcaseFov * 0.5))
						for x = -1, 1, 2 do
							for y = -1, 1, 2 do
								for z = -1, 1, 2 do
									local corner = body.CFrame:PointToWorldSpace(body.Size * Vector3.new(x, y, z) * 0.5)
									local point = view:PointToObjectSpace(corner)
									assert(point.Z < 0 and math.abs(point.X / (-point.Z * tangent * viewport.X / viewport.Y)) < 1
										and math.abs(point.Y / (-point.Z * tangent)) < 1, "Fish clipped in showcase: " .. template.Name)
								end
							end
						end
					end
				end
				samples += 1
			end
			startedAt += duration
		end
		active:Destroy()
		assert(not fish.Parent and active.animation.destroyed, "Fish survived round cleanup")
		active = nil
	end
	local speciesCount = 0
	for _ in pairs(randomSpecies) do
		speciesCount += 1
	end
	return { passed = true, templates = #templates, randomRounds = 12, randomSpecies = speciesCount, samples = samples }
end, debug.traceback)

if active then
	active:Destroy()
end
folder:Destroy()
settings.FishName, Bite.SelectFishTemplate = originalName, originalSelector
camera.CFrame, camera.Focus, camera.FieldOfView, camera.CameraType = unpack(savedCamera)
assert(ok, result)
return result
