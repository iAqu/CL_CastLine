local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local modules = {
	config = assert(loadstring(read("src/ReplicatedStorage/Modules/FishingConfig.lua")))(),
	rig = {},
	water = {},
	bite = {},
}
local workspace = {}
local environment = setmetatable({
	script = {
		Parent = {
			FishingConfig = "config",
			FishingProjectileMath = "math",
			FishingRigUtil = "rig",
			WaterSurfaceUtil = "water",
			FishingBiteSequence = "bite",
		},
	},
	game = {
		GetService = function(_, name)
			return if name == "Workspace" then workspace else {}
		end,
	},
	require = function(name)
		return assert(modules[name])
	end,
	Color3 = {
		fromRGB = function(r, g, b)
			return { r, g, b }
		end,
	},
	UDim2 = {
		fromScale = function(x, y)
			return { X = x, Y = y }
		end,
		fromOffset = function(x, y)
			return { X = x, Y = y }
		end,
	},
}, { __index = getfenv() })
environment.script.Parent.BaitElasticMotion = "elastic"
local baseRequire = environment.require
local Elastic = assert(load(read("src/ReplicatedStorage/Modules/BaitElasticMotion.lua"), "Elastic", "t", environment))()
environment.require = function(name)
	return if name == "elastic" then Elastic else baseRequire(name)
end
modules.math = assert(
	load(read("src/ReplicatedStorage/Modules/FishingProjectileMath.lua"), "FishingProjectileMath", "t", environment)
)()
local Sequence = assert(
	load(read("src/ReplicatedStorage/Modules/FishingCastSequence.lua"), "FishingCastSequence", "t", environment)
)()

-- 抛竿音跟随实际动画起播；动画未加载、前摇等待和重复帧不能提前或重复播放。
do
	local starts, cues, phases = 0, 0, {}
	modules.rig.RestoreReadyPose = function() end
	local probe = setmetatable({
		phase = "Casting", castClickedAt = 0, rig = {},
		track = { Length = 0, Play = function() starts += 1 end },
		folder = { SetAttribute = function() end },
		fishAudio = {
			Play = function(_, name) assert(name == "FishingRodCast"); cues += 1 end,
			SetPhase = function(_, phase) table.insert(phases, phase) end,
		},
	}, Sequence)
	probe:_updateAction(0.1)
	probe.track.Length = 3
	probe:_updateAction(0.2)
	assert(starts == 0 and cues == 0)
	probe:_updateAction(modules.config.CastLeadTime)
	probe:_updateAction(modules.config.CastLeadTime + 0.01)
	assert(starts == 1 and cues == 1)
	probe:_setPhase("Struggling")
	probe:_setPhase("Struggling")
	probe:_setPhase("Lifting")
	assert(#phases == 2 and phases[1] == "Struggling" and phases[2] == "Lifting")
end

local attributes = {}
local feedbackCount = 0
local sequence = setmetatable({
	phase = "Preparing",
	folder = {
		SetAttribute = function(_, name, value)
			attributes[name] = value
		end,
	},
	meter = { prompt = {}, marker = {}, scale = {} },
	_castFeedback = function()
		feedbackCount += 1
	end,
}, Sequence)
sequence:Cast(0)
assert(sequence.phase == "Casting" and sequence.distance == 55)
local clickedAt = sequence.castClickedAt
sequence:Cast(1)
assert(
	sequence.distance == 55 and sequence.castClickedAt == clickedAt,
	"Repeated taps must not restart casting or change its locked power"
)
sequence.phase = "Flying"
sequence:Cast(1)
assert(sequence.distance == 55, "Flight input must not queue another cast")
sequence.phase = "Waiting"
sequence:Cast(1)
assert(sequence.distance == 55, "Waiting input must not start another cast")
assert(feedbackCount == 1, "Repeated taps must not replay feedback")

for _, case in ipairs({
	{ 0, "BAD" },
	{ 0.4499, "BAD" },
	{ 0.45, "GOOD" },
	{ 0.7199, "GOOD" },
	{ 0.72, "GREAT!" },
	{ 0.9199, "GREAT!" },
	{ 0.92, "PERFECT!" },
	{ 1, "PERFECT!" },
}) do
	assert(Sequence.GetRating(case[1]).Text == case[2], "Rating boundary must match the locked meter value")
end

-- 飘字按实际视口约束位置，包括竖屏和横屏手机比例。
for _, size in ipairs({ { 390, 844 }, { 844, 390 }, { 1877, 1240 } }) do
	local width, height = size[1], size[2]
	workspace.CurrentCamera = { ViewportSize = { X = width, Y = height } }
	for _, markerY in ipairs({ 0, height / 2, height }) do
		local feedback = setmetatable({
			distance = 71,
			meter = {
				prompt = {},
				marker = { AbsolutePosition = { Y = markerY } },
				glow = {},
				label = { AbsolutePosition = { X = width * 0.9 }, AbsoluteSize = { X = 100 } },
			},
			popup = { AbsoluteSize = { X = width * 0.2 } },
			_sound = function() end,
			_impulse = function() end,
		}, Sequence)
		feedback:_castFeedback(0.8, 0)
		local origin = feedback.popupOrigin
		assert(origin.X - width * 0.1 >= 0 and origin.X + width * 0.1 <= width, "Popup must fit narrow viewports")
		assert(origin.Y - height * modules.config.Meter.PopupRise >= 0, "Popup rise must stay on screen")
		assert(feedback.popup.Text == "+16 POWER" and feedback.meter.prompt.Text == "GREAT!")
	end
end

local impulses = setmetatable({ impulses = {} }, Sequence)
local cameraConfig = modules.config.Camera
impulses:_impulse(cameraConfig.Release, 0)
local function fovAt(time)
	return select(6, impulses:_sampleImpulses(time))
end
assert(fovAt(0) == 0, "FOV attack must start from the existing shot")
assert(math.abs(fovAt(0.05) - 10) < 0.00001, "Release must reach +10 degrees after 50ms")
assert(fovAt(0.3) > 0 and fovAt(0.3) < 10, "FOV must recover after its peak")
assert(fovAt(0.56) == 0 and #impulses.impulses == 0, "Expired impulses must leave no FOV offset")
impulses:_impulse(cameraConfig.Landing, 1, 1)
assert(math.abs(impulses.impulses[1].shake - 3.0) < 0.00001, "Long casts must strengthen landing shake")
assert(math.abs(fovAt(1.05) + 8) < 0.00001, "Landing must punch inward")
impulses:_impulse(cameraConfig.Perfect, 1.05)
assert(fovAt(1.1) > -8, "Independent FOV effects must combine")
assert(fovAt(2) == 0 and #impulses.impulses == 0)

-- 落水位移按鱼饵尺寸缩放，三段之间连续，结束后只保留轻微漂浮。
for _, height in ipairs({ 0.8, 2 }) do
	local bounce = setmetatable({ bait = { Size = { Y = height } } }, Sequence)
	local function near(actual, expected)
		assert(math.abs(actual - expected) < 0.00001, string.format("Expected %.6f, got %.6f", expected, actual))
	end
	near(bounce:_landingOffset(0), 0)
	near(bounce:_landingOffset(0.12), -height * 0.65)
	near(bounce:_landingOffset(0.3), height * modules.config.Landing.ReboundHeight)
	near(bounce:_landingOffset(0.5), 0)
	assert(bounce:_landingOffset(0.06) < 0, "Bait must sink before rebounding")
	assert(bounce:_landingOffset(0.25) > 0, "Rebound must carry bait above its floating position")
	assert(bounce:_landingOffset(0.4) < 0, "Landing must cross below rest during its smaller rebound")
	for _, boundary in ipairs({ 0.12, 0.3, 0.5 }) do
		assert(
			math.abs(bounce:_landingOffset(boundary - 0.0000001) - bounce:_landingOffset(boundary + 0.0000001))
				< 0.00001,
			"Landing phase changes must not jump"
		)
	end
	for index = 1, 100 do
		assert(math.abs(bounce:_landingOffset(0.5 + index * 0.1)) <= 0.1, "Rebound must not restart after settling")
	end
end

local ticks = {}
local meterSequence = setmetatable({
	lastMeterStep = 0,
	_sound = function(_, name, _, pitch)
		table.insert(ticks, { name, pitch })
	end,
}, Sequence)
meterSequence:UpdateMeter(0.1)
assert(#ticks == 0)
meterSequence:UpdateMeter(0.9)
assert(#ticks == 1 and ticks[1][1] == "MeterTick", "A skipped frame must play one tick, not a burst")
meterSequence:UpdateMeter(0.89)
assert(#ticks == 1, "Moving within a segment must not repeat ticks")
meterSequence:UpdateMeter(0.2)
assert(#ticks == 2 and ticks[2][2] < ticks[1][2], "Downward ticks must lower the pitch")

local enabled = false
local stopped, resumed, destroyed = 0, 0, 0
local wind = {
	Looped = true,
	IsPlaying = true,
	Stop = function(self)
		stopped += 1
		self.IsPlaying = false
	end,
	Play = function(self)
		resumed += 1
		self.IsPlaying = true
	end,
}
local oneShot = {
	Stop = function()
		stopped += 1
	end,
	Destroy = function()
		destroyed += 1
	end,
}
local audio = setmetatable({
	options = {
		isSoundEnabled = function()
			return enabled
		end,
	},
	sounds = { [wind] = true, [oneShot] = true },
	wind = wind,
	phase = "Flying",
}, Sequence)
audio:RefreshSoundSetting()
assert(stopped == 2 and destroyed == 1 and not wind.IsPlaying, "Muting must stop active audio immediately")
enabled = true
audio:RefreshSoundSetting()
audio:RefreshSoundSetting()
assert(resumed == 1, "Only the active flight wind may resume, without replaying old one-shots")

local function cleanupProbe(failStop)
	local stopped, trackDestroyed, folderDestroyed, guiDestroyed = 0, 0, 0, 0
	local instance = setmetatable({
		track = {
			Stop = function()
				stopped += 1
				if failStop then
					error("Animator already destroyed")
				end
			end,
			Destroy = function()
				trackDestroyed += 1
			end,
		},
		folder = {
			Destroy = function()
				folderDestroyed += 1
			end,
		},
		gui = {
			Parent = true,
			Enabled = true,
			Destroy = function()
				guiDestroyed += 1
			end,
		},
	}, Sequence)
	instance:Destroy()
	instance:Destroy()
	assert(
		stopped == 1 and folderDestroyed == 1 and guiDestroyed == 0 and not instance.gui.Enabled,
		"Cleanup must be idempotent and survive an unavailable Animator"
	)
	if not failStop then
		assert(trackDestroyed == 1)
	end
end
cleanupProbe(false)
cleanupProbe(true)

-- 复用同一预置 UI；每轮的状态变化与初始化失败均不能销毁它或污染下一轮。
do
	local function node(name, class, children)
		local item = { Name = name, Parent = true, children = children or {} }
		function item:IsA(kind)
			return kind == class
		end
		function item:FindFirstChild(key)
			return self.children[key]
		end
		function item:GetFullName()
			return self.Name
		end
		return item
	end
	local function text(name)
		local item = node(name, "TextLabel")
		item.Text, item.Visible, item.TextTransparency, item.TextColor3 = name, false, 0.2, "studioColor"
		item.Position, item.FontFace = "studioPosition", "studioFont"
		return item
	end
	local gui = node("FishingSequenceGui", "ScreenGui", {
		PerfectFlash = node("PerfectFlash", "Frame"),
		TopBar = node("TopBar", "Frame"), BottomBar = node("BottomBar", "Frame"),
		Distance = text("Distance"), ReturnPrompt = text("ReturnPrompt"),
		CatchStatus = text("CatchStatus"), PowerPopup = text("PowerPopup"),
	})
	gui.children.PerfectFlash.BackgroundColor3, gui.children.PerfectFlash.BackgroundTransparency = "studioFlash", 1
	gui.children.TopBar.Size, gui.children.BottomBar.Size = "studioTopSize", "studioBottomSize"
	local popup = gui.children.PowerPopup
	popup.children.UIStroke, popup.children.UIScale = node("UIStroke", "UIStroke"), node("UIScale", "UIScale")
	popup.children.UIStroke.Transparency, popup.children.UIScale.Scale = 0.1, 1.1
	local playerGui = node("PlayerGui", "PlayerGui", { FishingSequenceGui = gui })
	local function create()
		return setmetatable({ originals = {}, createdScales = {} }, Sequence)
	end
	for _ = 1, 2 do
		local owner = create()
		owner:_bindGui(playerGui)
		assert(owner.gui == gui and not gui.Enabled and not owner.popup.Visible)
		assert(owner.distanceLabel.Text == "0 STUDS" and owner.popupScale.Scale == 1)
		assert(owner.popup.FontFace == "studioFont" and owner.distanceLabel.Position == "studioPosition")
		gui.Enabled = true
		for _, original in ipairs(owner.originals) do
			original.instance[original.property] = "changedDuringRound"
		end
		owner:Destroy()
		owner:Destroy()
		assert(not gui.Enabled and gui.Parent, "Preset UI must stay available after cleanup")
		for _, original in ipairs(owner.originals) do
			assert(original.instance[original.property] == original.value, "Presentation state leaked into the next round")
		end
	end
	for _, replacement in ipairs({ false, node("UIScale", "Frame") }) do
		local scale = popup.children.UIScale
		popup.children.UIScale = replacement or nil
		local owner = create()
		local ok, err = pcall(owner._bindGui, owner, playerGui)
		assert(not ok and string.find(err, "PowerPopup.UIScale", 1, true), "Invalid preset must fail with its path")
		owner:Destroy()
		assert(gui.Parent and not gui.Enabled, "Partial binding must leave the preset hidden and intact")
		popup.children.UIScale = scale
	end
	local owner = create()
	playerGui.children.FishingSequenceGui = nil
	assert(not pcall(owner._bindGui, owner, playerGui), "Missing preset must fail without a runtime fallback")
	owner:Destroy()
end

-- 保留的水花音沿用声音开关，静音时不创建或延迟补播。
local plays, created = 0, 0
environment.Instance = {
	new = function(class)
		assert(class == "Sound")
		created += 1
		return {
			Ended = { Once = function() end },
			Play = function()
				plays += 1
			end,
		}
	end,
}
enabled = false
assert(audio:_sound("Splash") == nil and created == 0)
enabled = true
local cue = audio:_sound("Splash")
assert(created == 1 and plays == 1 and cue.Volume == 0.8 and cue.PlaybackSpeed == 1)
assert(cue.SoundId == modules.config.Sounds.Splash.Id)

-- 同帧先计算基础姿态和镜头，再显示透视补偿并连接鱼线。
do
	local order = {}
	local position = {}
	local resource = { Parent = true }
	local session = setmetatable({
		phase = "Holding",
		bait = resource,
		line = resource,
		lineEnd = resource,
		lineEndAttachment = resource,
		lineTop = resource,
		lineTopAttachment = resource,
		tip = {
			IsDescendantOf = function()
				return true
			end,
		},
		gui = resource,
		bars = {},
		barAmount = 0,
		bite = {
			Present = function(_, actualCamera)
				assert(actualCamera == position, "Presentation used a stale camera")
				table.insert(order, "present")
			end,
		},
		_updateBait = function()
			table.insert(order, "base")
		end,
		_updateCamera = function()
			workspace.CurrentCamera = { CFrame = { Position = position } }
			table.insert(order, "camera")
		end,
		_updateLine = function()
			table.insert(order, "line")
		end,
		_updateWaterEffects = function() end,
		RefreshSoundSetting = function() end,
		_updatePresentation = function() end,
	}, Sequence)
	session:Update(10, 1 / 60)
	assert(table.concat(order, ",") == "base,camera,present,line", "Camera/presentation/line order changed")
end
