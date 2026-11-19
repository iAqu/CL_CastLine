local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end
local loading = assert(load(read("src/ReplicatedFirst/LoadingAttributes.lua")))()
local introConfig = assert(load(read("src/ReplicatedStorage/Modules/FishingIntroConfig.lua")))()
local source = read("src/StarterPlayer/StarterPlayerScripts/Controllers/FishingIntroController.lua")
local ending = assert(source:find("return Controller\n", 1, true))
source = source:sub(1, ending - 1) .. [[
Controller.testUpdate = update
Controller.testSetSession = function(value) session = value end
return Controller
]]
local function signal()
	local callbacks = {}
	return {
		Connect = function(_, callback)
			table.insert(callbacks, callback)
			return { Disconnect = function() end }
		end,
		Fire = function(_, ...)
			for _, callback in callbacks do callback(...) end
		end,
	}
end
local function fixture(eligible)
	local now, plays, warnings, starts, ducks = 0, {}, {}, {}, {}
	local cancellations = {}
	local attributes, changed = {}, {}
	local player = { Parent = true, CharacterRemoving = signal() }
	function player:GetAttribute(name) return attributes[name] end
	function player:GetAttributeChangedSignal(name)
		changed[name] = changed[name] or signal()
		return changed[name]
	end
	function player:SetAttribute(name, value)
		local previous = attributes[name]
		attributes[name] = value
		if previous ~= value then self:GetAttributeChangedSignal(name):Fire() end
	end
	local humanoid = { Health = 100 }
	local root = { Parent = true }
	local character = {
		IsDescendantOf = function() return true end,
		FindFirstChild = function() return root end,
		FindFirstChildOfClass = function() return humanoid end,
	}
	player.Character = character
	local appearance = true
	function player:HasAppearanceLoaded() return appearance end
	local gui = { FindFirstChild = function() return nil end }
	player.PlayerGui = gui
	function player:WaitForChild() return gui end
	local camera = { ViewportSize = {} }
	local function promise()
		local result = {}
		function result:timeout(seconds)
			assert(seconds == loading.INTRO_CLAIM_TIMEOUT)
			return self
		end
		function result:andThen(callback) self.resolve = callback return self end
		function result:catch(callback) self.reject = callback return self end
		return result
	end
	local service = {
		ClaimAutoPlay = function()
			local request = promise()
			function request:await()
				if eligible == "Pending" then return coroutine.yield("Claim") end
				if eligible == "Timeout" then return false, "Timed out" end
				return true, eligible
			end
			return request
		end,
		StartPlayback = function()
			local request = promise()
			table.insert(starts, request)
			return request
		end,
		Cancel = function(_, token, completed)
			table.insert(cancellations, { token = token, completed = completed })
			return promise()
		end,
	}
	local music = {
		SetCinematicDuck = function(_, _, value) table.insert(ducks, { value }) end,
		SetFishingActive = function() end,
	}
	local input = { InputBegan = signal(), GetFocusedTextBox = function() return nil end }
	local modules = {
		FishingIntroConfig = introConfig,
		FishingInstructionView = assert(load(
			read("src/ReplicatedStorage/Modules/FishingInstructionView.lua"),
			"FishingInstructionView", "t", setmetatable({
				game = { GetService = function() return input end },
				script = { Parent = { FishingIntroConfig = introConfig } },
				require = function(value) return value end,
				UDim2 = { fromScale = function() end },
				Color3 = { fromRGB = function() end },
				Enum = { PreferredInput = { Gamepad = "Gamepad" } },
			}, { __index = getfenv() })
		))(),
		GameplayInputGate = {
			SetActive = function() end,
			IsWorldActionAllowed = function() return true end,
			IsUiBlockingWorld = function() return false end,
		},
		PlotWorkspaceUtil = { getPlotBySlot = function() return { FindFirstChild = function() return {} end } end },
	}
	local tasks = {}
	local services = {
		Players = { LocalPlayer = player },
		ReplicatedStorage = { Modules = modules, Packages = { Knit = {
			CreateController = function(value) return value end,
			GetService = function() return service end,
			GetController = function() return music end,
		} } },
		ReplicatedFirst = { LoadingAttributes = loading, Data = {} },
		Workspace = { CurrentCamera = camera },
		RunService = { IsStudio = function() return true end, UnbindFromRenderStep = function() end },
		ContextActionService = { UnbindAction = function() end },
		UserInputService = input,
	}
	local environment = setmetatable({
		game = { GetService = function(_, name) return services[name] or {} end },
		require = function(value) return value or {} end,
		Instance = { new = function() return {} end },
		Enum = {
			KeyCode = { F6 = "F6", F7 = "F7", ButtonA = "ButtonA" },
			UserInputType = { MouseButton1 = "MouseButton1", Touch = "Touch" },
			PreferredInput = { Gamepad = "Gamepad" },
		},
		CFrame = { new = function(value) return value end },
		UDim2 = { fromScale = function(x, y) return { X = x, Y = y } end },
		Color3 = { fromRGB = function(r,g,b) return {r,g,b} end },
		os = { clock = function() return now end },
		task = { wait = coroutine.yield, spawn = function(callback) table.insert(tasks, callback) end },
		warn = function(message) table.insert(warnings, message) end,
	}, { __index = getfenv() })
	local controller = assert(load(source, "FishingIntroController", "t", environment))()
	controller:KnitInit()
	controller.Play = function(_, mode) table.insert(plays, mode) return true end
	attributes[loading.PLAYER_DATA_LOADED] = true
	attributes[loading.CLIENT_CONTROLLERS_READY] = true
	attributes[loading.LOADING_BASE_READY] = true
	return {
		controller = controller, player = player, attributes = attributes, plays = plays, warnings = warnings,
		camera = camera, starts = starts, ducks = ducks, input = input, tasks = tasks, cancellations = cancellations,
		clock = function(value) now = value end,
		appearance = function(value) appearance = value end,
		run = function(mode)
			local thread = coroutine.create(function() controller:_RunStartup(mode or "Auto") end)
			local ok, err = coroutine.resume(thread)
			assert(ok, err)
			return thread
		end,
		prepared = function()
			local samples = {}
			local state = {
				phase = "Prepared", preparedAt = 0, root = root, character = character, humanoid = humanoid, hint = { FindFirstChildOfClass = function() return {} end },
				service = service, token = "test", saved = {}, connections = {},
                scene = { Destroy = function() end },
                sequence = {
                    phase = "Preparing", meter = { prompt = {} }, continueLabel = {},
                    Update = function(_,time,dt) table.insert(samples,{time=time,dt=dt}) end,
                    Destroy = function() end,
                },
				gui = { SetAttribute = function() end, Destroy = function() end },
			}
			controller.testSetSession(state)
			return state, samples
		end,
	}
end

local veteran = fixture(false)
veteran.appearance(false)
veteran.run()
assert(#veteran.plays == 0 and veteran.attributes[loading.INTRO_STARTUP_STATE] == "Skipped")

local first = fixture(true)
local startup = first.run()
assert(first.attributes[loading.INTRO_STARTUP_STATE] == "Preparing" and #first.plays == 0)
first.attributes[loading.INTRO_HANDOFF_READY] = true
assert(coroutine.resume(startup))
assert(first.plays[1] == "Auto" and coroutine.status(startup) == "dead")

local canceled = fixture("Pending")
local lateClaim = canceled.run()
canceled.controller:Cancel()
assert(coroutine.resume(lateClaim, true, true))
assert(#canceled.plays == 0 and canceled.attributes[loading.INTRO_STARTUP_STATE] == "Skipped", "Late claim cannot revive a stopped intro")

local timeout = fixture("Timeout")
timeout.run()
assert(#timeout.plays == 0 and #timeout.warnings == 1)
local missing = fixture(true)
missing.appearance(false)
local waiting = missing.run()
missing.clock(31)
assert(coroutine.resume(waiting))
assert(missing.attributes[loading.INTRO_STARTUP_STATE] == "Skipped" and #missing.plays == 0)

local frozen = fixture(true)
local state, samples = frozen.prepared()
frozen.controller.testUpdate(state, 500, 1)
frozen.controller.testUpdate(state, 600, 1)
assert(#frozen.starts == 0 and state.startedAt == nil)
for _, sample in samples do assert(sample.time == 0 and sample.dt == 0) end
frozen.attributes[loading.LOADING_SCREEN_DONE] = true
frozen.controller.testUpdate(state, 700, 1)
assert(#frozen.starts == 1 and state.phase == "PlaybackStarting")
frozen.clock(1000)
frozen.starts[1].resolve({ ok = true })
assert(state.startedAt == 1000 and state.phase == "Teaching", "Teaching starts directly at handoff acknowledgement")
frozen.controller.testUpdate(state, 1000, 0)
assert(samples[#samples].time == 1000 and state.hint.Text == "TAP TO CAST!")

local lateStart = fixture(true)
local lateState = lateStart.prepared()
lateStart.attributes[loading.LOADING_SCREEN_DONE] = true
lateStart.controller.testUpdate(lateState, 0, 0)
lateStart.controller:Cancel()
lateStart.starts[1].resolve({ ok = true })
assert(lateState.startedAt == nil and not lateStart.controller:IsPlaying(), "Late playback acknowledgement cannot revive a canceled session")

local shortcuts = fixture(false)
shortcuts.controller:KnitStart()
shortcuts.attributes[loading.LOADING_SCREEN_DONE] = true
shortcuts.input.InputBegan:Fire({ KeyCode = "F6" }, false)
shortcuts.input.InputBegan:Fire({ KeyCode = "F6" }, false)
assert(#shortcuts.plays == 2 and shortcuts.plays[2] == "Preview", "F6 can replay without an automatic eligibility claim")
shortcuts.input.InputBegan:Fire({ KeyCode = "F7" }, true)
assert(shortcuts.attributes[loading.INTRO_STARTUP_STATE] == "Skipped", "F7 works even when overlay input was processed")

local handoff = fixture(true)
local caught, caughtSamples = handoff.prepared()
caught.phase, caught.caughtAt, caught.readyAt = "Teaching", 10, 1
caught.sequence.phase = "Caught"
caught.camera = { frame = "normal frame", focus = "normal focus", fov = 70, kind = "Custom" }
handoff.camera.CFrame, handoff.camera.CameraType = "fish closeup", "Scriptable"
handoff.attributes.FishingIntroActive = true
caught.sequence.gui = { RevealInfo = {} }
caught.sequence.vignette = { gui = {} }
caught.sequence.Update = function()
	-- Model the shared sequence updating its own prompt before the intro applies the hold.
	caught.sequence.continueLabel.Visible = true
	caught.sequence.continueLabel.Text = "tap to continue"
end
handoff.controller.testUpdate(caught, caught.caughtAt, 0)
assert(not caught.sequence.continueLabel.Visible and not caught.hint.Visible)
handoff.controller.testUpdate(caught, caught.caughtAt + introConfig.SuccessHold, 0)
assert(caught.sequence.continueLabel.Visible and not caught.hint.Visible)
assert(caught.sequence.continueLabel.Text == "tap to continue", "Keep the regular fishing prompt for mouse and touch")
handoff.input.PreferredInput = "Gamepad"
handoff.controller.testUpdate(caught, caught.caughtAt + introConfig.SuccessHold, 0)
assert(caught.sequence.continueLabel.Text == "press A to continue", "Show the gamepad confirmation on the small prompt")
caught.sequence.Update = function(_, time, dt)
	table.insert(caughtSamples, { time = time, dt = dt })
end
local confirm = { KeyCode = "ButtonA", UserInputType = "Gamepad1" }
handoff.clock(11.3)
handoff.controller:HandleInput(confirm, false)
assert(not caught.exitRequested, "The minimum catch hold still applies")
handoff.clock(11.5)
handoff.controller:HandleInput(confirm, true)
assert(not caught.exitRequested, "Ignore confirmations already consumed by UI")
handoff.controller:HandleInput(confirm, false)
handoff.controller:HandleInput(confirm, false)
assert(caught.exitRequested and handoff.controller:IsPlaying() and handoff.camera.CFrame == "fish closeup",
	"Keep the input gate in place while dispatching the Continue input")
handoff.controller.testUpdate(caught, 11.516, 0.016)
assert(handoff.camera.CameraType == "Custom" and handoff.camera.CFrame == "normal frame" and handoff.camera.FieldOfView == 70,
	"Cut straight to the normal camera on the first render after confirmation")
assert(#caughtSamples == 0 and not handoff.controller:IsPlaying() and handoff.attributes.FishingIntroActive == false,
	"Do not render another shot or leave presentation state active")
assert(#handoff.cancellations == 1 and handoff.cancellations[1].token == "test"
	and handoff.cancellations[1].completed == nil, "Close the completed intro session once with just its token")
assert(#lateStart.cancellations == 1 and lateStart.cancellations[1].token == "test"
	and lateStart.cancellations[1].completed == nil, "Close an interrupted intro session in the same way")
