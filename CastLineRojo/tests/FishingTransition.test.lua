local function read(path)
	local file = assert(io.open(path, "r"))
	local result = file:read("*a")
	file:close()
	return result
end
local config = assert(loadstring(read("src/ReplicatedStorage/Modules/FishingConfig.lua")))()
local reelDuration = 1.5 -- Fixture-reported settling time; real spr is tested separately.
local source = read("src/StarterPlayer/StarterPlayerScripts/Controllers/FishingController.lua")
local function fixture()
	local now, render, locked, movement = 0, nil, false, false
	local created, warnings = {}, {}
	local fishingAudio = { active = false, starts = 0 }
	local effectAudio = { clears = 0, refreshes = 0 }
	local function signal()
		local handlers = {}
		return {
			Connect = function(_, callback)
				local connection = { connected = true }
				function connection:Disconnect()
					self.connected = false
				end
				table.insert(handlers, { callback, connection })
				return connection
			end,
			Fire = function(_, ...)
				for _, handler in ipairs(handlers) do
					if handler[2].connected then
						handler[1](...)
					end
				end
			end,
		}
	end
	local vm = {}
	local function vec(x, y, z)
		return setmetatable({ X = x, Y = y, Z = z }, vm)
	end
	vm.__add = function(a, b)
		return vec(a.X + b.X, a.Y + b.Y, a.Z + b.Z)
	end
	vm.__sub = function(a, b)
		return vec(a.X - b.X, a.Y - b.Y, a.Z - b.Z)
	end
	vm.__mul = function(a, b)
		return vec(a.X * b, a.Y * b, a.Z * b)
	end
	vm.__div = function(a, b)
		return vec(a.X / b, a.Y / b, a.Z / b)
	end
	vm.__index = function(a, key)
		if key == "Magnitude" then
			return math.sqrt(a.X * a.X + a.Y * a.Y + a.Z * a.Z)
		end
	end
	local fm = {}
	local function frame(position)
		return setmetatable({ Position = position or vec(0, 0, 0), UpVector = vec(0, 1, 0) }, fm)
	end
	fm.__mul = function(a, b)
		return frame(a.Position + b.Position)
	end
	fm.__index = {
		PointToObjectSpace = function(self, point)
			return point - self.Position
		end,
		ToObjectSpace = function(self, other)
			return frame(other.Position - self.Position)
		end,
		Inverse = function(self)
			return frame(vec(0, 0, 0) - self.Position)
		end,
	}
	local function object(class, children)
		local obj = { Parent = true, ClassName = class, children = children or {}, DescendantAdded = signal() }
		function obj:IsA(kind)
			return kind == self.ClassName
				or kind == "Instance"
				or kind == "BasePart" and self.ClassName == "Part"
				or kind == "GuiObject" and (self.ClassName == "Frame" or self.ClassName == "TextLabel")
		end
		function obj:FindFirstChild(name)
			return self.children[name]
		end
		function obj:FindFirstChildOfClass(kind)
			for _, child in pairs(self.children) do
				if child:IsA(kind) then
					return child
				end
			end
		end
		function obj:GetChildren()
			local result = {}
			for _, child in pairs(self.children) do
				table.insert(result, child)
			end
			return result
		end
		function obj:GetDescendants()
			return {}
		end
		function obj:IsDescendantOf(_)
			return self.Parent ~= nil
		end
		function obj:GetPropertyChangedSignal(_)
			return signal()
		end
		function obj:Destroy()
			self.Parent = nil
			self.destroyCount = (self.destroyCount or 0) + 1
		end
		return obj
	end
	local meter = object("ScreenGui", {
		Meter = object("Frame", {
			Bar = object(
				"Frame",
				{ Marker = object("Frame", { MultLabel = object("TextLabel"), Glow = object("Frame") }) }
			),
			Prompt = object("TextLabel", { UIScale = object("UIScale") }),
		}),
	})
	local root = object("Part")
	root.Position, root.CFrame, root.Size, root.Anchored = vec(0, 3.5, 0), frame(vec(0, 3.5, 0)), vec(2, 2, 1), false
	local humanoid = object("Humanoid")
	humanoid.HipHeight, humanoid.Health, humanoid.AutoRotate, humanoid.Died = 2, 100, true, signal()
	local character = object("Model", { HumanoidRootPart = root, Humanoid = humanoid })
	function character:GetPivot()
		return root.CFrame
	end
	function character:PivotTo(target)
		root.Position, root.CFrame = target.Position, target
		self.teleports = (self.teleports or 0) + 1
	end
	local playerGui = object("PlayerGui", { CastMeterGui = meter })
	playerGui.ChildAdded = signal()
	function playerGui:GetGuiObjectsAtPosition()
		return {}
	end
	local player = object("Player", { PlayerGui = playerGui })
	player.Character, player.CharacterRemoving = character, signal()
	function player:GetAttribute()
		return true
	end
	local start = object("Part")
	start.Position, start.CFrame, start.Size = vec(0, 0, 0), frame(), vec(20, 1, 20)
	local spawn = object("Part")
	spawn.CFrame, spawn.Size = frame(vec(100, 0, 0)), vec(10, 1, 10)
	local camera = { CFrame = frame(), Focus = frame(), FieldOfView = 70 }
	local workspace =
		object("Workspace", { Areas = object("Folder", { CastStartPart = start }), SpawnLocation = spawn })
	workspace.CurrentCamera = camera
	local input, heartbeat = signal(), signal()
	local sequence, failCreate = nil, false
	local controllers = {
		MusicController = {
			SetFishingActive = function(_, active)
				fishingAudio.active = active
				if active then
					fishingAudio.starts += 1
				end
			end,
		},
		PlayerDataController = {
			GetData = function()
				return { Settings = { Sound = true } }
			end,
		},
		SettingsGuiController = { ToggleSound = signal() },
	}
	local modules = {
		Knit = {
			CreateController = function(value)
				return value
			end,
			GetController = function(name)
				return controllers[name]
			end,
		},
		Config = config,
		FishingAudio = {
			ClearTails = function() effectAudio.clears += 1 end,
			RefreshTails = function() effectAudio.refreshes += 1 end,
			new = function()
				return { Destroy = function() end }
			end,
		},
		Constants = { SETTINGS_ID = { SOUND = "Sound" } },
		LoadingAttributes = { LOADING_SCREEN_DONE = "LoadingScreenDone" },
		GameplayInputGate = {
			SetActive = function(_, _, active)
				locked = active
			end,
			IsUiBlockingWorld = function()
				return false
			end,
			IsWorldActionAllowed = function()
				return not locked
			end,
		},
		FishingRigUtil = {
			Create = function()
				if failCreate then
					error("Missing rig resource")
				end
				local rig = object("Model", { Humanoid = humanoid })
				rig.PrimaryPart = root
				function rig:PivotTo(_) end
				return rig
			end,
		},
		FishingCastSequence = {
			new = function()
				sequence = {
					phase = "Preparing",
					gui = object("ScreenGui"),
					UpdateMeter = function() end,
					RefreshSoundSetting = function() end,
					Update = function(self, now)
						if self.phase == "Reeling" and now >= self.reelStarted + reelDuration then
							self.phase, self.readyAt = "Reeled", now + config.Reel.HoldTime
						end
					end,
					Destroy = function(self, keepFail)
						self.keepFail = keepFail
						self.destroyCount = (self.destroyCount or 0) + 1
					end,
					Cast = function(self)
						self.phase = "Casting"
						self.casts = (self.casts or 0) + 1
					end,
					CanReturn = function(self, now)
						return (self.phase == "Reeled" or self.phase == "Caught") and now >= self.readyAt
					end,
					TryHook = function(self, at)
						self.hooks = (self.hooks or 0) + 1
						if self.phase == "Waiting" or self.phase == "Escaped" then
							self.phase = "Reeling"
							self.reelStarted, self.readyAt = at, math.huge
						end
					end,
				}
				return sequence
			end,
		},
	}
	local storage = object("ReplicatedStorage", {
		Character = object("Folder", { PoseDefaultCharacter = object("Model") }),
		Models = object("Folder", {
			FishRod = object("Folder", { TestRod = object("Tool") }),
			FishBait = object("Folder", { ["1"] = object("Folder", { ["1"] = object("Part") }) }),
		}),
		Animation = object("Folder", { Fishing = object("Folder", { CastRod = object("Animation") }) }),
	})
	storage.Packages = { Knit = "Knit" }
	storage.Modules = {
		FishingRigUtil = "FishingRigUtil",
		FishingCastSequence = "FishingCastSequence",
		FishingAudio = "FishingAudio",
		FishingConfig = "Config",
		Constants = "Constants",
		GameplayInputGate = "GameplayInputGate",
	}
	local services = {
		Players = {
			LocalPlayer = player,
			PlayerAdded = signal(),
			GetPlayers = function()
				return { player }
			end,
		},
		ReplicatedStorage = storage,
		ReplicatedFirst = { LoadingAttributes = "LoadingAttributes" },
		Workspace = workspace,
		ProximityPromptService = object("ProximityPromptService"),
		ContextActionService = {
			BindActionAtPriority = function()
				movement = true
			end,
			UnbindAction = function()
				movement = false
			end,
		},
		RunService = {
			Heartbeat = heartbeat,
			BindToRenderStep = function(_, _, _, callback)
				render = callback
			end,
			UnbindFromRenderStep = function()
				render = nil
			end,
		},
		StarterGui = {
			GetCoreGuiEnabled = function()
				return true
			end,
			SetCoreGuiEnabled = function() end,
		},
		UserInputService = { InputBegan = input },
	}
	local env = setmetatable({
		game = {
			GetService = function(_, name)
				return assert(services[name], name)
			end,
		},
		require = function(name)
			return assert(modules[name], name)
		end,
		Instance = {
			new = function(class)
				local obj = object(class)
				table.insert(created, obj)
				return obj
			end,
		},
		os = {
			clock = function()
				return now
			end,
		},
		Vector3 = { new = vec, zero = vec(0, 0, 0), zAxis = vec(0, 0, 1) },
		CFrame = {
			new = function(x, y, z)
				return frame(if type(x) == "table" then x else vec(x or 0, y or 0, z or 0))
			end,
			identity = frame(),
			lookAt = function(position)
				return frame(position)
			end,
		},
		UDim2 = {
			fromScale = function(x, y)
				return { x, y }
			end,
		},
		Color3 = {
			new = function()
				return {}
			end,
		},
		Enum = {
			HumanoidRigType = { R6 = "R6" },
			CameraType = { Custom = "Custom" },
			CoreGuiType = { Backpack = "Backpack" },
			ContextActionPriority = { High = { Value = 2000 } },
			ContextActionResult = { Sink = "Sink" },
			PlayerActions = {
				GetEnumItems = function()
					return {}
				end,
			},
			RenderPriority = { Camera = { Value = 200 } },
			UserInputType = { MouseButton1 = "MouseButton1", Touch = "Touch" },
		},
		warn = function(message)
			table.insert(warnings, message)
		end,
	}, { __index = getfenv() })
	local controller = assert(load(source, "FishingController", "t", env))()
	controller:KnitStart()
	heartbeat:Fire()
	return {
		controller = controller,
		root = root,
		character = character,
		camera = camera,
		warnings = warnings,
		fishingAudio = fishingAudio,
		effectAudio = effectAudio,
		toggleSound = function() controllers.SettingsGuiController.ToggleSound:Fire() end,
		advance = function(dt)
			now += dt
			if render then
				render(dt)
			end
			heartbeat:Fire()
		end,
		tap = function()
			input:Fire({ UserInputType = "MouseButton1", Position = vec(20, 20, 0) }, false)
		end,
		abort = function()
			player.CharacterRemoving:Fire()
		end,
		die = function()
			humanoid.Health = 0
			humanoid.Died:Fire()
		end,
		sequence = function()
			return sequence
		end,
		locked = function()
			return locked or movement
		end,
		failCreate = function()
			failCreate = true
		end,
		covered = function()
			for _, obj in ipairs(created) do
				if obj.Name == "Cover" and obj.Parent and obj.Parent.Parent and obj.Parent.Enabled then
					return 1 - obj.BackgroundTransparency
				end
			end
			return 0
		end,
	}
end
local normal = fixture()
assert(normal.locked() and normal.root.Anchored)
assert(not normal.fishingAudio.active and normal.fishingAudio.starts == 0, "Entering cover must not start ocean audio yet")
normal.advance(0.15)
assert(normal.covered() > 0 and normal.covered() < 1)
assert(normal.sequence() == nil, "Do not replace the character before the screen is covered")
assert(not normal.fishingAudio.active, "Ocean audio must wait for fishing scene preparation")
normal.tap()
normal.advance(0.16)
assert(normal.sequence(), table.concat(normal.warnings, "\n"))
assert(normal.sequence().phase == "Preparing")
assert(normal.fishingAudio.active and normal.fishingAudio.starts == 1, "Preparing the covered fishing scene must start ocean audio once")
normal.tap()
assert(normal.sequence().casts == nil, "Block input until the new scene is revealed")
normal.advance(0.36)
normal.tap()
normal.tap()
assert(
	normal.sequence().casts == 1,
	"Casting must only start once: " .. tostring(normal.sequence().casts) .. " " .. table.concat(normal.warnings, "\n")
)
normal.sequence().phase, normal.sequence().readyAt = "Settling", math.huge
normal.tap()
assert(normal.covered() == 0, "Early landing taps must not start return")
normal.sequence().readyAt = 0
normal.sequence().phase = "Struggling"
normal.tap()
assert(normal.covered() == 0, "Struggle input must not return")
normal.sequence().phase = "Caught"
normal.tap()
normal.tap()
normal.advance(0.15)
assert(normal.sequence().destroyCount == nil, "Keep the sequence visible until return is covered")
assert(normal.fishingAudio.active, "Keep ocean audio until the fishing scene is restored")
normal.advance(0.16)
assert(normal.character.teleports == 1 and normal.sequence().destroyCount == 1)
assert(normal.sequence().keepFail, "Normal covered return must allow the failure tail")
assert(not normal.fishingAudio.active, "Covered return must stop ocean audio")
assert(normal.locked(), "Keep gameplay blocked until the world is revealed")
normal.advance(0.36)
assert(not normal.locked() and not normal.root.Anchored and normal.covered() == 0)
assert(normal.effectAudio.clears == 1, "Finishing a normal return must not clear the tail")
normal.toggleSound()
assert(normal.effectAudio.refreshes == 1, "Sound settings must reach tails outside fishing")
assert(normal.camera.FieldOfView == 70 and not normal.controller:IsPreparing())
assert(#normal.warnings == 0)
for _, phase in ipairs({ "Waiting", "Escaped" }) do
	local reeled = fixture()
	reeled.advance(0.31)
	reeled.advance(0.36)
	reeled.sequence().phase = phase
	reeled.tap()
	local startedAt = reeled.sequence().reelStarted
	assert(reeled.sequence().phase == "Reeling" and reeled.covered() == 0, "First tap skipped reel showcase")
	reeled.tap()
	assert(reeled.sequence().reelStarted == startedAt, "Repeated tap restarted reeling")
	reeled.advance(reelDuration + 0.1)
	reeled.tap()
	assert(reeled.covered() == 0 and not reeled.sequence().destroyCount, "Reel showcase returned before settling")
	reeled.advance(config.Reel.HoldTime - 0.01)
	assert(reeled.covered() == 0 and not reeled.sequence().destroyCount, "Auto-return shortened the showcase")
	reeled.advance(0.011)
	reeled.advance(0.15)
	assert(reeled.covered() > 0 and not reeled.sequence().destroyCount, "Empty reel did not auto-return")
	reeled.tap()
	reeled.advance(0.16)
	assert(reeled.sequence().destroyCount == 1 and reeled.character.teleports == 1, "Auto-return must finish once")
	reeled.advance(0.36)
	assert(not reeled.controller:IsPreparing() and not reeled.root.Anchored)
	assert(not reeled.fishingAudio.active, "Auto-return must stop ocean audio")
end
for _, delay in ipairs({ 0.1, reelDuration + 0.1 }) do
	local cancelled = fixture()
	cancelled.advance(0.31)
	cancelled.advance(0.36)
	cancelled.sequence().phase = "Waiting"
	cancelled.tap()
	cancelled.advance(delay)
	cancelled.abort()
	cancelled.advance(10)
	assert(cancelled.sequence().destroyCount == 1 and not cancelled.controller:IsPreparing(), "Cancelled reel returned again")
	assert(not cancelled.fishingAudio.active, "Cancelled reel must stop ocean audio")
end
for _, elapsed in ipairs({ 0.15, 0.31, 0.67 }) do
	local interrupted = fixture()
	interrupted.advance(elapsed)
	interrupted.abort()
	assert(not interrupted.locked() and not interrupted.root.Anchored and interrupted.covered() == 0)
	interrupted.advance(5)
	assert(not interrupted.controller:IsPreparing(), "Cancelled transitions must not reopen")
	assert(not interrupted.fishingAudio.active, "Interrupted transitions must leave ocean audio stopped")
end
local returning = fixture()
returning.advance(0.31)
returning.advance(0.36)
returning.controller:ReturnToSpawn()
returning.advance(0.15)
returning.abort()
returning.advance(5)
assert(returning.covered() == 0 and not returning.locked() and returning.sequence().destroyCount == 1)
assert(not returning.fishingAudio.active, "Interrupted return must stop ocean audio")
local failed = fixture()
failed.failCreate()
failed.advance(0.31)
assert(not failed.locked() and not failed.root.Anchored and failed.covered() == 0 and #failed.warnings == 1)
assert(not failed.fishingAudio.active and failed.fishingAudio.starts == 0, "Failed preparation must never start ocean audio")
local dead = fixture()
dead.advance(0.31)
assert(dead.fishingAudio.active)
dead.die()
assert(dead.sequence().keepFail == false, "Death must not preserve a failure tail")
assert(not dead.fishingAudio.active and not dead.controller:IsPreparing(), "Death must stop ocean audio")
local broken = fixture()
broken.advance(0.31)
assert(broken.fishingAudio.active)
broken.sequence().Update = function() error("Sequence update failed") end
broken.advance(0.36)
assert(not broken.fishingAudio.active and not broken.controller:IsPreparing(), "Runtime errors must stop ocean audio")
assert(#broken.warnings == 1, "Runtime errors must retain their warning")
