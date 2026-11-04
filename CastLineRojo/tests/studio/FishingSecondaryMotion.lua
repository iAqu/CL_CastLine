-- Studio Client: actual path banking, scaled mouth pivot and deterministic secondary poses.
local storage = game:GetService("ReplicatedStorage")
local Bite = require(storage.Modules.FishingBiteSequence)
local settings = require(storage.Modules.FishingConfig).Bite
local folder = Instance.new("Folder")
folder.Name, folder.Parent = "FishingSecondaryValidation", workspace
local active
local ok, result = xpcall(function()
	local bait = storage.Models.FishBait["1"]["1"]:Clone()
	bait.Anchored, bait.Parent = true, folder
	local target = Vector3.new(10, 1000, 30)
	local owner = { folder = folder, bait = bait, forward = Vector3.zAxis }
	local samples, maxError, maxBank = 0, 0, 0
	for _, mirror in ipairs({ -1, 1 }) do
		active = Bite.new(owner, 100, 100, Random.new(1), Random.new(2))
		active.motion.mirror = mirror
		for _, scale in ipairs({ 0.65, 1, 1.45 }) do
			active.scale = scale
			active.fish:ScaleTo(active.baseScale * scale)
			for _, phase in ipairs({ "Approaching", "Struggling", "Caught", "Escaped" }) do
				for _, at in ipairs({ 0, 0.15, 0.55, 0.65, 1.25, 2.999, 4.2 }) do
					local request = if phase == "Caught" and at >= 4
						then { name = "ShowcaseFlop", position = at - 4 }
						else nil
					local base = active:_basePose(phase, at, target)
					if phase == "Struggling" and at >= settings.Struggle.BlendTime then
						assert(math.abs(base.Position.Y - target.Y + active.depth) < 0.001, "Fish inherited bait bounce")
					end
					local expected = active:_pose(phase, at, target, 100 + at, request)
					local mouth = active.mouthOffset * scale
					local error = (expected:PointToWorldSpace(mouth) - base:PointToWorldSpace(mouth)).Magnitude
					maxError = math.max(maxError, error)
					assert(error < 0.001, "Secondary rotation moved the scaled mouth")
					if phase == "Caught" then
						assert((active.showcasePosition - base.Position).Magnitude < 0.001, "Camera followed sway")
					end
					if phase == "Struggling" and at == 0.55 then
						local _, _, roll = base:ToObjectSpace(expected):ToEulerAnglesXYZ()
						local step = settings.Motion.Secondary.Bank.SampleInterval
						local before = active:_basePose(phase, at - step, target)
						local after = active:_basePose(phase, at + step, target)
						assert(roll * before.LookVector:Cross(after.LookVector).Y > 0, "Bank tilted outside the turn")
						maxBank = math.max(maxBank, math.abs(roll))
						assert(math.abs(roll) <= math.rad(4) + 0.0001, "Bank exceeded limit")
					end
					for _, rate in ipairs({ 15, 30, 60, 144 }) do
						for index = 0, math.floor(at * rate) do
							active:_pose(phase, index / rate, target, 100 + index / rate)
						end
						local actual = active:_pose(phase, at, target, 100 + at, request)
						assert(actual:FuzzyEq(expected, 0.0001), "Pose depends on frame history")
						samples += 1
					end
				end
			end
		end
		active.scale = 1
		local endStruggle = active:_pose("Struggling", settings.StruggleTime, target)
		local startLift = active:_pose("Lifting", 0, target)
		assert(endStruggle:FuzzyEq(startLift, 0.0001), "Bank jumped at lift transition")
		local endLift = active:_pose("Lifting", settings.LiftTime, target)
		local startCaught = active:_pose("Caught", 0, target)
		assert(endLift:FuzzyEq(startCaught, 0.0001), "Sway jumped at showcase transition")
		active:Destroy()
		active = nil
	end
	return { passed = true, samples = samples, maxMouthError = maxError, maxBankDegrees = math.deg(maxBank) }
end, debug.traceback)
if active then
	active:Destroy()
end
folder:Destroy()
assert(ok, result)
return result
