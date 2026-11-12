-- Studio Client：真实收竿弹簧首次越过水面时播放失败音，随后回弹及展示不重播。
local storage = game:GetService("ReplicatedStorage")
local Audio = require(storage.Modules.FishingAudio)
local Bite = require(storage.Modules.FishingBiteSequence)
local Reel = require(storage.Modules.FishingReelSpring)
local Water = require(storage.Modules.WaterSurfaceUtil)
local waterY = assert(Water.GetWaterSurfaceY(), "Water surface is missing")
game:GetService("ContentProvider"):PreloadAsync({ storage.Sound.Fishing.FishFail })
local audio, motion
local cases = {}
local ok, err = xpcall(function()
	for _, withFish in ipairs({ false, true }) do
		audio = Audio.new(function()
			return true
		end)
		local started = os.clock()
		motion = Reel.new(Vector3.new(0, -0.08, 0), 1.4, started)
		local probe = setmetatable({
			owner = { fishAudio = audio },
			reelMotion = motion,
			reelFish = if withFish then {} else nil,
		}, Bite)
		local target = Vector3.new(0, waterY + 0.21, 0)
		local count, crossingAt, crossingHeight = 0, nil, nil
		local play = audio.Play
		audio.Play = function(self, name)
			assert(name == "FishFail", "Unexpected reel audio")
			count += 1
			crossingAt, crossingHeight = os.clock(), target.Y + motion.position.Y
			assert(motion.lifting and crossingHeight > Water.GetWaterSurfaceY(), "Failure audio started underwater")
			return play(self, name)
		end
		local settled = false
		while not settled and os.clock() - started < 5 do
			local now = os.clock()
			local _, finished = motion:Update(now)
			probe:_updateReelSurface(now, target)
			if not probe.reelSurfaced then
				assert(count == 0, "Failure audio played before surfacing")
			end
			settled = finished
			task.wait()
		end
		assert(settled and count == 1, "Surface crossing was missed or repeated")
		audio:SetPhase("Reeled")
		audio:SetPhase("Reeled")
		probe:_updateReelSurface(os.clock(), target)
		assert(count == 1, "Settled showcase replayed failure audio")
		if withFish then
			assert(probe.reelFish.startedAt ~= nil, "Nearby fish did not escape on surfacing")
		end
		table.insert(
			cases,
			{
				withFish = withFish,
				played = count,
				at = crossingAt - started,
				heightAboveWater = crossingHeight - waterY,
			}
		)
		audio:Destroy(false)
		motion:Destroy()
	end
end, debug.traceback)
if audio then
	audio:Destroy(false)
end
if motion then
	motion:Destroy()
end
assert(ok, err)
return cases
