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
		fromOffset = function(x, y)
			return { X = x, Y = y }
		end,
	},
}, { __index = getfenv() })
modules.math = assert(
	load(read("src/ReplicatedStorage/Modules/FishingProjectileMath.lua"), "FishingProjectileMath", "t", environment)
)()
local Sequence = assert(
	load(read("src/ReplicatedStorage/Modules/FishingCastSequence.lua"), "FishingCastSequence", "t", environment)
)()

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
	near(bounce:_landingOffset(0.3), height * 0.45)
	near(bounce:_landingOffset(0.5), 0)
	assert(bounce:_landingOffset(0.06) < 0, "Bait must sink before rebounding")
	assert(bounce:_landingOffset(0.25) > 0, "Rebound must carry bait above its floating position")
	assert(bounce:_landingOffset(0.4) > 0 and bounce:_landingOffset(0.4) < height * 0.45)
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
			Destroy = function()
				guiDestroyed += 1
			end,
		},
	}, Sequence)
	instance:Destroy()
	instance:Destroy()
	assert(
		stopped == 1 and folderDestroyed == 1 and guiDestroyed == 1,
		"Cleanup must be idempotent and survive an unavailable Animator"
	)
	if not failStop then
		assert(trackDestroyed == 1)
	end
end
cleanupProbe(false)
cleanupProbe(true)
