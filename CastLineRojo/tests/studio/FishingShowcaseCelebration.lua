-- 在 Studio Client 执行；使用正式模块与临时 GUI 验证展示时机、去重、静音及清理。
local storage = game:GetService("ReplicatedStorage")
local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local Cast = require(storage.Modules.FishingCastSequence)
local Info = require(storage.Modules.FishingSequenceInfo)
local Audio = require(storage.Modules.FishingAudio)
local Confetti = require(storage.Modules.UiConfettiUtil)
local config = require(storage.Modules.FishingConfig)
local rarities = require(storage.Modules.RarityConfig)
assert(not workspace:FindFirstChild("FishingRig"), "Finish active fishing before validation")

local enabled, owner, gui = true, nil, nil
local report = { rarities = 0, sounds = {}, desktop = false, mobileCanvas = false }
local function create()
	gui = game.StarterGui.FishingSequenceGui:Clone()
	gui.Name, gui.Enabled, gui.Parent = "FishingShowcaseValidation", true, playerGui
	local audio = Audio.new(function()
		return enabled
	end)
	local folder = Instance.new("Folder")
	folder.Name, folder.Parent = "FishingShowcaseValidation", workspace
	owner = setmetatable({ gui = gui, folder = folder, fishAudio = audio,
		originals = {}, createdScales = {}, sounds = {}, options = {} }, Cast)
	owner.info = Info.new(gui, owner, 1, 0)
	local play = audio.Play
	audio.Play = function(self, name, looped)
		local sound = play(self, name, looped)
		if sound then
			report.sounds[name] = (report.sounds[name] or 0) + 1
			local source = if name == "Gui_Fuse_Success" then storage.Sound.Gui[name] else storage.Sound.Fishing[name]
			assert(sound ~= source and sound.Volume == source.Volume
				and sound.PlaybackSpeed == source.PlaybackSpeed
				and #sound:GetChildren() == #source:GetChildren(), "Preserve the Studio audio template")
		end
		return sound
	end
end
local function bite(rarity, egg)
	return { isEgg = egg, fishConfig = { DisplayName = "ValidationFish", Rarity = rarity,
		CpsPrice = 1, DefaultWeight = 1 }, catchWeight = 1,
		timeline = { phase = "Lifting", startedAt = 0 }, Destroy = function() end }
end
local function dispose()
	local audio = owner.fishAudio
	owner:Destroy()
	owner:Destroy()
	assert(not gui:FindFirstChild("ConfettiLayer") and not next(audio.sounds)
		and not audio.folder, "Exit left particles or sounds alive")
	gui:Destroy()
	owner, gui = nil, nil
end
local motion = require(storage.Modules.FishingLiftMotion)
local landing = motion.Timing(config.Bite, false).landAt
local ok, err = xpcall(function()
	create()
	for _, rarity in rarities.List do
		local fish = bite(rarity.Name)
		owner.bite = fish
		owner:_setPhase("Lifting")
		Confetti.clear(gui)
		owner.info:Update(landing - 0.01, fish)
		local before = report.sounds.FishSuccess or 0
		assert(not gui:FindFirstChild("ConfettiLayer"), "Celebrated before the reveal")
		owner.info:Update(landing + 0.01, fish)
		assert(gui.RevealInfo.Visible and gui:FindFirstChild("ConfettiLayer"), "Reveal did not create the layer")
		assert(report.sounds.FishSuccess == before + 1 and report.sounds.Gui_Fuse_Success == before + 1,
			"Reveal must synchronously start both sounds")
		owner.info:Update(landing + 0.02, fish)
		fish.timeline.phase = "Caught"
		owner:_setPhase("Caught")
		owner.info:Update(config.Bite.LiftTime + 0.01, fish)
		-- 即使同一对象短暂离开展示，再进入也不能重复庆祝。
		fish.timeline.phase = "Escaped"
		owner.info:Update(10, fish)
		fish.timeline.phase = "Caught"
		owner.info:Update(11, fish)
		assert(report.sounds.FishSuccess == before + 1 and report.sounds.Gui_Fuse_Success == before + 1,
			"Repeated frames or Caught replayed showcase audio")
		report.rarities += 1
	end
	task.wait(0.1)
	local layer = assert(gui:FindFirstChild("ConfettiLayer"))
	local left, right = false, false
	for _, piece in layer:GetChildren() do
		left = left or piece.Position.X.Scale < 0.15
		right = right or piece.Position.X.Scale > 0.85
	end
	assert(left and right, "Desktop must emit from both sides")
	report.desktop = true
	dispose()
	task.wait(0.6)
	assert(not playerGui:FindFirstChild("FishingShowcaseValidation"), "Deferred emission survived exit")

	-- 下一次钓鱼、静音、重新开启声音及快速退出。
	enabled = false
	create()
	local before = report.sounds.FishSuccess
	local fish = bite("Common")
	owner.bite = fish
	owner.info:Update(landing + 0.01, fish)
	assert(gui:FindFirstChild("ConfettiLayer") and report.sounds.FishSuccess == before,
		"Muted fishing must retain confetti and skip audio")
	enabled = true
	owner:RefreshSoundSetting()
	owner.info:Update(landing + 0.02, fish)
	assert(report.sounds.FishSuccess == before and report.sounds.Gui_Fuse_Success == before,
		"Unmuting replayed consumed showcase sounds")
	dispose()
	task.wait(0.6)

	create()
	local egg = bite("Rare", true)
	owner.bite = egg
	owner.info:Update(motion.Timing(config.Bite, true).riseEnd, egg)
	assert(not gui:FindFirstChild("ConfettiLayer"), "Egg received fish confetti")
	owner:_setPhase("Caught")
	owner:_setPhase("Caught")
	assert(report.sounds.FishSuccess == before + 1 and report.sounds.Gui_Fuse_Success == before,
		"Egg must preserve its original success cue without the extra cheer")
	dispose()

	create()
	for _, phase in { "Escaped", "Reeling", "Reeled" } do
		fish = bite("Common")
		fish.timeline.phase, owner.bite = phase, fish
		owner.info:Update(10, fish)
		owner:_setPhase(phase)
	end
	assert(not gui:FindFirstChild("ConfettiLayer"), "Escape or empty reel created confetti")
	assert(report.sounds.FishSuccess == before + 1 and report.sounds.Gui_Fuse_Success == before,
		"Escape or empty reel played showcase audio")

	-- 窄屏画布验证两侧发射、粒子回收和 clear 后再次播放。
	local canvas = Instance.new("Frame")
	canvas.Name, canvas.Size, canvas.BackgroundTransparency = "MobileCanvas", UDim2.fromOffset(390, 844), 1
	canvas.Parent = gui
	Confetti.play(canvas, "sideCannons")
	task.wait(0.1)
	layer = assert(canvas:FindFirstChild("ConfettiLayer"))
	left, right = false, false
	for _, piece in layer:GetChildren() do
		left = left or piece.Position.X.Scale < 0.15
		right = right or piece.Position.X.Scale > 0.85
	end
	assert(left and right and canvas.AbsoluteSize == Vector2.new(390, 844), "Narrow canvas lost a side cannon")
	task.wait(5.3)
	assert(#layer:GetChildren() > 0, "Expected pooled frames after the sequence")
	for _, piece in layer:GetChildren() do
		assert(not piece.Visible, "Particle survived its lifetime")
	end
	Confetti.clear(canvas)
	Confetti.clear(canvas)
	assert(not layer.Parent and #layer:GetChildren() == 0, "Clear did not destroy pooled frames")
	Confetti.play(canvas, "sideCannons")
	Confetti.clear(canvas)
	task.wait(0.6)
	assert(not canvas:FindFirstChild("ConfettiLayer"), "Cleared deferred sequence emitted again")
	Confetti.play(canvas, "sideCannons")
	task.wait(0.1)
	assert(#canvas.ConfettiLayer:GetChildren() > 0, "Clear prevented the next sequence from playing")
	Confetti.clear(canvas)
	report.mobileCanvas = true
	dispose()
	Confetti.clear(nil)
end, debug.traceback)
if owner then
	owner:Destroy()
end
if gui then
	gui:Destroy()
end
assert(ok, err)
return report
