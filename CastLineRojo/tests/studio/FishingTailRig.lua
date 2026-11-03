-- Studio Client 回归：真实蒙皮模板、阶段摆尾、鱼嘴约束、缩放和克隆清理。
local storage = game:GetService("ReplicatedStorage")
local Bite = require(storage.Modules.FishingBiteSequence)
local settings = require(storage.Modules.FishingConfig).Bite
local template = storage.Models.Fish[settings.FishName]
local originalTail = template.PrimaryPart.FishBody.FishTail.Transform
local folder = Instance.new("Folder")
folder.Name, folder.Parent = "FishingTailRigValidation", workspace
local active
local ok, result = xpcall(function()
	local bait = storage.Models.FishBait["1"]["1"]:Clone()
	bait.Anchored, bait.Transparency, bait.Parent = true, 1, folder
	local target = Vector3.new(0, 1000, 0)
	local owner = {
		folder = folder,
		forward = Vector3.zAxis,
		bait = bait,
		statusLabel = Instance.new("TextLabel"),
		returnLabel = Instance.new("TextLabel"),
		_waterTarget = function()
			return target
		end,
		_presentBait = function() end,
		_waterFeedback = function() end,
		_impulse = function() end,
		_setPhase = function() end,
	}
	local phases = {
		{ "Approaching", settings.ApproachTime },
		{ "Holding", 1 },
		{ "Nibbling", settings.NibbleTime },
		{ "Bite", settings.HookWindow },
		{ "Struggling", settings.StruggleTime },
		{ "Lifting", settings.LiftTime },
		{ "Caught", 7 },
		{ "Escaped", settings.EscapeTime },
		{ "Reeling", 1 },
	}
	local samples, moving = 0, {}
	for cycle = 1, 3 do
		active = Bite.new(owner, 100, 100, Random.new(cycle))
		assert(active.tailBone and active.fish.PrimaryPart.HasSkinnedMesh, "Template has no usable skin")
		local root = active.fish.PrimaryPart.FishBody
		local rootRest = root.Transform
		local axis = active.tailBone.WorldCFrame:VectorToWorldSpace(active.tailAxis)
		assert(axis:Dot(active.fish.PrimaryPart.CFrame.UpVector) > 0.99999, "Tail axis is not fish vertical")
		local startedAt = 101
		for _, entry in ipairs(phases) do
			local phase, duration = entry[1], entry[2]
			active.timeline:_enter(phase, startedAt, duration)
			for index = 0, math.ceil(duration * 30) - 1 do
				local elapsed = math.min(index / 30, duration - 0.0001)
				local now = startedAt + elapsed
				active:Update(now)
				local expected = active.tailRest
					* CFrame.fromAxisAngle(active.tailAxis, active.motion:SampleTail(phase, elapsed, now))
				assert(active.tailBone.Transform:FuzzyEq(expected, 0.0001), "Tail pose was not applied in " .. phase)
				assert(root.Transform == rootRest, "Swimming moved the fixed head bone")
				if math.abs(active.motion:SampleTail(phase, elapsed, now)) > 0.01 then
					moving[phase] = true
				end
				if phase == "Bite" and elapsed >= settings.BiteSinkTime then
					local body = active.fish.PrimaryPart
					local mouth = body.CFrame:PointToWorldSpace(active.mouthOffset * active.scale)
					assert(
						(mouth - (bait.Position + active.contactOffset)).Magnitude < 0.001,
						"Tail moved mouth off bait"
					)
				end
				if phase == "Lifting" or phase == "Caught" then
					local mouth = active.fish.PrimaryPart.CFrame:PointToWorldSpace(active.mouthOffset * active.scale)
					assert((mouth - active.linePosition).Magnitude < 0.001, "Scaled mouth left fishing line")
				end
				samples += 1
			end
			startedAt += duration
		end
		local tail = active.tailBone
		active:Destroy()
		active:Destroy()
		assert(tail.Parent == nil and not active.fish.Parent, "Session left rig instances behind")
		assert(template.PrimaryPart.FishBody.FishTail.Transform == originalTail, "Session changed source template")
		active = nil
		task.wait()
	end
	for _, phase in ipairs({ "Approaching", "Holding", "Nibbling", "Struggling", "Lifting", "Caught", "Escaped" }) do
		assert(moving[phase], "No tail motion observed in " .. phase)
	end
	owner.statusLabel:Destroy()
	owner.returnLabel:Destroy()
	return {
		passed = true,
		cycles = 3,
		samples = samples,
		checks = "skin, axis, all phases, fixed head, bait/line contact, scale, showcase, clone isolation, cleanup",
	}
end, debug.traceback)
if active then
	active:Destroy()
end
folder:Destroy()
assert(ok, result)
return result
