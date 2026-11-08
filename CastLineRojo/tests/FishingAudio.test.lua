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
local templates, clones, folders, timers = {}, {}, {}, {}
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
	"FishBiteHeavey",
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
local storage = {
	FindFirstChild = function()
		return {
			FindFirstChild = function()
				return fish
			end,
		}
	end,
}
local environment = setmetatable({
	game = {
		GetService = function(_, name)
			return if name == "ReplicatedStorage" then storage else {}
		end,
	},
	script = { Parent = { FishingConfig = "config" } },
	require = function()
		return config
	end,
	Instance = {
		new = function(class)
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
local cast = audio:Play("FishingRodCast")
assert(cast.Volume == 0.37 and cast.PlaybackSpeed == 0.85 and cast.effect == "template-effect")
assert(not cast.Looped and cast ~= templates.FishingRodCast)
cast.Ended:Fire()
assert(cast.destroyed and not next(audio.sounds), "Ended must release one-shots and their timers")
audio:SetPhase("Nibbling")
assert(count("FishBiteHeavey") == 0, "False bites must not play the true-bite cue")
audio:SetPhase("Bite")
audio:SetPhase("Bite")
audio:SetPhase("Struggling")
audio:SetPhase("Struggling")
assert(count("FishBiteHeavey") == 1 and count("FishReelLoop") == 1)
local loop = audio.loops.FishReelLoop
assert(loop.Looped and not templates.FishReelLoop.Looped, "Loop only the playback clone")
enabled = false
audio:RefreshSoundSetting()
assert(loop.destroyed and not next(audio.sounds), "Muting must immediately release all voices")
enabled = true
audio:RefreshSoundSetting()
audio:RefreshSoundSetting()
assert(count("FishReelLoop") == 2 and count("FishBiteHeavey") == 1, "Restore only the current loop, once")
loop = audio.loops.FishReelLoop
audio:SetPhase("Lifting")
assert(loop.destroyed and count("FishWaterOut") == 1)
audio:SetPhase("Caught")
audio:SetPhase("Caught")
assert(count("FishDrop") == 1 and count("FishSuccess") == 1)

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
audio:SetPhase("Bite")
enabled = true
audio:SetPhase("Bite")
audio:RefreshSoundSetting()
assert(count("FishBiteHeavey") == 1, "Muted one-shots must not be replayed")
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
templates.FishWaterOut = nil
assert(audio:Play("FishWaterOut") == nil)
assert(audio:Play("FishWaterOut") == nil and warnings == 1)
templates.FishWaterOut = {
	IsA = function()
		return false
	end,
}
assert(audio:Play("FishWaterOut") == nil and warnings == 1)
templates.FishWaterOut = saved
local stuck = audio:Play("FishWaterOut")
advance(31)
assert(stuck.destroyed, "A sound which never emits Ended must still be released")
audio:Destroy()
assert(not next(timers), "Sound cleanup must not leave deferred callbacks")
