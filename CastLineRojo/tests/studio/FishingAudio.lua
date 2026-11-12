-- 在 Studio Client 执行；只创建临时声音，不修改模板、镜头或当前钓鱼会话。
local storage = game:GetService("ReplicatedStorage")
local Audio = require(storage.Modules.FishingAudio)
local Cast = require(storage.Modules.FishingCastSequence)
local Bite = require(storage.Modules.FishingBiteSequence)
local templates = storage.Sound.Fishing
local function sourceFor(name)
	return if name == "Gui_Fuse_Success" then storage.Sound.Gui.Gui_Fuse_Success else templates[name]
end
local names = {
	"FishingRodCast",
	"FishingCastWind",
	"FishingCastImpact",
	"FishBiteHeavey",
	"FishReelLoop",
	"FishWaterOut",
	"FishDrop",
	"FishSuccess",
	"Gui_Fuse_Success",
	"FishFlap",
	"FishFail",
}
local assets, originals = {}, {}
for _, name in ipairs(names) do
	local source = sourceFor(name)
	originals[name] = { volume = source.Volume, speed = source.PlaybackSpeed, looped = source.Looped }
	table.insert(assets, source)
end
game:GetService("ContentProvider"):PreloadAsync(assets)
for _, source in ipairs(assets) do
	assert(source.IsLoaded and source.TimeLength > 0, source.Name .. " did not load")
end
local enabled, audio, folder = true, nil, nil
local report = { loaded = #assets, played = {} }
local function create()
	audio = Audio.new(function()
		return enabled
	end)
	return audio
end
local ok, err = xpcall(function()
	create()
	folder = Instance.new("Folder")
	folder.Name, folder.Parent = "FishingAudioValidation", workspace
	local owner = setmetatable({
		phase = "Preparing",
		folder = folder,
		fishAudio = audio,
		sounds = {},
		options = {
			isSoundEnabled = function()
				return enabled
			end,
		},
	}, Cast)
	local play = audio.Play
	audio.Play = function(self, name, looped)
		local sound = play(self, name, looped)
		if sound then
			report.played[name] = (report.played[name] or 0) + 1
			local source = sourceFor(name)
			assert(
				sound.Volume == source.Volume and sound.PlaybackSpeed == source.PlaybackSpeed,
				"Template mix changed"
			)
			assert(#sound:GetChildren() == #source:GetChildren(), "Sound effects were not cloned")
		end
		return sound
	end
	audio:Play("FishingRodCast")
	local wind = assert(audio:Play("FishingCastWind"), "Cast wind sound is missing")
	local impact = assert(audio:Play("FishingCastImpact"), "Cast impact sound is missing")
	assert(not wind.Looped and not impact.Looped and wind.IsPlaying and impact.IsPlaying,
		"Cast wind and impact must play once")
	owner:_setPhase("Nibbling")
	assert(not report.played.FishBiteHeavey, "False bite played the true-bite cue")
	local bite = setmetatable({ owner = owner }, Bite)
	bite:_biteSound()
	bite:_biteSound()
	owner:_setPhase("Bite")
	assert(report.played.FishBiteHeavey == 1, "True bite played more than once")
	owner:_setPhase("Struggling")
	local loop = assert(audio.loops.FishReelLoop, "Struggle loop is missing")
	assert(loop.Looped and loop.IsPlaying, "Struggle sound is not looping")
	owner:_setPhase("Struggling")
	assert(report.played.FishReelLoop == 1, "Repeated phase restarted the loop")
	enabled = false
	owner:RefreshSoundSetting()
	assert(not loop.Parent, "Muting left the loop alive")
	assert(not wind.Parent and not impact.Parent, "Muting left cast sounds alive")
	enabled = true
	owner:RefreshSoundSetting()
	loop = assert(audio.loops.FishReelLoop, "Struggle loop is missing")
	owner:_setPhase("Lifting")
	assert(not loop.Parent and report.played.FishWaterOut == 1, "Lift did not stop the loop and play exit audio")
	audio:PlayShowcase()
	owner:_setPhase("Caught")
	assert(report.played.FishDrop == 1 and report.played.FishSuccess == 1
		and report.played.Gui_Fuse_Success == 1, "Showcase cues missing or repeated")
	audio:UpdateFlap("Caught", { name = "ShowcaseFlop", token = 1, position = 0.15 }, true)
	audio:UpdateFlap("Caught", { name = "ShowcaseFlop", token = 1, position = 0.2 }, true)
	audio:UpdateFlap("Caught", { name = "ShowcaseFlop", token = 2, position = 0.4 }, true)
	assert(report.played.FishFlap == 1, "Flap repeated or replayed an expired window")
	owner:_setPhase("Escaped")
	owner:_setPhase("Waiting")
	owner:_setPhase("Reeling")
	assert(
		not report.played.FishFail and not audio.loops.FishReelLoop,
		"Escape or empty reel played result audio early"
	)
	audio:Play("FishFail")
	owner:_setPhase("Reeled")
	assert(report.played.FishFail == 1, "Showcase replayed failure audio")
	local fail = assert(audio.folder:FindFirstChild("FishFail"), "Empty showcase did not play failure audio")
	local tailFolder = audio.folder
	owner:Destroy(true)
	assert(fail.IsPlaying and tailFolder.Parent, "Return truncated failure audio")
	local deadline = os.clock() + fail.TimeLength + 2
	while tailFolder.Parent and os.clock() < deadline do
		task.wait(0.1)
	end
	assert(not tailFolder.Parent, "Failure tail did not clean itself up")
	report.tailCompleted = true
	create():Play("FishFail")
	tailFolder = audio.folder
	audio:Destroy(true)
	enabled = false
	Audio.RefreshTails()
	assert(not tailFolder.Parent, "Muting did not stop returned failure audio")
	report.tailMuted = true
	enabled = true
	create():SetPhase("Struggling")
	loop = assert(audio.loops.FishReelLoop, "Struggle loop is missing")
	audio:Destroy(false)
	assert(not loop.Parent, "Abort left a struggle loop playing")
	create()
	wind = assert(audio:Play("FishingCastWind"), "Cast wind sound is missing")
	impact = assert(audio:Play("FishingCastImpact"), "Cast impact sound is missing")
	audio:Destroy(false)
	assert(not wind.Parent and not impact.Parent, "Abort left cast sounds playing")
	for _, name in ipairs(names) do
		local source, before = sourceFor(name), originals[name]
		assert(
			source.Volume == before.volume and source.PlaybackSpeed == before.speed and source.Looped == before.looped,
			"Studio sound template changed"
		)
	end
	report.templatesUnchanged = true
end, debug.traceback)
if audio then
	audio:Destroy(false)
end
if folder then
	folder:Destroy()
end
assert(ok, err)
return report
