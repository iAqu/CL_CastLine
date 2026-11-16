local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local source = read("src/ReplicatedStorage/Modules/ButtonAnimation.lua")
local function signal()
	local result = { connections = {} }
	function result:Connect(callback)
		local connection = { Connected = true, callback = callback }
		function connection:Disconnect()
			self.Connected = false
		end
		table.insert(self.connections, connection)
		return connection
	end
	function result:Fire(...)
		for _, connection in ipairs(table.clone(self.connections)) do
			if connection.Connected then
				connection.callback(...)
			end
		end
	end
	function result:Count()
		local count = 0
		for _, connection in ipairs(self.connections) do
			if connection.Connected then
				count += 1
			end
		end
		return count
	end
	return result
end

local function dim(x, xo, y, yo)
	return { X = { Scale = x, Offset = xo }, Y = { Scale = y, Offset = yo } }
end

local function button(offset, useUIScale)
	local result = { Size = dim(0.5, offset or 0, 0.25, offset or 0), signals = {} }
	for _, name in ipairs({
		"Activated", "MouseEnter", "MouseLeave", "MouseButton1Down", "MouseButton1Up",
		"SelectionGained", "SelectionLost", "Destroying",
	}) do
		result[name] = signal()
		table.insert(result.signals, result[name])
	end
	function result:IsA(class)
		return class == "GuiButton"
	end
	function result:FindFirstChild(name)
		return rawget(self, name)
	end
	function result:GetAttribute(name)
		return self.attributes and self.attributes[name]
	end
	function result:TweenSize(size, direction, style, duration)
		self.Size = size
		self.lastTween = { direction = direction, style = style, duration = duration }
	end
	if useUIScale then
		result.UIScale = { Scale = 1, IsA = function(_, class) return class == "UIScale" end }
	end
	return result
end

local function harness(existing, tagged)
	local h = { required = {}, sounds = {}, waits = 0 }
	local gui = { descendants = existing or {}, DescendantAdded = signal() }
	local collection = { added = signal(), tagged = tagged or {} }
	function gui:GetDescendants()
		assert(self.DescendantAdded:Count() == 1, "Subscribe to descendants before scanning")
		assert(collection.added:Count() == 1, "Subscribe to tags before scanning")
		if h.onScan then h.onScan() end
		return table.clone(self.descendants)
	end
	function collection:GetTagged() return self.tagged end
	function collection:GetInstanceAddedSignal() return self.added end
	local sound = {}
	local modules = {
		SoundHelper = { PlaySound = function(value) table.insert(h.sounds, value) end },
		Constants = { SoundRes = { GUI_BUTTON_CLICK = sound } },
	}
	local services = {
		CollectionService = collection,
		Players = { LocalPlayer = { WaitForChild = function(_, name)
			assert(name == "PlayerGui")
			h.waits += 1
			return gui
		end } },
		ReplicatedStorage = { Modules = modules },
		TweenService = { Create = function(_, target, info, goals)
			return { Play = function()
				for key, value in pairs(goals) do target[key] = value end
				h.lastTweenInfo = info
			end }
		end },
	}
	local chunk = assert(loadstring(source, "ButtonAnimation"))
	setfenv(chunk, setmetatable({
		game = { GetService = function(_, name) return assert(services[name], name) end },
		require = function(value)
			table.insert(h.required, value)
			return value
		end,
		UDim2 = { new = dim },
		TweenInfo = { new = function(duration) return { Time = duration } end },
		Enum = { EasingDirection = { Out = "Out" }, EasingStyle = { Quad = "Quad", Back = "Back" } },
	}, { __index = getfenv() }))
	h.module, h.gui, h.collection, h.sound = chunk(), gui, collection, sound
	return h
end

-- Module loading and registration must work without loading audio/data dependencies.
local early, offset, scaledOffset = button(), button(20), button(20, true)
local h = harness({ early, offset, scaledOffset })
assert(#h.required == 0 and h.waits == 0, "Requiring animation must not wait for GUI or load sound/data modules")
h.module.Start()
h.module.Start()
assert(h.waits == 1 and h.gui.DescendantAdded:Count() == 1 and h.collection.added:Count() == 1,
	"Start is idempotent")
assert(early.MouseEnter:Count() == 1, "Bind existing scale buttons")
assert(offset.MouseEnter:Count() == 0 and scaledOffset.MouseEnter:Count() == 0,
	"Automatic registration still excludes offset buttons, including those with UIScale")

local late = button()
h.gui.DescendantAdded:Fire(late)
assert(late.MouseEnter:Count() == 1, "Bind an untagged button arriving after startup")
local screen = { IsA = function() return false end }
h.gui.DescendantAdded:Fire(screen)
for _ = 1, 5 do
	local descendant = button()
	h.gui.DescendantAdded:Fire(descendant)
	assert(descendant.MouseEnter:Count() == 1, "Bind every button in a late ScreenGui subtree")
end
h.collection.added:Fire(screen)
h.gui.DescendantAdded:Fire(offset)
assert(offset.MouseEnter:Count() == 0)
h.collection.added:Fire(offset)
h.module.SetUp(scaledOffset)
assert(offset.MouseEnter:Count() == 1 and scaledOffset.MouseEnter:Count() == 1,
	"Tagged and manually registered offset buttons remain supported")

-- Scan/event overlap, explicit setup, and tags must share the same registration.
for _ = 1, 3 do
	h.gui.DescendantAdded:Fire(late)
	h.collection.added:Fire(late)
	h.module.SetUp(late)
end
assert(late.MouseEnter:Count() == 1 and late.Activated:Count() == 1, "Never duplicate callbacks")
h.module.SetUp(late, 1.05)
h.gui.DescendantAdded:Fire(late)
h.collection.added:Fire(late)
late.MouseEnter:Fire()
assert(math.abs(late.Size.X.Scale - 0.525) < 1e-9, "Explicit hover multiplier overrides automatic registration")
assert(late.lastTween.duration == 0.15)
late.MouseLeave:Fire()
assert(late.Size.X.Scale == 0.5 and late.lastTween.duration == 0.2)
late.MouseButton1Down:Fire()
assert(math.abs(late.Size.X.Scale - 0.5 / 1.1) < 1e-9 and late.lastTween.duration == 0.05)
late.MouseButton1Up:Fire()
assert(late.Size.X.Scale == 0.5)
late.SelectionGained:Fire()
assert(math.abs(late.Size.X.Scale - 0.525) < 1e-9)
late.SelectionLost:Fire()
assert(late.Size.X.Scale == 0.5)
assert(#h.required == 0, "Hover, press and gamepad animation do not load audio dependencies")
late.Activated:Fire()
assert(#h.sounds == 1 and h.sounds[1] == h.sound and #h.required == 2, "One activation plays one lazy-loaded sound")

-- UIScale callbacks read the current multiplier too, and keep the existing timings.
local scaled = button(0, true)
h.gui.DescendantAdded:Fire(scaled)
h.module.SetUp(scaled, 1.05)
h.module.SetUp(scaled)
scaled.MouseEnter:Fire()
assert(scaled.UIScale.Scale == 1.05 and scaled.Size.X.Scale == 0.5 and h.lastTweenInfo.Time == 0.1)
scaled.MouseButton1Down:Fire()
assert(scaled.UIScale.Scale == 1)
scaled.MouseButton1Up:Fire()
assert(scaled.UIScale.Scale == 1.05)
scaled.MouseLeave:Fire()
assert(scaled.UIScale.Scale == 1)
scaled.SelectionGained:Fire()
assert(scaled.UIScale.Scale == 1.05)
scaled.SelectionLost:Fire()
assert(scaled.UIScale.Scale == 1 and scaled.MouseEnter:Count() == 1)

-- Destroy disconnects every callback; a replacement GUI can bind normally.
late.Destroying:Fire()
for _, event in ipairs(late.signals) do
	assert(event:Count() == 0, "Destroying a button disconnects every managed connection")
end
late.Activated:Fire()
assert(#h.sounds == 1)
local replacement = button()
h.gui.DescendantAdded:Fire(replacement)
assert(replacement.MouseEnter:Count() == 1, "Bind replacement buttons after GUI recreation")
-- A mock can be reused to verify that registration and captured size were also released.
late.Size = dim(0.8, 0, 0.6, 0)
h.module.SetUp(late)
late.MouseEnter:Fire()
assert(math.abs(late.Size.X.Scale - 0.88) < 1e-9, "Destroyed state does not retain the old multiplier or size")

local beforeStart, initiallyTagged, duringScan = button(), button(20), button()
local overlap = harness({ beforeStart }, { initiallyTagged })
overlap.module.SetUp(beforeStart, 1.05)
overlap.onScan = function()
	overlap.gui.DescendantAdded:Fire(beforeStart)
	overlap.gui.DescendantAdded:Fire(duringScan)
end
overlap.module.Start()
beforeStart.MouseEnter:Fire()
assert(math.abs(beforeStart.Size.X.Scale - 0.525) < 1e-9 and beforeStart.MouseEnter:Count() == 1,
	"Startup scanning preserves manual setup performed before Start")
assert(initiallyTagged.MouseEnter:Count() == 1 and duringScan.MouseEnter:Count() == 1,
	"Initial tags and arrivals during scanning are covered")

-- TopbarPlus parents its click region before calculating the final hit area.
-- A global animation must never capture and restore that temporary zero size.
local topbar = button()
topbar.attributes = { CorrespondingIconUID = "inventory-icon" }
topbar.Size = dim(0, 0, 0, 0)
local topbarHarness = harness({ topbar }, { topbar })
topbarHarness.module.Start()
topbarHarness.gui.DescendantAdded:Fire(topbar)
topbarHarness.module.SetUp(topbar)
topbar.Size = dim(0, 36, 1, 0)
for _ = 1, 4 do
	topbar.MouseEnter:Fire()
	topbar.MouseButton1Down:Fire()
	topbar.MouseButton1Up:Fire()
	topbar.MouseLeave:Fire()
	assert(topbar.Size.X.Offset == 36 and topbar.Size.Y.Scale == 1,
		"TopbarPlus retains its clickable area across repeated pointer interactions")
end
assert(topbar.MouseEnter:Count() == 0 and topbar.Activated:Count() == 0,
	"Third-party icon inputs keep their own animation and activation handlers")
