local modules = "src/ReplicatedStorage/Modules/"
local function read(path)
	return assert(io.open(path)):read("*a")
end

local function noop() end
local function tuple(...)
	return { ... }
end
local vector = { X = 0, Y = 0 }
local function zeroVector()
	return vector
end
setmetatable(vector, { __add = zeroVector, __sub = zeroVector, __mul = zeroVector, __div = zeroVector })

local fill = { Size = { 0, 1 } }
local track = { Fill = fill, PulseScale = { Scale = 1 } }
local bar = {
	Track = track,
	PulseScale = { Scale = 1 },
	LevelLabel = {},
	XPLabel = {},
	AbsolutePosition = vector,
	AbsoluteSize = vector,
}
local confetti, popups = 0, {}
local gui = {
	XPBar = bar,
	Effects = { AbsolutePosition = vector },
	Templates = {
		ConfettiPiece = {
			Clone = function()
				confetti += 1
				return { Destroy = noop }
			end,
		},
	},
}

local latestFillTween
local tweenService = {}
function tweenService:Create(object, info, properties)
	local tween = { Completed = {}, info = info }
	function tween.Completed:Once(callback)
		tween.completed = callback
	end
	function tween:Play()
		if object == fill then
			latestFillTween = self
		end
	end
	function tween:Cancel()
		if not self.finished then
			self.finished = true
			self.cancelled = true
			self.completed()
		end
	end
	function tween:Finish()
		assert(not self.cancelled, "A cancelled tween must never overwrite the current progress")
		for key, value in pairs(properties) do
			object[key] = value
		end
		self.finished = true
		self.completed()
	end
	return tween
end

local function minimum(_, value)
	return value
end
local formats = { FormatNumberStartKWithDecimal = tostring, FormatMaxCatchWeight = tostring }
local effectsChunk = assert(loadstring(read(modules .. "TrainingUIEffects.lua")))
setfenv(
	effectsChunk,
	setmetatable({
		game = {
			GetService = function()
				return tweenService
			end,
		},
		script = { Parent = {} },
		require = function()
			return formats
		end,
		Color3 = { fromRGB = tuple, new = tuple },
		Vector3 = { new = zeroVector },
		UDim2 = { fromScale = tuple, fromOffset = tuple },
		Enum = { EasingStyle = { Quad = "Quad", Elastic = "Elastic" }, EasingDirection = { Out = "Out" } },
		TweenInfo = { new = tuple },
		Random = {
			new = function()
				return { NextNumber = minimum, NextInteger = minimum }
			end,
		},
		workspace = { CurrentCamera = { CFrame = { RightVector = vector, UpVector = vector } } },
		task = { delay = noop },
	}, { __index = getfenv() })
)
local effects = effectsChunk().new(gui)
function effects:_popup(template)
	table.insert(popups, template)
end

-- Exercise the callback shared by all snapshot deliveries without starting Roblox input and plot listeners.
local controller = read("src/StarterPlayer/StarterPlayerScripts/Controllers/TrainingController.lua")
local start = assert(controller:find("\tlocal function apply(value)", 1, true))
local finish = assert(controller:find("\tlocal function bindPlot()", start, true))
local applyChunk =
	assert(loadstring("local snapshot, feedbackPrevious\n" .. controller:sub(start, finish - 1) .. "\nreturn apply"))
local levels = assert(loadstring(read("src/ReplicatedFirst/Data/TrainingLevelsData.lua")))()
local firstThreshold = levels["19"].XpToNextLevel
local nextThreshold = levels["20"].XpToNextLevel
local multiThreshold = levels["22"].XpToNextLevel
local state = {}
setfenv(
	applyChunk,
	setmetatable({
		alive = true,
		self = state,
		gui = gui,
		xpBar = bar,
		effects = effects,
		NumberUtil = formats,
		Feedback = assert(loadstring(read(modules .. "TrainingFeedback.lua")))(),
		Levels = levels,
		player = {},
		Gate = { SetActive = noop },
		backpack = { SetActive = noop },
		applyWeight = noop,
		refreshUpgrade = noop,
	}, { __index = getfenv() })
)
local apply = applyChunk()

local function send(revision, level, xp, active)
	local row = levels[tostring(level)]
	apply({
		revision = revision,
		level = level,
		xp = xp,
		xpToNextLevel = row.XpToNextLevel,
		maxCatchWeight = row.MaxCatchWeight,
		active = active ~= false,
	})
end

local function assertWidth(expected)
	assert(fill.Size[1] == expected, "The fill must match the current level's experience")
	assert(bar.PulseScale.Scale == 1 and track.PulseScale.Scale == 1, "Reward feedback must not resize the bar")
end

local firstXp = firstThreshold - 5
send(1, 19, firstXp)
assertWidth(firstXp / firstThreshold)
for xp = firstXp + 1, firstXp + 3 do
	send(xp - firstXp + 1, 19, xp)
	assertWidth((xp - 1) / firstThreshold)
	assert(latestFillTween.info[1] == 0.3 and latestFillTween.info[2] == "Quad")
	latestFillTween:Finish()
	assertWidth(xp / firstThreshold)
end
assert(#popups == 3 and popups[3] == "XpPopup")

send(5, 19, firstXp + 4)
local pendingFill = latestFillTween
send(6, 19, firstXp + 4)
assert(latestFillTween == pendingFill and not pendingFill.cancelled, "Same target must reuse the current tween")
send(5, 19, firstXp, false)
send(6, 19, firstXp, false)
assert(state._snapshot.revision == 6 and gui.Enabled and bar.XPLabel.Text == (firstXp + 4) .. "/" .. firstThreshold)

send(7, 20, 1)
assert(pendingFill.cancelled and bar.LevelLabel.Text == "Level 20" and bar.XPLabel.Text == "1/" .. nextThreshold)
assertWidth(1 / nextThreshold)
assert(popups[#popups - 1] == "LevelPopup" and popups[#popups] == "WeightPopup" and confetti == 26)
send(8, 22, 4)
assert(bar.LevelLabel.Text == "Level 22" and bar.XPLabel.Text == "4/" .. multiThreshold and confetti == 52)
assertWidth(4 / multiThreshold)

send(9, 22, 5)
local interruptedFill = latestFillTween
send(10, 22, 5, false)
assert(not gui.Enabled and interruptedFill.cancelled, "Stopping must cancel animated fill")
send(11, 22, 5)
assert(gui.Enabled and latestFillTween == interruptedFill)
assertWidth(5 / multiThreshold)

send(12, 1499, 0, false)
send(13, 1499, 0)
send(14, 1500, 0)
assert(bar.LevelLabel.Text == "Level 1500" and bar.XPLabel.Text == "MAX")
assertWidth(1)
send(15, 1500, 0)
assert(latestFillTween == interruptedFill, "Repeated MAX snapshots must not start another tween")
assertWidth(1)
