-- Studio Client：不同速度组合通过正式 Update/Present，校验时序、鱼饵、事件及提竿衔接。
local storage = game:GetService("ReplicatedStorage")
local Bite = require(storage.Modules.FishingBiteSequence)
local Elastic = require(storage.Modules.BaitElasticMotion)
local settings = require(storage.Modules.FishingConfig).Bite
local folder = Instance.new("Folder")
folder.Name, folder.Parent = "FishingRhythmValidation", workspace
local active
local ok, result = xpcall(function()
	local bait = storage.Models.FishBait["1"]["1"]:Clone()
	bait.Anchored, bait.Parent = true, folder
	local baseSize = bait.Size
	local target = Vector3.new(0, 1000, 0)
	local owner = {
		folder = folder, bait = bait, forward = Vector3.zAxis,
		continueLabel = {},
		_waterTarget = function() return target end,
		_presentBait = function() end, _setPhase = function() end, _impulse = function() end,
	}
	local cases, samples, cues, touches, ripples = 0, 0, 0, {}, {}
	function owner:_sound(name)
		assert(name == "FishBite", "Unexpected cue")
		cues += 1
	end
	function owner:_waterFeedback() end
	function owner:_playWaterVFX() end
	function owner:_nibbleRipple(now, _position)
		local timeline = active.timeline
		local threshold = timeline:GetNibbleTiming().attackTime * settings.Nibble.RippleTriggerRatio
		local elapsed = now - timeline.startedAt
		assert(timeline.phase == "Nibbling" and elapsed >= threshold
			and elapsed - threshold <= owner.sampleStep + 1e-6,
			"Ripple feedback used the wrong clock")
		local index = timeline.nibbleIndex
		ripples[index] = (ripples[index] or 0) + 1
		assert(ripples[index] == 1, "Ripple feedback duplicated")
	end
	function owner:_nibbleFeedback(now, _position)
		local timeline = active.timeline
		local timing = timeline:GetNibbleTiming()
		local elapsed = now - timeline.startedAt
		assert(timeline.phase == "Nibbling" and elapsed >= timing.attackTime
			and elapsed - timing.attackTime <= owner.sampleStep + 1e-6,
			"Touch feedback used the wrong clock")
		local index = timeline.nibbleIndex
		assert(ripples[index] == 1, "Contact feedback preceded the early ripple")
		touches[index] = (touches[index] or 0) + 1
		assert(touches[index] == 1, "Touch feedback duplicated")
	end
	local function gameplay(count)
		return {
			NextInteger = function(_, low) return if low == 0 then count else 1 end,
			NextNumber = function(_, low) return if low < 0 then 0 else 1 end,
		}
	end
	for _, fastNibble in ipairs({ false, true }) do
		for _, count in ipairs({ 0, 3, settings.MaxNibbles }) do
			local referenceAt
			for _, rate in ipairs({ 15, 30, 60, 144 }) do
				local visual = {
					NextInteger = function() return 1 end,
					NextNumber = function(_, low, high)
						if low == settings.Nibble.SpeedMin and high == settings.Nibble.SpeedMax then
							return if fastNibble then high else low
						elseif low == settings.Nibble.ReturnSpeedMin and high == settings.Nibble.ReturnSpeedMax then
							return if fastNibble then low else high
						end
						return (low + high) / 2
					end,
				}
				cues, touches, ripples = 0, {}, {}
				owner.sampleStep = 1 / rate
				active = Bite.new(owner, 0, 0, gameplay(count), visual)
				local timeline = active.timeline
				for index, entry in ipairs(active.motion.nibbles) do
					local path = active.repositions[index].path
					local speed = settings.ApproachDistance / settings.ApproachTime
						* settings.Nibble.ReturnSpeedScale * entry.returnSpeed
					assert(math.abs(path.speed - speed) < 1e-8, "Return speed did not use its own multiplier")
					assert(math.abs(path.ramp - settings.Nibble.ReturnRampTime) < 1e-8, "Return ramp changed")
				end
				local reference = Bite.NewTimeline(0, gameplay(count), 0)
				reference.nibbleTimings, reference.repositionDurations = timeline.nibbleTimings, timeline.repositionDurations
				while reference.phase ~= "Bite" do
					reference:Advance(reference.endsAt)
				end
				local biteAt = reference.startedAt
				assert(not referenceAt or referenceAt == biteAt, "Frame rate changed bite time")
				referenceAt = biteAt
				local now = 0
				while now < biteAt do
					active:Update(now)
					local phase = timeline.phase
					local elapsed = now - timeline.startedAt
					local _, scale = Elastic.Sample(phase, elapsed, timeline.endsAt - timeline.startedAt,
						timeline:GetNibbleTiming().nibbleSpeed)
					assert((bait.Size - baseSize * scale).Magnitude < 0.001, "Presented bait used the wrong clock")
					assert(cues == 0, "Fake bite played true bite cue")
					if phase == "Nibbling" then
						local timing = timeline:GetNibbleTiming()
						assert(math.abs(timeline.endsAt - timeline.startedAt - timing.duration) < 1e-8,
							"Nibble duration did not follow its sampled speed")
					end
					samples += 1
					now = math.min(biteAt, now + 1 / rate)
				end
				active:Update(biteAt + 0.1)
				for index = 1, count do
					assert(touches[index] == 1, "Render step skipped a fast nibble's contact feedback")
					assert(ripples[index] == 1, "Render step skipped a fast nibble's early ripple")
				end
				assert(timeline.phase == "Bite" and timeline.completedNibbles == count and cues == 1,
					"Final return lost the true bite or cue")
				assert(math.abs(timeline.endsAt - biteAt - 0.6) < 1e-8, "Hook window changed")
				local fishFrame, baitFrame, size = active.fish.PrimaryPart.CFrame, bait.CFrame, bait.Size
				assert(active:TryHook(biteAt + 0.1) and cues == 1, "Hook or cue deduplication failed")
				active:Update(biteAt + 0.1)
				assert((active.fish.PrimaryPart.Position - fishFrame.Position).Magnitude < 0.001, "Hook moved fish")
				assert(active.fish.PrimaryPart.CFrame.LookVector:Dot(fishFrame.LookVector) > 0.99999, "Hook turned fish")
				assert((bait.Position - baitFrame.Position).Magnitude < 0.001 and (bait.Size - size).Magnitude < 0.001,
					"Hook jumped bait")
				local escaped = Bite.NewTimeline(0, gameplay(count), 0)
				escaped.nibbleTimings, escaped.repositionDurations = timeline.nibbleTimings, timeline.repositionDurations
				assert(escaped:Advance(biteAt + settings.HookWindow + 0.01) == "Escaped", "Long frame lost timeout")
				assert(escaped:CanRetry(biteAt + settings.HookWindow + settings.EscapeTime + 0.01), "Retry stayed blocked")
				local fish, animation = active.fish, active.animation
				active:Destroy()
				assert(not fish.Parent and animation.destroyed and not next(animation.tracks), "Resources survived cleanup")
				active = nil
				-- 一次长帧跨过全部假咬与真咬，不补播过期的波纹、粒子或声音。
				cues, touches, ripples = 0, {}, {}
				active = Bite.new(owner, 0, 0, gameplay(count), visual)
				active:Update(biteAt + settings.HookWindow + 0.01)
				assert(cues == 0 and not next(touches) and not next(ripples), "Long frame replayed expired feedback")
				active:Destroy()
				active = nil
				cases += 1
				task.wait()
			end
		end
	end
	return { passed = true, cases = cases, samples = samples }
end, debug.traceback)
if active then
	active:Destroy()
end
folder:Destroy()
assert(ok, result)
return result
