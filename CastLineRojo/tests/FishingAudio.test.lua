local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end
local config = assert(loadstring(read("src/ReplicatedStorage/Modules/FishingConfig.lua")))()
local function signal()
	local listeners = {}
	return {
		Once = function(_, callback)
			local connection = { connected = true }
			function connection:Disconnect()
				self.connected = false
			end
			table.insert(listeners, { callback, connection })
			return connection
		end,
		Fire = function()
			for _, entry in ipairs(listeners) do
				if entry[2].connected then
					entry[2].connected = false
					entry[1]()
				end
			end
		end,
	}
end
local enabled, warnings = true, 0
local soundService = {}
local templates, clones, folders, timers = {}, {}, {}, {}
local preloadTasks, preloadObjects = {}, {}
local preloadCalls, failPreload, failMeterLoad = 0, false, false
local contentProvider = {
	PreloadAsync = function(_, sounds)
		preloadCalls += 1
		assert(#sounds == 3, "Preload the three unique meter, click and perfect resources")
		local ids = {}
		for _, source in sounds do
			assert(not ids[source.SoundId] and not source.plays, "Preloading must deduplicate assets and never play them")
			ids[source.SoundId] = true
		end
		assert(ids[config.Sounds.MeterTick.Id] and ids[config.Sounds.LuckTick.Id]
			and ids[config.Sounds.ButtonClick.Id] and ids[config.Sounds.Perfect.Id],
			"Warm the light tick, shared integer/click sound and perfect confirmation")
		if failPreload then error("Simulated loading failure") end
		for _, source in sounds do
			source.IsLoaded = not (failMeterLoad and source.SoundId == config.Sounds.MeterTick.Id)
		end
	end,
}
local clock = 0
local function sound(name)
	local obj = {
		Name = name,
		SoundId = name .. "-asset",
		Volume = 0.37,
		PlaybackSpeed = 0.85,
		TimeLength = 3,
		Looped = false,
		PlayOnRemove = false,
		effect = "template-effect",
		Ended = signal(),
	}
	function obj:IsA(class)
		return class == "Sound"
	end
	function obj:Play()
		self.IsPlaying = true
		self.plays = (self.plays or 0) + 1
	end
	function obj:Destroy()
		self.destroyed = true
		self.IsPlaying = false
		self.Parent = nil
	end
	function obj:Clone()
		local copy = sound(self.Name)
		copy.Volume, copy.PlaybackSpeed, copy.effect, copy.Looped =
			self.Volume, self.PlaybackSpeed, self.effect, self.Looped
		table.insert(clones, copy)
		return copy
	end
	return obj
end
for _, name in ipairs({
	"FishingRodCast",
	"FishingBaitShow",
	"FishBiteHeavey",
	"FishBite",
	"FishReelLoop",
	"FishWaterOut",
	"FishDrop",
	"FishSuccess",
	"FishFlap",
	"FishFail",
}) do
	templates[name] = sound(name)
end
local fish = {
	FindFirstChild = function(_, name)
		return templates[name]
	end,
}
templates.Gui_Fuse_Success = sound("Gui_Fuse_Success")
local gui = {
	FindFirstChild = function(_, name)
		return if name == "Gui_Fuse_Success" then templates[name] else nil
	end,
}
local storage = {
	FindFirstChild = function()
		return {
			FindFirstChild = function(_, name)
				return if name == "Gui" then gui else fish
			end,
		}
	end,
}
local environment = setmetatable({
	game = {
		GetService = function(_, name)
			return if name == "ReplicatedStorage" then storage
				elseif name == "ContentProvider" then contentProvider
				elseif name == "SoundService" then soundService else {}
		end,
	},
	script = { Parent = { FishingConfig = "config" } },
	require = function()
		return config
	end,
	Instance = {
		new = function(class)
			if class == "Sound" then
				local source = sound("Preload")
				table.insert(preloadObjects, source)
				return source
			end
			assert(class == "Folder")
			local folder = {
				Destroy = function(self)
					self.destroyed = true
				end,
			}
			table.insert(folders, folder)
			return folder
		end,
	},
	task = {
		spawn = function(callback)
			table.insert(preloadTasks, callback)
		end,
		delay = function(seconds, callback)
			local timer = { at = clock + seconds, callback = callback }
			timers[timer] = true
			return timer
		end,
		cancel = function(timer)
			timers[timer] = nil
		end,
	},
	warn = function()
		warnings += 1
	end,
}, { __index = getfenv() })
local Audio = assert(load(read("src/ReplicatedStorage/Modules/FishingAudio.lua"), "FishingAudio", "t", environment))()
local function create()
	return Audio.new(function()
		return enabled
	end)
end
local function count(name)
	local total = 0
	for _, clone in ipairs(clones) do
		if clone.Name == name then
			total += clone.plays or 0
		end
	end
	return total
end
local function advance(seconds)
	clock += seconds
	for timer in pairs(timers) do
		if timer.at <= clock then
			timers[timer] = nil
			timer.callback()
		end
	end
end

local audio = create()
local appear = audio:Play("FishingBaitShow")
assert(appear.Volume == 0.37 and appear.PlaybackSpeed == 0.85 and not appear.Looped,
	"Bait appearance must preserve the Studio sound mix and play once")
enabled = false
audio:RefreshSoundSetting()
assert(appear.destroyed and audio:Play("FishingBaitShow") == nil,
	"Muting must stop the appearance cue and prevent new voices")
enabled = true
audio:RefreshSoundSetting()
assert(count("FishingBaitShow") == 1, "Unmuting must not replay appearance")
local appearTemplate = templates.FishingBaitShow
templates.FishingBaitShow = nil
local appearWarnings = warnings
assert(audio:Play("FishingBaitShow") == nil and audio:Play("FishingBaitShow") == nil)
assert(warnings == appearWarnings + 1, "Missing appearance sound must warn once without blocking")
templates.FishingBaitShow = appearTemplate
appear = audio:Play("FishingBaitShow")
audio:Destroy()
assert(appear.destroyed, "Exiting must immediately stop the appearance sound")
audio = create()
local cast = audio:Play("FishingRodCast")
assert(cast.Volume == 0.37 and cast.PlaybackSpeed == 0.85 and cast.effect == "template-effect")
assert(not cast.Looped and cast ~= templates.FishingRodCast)
cast.Ended:Fire()
assert(cast.destroyed and not next(audio.sounds), "Ended must release one-shots and their timers")
audio:SetPhase("Nibbling")
assert(count("FishBiteHeavey") == 0 and count("FishBite") == 0, "False bites must not play true-bite cues")
audio:SetPhase("Bite")
audio:SetPhase("Bite")
audio:SetPhase("Struggling")
audio:SetPhase("Struggling")
assert(count("FishBiteHeavey") == 1 and count("FishBite") == 1 and count("FishReelLoop") == 1,
	"A true bite must play both cues exactly once")
local loop = audio.loops.FishReelLoop
assert(loop.Looped and not templates.FishReelLoop.Looped, "Loop only the playback clone")
enabled = false
audio:RefreshSoundSetting()
assert(loop.destroyed and not next(audio.sounds), "Muting must immediately release all voices")
enabled = true
audio:RefreshSoundSetting()
audio:RefreshSoundSetting()
assert(count("FishReelLoop") == 2 and count("FishBiteHeavey") == 1 and count("FishBite") == 1,
	"Restore only the current loop, once")
loop = audio.loops.FishReelLoop
audio:SetPhase("Lifting")
assert(loop.destroyed and count("FishWaterOut") == 1)
audio:PlayShowcase()
assert(count("FishSuccess") == 1 and count("Gui_Fuse_Success") == 1, "Reveal must play success and cheer together")
for _, clone in clones do
	if clone.Name == "FishSuccess" or clone.Name == "Gui_Fuse_Success" then
		assert(clone.Volume == 0.37 and clone.PlaybackSpeed == 0.85 and clone.effect == "template-effect",
			"Both showcase sounds must preserve their Studio template mix and effects")
	end
end
audio:SetPhase("Caught")
audio:SetPhase("Caught")
assert(count("FishDrop") == 1 and count("FishSuccess") == 1 and count("Gui_Fuse_Success") == 1,
	"Caught must only add the drop cue without repeating the reveal sounds")

local function flap(phase, token, position, playing)
	audio:UpdateFlap(phase, { name = "ShowcaseFlop", token = token, position = position }, playing)
end
flap("Lifting", 1, 0.15, true)
flap("Caught", 1, 0.15, false)
flap("Caught", 1, 0.05, true)
assert(count("FishFlap") == 0)
flap("Caught", 1, 0.1, true)
flap("Caught", 1, 0.2, true)
flap("Caught", 2, 0.3, true)
flap("Caught", 2, 0.15, true)
assert(count("FishFlap") == 1, "Each real flop plays once; skip expired windows")
enabled = false
audio:RefreshSoundSetting()
flap("Caught", 3, 0.15, true)
enabled = true
flap("Caught", 3, 0.2, true)
flap("Caught", 4, 0.15, true)
assert(count("FishFlap") == 2, "Unmuting must not replay a muted flop")
audio:Destroy()
assert(folders[#folders].destroyed)

audio = create()
enabled = false
audio:PlayShowcase()
enabled = true
audio:RefreshSoundSetting()
assert(count("FishSuccess") == 1 and count("Gui_Fuse_Success") == 1, "Unmuting must not replay a muted showcase")
audio:PlayShowcase()
assert(count("FishSuccess") == 2 and count("Gui_Fuse_Success") == 2, "A later catch must play both sounds again")
local showcaseFolder = audio.folder
audio:Destroy()
assert(showcaseFolder.destroyed and not next(audio.sounds), "Abort must release both showcase sounds")
for _, clone in clones do
	if clone.Name == "FishSuccess" or clone.Name == "Gui_Fuse_Success" then
		assert(clone.destroyed, "No showcase sound may survive abort")
	end
end

audio = create()
local cheerTemplate, beforeWarnings = templates.Gui_Fuse_Success, warnings
templates.Gui_Fuse_Success = nil
audio:PlayShowcase()
audio:PlayShowcase()
assert(count("FishSuccess") == 4 and warnings == beforeWarnings + 1,
	"A missing cheer must warn once and leave the success cue functional")
templates.Gui_Fuse_Success = cheerTemplate
audio:Destroy()

audio = create()
enabled = false
audio:SetPhase("Bite")
enabled = true
audio:SetPhase("Bite")
audio:RefreshSoundSetting()
assert(count("FishBiteHeavey") == 1 and count("FishBite") == 1, "Muted one-shots must not be replayed")
audio:SetPhase("Escaped")
audio:SetPhase("Waiting")
audio:SetPhase("Reeling")
assert(count("FishFail") == 0 and not audio.loops.FishReelLoop)
audio:Play("FishFail")
audio:SetPhase("Reeled")
audio:SetPhase("Reeled")
assert(count("FishFail") == 1, "Showcase must not replay the surfaced failure cue")
local fail = clones[#clones]
local folder = audio.folder
audio:Destroy(true)
assert(fail.IsPlaying and not folder.destroyed, "Fail tail must survive normal return")
enabled = false
Audio.RefreshTails()
assert(fail.destroyed and folder.destroyed, "Muting after return must stop the detached tail")
enabled = true
Audio.RefreshTails()
assert(count("FishFail") == 1)

audio = create()
audio:Play("FishFail")
fail, folder = clones[#clones], audio.folder
audio:Destroy(true)
fail.Ended:Fire()
assert(folder.destroyed, "Natural tail completion must release its container")
audio = create()
audio:Play("FishFail")
fail = clones[#clones]
audio:Destroy(true)
local nextAudio = create()
assert(fail.destroyed, "A new session must clear the preceding tail")
nextAudio:Play("FishFail")
fail = clones[#clones]
nextAudio:Destroy(true)
Audio.ClearTails()
assert(fail.destroyed, "Death and abnormal cleanup must clear tails")

audio = create()
local saved = templates.FishWaterOut
local missingBefore = warnings
templates.FishWaterOut = nil
assert(audio:Play("FishWaterOut") == nil)
assert(audio:Play("FishWaterOut") == nil and warnings == missingBefore + 1)
templates.FishWaterOut = {
	IsA = function()
		return false
	end,
}
assert(audio:Play("FishWaterOut") == nil and warnings == missingBefore + 1)
templates.FishWaterOut = saved
local stuck = audio:Play("FishWaterOut")
advance(31)
assert(stuck.destroyed, "A sound which never emits Ended must still be released")
audio:Destroy()
assert(not next(timers), "Sound cleanup must not leave deferred callbacks")

local warningsBeforePreload = warnings
Audio.PreloadLuckSounds()
Audio.PreloadLuckSounds()
assert(#preloadTasks == 1 and preloadCalls == 0, "Start preloading once without blocking the caller")
preloadTasks[1]()
Audio.PreloadLuckSounds()
assert(preloadCalls == 1 and #preloadTasks == 1 and warnings == warningsBeforePreload,
	"Preload must succeed without new warnings and must not restart each fishing session")
local meterCache
for _, source in preloadObjects do
	if source.SoundId == config.Sounds.MeterTick.Id then
		meterCache = source
		assert(not source.destroyed and source.Parent == soundService and source.IsLoaded,
			"Keep the loaded meter resource resident after preloading, so new ticks do not load again")
		assert(source.Name == "FishingMeterTickCache" and source.Volume == 0 and not source.plays,
			"The resident meter cache must never play or emit sound")
	else
		assert(source.destroyed and source.Parent == nil, "Other cue preloads must retain their existing cleanup")
	end
end
assert(meterCache, "Preload must retain exactly the meter resource")
create():Destroy()
Audio.ClearTails()
Audio.PreloadLuckSounds()
assert(not meterCache.destroyed and meterCache.Parent == soundService and #preloadObjects == 3,
	"Returning from fishing and fishing again must reuse the same resident meter resource")
local failureAudio = assert(load(read("src/ReplicatedStorage/Modules/FishingAudio.lua"), "FishingAudio", "t", environment))()
local beforeWarnings = warnings
local beforeObjects = #preloadObjects
failPreload = true
failureAudio.PreloadLuckSounds()
preloadTasks[2]()
failureAudio.PreloadLuckSounds()
assert(preloadCalls == 2 and #preloadTasks == 2 and warnings == beforeWarnings + 1,
	"Loading failures must stay nonfatal and avoid repeated preload attempts")
for index = beforeObjects + 1, #preloadObjects do
	local source = preloadObjects[index]
	assert(source.destroyed and source.Parent == nil, "Loading failure must release temporary sounds too")
end
assert(not meterCache.destroyed, "A separate failed preload must not release the already loaded meter cache")

-- PreloadAsync 可能正常返回，但某个资源仍未加载；不能将它当成已就绪的缓存。
local unloadedAudio = assert(load(read("src/ReplicatedStorage/Modules/FishingAudio.lua"), "FishingAudio", "t", environment))()
beforeObjects, beforeWarnings = #preloadObjects, warnings
failPreload, failMeterLoad = false, true
unloadedAudio.PreloadLuckSounds()
preloadTasks[3]()
unloadedAudio.PreloadLuckSounds()
assert(preloadCalls == 3 and #preloadTasks == 3 and warnings == beforeWarnings + 1,
	"An unloaded meter resource must warn once without starting repeated preload tasks")
for index = beforeObjects + 1, #preloadObjects do
	assert(preloadObjects[index].destroyed, "Release resources if the meter failed to load")
end
