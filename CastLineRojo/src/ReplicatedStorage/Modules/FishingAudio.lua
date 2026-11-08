local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Config = require(script.Parent.FishingConfig)

local FishingAudio = {}
FishingAudio.__index = FishingAudio
local tails = {}
local warned = {}

local function template(name)
	local sounds = ReplicatedStorage:FindFirstChild("Sound")
	local fish = sounds and sounds:FindFirstChild("Fish")
	local sound = fish and fish:FindFirstChild(name)
	if not sound or not sound:IsA("Sound") or sound.SoundId == "" then
		if not warned[name] then
			warned[name] = true
			warn("FishingAudio: Sound.Fish." .. name .. " is missing or invalid; skipping sound")
		end
		return nil
	end
	return sound
end

function FishingAudio.ClearTails()
	for audio in pairs(tails) do
		audio:Destroy(false)
	end
end

function FishingAudio.RefreshTails()
	for audio in pairs(tails) do
		audio:RefreshSoundSetting()
	end
end

function FishingAudio.new(isSoundEnabled)
	FishingAudio.ClearTails()
	local folder = Instance.new("Folder")
	folder.Name, folder.Parent = "FishingAudio", SoundService
	return setmetatable({ folder = folder, sounds = {}, loops = {}, isSoundEnabled = isSoundEnabled }, FishingAudio)
end

function FishingAudio:_enabled()
	return not self.isSoundEnabled or self.isSoundEnabled()
end

function FishingAudio:_remove(sound)
	local record = self.sounds[sound]
	if not record then
		return
	end
	self.sounds[sound] = nil
	if record.ended then
		record.ended:Disconnect()
	end
	if record.timeout then
		task.cancel(record.timeout)
	end
	if self.loops[sound.Name] == sound then
		self.loops[sound.Name] = nil
	end
	sound:Destroy()
	if self.destroyed and not next(self.sounds) then
		tails[self] = nil
		if self.folder then
			self.folder:Destroy()
			self.folder = nil
		end
	end
end

function FishingAudio:Play(name, looped)
	if self.destroyed or not self:_enabled() then
		return nil
	end
	local source = template(name)
	if not source then
		return nil
	end
	local sound = source:Clone()
	-- 使用 Studio 模板的音量、音高和效果器，只修改播放副本的循环状态。
	sound.Looped, sound.PlayOnRemove, sound.TimePosition = looped == true, false, 0
	sound.Parent = self.folder
	local record = {}
	self.sounds[sound] = record
	if sound.Looped then
		self.loops[name] = sound
	else
		record.ended = sound.Ended:Once(function()
			self:_remove(sound)
		end)
		-- 无法加载的声音也必须释放，避免 Ended 永远不触发。
		record.timeout = task.delay(math.max(30, sound.TimeLength + 5), function()
			record.timeout = nil
			self:_remove(sound)
		end)
	end
	sound:Play()
	return sound
end

function FishingAudio:StartLoop(name)
	local sound = self.loops[name]
	if sound then
		return sound
	end
	return self:Play(name, true)
end

function FishingAudio:StopLoop(name)
	local sound = self.loops[name]
	if sound then
		self:_remove(sound)
	end
end

function FishingAudio:SetPhase(phase)
	if self.destroyed or self.phase == phase then
		return
	end
	self.phase = phase
	if phase == "Struggling" then
		self:StartLoop("FishReelLoop")
	else
		self:StopLoop("FishReelLoop")
	end
	if phase == "Bite" then
		self:Play("FishBiteHeavey")
	elseif phase == "Lifting" then
		self:Play("FishWaterOut")
	elseif phase == "Caught" then
		self:Play("FishDrop")
		self:Play("FishSuccess")
	end
end

function FishingAudio:UpdateFlap(phase, request, playing)
	if phase ~= "Caught" or not playing or not request or request.name ~= "ShowcaseFlop" then
		return
	end
	local position = request.position or 0
	local window = Config.Bite.Drip.Burst.Window
	if request.token == nil or request.token == self.lastFlap or position < window[1] then
		return
	end
	self.lastFlap = request.token
	if position <= window[2] then
		self:Play("FishFlap")
	end
end

function FishingAudio:RefreshSoundSetting()
	if not self:_enabled() then
		for sound in pairs(self.sounds) do
			self:_remove(sound)
		end
	elseif not self.destroyed and self.phase == "Struggling" then
		self:StartLoop("FishReelLoop")
	end
end

function FishingAudio:Destroy(keepFail)
	self.destroyed = true
	for sound in pairs(self.sounds) do
		if not keepFail or sound.Name ~= "FishFail" or not sound.IsPlaying then
			self:_remove(sound)
		end
	end
	if next(self.sounds) then
		tails[self] = true
	else
		tails[self] = nil
		if self.folder then
			self.folder:Destroy()
			self.folder = nil
		end
	end
end

return FishingAudio
