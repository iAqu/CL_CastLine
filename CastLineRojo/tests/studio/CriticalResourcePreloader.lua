-- 在 Studio Client 执行。检查正式预加载、隐藏咬钩图标的首次渲染及音效播放副本。
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ContentProvider = game:GetService("ContentProvider")
local preloader = require(ReplicatedFirst:WaitForChild("CriticalResourcePreloader", 5))
local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")
local sourceIcon = gui.FishingSequenceGui.BitePromptTemplate.Icon
local Audio = require(ReplicatedStorage.Modules.FishingAudio)
local temporaryGui, audio
local report = {}

local ok, err = xpcall(function()
	local started = os.clock()
	preloader.Start()
	preloader.Start()
	local status = preloader.GetStatus()
	while status.phase == "Loading" and os.clock() - started < 5.5 do
		task.wait(0.05)
		status = preloader.GetStatus()
	end
	report.status, report.seconds = status, os.clock() - started
	assert(status.phase == "Ready", "Critical assets failed or timed out: " .. status.phase)
	assert(status.loaded == status.total and status.total > 0, "Critical progress must count successful resources")
	assert(ContentProvider:GetAssetFetchStatus(sourceIcon.Image) == Enum.AssetFetchStatus.Success,
		"Bite icon was not fetched by the production preloader")

	-- 模板隐藏时 IsLoaded 可能仍为 false；必须验证首次显示的播放副本。
	temporaryGui = Instance.new("ScreenGui")
	temporaryGui.Name, temporaryGui.ResetOnSpawn = "FishingPreloadValidation", false
	local icon = Instance.new("ImageLabel")
	icon.Image, icon.BackgroundTransparency = sourceIcon.Image, 1
	icon.Size, icon.Position = UDim2.fromOffset(64, 64), UDim2.fromScale(0.5, 0.35)
	icon.Parent, temporaryGui.Parent = temporaryGui, gui
	local frames = 0
	local renderDeadline = os.clock() + 2
	repeat
		RunService.RenderStepped:Wait()
		frames += 1
	until icon.IsLoaded or os.clock() >= renderDeadline
	report.iconFrames, report.iconLoaded = frames, icon.IsLoaded
	assert(icon.IsLoaded, "Preloaded bite icon failed its first visible render")

	audio = Audio.new(function()
		return true
	end)
	local sounds = { audio:Play("FishBite"), audio:Play("FishBiteHeavey") }
	audio:PlayShowcase()
	for sound in pairs(audio.sounds) do
		assert(sound.IsLoaded and sound.IsPlaying and sound.TimeLength > 0,
			"First playback was not ready: " .. sound.Name)
		report[sound.Name] = true
	end
	assert(#sounds == 2 and report.FishSuccess and report.Gui_Fuse_Success,
		"Bite and showcase cues must all play")
end, debug.traceback)
if audio then
	audio:Destroy()
end
if temporaryGui then
	temporaryGui:Destroy()
end
assert(ok, err)
return report
