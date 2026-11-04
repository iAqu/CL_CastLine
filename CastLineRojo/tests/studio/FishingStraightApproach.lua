-- Studio Client：直线出现、退开游动换位、浅弧接触与任意时刻提竿的连续性。
local storage = game:GetService("ReplicatedStorage")
local Bite = require(storage.Modules.FishingBiteSequence)
local Elastic = require(storage.Modules.BaitElasticMotion)
local settings = require(storage.Modules.FishingConfig).Bite
local folder = Instance.new("Folder")
folder.Name, folder.Parent = "FishingFeedingValidation", workspace
local active
local epsilon = 0.001
local flat = Vector3.new(1, 0, 1)
local ok, result = xpcall(function()
	local bait = storage.Models.FishBait["1"]["1"]:Clone()
	bait.Anchored, bait.Transparency, bait.Parent = true, 1, folder
	local target = Vector3.new(10, 20, 30)
	local view = CFrame.lookAt(target + Vector3.new(14, 18, -22), target)
	local function screen(point)
		local localPoint = view:PointToObjectSpace(point)
		return Vector2.new(localPoint.X, localPoint.Y) / -localPoint.Z * (540 / math.tan(math.rad(30)))
	end
	local sounds = 0
	local owner = {
		folder = folder,
		forward = Vector3.zAxis,
		bait = bait,
		_waterTarget = function()
			return target
		end,
		_presentBait = function() end,
		_waterFeedback = function() end,
		_playWaterVFX = function() end,
		_sound = function(_, name)
			assert(name == "FishBite", "Unexpected cue")
			sounds += 1
		end,
	}
	local function close(a, b, label)
		assert((a - b).Magnitude < epsilon, label)
	end
	local function sameFrame(a, b, label)
		close(a.Position, b.Position, label .. " position")
		assert(a.LookVector:Dot(b.LookVector) > 0.99999, label .. " heading")
		assert(a.UpVector:Dot(b.UpVector) > 0.99999, label .. " roll")
	end
	local poseClock = 10
	local function pose(phase, elapsed)
		return active:_pose(phase, elapsed, target, poseClock + elapsed)
	end
	local function mouth(frame)
		return frame:PointToWorldSpace(active.mouthOffset)
	end
	local cases, samples = 0, 0
	local corner = math.atan2(bait.Size.X, bait.Size.Z)
	for _, yaw in ipairs({ 0, math.pi / 2, math.pi / 4, corner, corner - 1e-7, corner + 1e-7 }) do
		for sector = 1, 3 do
			for _, jitter in ipairs({ -settings.SpawnAngleJitter, 0, settings.SpawnAngleJitter }) do
				for _, high in ipairs({ false, true }) do
					owner.spin = yaw
					local random = {
						NextInteger = function(_, low)
							return if low == 0 then 3 else sector
						end,
						NextNumber = function(_, low)
							return if low < 0 then jitter else low
						end,
					}
					local visualRandom = {
						NextInteger = function(_, low, maximum)
							return if high then maximum else low
						end,
						NextNumber = function(_, low, maximum)
							return if high then maximum else low
						end,
					}
					active = Bite.new(owner, 0, 0, random, visualRandom)
					local function onLine(point)
						assert(
							math.abs(((point - target) * flat):Cross(active.spawnDirection).Y) < epsilon,
							"Initial approach left line"
						)
					end
					for _, elapsed in ipairs({ 0, 0.001, 0.3, settings.AppearTime, settings.ApproachTime }) do
						local frame = pose("Approaching", elapsed)
						onLine(frame.Position)
						onLine(mouth(frame))
						assert(active:_scaleAt("Approaching", elapsed) == 1, "Fish grew while appearing")
					end
					sameFrame(pose("Approaching", settings.ApproachTime), pose("Holding", 0), "Approach/hold")
					for index = 1, 3 do
						active.timeline.nibbleIndex = index
						active.timeline.completedNibbles = index - 1
						local timing = active.timeline:GetNibbleTiming()
						local restTime = if index > 1 then active.repositions[index - 1].path.duration else 0
						local rest = pose("Holding", restTime)
						sameFrame(rest, pose("Nibbling", 0), "Hold/attack")
						for _, canonical in ipairs({ 0.12, 0.15, 0.18 }) do
							local elapsed = canonical / timing.nibbleSpeed
							local frame, baitPosition, _, rotation = pose("Nibbling", elapsed)
							local displayed = active:_pose("Nibbling", elapsed, target, poseClock + elapsed, nil, view.Position)
							local edge = baitPosition + active:_contactOffset(
								active:_feedingState("Nibbling", elapsed), owner.baitBaseSize * active:_baitScaleAt("Nibbling", elapsed)
							)
							assert((screen(mouth(displayed)) - screen(edge)).Magnitude < 1, "Nibble missed screen edge")
							assert(mouth(frame).Y <= mouth(rest).Y + epsilon, "Nibble rose out of water")
							assert(math.abs(frame.LookVector.Y) <= math.sin(math.rad(3)), "Nibble tilted too far")
							assert(rotation.RightVector:Dot(active.baitRotation.RightVector) > 0.99999, "Bait rotated")
						end
						close(select(2, pose("Nibbling", timing.duration)), target, "Bait did not rebound")
						local recovered = pose("Nibbling", timing.duration)
						active.timeline.completedNibbles = index
						sameFrame(recovered, pose("Holding", 0), "Recovery/turn")
						local duration = active.repositions[index].path.duration
						local after = pose("Holding", duration)
						local _, turn = rest.Rotation:ToObjectSpace(after.Rotation):ToAxisAngle()
						assert(
							turn >= math.rad(15) - epsilon and turn <= math.rad(45) + epsilon,
							"Final bearing out of bounds"
						)
						assert((mouth(after) - mouth(rest)).Magnitude > 0.25, "Head did not relocate")
						assert((after.Position - rest.Position).Magnitude > 0.25, "Body did not relocate")
						local yawAfter = active.motion.nibbles[index].yaw
						assert(after.LookVector:Dot(-active:_outward(yawAfter)) > 0.99999, "Fish did not face bait")
						local returnAt = timing.returnAt
						local carried = timing.duration - returnAt
						local function returning(time)
							if time <= carried then
								active.timeline.completedNibbles = index - 1
								return pose("Nibbling", returnAt + time)
							end
							active.timeline.completedNibbles = index
							return pose("Holding", time - carried)
						end
						for sample = 1, 60 do
							local time = duration * sample / 61
							local earlier, later = returning(time - 0.0001), returning(time + 0.0001)
							local frame = returning(time)
							local velocity = later.Position - earlier.Position
							assert(frame.LookVector:Dot(velocity.Unit) > 0.999, "Body did not swim forward along path")
						end
						for _, boundary in ipairs({ 0, carried, duration }) do
							sameFrame(
								returning(math.max(0, boundary - 1e-6)),
								returning(boundary + 1e-6),
								"Return path boundary"
							)
						end
						active.timeline.completedNibbles = index
						sameFrame(after, pose("Holding", duration + 1), "Return did not stop")
						samples += 60
					end
					sameFrame(pose("Holding", active.repositions[3].path.duration), pose("Bite", 0), "Last return/bite")
					for _, elapsed in ipairs({ 0.15, 0.4, 0.999 }) do
						local frame, baitPosition = pose("Bite", elapsed)
						local bounce = Elastic.Sample("Bite", elapsed)
						close(baitPosition, target + Vector3.yAxis * owner.baitBaseSize.Y * (bounce - 0.65), "True bite depth/hold")
						close(
							mouth(frame),
							baitPosition + active:_contactOffset(
								active:_feedingState("Bite", elapsed), owner.baitBaseSize * active:_baitScaleAt("Bite", elapsed)
							),
							"True bite missed edge"
						)
					end
					-- 鱼饵旋转任意角度时，嘴部交点仍落在矩形近侧边界。
					local localContact =
						active.baitRotation:PointToObjectSpace(active:_contactOffset((active:_feedingState("Bite", 0))))
					local half = bait.Size * 0.5
					assert(
						math.abs(localContact.X) <= half.X + epsilon and math.abs(localContact.Z) <= half.Z + epsilon,
						"Contact outside bait"
					)
					assert(
						math.min(
							math.abs(math.abs(localContact.X) - half.X),
							math.abs(math.abs(localContact.Z) - half.Z)
						) < epsilon,
						"Contact missed boundary"
					)
					-- 检查尚未渲染真咬第一帧、下沉途中、窗口末端的提竿。
					poseClock = 20
					for _, elapsed in ipairs({ 0, 0.04, 0.149, 0.2, settings.HookWindow - 0.001 }) do
						active.timeline:_enter("Bite", 20, settings.HookWindow)
						active.biteSoundPlayed = nil
						local expected, expectedBait, _, expectedRotation = pose("Bite", elapsed)
						local beforeSounds = sounds
						assert(active:TryHook(20 + elapsed))
						local actual, actualBait, _, actualRotation = pose("Struggling", 0)
						sameFrame(expected, actual, "Hook transition")
						close(expectedBait, actualBait, "Hook moved bait")
						assert(
							expectedRotation.LookVector:Dot(actualRotation.LookVector) > 0.99999,
							"Hook rotated bait"
						)
						active:_biteSound()
						assert(sounds == beforeSounds + 1, "Cue duplicated")
					end
					local finish = pose("Struggling", settings.StruggleTime)
					sameFrame(finish, pose("Lifting", 0), "Struggle/lift")
					local initial = pose("Struggling", 0)
					local initialRadius = ((initial.Position - target) * flat).Magnitude
					local previousRadius, previousRadial
					for sample = 0, 180 do
						local time = sample / 60
						-- 缩圈与切线检查基础路径；绕嘴部的姿态补偿会轻微移动鱼身中心。
						local frame = active:_basePose("Struggling", time, target)
						local delta = (frame.Position - target) * flat
						local radial = delta.Magnitude
						if time <= settings.Struggle.BlendTime then
							assert(radial >= (previousRadius or initialRadius) - epsilon, "Orbit did not expand initially")
						else
							assert(radial <= previousRadius + epsilon, "Orbit grew after initial expansion")
						end
						if math.abs(time - settings.Struggle.BlendTime) < 1e-7 then
							assert(math.abs(radial / initialRadius - 1.2) < epsilon, "Initial expansion missed 1.2x radius")
						end
						if previousRadial then
							assert(previousRadial:Cross(delta.Unit).Y * active.motion.mirror < 1e-5, "Orbit reversed")
						end
						if time > settings.Struggle.BlendTime and time < settings.StruggleTime then
							local earlier = active:_basePose("Struggling", time - 0.0001, target)
							local later = active:_basePose("Struggling", time + 0.0001, target)
							-- 弹性表现另有上下浮动，绕圈朝向跟随水平切线。
							local velocity = ((later.Position - earlier.Position) * flat).Unit
							assert((frame.LookVector * flat).Unit:Dot(velocity) > 0.999, "Orbit body missed tangent")
						end
						previousRadius, previousRadial = radial, delta.Unit
					end
					assert(
						math.abs(previousRadius / initialRadius - active.motion.orbit.endRadius) < epsilon,
						"Final radius wrong"
					)
					for _, boundary in ipairs({ 0, settings.Struggle.BlendTime, settings.StruggleTime }) do
						sameFrame(
							pose("Struggling", math.max(0, boundary - 1e-6)),
							pose("Struggling", boundary + 1e-6),
							"Orbit boundary"
						)
					end
					for _, rate in ipairs({ 15, 30, 60, 144 }) do
						for sample = 0, rate * 3 do
							pose("Struggling", sample / rate)
						end
						sameFrame(finish, pose("Struggling", 3), "Frame rate changed path")
					end
					active:Destroy()
					active = nil
					cases += 1
					if cases % 6 == 0 then
						task.wait()
					end
				end
			end
		end
	end
	return { passed = true, cases = cases, relocationSamples = samples }
end, debug.traceback)
if active then
	active:Destroy()
end
folder:Destroy()
assert(ok, result)
return result
