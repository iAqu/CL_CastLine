local function read(path)
	local file = assert(io.open(path, "r"))
	local result = file:read("*a")
	file:close()
	return result
end
local config = assert(loadstring(read("src/ReplicatedStorage/Modules/FishingConfig.lua")))()
local reelDuration = 1.5 -- Fixture-reported settling time; real spr is tested separately.
local source = read("src/StarterPlayer/StarterPlayerScripts/Controllers/FishingController.lua")
local function fixture(deferBegin: boolean?, startOutside: boolean?, deferCast: boolean?, lesson: string?)
	local now, render, locked, movement = 0, nil, false, false
	local created, warnings = {}, {}
	local requests, cancellations, notices = {}, {}, {}
	local castReplies = {}
	local selections, autoSelectFailure = {}, nil
	local pickerShows, pickerDestroys = 0, 0
	local fishingAudio = { active = false, starts = 0 }
	local effectAudio = { clears = 0, refreshes = 0, preloads = 0 }
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
		return setmetatable({ Position = position or vec(0, 0, 0), UpVector = vec(0, 1, 0), LookVector = vec(0, 0, 1) }, fm)
	end
	fm.__mul = function(a, b)
		return frame(a.Position + b.Position)
	end
	fm.__index = {
		PointToWorldSpace = function(self, point) return self.Position + point end,
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
		local obj = { Parent = true, ClassName = class, children = children or {}, DescendantAdded = signal(), DescendantRemoving = signal() }
		local attributes = {}
		local properties, propertySignals = {}, {}
		setmetatable(obj, {
			__index = properties,
			__newindex = function(self, key, value)
				if key ~= "Enabled" and key ~= "Visible" then
					rawset(self, key, value)
				elseif properties[key] ~= value then
					properties[key] = value
					if propertySignals[key] then
						propertySignals[key]:Fire()
					end
				end
			end,
		})
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
			local result = {}
			for _, child in pairs(self.children) do
				table.insert(result, child)
				for _, descendant in ipairs(child:GetDescendants()) do
					table.insert(result, descendant)
				end
			end
			return result
		end
		function obj:GetAttribute(name)
			return attributes[name]
		end
		function obj:SetAttribute(name, value)
			attributes[name] = value
		end
		function obj:IsDescendantOf(_)
			return self.Parent ~= nil
		end
		function obj:GetPropertyChangedSignal(property)
			propertySignals[property] = propertySignals[property] or signal()
			return propertySignals[property]
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
	local baitGui = object("ScreenGui")
	baitGui.Enabled = false
	local guideButton = object("TextButton")
	local wins, luck, layout = object("Frame"), object("Frame"), object("UIListLayout")
	local currency = object("Frame", { Wins = wins, Luck = luck, UIListLayout = layout })
	local bottom = object("Frame", { CurrencyFrame = currency })
	local backpack = object("Frame")
	local homeGui = object("ScreenGui", { BottomFrame = bottom, BackpackPanel = backpack })
	bottom.Parent, currency.Parent, wins.Parent = homeGui, bottom, currency
	homeGui.Enabled, bottom.Visible, currency.Visible, wins.Visible = true, true, true, true
	backpack.Visible, luck.Visible = true, false
	local sequenceGui = object("ScreenGui")
	sequenceGui.Enabled = true
	local vignetteGui = object("ScreenGui")
	vignetteGui.Name, vignetteGui.Enabled = "FishingVignetteGui", true
	local playerGui = object("PlayerGui", {
		CastMeterGui = meter, BaitSelectGui = baitGui, HomeGui = homeGui, FishingSequenceGui = sequenceGui,
		FishingVignetteGui = vignetteGui,
	})
	playerGui.ChildAdded = signal()
	function playerGui:GetGuiObjectsAtPosition()
		return {}
	end
	local player = object("Player", { PlayerGui = playerGui })
	player.Character, player.CharacterRemoving, player.UserId = character, signal(), 123
	function player:GetAttribute(name)
		return if name == "PlotSlotId" then 1 else true
	end
	local start = object("Part")
	start.Position, start.CFrame, start.Size = vec(0, 0, 0), frame(), vec(20, 1, 20)
	function start:GetAttribute(name)
		return if name == "FishingWaterSurfaceY" then 775.01 else nil
	end
	local spawn = object("Part")
	spawn.CFrame, spawn.Size = frame(vec(100, 0, 0)), vec(10, 1, 10)
	local camera = { CFrame = frame(), Focus = frame(), FieldOfView = 70 }
	local plot = object("Model", { FishingStartPart = start, AreaSpawnPoint = spawn })
	plot.Name, plot.owner = "Plot_1", player.UserId
	function plot:GetAttribute() return self.owner end
	local workspace = object("Workspace", { Areas = object("Folder", { Plot = object("Folder", { Plot_1 = plot }) }) })
	workspace.CurrentCamera = camera
	local function addBillboard(inPlayerGui, enabled, exempt)
		local container = if inPlayerGui then playerGui else workspace
		local billboard = object("BillboardGui")
		billboard.Enabled = enabled
		billboard:SetAttribute("FishingBillboardExempt", exempt)
		container.children[billboard] = billboard
		container.DescendantAdded:Fire(billboard)
		return billboard
	end
	local billboards = {}
	for _, container in ipairs({ workspace, playerGui }) do
		local visible, hidden = object("BillboardGui"), object("BillboardGui")
		visible.Enabled, hidden.Enabled = true, false
		container.children.SceneLabels = object("Folder", { Visible = visible, Hidden = hidden })
		table.insert(billboards, { visible = visible, hidden = hidden })
	end
	local input, heartbeat = signal(), signal()
	local sequence, failCreate = nil, false
	local chooseBait
	local function resolved(result)
		return {
			andThen = function(self, callback)
				callback(result)
				return self
			end,
			catch = function(self) return self end,
		}
	end
	local fishingService = {
		AnalyticsPresentation = { Fire = function() end },
		Begin = function()
			if not deferBegin then
				return resolved({
					ok = true,
					token = "test",
					rodId = "Rod_101",
					lesson = lesson,
					guideBaitId = if lesson == "FinalCatch" then "Bait_102" else nil,
				})
			end
			return {
				andThen = function(self, callback)
					table.insert(requests, callback)
					return self
				end,
				catch = function(self) return self end,
			}
		end,
		SelectBait = function(_, _, baitId)
			table.insert(selections, baitId)
			if autoSelectFailure then
				return resolved({ ok = false, message = autoSelectFailure })
			end
			if baitId == "Unaffordable" then
				return resolved({ ok = false, message = "Not enough cash" })
			end
			return resolved({ ok = true, initialYaw = 0, luck = 7.25, lesson = lesson })
		end,
		Cast = function(_, _, progress)
			assert(progress == 0.5, "Send the locked visible meter progress")
			assert(sequence.clickSounds == 1, "Local click feedback must occur before the server request")
			if deferCast then
				return {
					andThen = function(self, callback)
						table.insert(castReplies, callback)
						return self
					end,
					catch = function(self) return self end,
				}
			end
			return resolved({ ok = true, distance = 30, luck = 3.9875 })
		end,
		Cancel = function(_, token)
			table.insert(cancellations, token)
			return resolved({ ok = true })
		end,
	}
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
		FishingOnboarding = dofile("src/ReplicatedStorage/Modules/FishingOnboarding.lua"),
		FishingAnalyticsPresentation = dofile("src/ReplicatedStorage/Modules/FishingAnalyticsPresentation.lua"),
		FishingVisibility = dofile("src/ReplicatedStorage/Modules/FishingVisibility.lua"),
		PetFeatureConfig = { Enabled = false },
		Knit = {
			CreateController = function(value)
				return value
			end,
			GetService = function() return fishingService end,
			GetController = function(name)
				return controllers[name]
			end,
		},
		Config = config,
		RodsData = { Rod_101 = { Model = "Alien Antenna", MaxWeight = 10 } },
		BaitsData = { Bait_102 = { Model = "1", DisplayName = "Caterpillar" } },
		FishesData = {},
		EggsData = {},
		NotificationClient = { RedNotify = function(message) table.insert(notices, message) end },
		FishingAssets = { GetBait = function() return object("Part") end },
		FishingBaitSelect = { Bind = function(gui, _, _, choose)
			chooseBait = choose
			return {
				GetButton = function(baitId)
					return if gui.Enabled and baitId == "Bait_102" then guideButton else nil
				end,
				Show = function()
					pickerShows += 1
					gui.Enabled = true
				end,
				SetBusy = function() end,
				Destroy = function()
					pickerDestroys += 1
					gui.Enabled = false
				end,
			}
		end },
		FishingAudio = {
			PreloadLuckSounds = function() effectAudio.preloads += 1 end,
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
			PlaceAtFishingSpot = function(_, part)
				return part.Position
			end,
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
			new = function(_, _, sequenceMeter, _, _, options)
				vignetteGui.Enabled = true
					assert(options.fixedCast and options.launchPosition == start.Position)
					assert(options.initialLuck == 7.25, "Forward the server's initial luck to the presentation")
					assert(options.waterSurfaceY == nil, "Ignore the legacy water height on FishingStartPart")
				sequence = {
					phase = "Preparing",
					gui = object("ScreenGui"),
					bitePrompt = addBillboard(false, false, true),
					continueLabel = object("TextLabel"),
					RefreshSoundSetting = function() end,
					Update = function(self, now)
						if self.phase == "Reeling" and now >= self.reelStarted + reelDuration then
							self.phase, self.readyAt = "Reeled", now + config.Reel.HoldTime
						end
						self.bitePrompt.Enabled = self.phase == "Bite"
						self.continueLabel.Visible = true
						sequenceMeter.prompt.Visible = true
					end,
					Destroy = function(self, keepFail)
						vignetteGui.Enabled = false
						self.bitePrompt:Destroy()
						workspace.children[self.bitePrompt] = nil
						self.keepFail = keepFail
						self.destroyCount = (self.destroyCount or 0) + 1
					end,
					LockCastMeter = function(self)
						self.meterLocks = (self.meterLocks or 0) + 1
						self.clickSounds = (self.clickSounds or 0) + 1
						return 0.5
					end,
					Cast = function(self, progress, distance, luck)
						assert(progress == 0.5 and distance == 30 and luck == 3.9875,
							"Use the locked meter and the server-confirmed luck")
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
			FishRod = object("Folder", { ["Alien Antenna"] = object("Tool") }),
			FishBait = object("Folder", { ["1"] = object("Folder", { ["1"] = object("Part") }) }),
		}),
		Animation = object("Folder", { Fishing = object("Folder", { CastRod = object("Animation") }) }),
	})
	storage.Packages = { Knit = "Knit" }
	storage.Modules = {
		FishingOnboarding = "FishingOnboarding",
		FishingAnalyticsPresentation = "FishingAnalyticsPresentation",
		PetFeatureConfig = "PetFeatureConfig",
		FishingRigUtil = "FishingRigUtil",
		FishingVisibility = "FishingVisibility",
		FishingCastSequence = "FishingCastSequence",
		FishingAudio = "FishingAudio",
		FishingConfig = "Config",
		FishingAssets = "FishingAssets",
		FishingBaitSelect = "FishingBaitSelect",
		FishingSpotUtil = "FishingSpotUtil",
		PlotWorkspaceUtil = "PlotWorkspaceUtil",
		NotificationClient = "NotificationClient",
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
		ReplicatedFirst = {
			LoadingAttributes = "LoadingAttributes",
			WaitForChild = function()
				return { WaitForChild = function(_, name) return name end }
			end,
		},
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
				if name == "MarketplaceService" then return {} end
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
		Vector3 = { new = vec, zero = vec(0, 0, 0), yAxis = vec(0, 1, 0) },
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
			KeyCode = { ButtonA = "ButtonA" },
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
	for _, name in ipairs({ "FishingSpotUtil", "PlotWorkspaceUtil" }) do
		modules[name] = assert(load(read("src/ReplicatedStorage/Modules/" .. name .. ".lua"), name, "t", env))()
	end
	local controller = assert(load(source, "FishingController", "t", env))()
	controller:KnitInit()
	assert(effectAudio.preloads == 1, "Preload UI feedback sounds during client initialization")
	assert(not sequenceGui.Enabled, "Hide sequence sample labels before the first fishing session")
	assert(not vignetteGui.Enabled, "Hide the vignette before the first fishing session")
	controller:KnitStart()
	if startOutside then
		root.Position = vec(0, 3.5, -20)
	end
	heartbeat:Fire()
	return {
		controller = controller,
		plot = plot,
		root = root,
		character = character,
		camera = camera,
		warnings = warnings,
		billboards = billboards,
		addBillboard = addBillboard,
		castPrompt = meter.children.Meter.children.Prompt,
		requests = requests,
		cancellations = cancellations,
		notices = notices,
		castReplies = castReplies,
		selections = selections,
		failAutoSelect = function(message) autoSelectFailure = message end,
		leave = function()
			root.Position = vec(0, 3.5, -20)
			heartbeat:Fire()
		end,
		move = function(z)
			root.Position = vec(0, 3.5, z)
			heartbeat:Fire()
		end,
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
		baitVisible = function() return baitGui.Enabled == true end,
		guideButton = guideButton,
		vignetteVisible = function() return vignetteGui.Enabled == true end,
		pickerShows = function() return pickerShows end,
		pickerDestroys = function() return pickerDestroys end,
		choose = function(baitId) chooseBait(baitId or "NONE") end,
		cashVisible = function() return homeGui.Enabled and bottom.Visible and currency.Visible and wins.Visible end,
		backpackVisible = function() return homeGui.Enabled and backpack.Visible end,
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
local function revealPicker(fishing)
	fishing.advance(0.121)
	fishing.advance(0.101)
end

for _, lesson in ipairs({ "FirstCatch", "FinalCatch" }) do
	local fishing = fixture(false, false, false, lesson)
	revealPicker(fishing)
	if lesson == "FirstCatch" then
		assert(fishing.pickerShows() == 0 and not fishing.baitVisible() and not fishing.cashVisible())
		assert(#fishing.selections == 1 and fishing.selections[1] == "NONE")
		local active, hint = fishing.controller:GetOnboardingHint()
		assert(active and hint == "Cast", "First catch must wait for the player's cast")
	else
		assert(fishing.baitVisible() and fishing.cashVisible() and fishing.pickerShows() == 1)
		local active, hint, baitButton, message = fishing.controller:GetOnboardingHint()
		assert(active and not hint and baitButton == fishing.guideButton and message == "SELECT CATERPILLAR",
			"The final catch must point to the configured bait button and name the bait")
		fishing.choose("Bait_104")
		assert(fishing.notices[1] == "Select Caterpillar." and fishing.baitVisible() and #fishing.selections == 0)
		assert(select(3, fishing.controller:GetOnboardingHint()) == fishing.guideButton,
			"A rejected selection must keep guiding the player")
		fishing.choose("Bait_102")
		assert(fishing.selections[1] == "Bait_102")
		local casting, castHint, staleTarget, staleMessage = fishing.controller:GetOnboardingHint()
		assert(casting and castHint == "FinalCast" and not staleTarget and not staleMessage)
	end
	local sequence = fishing.sequence()
	assert(sequence, "Selecting bait must start the teaching sequence")
	for _, phase in ipairs({ "Nibbling", "Bite", "Bite", "Struggling" }) do
		sequence.phase = phase
		fishing.advance(0.016)
		assert(#fishing.warnings == 0 and fishing.controller:IsPreparing(), "The lesson must remain active")
		assert(
			sequence.bitePrompt.Enabled == (phase == "Bite"),
			lesson .. " has incorrect prompt visibility during " .. phase
		)
		assert(
			not fishing.castPrompt.Visible and not sequence.continueLabel.Visible,
			"Hide duplicate fishing instructions"
		)
		if phase == "Bite" then
			local active, hint = fishing.controller:GetOnboardingHint()
			assert(active and hint == "Hook", "Show the onboarding hook instruction alongside the bite prompt")
		end
	end
end

local exitPicker = fixture(false, false, false, "FinalCatch")
exitPicker.advance(0.121)
local entering, enteringHint, enteringTarget = exitPicker.controller:GetOnboardingHint()
assert(entering and not enteringHint and not enteringTarget, "Keep the spotlight hidden during the entry transition")
exitPicker.advance(0.101)
assert(select(3, exitPicker.controller:GetOnboardingHint()) == exitPicker.guideButton)
exitPicker.controller:ReturnToSpawn()
local returningLesson, returnHint, returnTarget = exitPicker.controller:GetOnboardingHint()
assert(returningLesson and not returnHint and not returnTarget, "Clear the spotlight when the picker starts closing")
exitPicker.abort()
assert(not exitPicker.controller:GetOnboardingHint() and not exitPicker.baitVisible())

do
	local fishing = fixture(false, false, false, "FirstCatch")
	fishing.failAutoSelect("Bait model unavailable")
	revealPicker(fishing)
	assert(fishing.notices[1] == "Bait model unavailable" and #fishing.cancellations == 1)
	assert(fishing.pickerShows() == 0 and not fishing.baitVisible() and fishing.cashVisible())
	assert(not fishing.controller:IsPreparing() and not fishing.locked() and not fishing.root.Anchored)
	assert(fishing.camera.CameraType == "Custom")
end

do
	local fishing = fixture()
	for _, pair in ipairs(fishing.billboards) do
		assert(not pair.visible.Enabled and not pair.hidden.Enabled, "Hide nested scene billboards at session start")
		pair.visible.Enabled, pair.hidden.Enabled = true, true
		assert(not pair.visible.Enabled and not pair.hidden.Enabled, "Hold both original states hidden")
	end
	revealPicker(fishing)
	local addedWorld = fishing.addBillboard(false, true)
	local addedGui = fishing.addBillboard(true, false)
	local bitePrompt = fishing.addBillboard(false, false, true)
	bitePrompt.Enabled = true
	assert(not addedWorld.Enabled and not addedGui.Enabled and bitePrompt.Enabled,
		"Hide newly added scene billboards while allowing the bite prompt")
	addedWorld.Enabled, addedGui.Enabled = true, true
	assert(not addedWorld.Enabled and not addedGui.Enabled, "Keep new billboards hidden when enabled externally")
	fishing.controller:ReturnToSpawn()
	fishing.advance(0.15)
	assert(not fishing.billboards[1].visible.Enabled, "Keep billboards hidden until return is covered")
	fishing.advance(0.16)
	for _, pair in ipairs(fishing.billboards) do
		assert(pair.visible.Enabled and not pair.hidden.Enabled, "Restore each billboard's original Enabled state")
		pair.hidden.Enabled = true
		assert(pair.hidden.Enabled, "Release the property listener during covered return")
	end
	assert(addedWorld.Enabled and not addedGui.Enabled, "Restore original states for billboards added during fishing")
	addedGui.Enabled = true
	assert(addedGui.Enabled and fishing.addBillboard(false, true).Enabled and fishing.addBillboard(true, true).Enabled,
		"Release property and descendant listeners before the return reveal finishes")
	fishing.advance(0.36)
	assert(not fishing.controller:IsPreparing() and #fishing.warnings == 0)
end

for _, exit in ipairs({ "abort", "die", "prepareFailure", "sequenceFailure" }) do
	local fishing = fixture()
	if exit == "prepareFailure" then
		fishing.failCreate()
		fishing.advance(0.121)
	elseif exit == "sequenceFailure" then
		revealPicker(fishing)
		fishing.choose()
		fishing.sequence().Update = function() error("Sequence update failed") end
		fishing.advance(0.016)
	else
		revealPicker(fishing)
		fishing[exit]()
	end
	for _, pair in ipairs(fishing.billboards) do
		assert(pair.visible.Enabled and not pair.hidden.Enabled, "Restore billboards after " .. exit)
	end
	assert(fishing.addBillboard(false, true).Enabled and fishing.addBillboard(true, true).Enabled,
		"Stop watching new billboards after " .. exit)
end

local normal = fixture()
assert(normal.locked() and normal.root.Anchored)
assert(not normal.fishingAudio.active and normal.fishingAudio.starts == 0, "Entering cover must not start ocean audio yet")
normal.advance(0.06)
assert(normal.covered() > 0 and normal.covered() < 1)
assert(normal.sequence() == nil, "Do not replace the character before the screen is covered")
assert(not normal.fishingAudio.active, "Ocean audio must wait for fishing scene preparation")
normal.tap()
normal.advance(0.061)
assert(normal.covered() == 1, "Entry cover must reach full opacity by 0.121 seconds")
assert(not normal.sequence() and not normal.baitVisible(), "Keep the selection hidden until the scene is revealed")
assert(not normal.cashVisible(), "Keep the HUD hidden under the entry cover")
assert(normal.fishingAudio.active and normal.fishingAudio.starts == 1, "Preparing the covered fishing scene must start ocean audio once")
normal.advance(0.09)
assert(not normal.baitVisible() and normal.pickerShows() == 0, "Keep the picker hidden while fading out")
normal.advance(0.011)
assert(normal.baitVisible() and not normal.sequence(), "Select bait before starting the meter")
assert(normal.covered() == 0 and normal.pickerShows() == 1, "Show the picker as soon as the entry cover clears")
assert(normal.cashVisible() and not normal.backpackVisible(), "Show only the cash HUD during selection")
normal.advance(0.016)
assert(normal.pickerShows() == 1, "Subsequent frames must not restart the picker animation")
normal.choose("Unaffordable")
assert(
	normal.notices[1] == "Not enough cash" and normal.cashVisible() and normal.baitVisible() and not normal.sequence(),
	"Keep cash and the picker visible after an unaffordable purchase"
)
normal.tap()
assert(not normal.sequence(), "Scene input during selection must not cast")
normal.choose()
assert(normal.sequence() and normal.sequence().phase == "Preparing" and not normal.baitVisible())
assert(normal.vignetteVisible(), "The fishing HUD filter must allow the sequence to enable its vignette")
assert(normal.pickerDestroys() == 1, "Choosing bait must clean up the picker")
assert(not normal.cashVisible(), "Hide cash when the casting meter opens")
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
assert(not normal.vignetteVisible(), "Covered return must clean up the vignette")
assert(normal.root.Position.X == 100, "A catch returns to the assigned plot spawn")
assert(normal.sequence().keepFail, "Normal covered return must allow the failure tail")
assert(not normal.fishingAudio.active, "Covered return must stop ocean audio")
assert(normal.locked(), "Keep gameplay blocked until the world is revealed")
normal.advance(0.36)
assert(not normal.locked() and not normal.root.Anchored and normal.covered() == 0)
assert(normal.cashVisible() and normal.backpackVisible(), "Restore the full HUD on return")
assert(normal.effectAudio.clears == 1, "Finishing a normal return must not clear the tail")
normal.toggleSound()
assert(normal.effectAudio.refreshes == 1, "Sound settings must reach tails outside fishing")
assert(normal.camera.FieldOfView == 70 and not normal.controller:IsPreparing())
assert(#normal.warnings == 0)
local purchased = fixture()
revealPicker(purchased)
purchased.choose("PaidBait")
assert(
	purchased.sequence() and not purchased.baitVisible() and not purchased.cashVisible(),
	"A successful purchase must close the picker and cash HUD"
)
local delayedCast = fixture(false, false, true)
revealPicker(delayedCast)
delayedCast.choose()
delayedCast.tap()
assert(delayedCast.sequence().clickSounds == 1 and delayedCast.sequence().casts == nil,
	"A pending response must already have local click feedback")
delayedCast.advance(0.5)
delayedCast.tap()
assert(#delayedCast.castReplies == 1 and delayedCast.sequence().meterLocks == 1,
	"Repeated input must not relock the meter or submit another pending cast")
assert(delayedCast.sequence().phase == "Preparing", "Wait for server confirmation before casting")
delayedCast.castReplies[1]({ ok = true, distance = 30, luck = 3.9875 })
assert(delayedCast.sequence().casts == 1 and delayedCast.sequence().phase == "Casting",
	"The pending cast must complete once with its original meter snapshot")
assert(delayedCast.sequence().clickSounds == 1, "Server confirmation must not repeat the click feedback")
for _, phase in ipairs({ "Waiting", "Escaped" }) do
	local reeled = fixture()
	revealPicker(reeled)
	reeled.choose()
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
	revealPicker(cancelled)
	cancelled.choose()
	cancelled.sequence().phase = "Waiting"
	cancelled.tap()
	cancelled.advance(delay)
	cancelled.abort()
	cancelled.advance(10)
	assert(cancelled.sequence().destroyCount == 1 and not cancelled.controller:IsPreparing(), "Cancelled reel returned again")
	assert(not cancelled.fishingAudio.active, "Cancelled reel must stop ocean audio")
end
for _, steps in ipairs({ { 0.06 }, { 0.121, 0.05 }, { 0.121, 0.101 } }) do
	local interrupted = fixture()
	for _, dt in ipairs(steps) do
		interrupted.advance(dt)
	end
	local pickerShows = interrupted.pickerShows()
	interrupted.abort()
	assert(not interrupted.locked() and not interrupted.root.Anchored and interrupted.covered() == 0)
	assert(interrupted.cashVisible() and interrupted.backpackVisible(), "Restore the HUD after character removal")
	assert(not interrupted.baitVisible() and interrupted.pickerDestroys() == (#steps - 1), "Clean up a bound picker on abort")
	interrupted.advance(5)
	assert(not interrupted.controller:IsPreparing(), "Cancelled transitions must not reopen")
	assert(interrupted.pickerShows() == pickerShows, "An interrupted entry must not replay the picker animation")
	assert(not interrupted.fishingAudio.active, "Interrupted transitions must leave ocean audio stopped")
end
local returning = fixture()
revealPicker(returning)
returning.choose()
returning.controller:ReturnToSpawn()
returning.advance(0.15)
returning.abort()
returning.advance(5)
assert(returning.covered() == 0 and not returning.locked() and returning.sequence().destroyCount == 1)
assert(not returning.fishingAudio.active, "Interrupted return must stop ocean audio")
local failed = fixture()
failed.failCreate()
failed.advance(0.121)
assert(not failed.locked() and not failed.root.Anchored and failed.covered() == 0 and #failed.warnings == 1)
assert(not failed.fishingAudio.active and failed.fishingAudio.starts == 0, "Failed preparation must never start ocean audio")
local dead = fixture()
revealPicker(dead)
dead.choose()
assert(dead.fishingAudio.active)
dead.die()
assert(dead.sequence().keepFail == false, "Death must not preserve a failure tail")
assert(not dead.fishingAudio.active and not dead.controller:IsPreparing(), "Death must stop ocean audio")
assert(not dead.vignetteVisible(), "Death must clean up the vignette")
local broken = fixture()
revealPicker(broken)
broken.choose()
assert(broken.fishingAudio.active)
broken.sequence().Update = function() error("Sequence update failed") end
broken.advance(0.36)
assert(not broken.fishingAudio.active and not broken.controller:IsPreparing(), "Runtime errors must stop ocean audio")
assert(#broken.warnings == 1, "Runtime errors must retain their warning")

local outside = fixture(true, true)
outside.advance(0.5)
assert(#outside.requests == 0 and not outside.locked(), "The client must not initiate fishing outside the trigger")

local otherPlot = fixture(true, true)
otherPlot.plot.owner = 456
otherPlot.move(0)
assert(#otherPlot.requests == 0, "The client must ignore a marker on a plot it does not own")
local noMarker = fixture(true, true)
noMarker.plot.children.FishingStartPart = nil
noMarker.move(0)
assert(#noMarker.requests == 0 and #noMarker.warnings == 0, "An unconfigured plot must be ignored")
local missingSpawn = fixture()
revealPicker(missingSpawn)
missingSpawn.plot.children.AreaSpawnPoint = nil
missingSpawn.controller:ReturnToSpawn()
missingSpawn.advance(0.31)
assert(missingSpawn.character.teleports == 1 and missingSpawn.root.Position.X == 0, "Cancel falls back to entry")
local cancelledAtHome = fixture()
revealPicker(cancelledAtHome)
cancelledAtHome.controller:ReturnToSpawn()
cancelledAtHome.advance(0.31)
assert(cancelledAtHome.root.Position.X == 100, "Cancel returns to the assigned plot spawn")

local displaced = fixture()
displaced.move(20)
assert(displaced.locked() and displaced.root.Anchored, "A 20 stud displacement must not end fishing")
displaced.move(20.01)
assert(not displaced.locked() and not displaced.root.Anchored and displaced.cancellations[1] == "test")

local loading = { ok = false, code = "ProfileNotReady", message = "Your fishing data is still loading" }
local entering = fixture(true)
assert(#entering.requests == 1 and not entering.root.Anchored and not entering.locked())
entering.advance(0.05)
assert(#entering.requests == 1, "Only one Begin request may be in flight")
entering.requests[1](loading)
assert(not entering.root.Anchored and #entering.notices == 0 and entering.covered() == 0)
entering.advance(0.051)
assert(#entering.requests == 2)
entering.requests[2]({ ok = true, token = "confirmed", rodId = "Rod_101" })
assert(entering.root.Anchored and entering.locked())
revealPicker(entering)
assert(entering.baitVisible() and #entering.requests == 2, "Opening the picker must not call Begin again")

for _, invalidate in ipairs({ "leave", "die", "abort" }) do
	local abandoned = fixture(true)
	abandoned[invalidate]()
	abandoned.advance(0.2)
	abandoned.requests[1]({ ok = true, token = "stale" })
	assert(abandoned.cancellations[1] == "stale" and #abandoned.cancellations == 1)
	assert(not abandoned.root.Anchored and not abandoned.baitVisible() and #abandoned.notices == 0)
end

local timedOut = fixture(true)
timedOut.advance(1.01)
timedOut.advance(0.5)
assert(#timedOut.requests == 1 and #timedOut.notices == 1 and not timedOut.root.Anchored)
timedOut.requests[1]({ ok = true, token = "late" })
timedOut.advance(0.5)
assert(timedOut.cancellations[1] == "late" and #timedOut.notices == 1)

do
	local Visibility = dofile("src/ReplicatedStorage/Modules/FishingVisibility.lua")
	local part = { LocalTransparencyModifier = 0.25, GetPropertyChangedSignal = function()
		return { Connect = function() return { Disconnect = function() end } end }
	end }
	local owner, observer = Visibility.new(), Visibility.new()
	owner:Hide(part, "LocalTransparencyModifier", 1)
	observer:Hide(part, "LocalTransparencyModifier", 1)
	owner:Destroy()
	assert(part.LocalTransparencyModifier == 1, "The observer's replacement rig still hides the original")
	observer:Destroy()
	assert(part.LocalTransparencyModifier == 0.25, "Restore the original transparency after both uses end")
end
