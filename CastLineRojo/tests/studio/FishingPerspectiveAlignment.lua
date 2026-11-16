-- Studio Client：透视接触、完整回游、同帧显示和中途提竿；使用正式模块和模型。
local storage = game:GetService("ReplicatedStorage")
local Bite = require(storage.Modules.FishingBiteSequence)
local settings = require(storage.Modules.FishingConfig).Bite
local folder = Instance.new("Folder")
folder.Name, folder.Parent = "FishingPerspectiveValidation", workspace
local active
local ok, result = xpcall(function()
	local bait = storage.Models.FishBait["1"]["1"]:Clone()
	bait.Anchored, bait.Transparency, bait.Parent = true, 1, folder
	local target = Vector3.new(10, 1000, 30)
	local owner = {
		folder = folder,
		bait = bait,
		forward = Vector3.zAxis,
		_waterTarget = function()
			return target
		end,
		_presentBait = function() end,
		_sound = function() end,
		_waterFeedback = function() end,
		_playWaterVFX = function() end,
		_nibbleRipple = function() end,
		_nibbleFeedback = function() end,
		_setPhase = function() end,
		continueLabel = {},
	}
	local samples, maxPixelError, maxUncorrectedError = 0, 0, 0
	local viewports = { Vector2.new(1920, 1080), Vector2.new(1080, 1920), Vector2.new(844, 390) }
	local function close(a, b, label)
		assert((a - b).Magnitude < 0.001, label)
	end
	local function sameFrame(a, b, label)
		close(a.Position, b.Position, label .. " position")
		assert(a.LookVector:Dot(b.LookVector) > 0.9999, label .. " heading")
		assert(a.UpVector:Dot(b.UpVector) > 0.9999, label .. " roll")
	end
	local function mouth(frame)
		return frame:PointToWorldSpace(active.mouthOffset)
	end
	local function screen(view, point, viewport)
		local localPoint = view:PointToObjectSpace(point)
		assert(localPoint.Z < 0, "Test point is behind the camera")
		return Vector2.new(localPoint.X, -localPoint.Y) / -localPoint.Z * (viewport.Y / (2 * math.tan(math.rad(30))))
			+ viewport * 0.5
	end
	for sector = 1, 3 do
		for _, baitYaw in ipairs({ 0, math.pi / 4, math.pi / 2 }) do
			owner.spin = baitYaw
			local random = {
				NextInteger = function(_, low)
					return if low == 0 then 3 else sector
				end,
				NextNumber = function(_, low)
					return if low < 0 then 0 else low
				end,
			}
			active = Bite.new(owner, 0, 0, random, Random.new(11))
			for _, eye in ipairs({ Vector3.new(0, 8, -25), Vector3.new(12, 18, -20), Vector3.new(-14, 35, 7) }) do
				local view = CFrame.lookAt(target + eye, target)
				local function pose(phase, elapsed)
					return active:_pose(phase, elapsed, target, 20 + elapsed, nil, view.Position)
				end
				active.timeline.completedNibbles, active.timeline.nibbleIndex = 0, 0
				sameFrame(pose("Approaching", settings.ApproachTime), pose("Holding", 0), "Approach/hold")
				for index = 1, 3 do
					active.timeline.completedNibbles, active.timeline.nibbleIndex = index - 1, index
					local timing = active.timeline:GetNibbleTiming()
					local restTime = if index > 1 then active.repositions[index - 1].path.duration else 0
					sameFrame(pose("Holding", restTime), pose("Nibbling", 0), "Hold/nibble")
					for _, canonical in ipairs({ 0.12, 0.15, 0.18 }) do
						local elapsed = canonical / timing.nibbleSpeed
						local frame, baitPosition = pose("Nibbling", elapsed)
						local base = active:_basePose("Nibbling", elapsed, target)
						local yaw = active.motion.nibbles[index].beforeYaw
						local edge = baitPosition
							+ active:_contactOffset(yaw, owner.baitBaseSize * active:_baitScaleAt("Nibbling", elapsed))
						assert(math.abs(mouth(frame).Y - mouth(base).Y) < 0.001, "Perspective changed mouth depth")
						for _, viewport in ipairs(viewports) do
							local error = (screen(view, mouth(frame), viewport) - screen(view, edge, viewport)).Magnitude
							maxPixelError = math.max(maxPixelError, error)
							maxUncorrectedError = math.max(
								maxUncorrectedError,
								(screen(view, mouth(base), viewport) - screen(view, edge, viewport)).Magnitude
							)
							assert(error < 1, "Mouth missed the screen edge: " .. error)
							samples += 1
						end
					end
					local route = active.repositions[index]
					local duration = route.path.duration
					local contactEnd = timing.returnAt
					local carried = timing.duration - contactEnd
					local function returning(time, cameraPosition)
						local phase, elapsed
						if time <= carried then
							active.timeline.completedNibbles = index - 1
							phase, elapsed = "Nibbling", contactEnd + time
						else
							active.timeline.completedNibbles = index
							phase, elapsed = "Holding", time - carried
						end
						return active:_basePose(phase, elapsed, target, cameraPosition or view.Position)
					end
					for _, boundary in ipairs({ 0, carried, duration }) do
						sameFrame(
							returning(math.max(0, boundary - 1e-6)),
							returning(boundary + 1e-6),
							"Return boundary"
						)
					end
					for sample = 1, 40 do
						local time = duration * sample / 41
						local before, after = returning(time - 0.001), returning(time + 0.001)
						local frame = returning(time)
						assert(
							frame.LookVector:Dot((after.Position - before.Position).Unit) > 0.999,
							"Corrected return did not swim forward"
						)
						local movingEye = view.Position + Vector3.new(math.sin(time), 0, math.cos(time))
						local nextEye = view.Position + Vector3.new(math.sin(time + 0.0001), 0, math.cos(time + 0.0001))
						local moving, later = returning(time, movingEye), returning(time + 0.0001, nextEye)
						assert((moving.Position - later.Position).Magnitude < 0.05, "Moving camera jumped the route")
						assert(moving.LookVector:Dot(later.LookVector) > 0.999, "Moving camera flipped route heading")
						samples += 1
					end
					active.timeline.completedNibbles = index
					assert(active.repositions[index].path.duration == duration, "Camera changed gameplay duration")
				end
				sameFrame(pose("Holding", active.repositions[3].path.duration), pose("Bite", 0), "Hold/bite")
				for _, elapsed in ipairs({ 0.15, 0.4 }) do
					local frame, baitPosition = pose("Bite", elapsed)
					close(
						mouth(frame),
						baitPosition
							+ active:_contactOffset(
								active.motion.nibbles[3].yaw,
								owner.baitBaseSize * active:_baitScaleAt("Bite", elapsed)
							),
						"True bite missed world edge"
					)
				end
				for _, elapsed in ipairs({ 0, 0.04, 0.149, 0.2, settings.HookWindow - 0.001 }) do
					active.timeline:_enter("Bite", 20, settings.HookWindow)
					active.presentationCamera = view.Position
					local expected, expectedBait = pose("Bite", elapsed)
					assert(active:TryHook(20 + elapsed))
					local actual, actualBait = pose("Struggling", 0)
					sameFrame(expected, actual, "Hook presentation")
					close(expectedBait, actualBait, "Hook moved bait")
				end
				-- 正式 Update/Present 入口：基础取景不变，显示使用传入的同帧相机。
				active.timeline.nibbleIndex, active.timeline.completedNibbles = 1, 0
				local timing = active.timeline:GetNibbleTiming()
				active.timeline:_enter("Nibbling", 30, timing.duration)
				active:Update(30 + 0.15 / timing.nibbleSpeed, true)
				local basePosition = active.lastPosition
				active:Present(view.Position)
				close(active.lastPosition, basePosition, "Presentation fed back into camera focus")
				local edge = bait.Position + active:_contactOffset(active.motion.nibbles[1].beforeYaw, bait.Size)
				local actualMouth = active.fish.PrimaryPart.CFrame:PointToWorldSpace(active.mouthOffset)
				assert(
					(screen(view, actualMouth, viewports[1]) - screen(view, edge, viewports[1])).Magnitude < 1,
					"Rendered fish missed the same-frame camera contact"
				)
			end
			active:Destroy()
			active = nil
			task.wait()
		end
	end
	assert(maxUncorrectedError > 10, "Test failed to reproduce the old perspective gap")
	return { passed = true, samples = samples, maxPixelError = maxPixelError, oldPixelError = maxUncorrectedError }
end, debug.traceback)
if active then
	active:Destroy()
end
folder:Destroy()
assert(ok, result)
return result
