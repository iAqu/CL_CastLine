-- Studio Client 回归：基础轨迹、鱼嘴支点、朝向和固定鱼饵的边缘接触。
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Bite = require(ReplicatedStorage.Modules.FishingBiteSequence)
local settings = require(ReplicatedStorage.Modules.FishingConfig).Bite
local folder = Instance.new("Folder")
folder.Name, folder.Parent = "FishingStraightApproachValidation", workspace
local active
local horizontal = Vector3.new(1, 0, 1)
local epsilon = 0.0001

local ok, result = xpcall(function()
	local bait = ReplicatedStorage.Models.FishBait["1"]["1"]:Clone()
	bait.Anchored, bait.Transparency, bait.Parent = true, 1, folder
	local owner = { folder = folder, forward = Vector3.zAxis, bait = bait }
	local target = Vector3.new(10, 20, 30)
	local corner = math.atan2(bait.Size.X, bait.Size.Z)
	local yaws = {
		0,
		math.pi * 0.5,
		math.pi * 0.25,
		math.rad(37),
		corner,
		corner - 0.0000001,
		corner + 0.0000001,
		0.0000001,
		math.pi * 0.5 - 0.0000001,
	}
	local samples = {
		Approaching = { 0, 0.001, 0.1, 0.3, settings.AppearTime, settings.ApproachTime - 0.001, settings.ApproachTime },
		Holding = { 0, 0.2, 0.7 },
		Nibbling = {
			0,
			settings.NibbleTime * 0.25,
			settings.NibbleTime * 0.5,
			settings.NibbleTime * 0.75,
			settings.NibbleTime,
		},
		Bite = { 0, settings.BiteSinkTime * 0.5, settings.BiteSinkTime, settings.BiteSinkTime + 0.2 },
	}
	local cases, poses = 0, 0
	for _, yaw in ipairs(yaws) do
		for sector = 1, 3 do
			for _, jitter in ipairs({ -settings.SpawnAngleJitter, 0, settings.SpawnAngleJitter }) do
				owner.spin = yaw
				active = Bite.new(owner, 0, 0, {
					NextInteger = function(_, low)
						return if low == 0 then 0 else sector
					end,
					NextNumber = function(_, low)
						return if low == 1 then 2 elseif low < 0 then jitter else 1
					end,
				})
				local motion = active.motion
				active.motion = {
					Sample = function()
						return 0, 0, 0
					end,
				}
				local outward = active.spawnDirection
				local function onLine(point, message)
					local delta = (point - target) * horizontal
					assert(math.abs(delta:Cross(outward).Y) < epsilon, message)
				end
				for phase, times in pairs(samples) do
					for _, elapsed in ipairs(times) do
						active.scale = active:_scaleAt(phase, elapsed)
						local frame, _, _, rotation = active:_pose(phase, elapsed, target, 10 + elapsed)
						onLine(frame.Position, phase .. " center left the approach line")
						onLine(
							frame:PointToWorldSpace(active.mouthOffset * active.scale),
							phase .. " mouth left the approach line"
						)
						local heading = (frame.LookVector * horizontal).Unit
						assert(heading:Dot(-outward) > 0.99999, phase .. " turned toward a different heading")
						assert(
							rotation.RightVector:Dot(active.baitRotation.RightVector) > 0.99999,
							"Bait rotated to face fish"
						)
						poses += 1
					end
				end
				-- 用几何约束验证交点，不复制生产代码的射线算法。
				for _, scale in ipairs({ settings.AppearScale, 0.5, 1 }) do
					active.scale = scale
					local baitPosition = target - Vector3.yAxis * settings.BiteDepth
					local frame = active:_biteFrame(baitPosition)
					local contact = frame:PointToWorldSpace(active.mouthOffset * scale)
					onLine(contact, "Contact is not on spawn ray")
					assert(((contact - target) * horizontal):Dot(outward) > 0, "Contact is on far side of bait")
					local localContact = (CFrame.new(baitPosition) * active.baitRotation):PointToObjectSpace(contact)
					local half = bait.Size * 0.5
					assert(math.abs(localContact.Y) < epsilon, "Contact is not at middle height")
					assert(
						math.abs(localContact.X) <= half.X + epsilon and math.abs(localContact.Z) <= half.Z + epsilon,
						"Contact is outside bait"
					)
					assert(
						math.min(
							math.abs(math.abs(localContact.X) - half.X),
							math.abs(math.abs(localContact.Z) - half.Z)
						) < epsilon,
						"Contact is not on bait boundary"
					)
				end
				active.scale = 1
				local function mouthAt(phase, elapsed)
					local frame = active:_pose(phase, elapsed, target, 10)
					return frame:PointToWorldSpace(active.mouthOffset)
				end
				local rest = mouthAt("Holding", 0)
				assert(
					(mouthAt("Approaching", settings.ApproachTime) - rest).Magnitude < epsilon,
					"Approach/holding jumped"
				)
				assert((mouthAt("Nibbling", 0) - rest).Magnitude < epsilon, "Holding/nibble jumped")
				assert((mouthAt("Nibbling", settings.NibbleTime) - rest).Magnitude < epsilon, "Nibble recovery jumped")
				assert((mouthAt("Bite", 0) - rest).Magnitude < epsilon, "Holding/bite jumped")
				assert(
					(mouthAt("Bite", settings.BiteSinkTime) - mouthAt("Struggling", 0)).Magnitude < epsilon,
					"Hook transition moved mouth"
				)
				active.motion = motion
				for _, phase in ipairs({ "Approaching", "Holding", "Nibbling", "Bite" }) do
					for index = 1, 5 do
						onLine(mouthAt(phase, index * 0.05), "Body sway displaced mouth from approach line")
					end
				end
				active:Destroy()
				active = nil
				cases += 1
				if cases % 9 == 0 then
					task.wait()
				end
			end
		end
	end
	return {
		passed = true,
		cases = cases,
		basePoses = poses,
		checks = "spawn sectors/jitter, fixed bait yaw, straight center/mouth, constant heading, edge/corner contact, phase continuity, scaled mouth, body sway",
	}
end, debug.traceback)
if active then
	active:Destroy()
end
folder:Destroy()
assert(ok, result)
return result
