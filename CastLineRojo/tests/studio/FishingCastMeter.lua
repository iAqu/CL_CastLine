-- 在 Studio Client 执行；试听临时音效，不修改 GUI、镜头或当前钓鱼会话。
local storage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local Cast = require(storage.Modules.FishingCastSequence)
local Config = require(storage.Modules.FishingConfig)
local Audio = require(storage.Modules.FishingAudio)
local soundService = game:GetService("SoundService")
assert(Config.Meter.BaseSpeed == 0.55 and Config.Meter.TopSpeedFactor == 2.6,
	"Restart Play after Rojo sync to load the reference meter settings")

local folder = Instance.new("Folder")
folder.Name, folder.Parent = "FishingCastMeterValidation", game:GetService("SoundService")
local assets, seen = {}, {}
local report = { played = {}, loaded = {}, frames = 0, sweeps = {}, readyTicks = 0 }
local enabled = true
local owner = setmetatable({
	phase = "Preparing", fixedCast = true, fullLuck = 10,
	meterProgress = 0, meterDirection = 1, lastMeterStep = 0,
	impulses = {}, flash = {},
	meter = { marker = {} }, folder = folder, sounds = {},
	options = { isSoundEnabled = function() return enabled end },
	info = {
		SetLuck = function(self, value) self.shown = value end,
		Update = function() end,
	},
	_sound = function(self, name, volume, pitch)
		local sound = Cast._sound(self, name, volume, pitch)
		if sound then
			if name == "MeterTick" then
				assert(sound.IsLoaded and sound.TimeLength > 0,
					"MeterTick must already be loaded at playback; no test-owned warm sound may mask a delay")
				report.readyTicks += 1
			end
			table.insert(report.played, {
				name = name, volume = sound.Volume, pitch = sound.PlaybackSpeed,
				duration = sound.TimeLength / sound.PlaybackSpeed,
			})
		end
		return sound
	end,
}, Cast)
local ok, err = xpcall(function()
	Audio.PreloadLuckSounds()
	local cache
	local deadline = os.clock() + 10
	repeat
		cache = soundService:FindFirstChild("FishingMeterTickCache")
		if cache and cache.IsLoaded then break end
		task.wait(0.05)
	until os.clock() >= deadline
	assert(cache and cache.IsLoaded and cache.SoundId == Config.Sounds.MeterTick.Id,
		"Production startup must keep a loaded MeterTick cache; restart Play after Rojo sync")
	assert(cache.Volume == 0 and not cache.IsPlaying, "The resident resource must never play")
	table.insert(report.loaded, { id = cache.SoundId, length = cache.TimeLength })
	-- 只为现有确认音预热；MeterTick 必须完全依赖正式代码的常驻缓存。
	for _, name in { "ButtonClick", "Perfect" } do
		local id = Config.Sounds[name].Id
		if not seen[id] then
			seen[id] = true
			local sound = Instance.new("Sound")
			sound.SoundId = id
			sound.Parent = folder
			table.insert(assets, sound)
		end
	end
	assert(#assets == 2, "The test must not create its own MeterTick warm resource")
	game:GetService("ContentProvider"):PreloadAsync(assets)
	for _, sound in assets do
		assert(sound.IsLoaded and sound.TimeLength > 0, "Audio failed to load: " .. sound.SoundId)
		table.insert(report.loaded, { id = sound.SoundId, length = sound.TimeLength })
	end
	for round = 1, 3 do
		local startedWith = #report.played
		owner.meterProgress, owner.meterDirection, owner.lastMeterStep = 0, 1, 0
		owner:_updatePresentation(os.clock(), 0)
		assert(#report.played == startedWith, "Initialization must be quiet")
		local expected, direction, step, reachedTop = 0, 1, 0, false
		deadline = os.clock() + 6
		repeat
			local dt = runService.RenderStepped:Wait()
			expected += direction * 0.55 * (1 + 1.6 * expected) * dt
			if expected >= 1 then
				expected, direction, reachedTop = 1, -1, true
			elseif expected <= 0 then
				expected, direction = 0, 1
			end
			local before = #report.played
			owner:_updatePresentation(os.clock(), dt)
			assert(math.abs(owner.meterProgress - expected) < 1e-8 and owner.meterDirection == direction,
				"Live meter must match Throw Food's integration")
			assert(math.abs(owner.info.shown - 10 * (0.1 + 0.9 * expected)) < 1e-8,
				"Live luck must follow the visible meter")
			local nextStep = math.floor(expected * 6)
			assert(#report.played - before == (if nextStep ~= step then 1 else 0),
				"Each sampled step must play once without cooldown")
			step = nextStep
			report.frames += 1
			assert(os.clock() < deadline, "Meter failed to complete a full sweep")
		until reachedTop and expected == 0
		table.insert(report.sweeps, #report.played - startedWith)
		assert(cache.Parent == soundService and cache.IsLoaded, "Finished ticks must not evict the resident resource")
		if round < 3 then
			task.wait(1.2)
		end
	end
	report.sweepTicks = #report.played
	enabled = false
	owner:RefreshSoundSetting()
	owner:_updatePresentation(os.clock(), 0.5)
	enabled = true
	owner:_updatePresentation(os.clock(), 0)
	assert(#report.played == report.sweepTicks, "Unmuting must not replay consumed steps")
	for _, progress in { 0.919999, 0.92 } do
		owner.lockedMeterProgress, owner.meterProgress = nil, progress
		local before = #report.played
		owner:LockCastMeter()
		local count = if progress >= 0.92 then 2 else 1
		assert(#report.played == before + count, "Confirm once, with a perfect cue at 92%")
		local cue = report.played[before + 1]
		assert(cue.name == "ButtonClick" and math.abs(cue.volume - 0.8) < 1e-6
			and math.abs(cue.pitch - (0.9 + progress * 0.5)) < 1e-6, "Incorrect confirmation mix")
		if count == 2 then
			cue = report.played[before + 2]
			assert(cue.name == "Perfect" and math.abs(cue.volume - 0.5) < 1e-6
				and math.abs(cue.pitch - 1.3) < 1e-6,
				"Incorrect perfect confirmation mix")
		end
		owner:_updatePresentation(os.clock(), 1)
		owner:LockCastMeter()
		assert(owner.meterProgress == progress and #report.played == before + count,
			"Locked progress must freeze and ignore repeated confirmation")
		local tail = 0
		for index = before + 1, #report.played do
			tail = math.max(tail, report.played[index].duration)
		end
		task.wait(tail + 0.1)
	end
end, debug.traceback)
for _, sound in assets do
	sound:Destroy()
end
folder:Destroy()
assert(ok, err)
return report
