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
	local boundActions = {}
	local uiBlocking = false
	local guiService = {}
	local requests, cancellations, notices = {}, {}, {}
	local eventRequests = {}
	local castReplies = {}
	local selections = {}
	local purchaseFinished = nil
	local purchaseRequests, tasks = {}, {}
	local paidBaitReady, promptError, pickerBusy = false, nil, false
	local pickerShows, pickerDestroys = 0, 0
	local fishingAudio = { active = false, starts = 0 }
	local effectAudio = { clears = 0, refreshes = 0, preloads = 0 }
	local function signal()
		local handlers = {}
		return {
			Connect = function(_, callback)
				local connection = { Connected = true }
				function connection:Disconnect()
					self.Connected = false
				end
				table.insert(handlers, { callback, connection })
				return connection
			end,
			Fire = function(_, ...)
				for _, handler in ipairs(handlers) do
					if handler[2].Connected then
						handler[1](...)
					end
				end
			end,
		}
	end
	purchaseFinished = signal()
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
		if type(b) == "table" then
			return vec(a.X * b.X, a.Y * b.Y, a.Z * b.Z)
		end
		return vec(a.X * b, a.Y * b, a.Z * b)
	end
	vm.__div = function(a, b)
		return vec(a.X / b, a.Y / b, a.Z / b)
	end
	vm.__index = function(a, key)
		if key == "Magnitude" then
			return math.sqrt(a.X * a.X + a.Y * a.Y + a.Z * a.Z)
		elseif key == "Unit" then
			return a / a.Magnitude
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
	local camera = { CameraType = "Custom", CFrame = frame(), Focus = frame(), FieldOfView = 70 }
	local plot = object("Model", { FishingStartPart = start, AreaSpawnPoint = spawn })
	plot.Name, plot.owner = "Plot_1", player.UserId
	function plot:GetAttribute() return self.owner end
	local workspace = object("Workspace", { Areas = object("Folder", { Plot = object("Folder", { Plot_1 = plot }) }) })
	workspace.GetServerTimeNow = function() return now end
	workspace.CurrentCamera = camera
	local function addSceneGui(class, inPlayerGui, enabled, exempt)
		local container = if inPlayerGui then playerGui else workspace
		local gui = object(class)
		gui.Enabled = enabled
		gui:SetAttribute("FishingBillboardExempt", exempt)
		container.children[gui] = gui
		container.DescendantAdded:Fire(gui)
		return gui
	end
	local sceneGuis = {}
	for _, container in ipairs({ workspace, playerGui }) do
		for _, class in ipairs({ "BillboardGui", "SurfaceGui" }) do
			local visible, hidden = object(class), object(class)
			visible.Enabled, hidden.Enabled = true, false
			container.children[class .. "Labels"] = object("Folder", { Visible = visible, Hidden = hidden })
			table.insert(sceneGuis, { visible = visible, hidden = hidden })
		end
	end
	local input, heartbeat = signal(), signal()
	local sequence, failCreate = nil, false
	local chooseBait
	local function resolved(result)
		return {
			timeout = function(self) return self end,
			andThen = function(self, callback)
				callback(result)
				return self
			end,
			catch = function(self) return self end,
		}
	end
	local fishingService = {
		AnalyticsPresentation = { Fire = function() end },
		JoinEvent = function(_, slotId)
			return {
				andThen = function(self, callback)
					table.insert(eventRequests, { slotId = slotId, resolve = callback })
					return self
				end,
				catch = function(self) return self end,
			}
		end,
		Begin = function()
			if not deferBegin then
				return resolved({
					ok = true,
					token = "test",
					rodId = "Rod_101",
					baitQuotes = { Premium = { productId = 1234, credits = 0 } },
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
		SelectBait = function(_, token, baitId, purchaseOnSelect)
			table.insert(selections, baitId)
			if baitId == "Premium" and not paidBaitReady then
				if purchaseOnSelect then
					assert(token == "test")
					table.insert(purchaseRequests, baitId)
					return resolved({ ok = false, prompted = not promptError, message = promptError })
				end
				return resolved({ ok = false, needsPurchase = true, productId = 1234 })
			end
			if baitId == "Unaffordable" then
				return resolved({ ok = false, message = "Not enough cash" })
			end
			return resolved({ ok = true, initialYaw = 0, luck = 7.25, lesson = lesson })
		end,
		Cast = function(_, _, progress)
			assert(progress == nil, "The server owns the meter progress")
			assert(sequence.clickSounds == 1, "Local click feedback must occur before the server request")
			if deferCast then
				return {
					timeout = function(self) return self end,
					andThen = function(self, callback)
						table.insert(castReplies, callback)
						return self
					end,
					catch = function(self) return self end,
				}
			end
			return resolved({ ok = true, distance = 30, luck = 3.9875, castProgress = 0.55 })
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
		PurchaseData = {},
		FishingBaitConfig = { PurchaseId = "PremiumBait" },
		FishesData = {},
		EggsData = {},
		NotificationClient = { RedNotify = function(message) table.insert(notices, message) end },
		FishingAssets = { GetBait = function() return object("Part") end },
		FishingOddsView = { GuiName = "FishingOddsGui" },
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
				SetBusy = function(value) pickerBusy = value end,
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
				return uiBlocking
			end,
			IsWorldActionAllowed = function()
				return not locked
			end,
			IsPlacementActionAllowed = function()
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
					bitePrompt = addSceneGui("BillboardGui", false, false, true),
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
					options = {meterStartsAt = 0},
					BeginCast = function(self)
						self.phase = "Casting"
						self.meterLocks = (self.meterLocks or 0) + 1
						self.clickSounds = (self.clickSounds or 0) + 1
						return 0.5
					end,
					Cast = function(self, progress, distance, luck)
						assert(progress == 0.55 and distance == 30 and luck == 3.9875,
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
		Character = object("Folder", {
			PoseDefaultCharacter = object("Model", { HumanoidRootPart = root, Humanoid = humanoid }),
		}),
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
		FishingOddsView = "FishingOddsView",
		FishingBaitConfig = "FishingBaitConfig",
		FishingSpotUtil = "FishingSpotUtil",
		PlotWorkspaceUtil = "PlotWorkspaceUtil",
		NotificationClient = "NotificationClient",
		Constants = "Constants",
		GameplayInputGate = "GameplayInputGate",
	}
	local services = {
		MarketplaceService = { PromptProductPurchaseFinished = purchaseFinished },
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
			BindActionAtPriority = function(_, name, callback, _, _, binding)
				if binding == "ButtonA" then
					boundActions[name] = callback
				else
					movement = true
				end
			end,
			UnbindAction = function(_, name)
				if boundActions[name] then
					boundActions[name] = nil
				elseif name == "CastLineFishingMovement" then
					movement = false
				end
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
		GuiService = guiService,
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
		task = {
			delay = function(seconds, callback)
				table.insert(tasks, { at = now + seconds, callback = callback })
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
			CameraType = { Custom = "Custom", Scriptable = "Scriptable" },
			CoreGuiType = { Backpack = "Backpack" },
			ContextActionPriority = { High = { Value = 2000 } },
			ContextActionResult = { Sink = "Sink", Pass = "Pass" },
			UserInputState = { Begin = "Begin", End = "End" },
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
	local rigSource = read("src/ReplicatedStorage/Modules/FishingRigUtil.lua")
	modules.FishingRigUtil.GetSpotRootCFrame = assert(load(rigSource, "FishingRigUtil", "t", env))().GetSpotRootCFrame
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
		sceneGuis = sceneGuis,
		addSceneGui = addSceneGui,
		castPrompt = meter.children.Meter.children.Prompt,
		requests = requests,
		eventRequests = eventRequests,
		cancellations = cancellations,
		notices = notices,
		castReplies = castReplies,
		selections = selections,
		purchaseRequests = purchaseRequests,
		purchaseFinished = function(purchased, productId)
			purchaseFinished:Fire(player.UserId, productId or 1234, purchased)
		end,
		pickerBusy = function() return pickerBusy end,
		showPromptError = function(message) promptError = message end,
		receiveBaitReceipt = function() paidBaitReady = true end,
		leave = function()
			root.Position = vec(0, 3.5, -20)
			heartbeat:Fire()
		end,
		move = function(z, y)
			root.Position = vec(0, y or 3.5, z)
			heartbeat:Fire()
		end,
		fishingAudio = fishingAudio,
		effectAudio = effectAudio,
		toggleSound = function() controllers.SettingsGuiController.ToggleSound:Fire() end,
		advance = function(dt)
			now += dt
			for index = #tasks, 1, -1 do
				if tasks[index].at <= now then
					table.remove(tasks, index).callback()
				end
			end
			if render then
				render(dt)
			end
			heartbeat:Fire()
		end,
		gamepadA = function(inputState)
			local event = { KeyCode = "ButtonA", UserInputType = "Gamepad1" }
			for name, callback in boundActions do
				if callback(name, inputState or "Begin", event) == "Sink" then
					return true
				end
			end
			return false
		end,
		setUiBlocking = function(blocked)
			uiBlocking = blocked
		end,
		setUiSelection = function(selected)
			guiService.SelectedObject = selected
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

for _, height in { -10, 20 } do
	local fishing = fixture(true, true)
	fishing.move(10.01, height)
	assert(#fishing.requests == 0, "Do not enter outside the horizontal footprint")
	fishing.move(10, height)
	assert(#fishing.requests == 1, "Enter at the horizontal edge regardless of height")
	fishing.requests[1]({ ok = true, token = "height-test", rodId = "Rod_101" })
	revealPicker(fishing)
	assert(fishing.baitVisible(), "Open the bait picker at either height")
end

do
	local fishing = fixture(false, false, false, "FinalCatch")
	revealPicker(fishing)
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
	local sequence = fishing.sequence()
	assert(sequence, "Selecting bait must start the teaching sequence")
	for _, phase in ipairs({ "Nibbling", "Bite", "Bite", "Struggling" }) do
		sequence.phase = phase
		fishing.advance(0.016)
		assert(#fishing.warnings == 0 and fishing.controller:IsPreparing(), "The lesson must remain active")
		assert(
			sequence.bitePrompt.Enabled == (phase == "Bite"),
			"The final lesson has incorrect prompt visibility during " .. phase
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

do
	local fishing = fixture(false, false, true)
	revealPicker(fishing)
	assert(not fishing.gamepadA(), "The picker owns A until a bait is chosen")
	fishing.choose()
	fishing.setUiBlocking(true)
	assert(not fishing.gamepadA(), "Pass A to an open menu, popup or text box")
	fishing.setUiBlocking(false)
	fishing.setUiSelection({})
	assert(not fishing.gamepadA(), "Pass A to a selected UI control")
	fishing.setUiSelection(nil)
	assert(#fishing.castReplies == 0, "UI input must not reach fishing")
	fishing.gamepadA("End")
	assert(#fishing.castReplies == 0, "A release cannot cast")
	assert(fishing.gamepadA() and #fishing.castReplies == 1, "A must cast in ordinary fishing")
	assert(fishing.gamepadA() and #fishing.castReplies == 1, "A must not repeat a pending cast")
	fishing.castReplies[1]({ ok = true, distance = 30, luck = 3.9875, castProgress = 0.55 })

	local sequence = fishing.sequence()
	sequence.phase = "Bite"
	assert(fishing.gamepadA() and sequence.hooks == 1, "A must hook the fish")
	sequence.phase, sequence.readyAt = "Caught", 0
	assert(fishing.gamepadA(), "A must dismiss the catch")
	fishing.advance(0.15)
	fishing.advance(0.16)
	fishing.advance(0.36)
	assert(not fishing.controller:IsPreparing() and not fishing.gamepadA(), "Restore A when fishing ends")
end

local exitPicker = fixture(false, false, false, "FinalCatch")
exitPicker.advance(0.121)
local entering, enteringHint, enteringTarget = exitPicker.controller:GetOnboardingHint()
assert(entering and not enteringHint and not enteringTarget, "Keep the spotlight hidden during the entry transition")
exitPicker.advance(0.101)
assert(select(3, exitPicker.controller:GetOnboardingHint()) == exitPicker.guideButton)
exitPicker.controller:ReturnToSpawn()
exitPicker.choose("Bait_102")
assert(#exitPicker.selections == 0, "A must not select a bait after closing the picker")
local returningLesson, returnHint, returnTarget = exitPicker.controller:GetOnboardingHint()
assert(returningLesson and not returnHint and not returnTarget, "Clear the spotlight when the picker starts closing")
exitPicker.abort()
assert(not exitPicker.controller:GetOnboardingHint() and not exitPicker.baitVisible())

do
	local fishing = fixture()
	for _, pair in ipairs(fishing.sceneGuis) do
		assert(not pair.visible.Enabled and not pair.hidden.Enabled, "Hide nested scene UI at session start")
		pair.visible.Enabled, pair.hidden.Enabled = true, true
		assert(not pair.visible.Enabled and not pair.hidden.Enabled, "Hold both original states hidden")
	end
	revealPicker(fishing)
	fishing.choose()
	local addedWorld = fishing.addSceneGui("SurfaceGui", false, true)
	local ripple = fishing.addSceneGui("SurfaceGui", false, true, true)
	fishing.sequence().phase = "Lifting"
	fishing.advance(0.016)
	assert(not addedWorld.Enabled and ripple.Enabled, "Hide world signs while preserving the fishing ripple")
	fishing.sequence().phase = "Caught"
	fishing.advance(0.016)
	local addedGui = fishing.addSceneGui("BillboardGui", true, false)
	assert(fishing.sequence().continueLabel.Visible, "Keep the catch confirmation visible")
	for _, pair in ipairs(fishing.sceneGuis) do
		assert(not pair.visible.Enabled and not pair.hidden.Enabled, "Keep scene UI hidden through the showcase")
	end
	addedWorld.Enabled, addedGui.Enabled = true, true
	assert(not addedWorld.Enabled and not addedGui.Enabled, "Keep new scene UI hidden when enabled externally")
	fishing.controller:ReturnToSpawn()
	fishing.advance(0.15)
	assert(not fishing.sceneGuis[1].visible.Enabled and not addedWorld.Enabled, "Keep scene UI hidden until return is covered")
	fishing.advance(0.16)
	for _, pair in ipairs(fishing.sceneGuis) do
		assert(pair.visible.Enabled and not pair.hidden.Enabled, "Restore each scene GUI's original Enabled state")
		pair.hidden.Enabled = true
		assert(pair.hidden.Enabled, "Release the property listener during covered return")
	end
	assert(addedWorld.Enabled and not addedGui.Enabled, "Restore original states for scene UI added during fishing")
	addedGui.Enabled = true
	assert(addedGui.Enabled and fishing.addSceneGui("SurfaceGui", false, true).Enabled
		and fishing.addSceneGui("BillboardGui", true, true).Enabled,
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
	for _, pair in ipairs(fishing.sceneGuis) do
		assert(pair.visible.Enabled and not pair.hidden.Enabled, "Restore scene UI after " .. exit)
	end
	assert(fishing.addSceneGui("BillboardGui", false, true).Enabled
		and fishing.addSceneGui("SurfaceGui", true, true).Enabled,
		"Stop watching new scene UI after " .. exit)
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
assert(delayedCast.sequence().phase == "Casting", "Windup begins before cast confirmation")
delayedCast.castReplies[1]({ ok = true, distance = 30, luck = 3.9875, castProgress = 0.55 })
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
assert(failed.camera.CameraType == "Custom" and failed.covered() == 1 and not failed.root.Anchored)
failed.advance(0.101)
assert(not failed.locked() and failed.covered() == 0 and #failed.warnings == 1)
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

local outsideSpot = { ok = false, code = "OutsideFishingSpot", message = "Stand at your fishing spot to start fishing" }
local loading = { ok = false, code = "ProfileNotReady", message = "Your fishing data is still loading" }
local entering = fixture(true)
assert(#entering.requests == 1 and entering.locked() and not entering.root.Anchored,
	"Start the local entry while leaving character position replication active")
entering.advance(0.05)
assert(entering.covered() > 0 and #entering.requests == 1, "Fade in while the first Begin request is in flight")
entering.requests[1](outsideSpot)
assert(not entering.root.Anchored and #entering.notices == 0)
entering.advance(0.051)
assert(#entering.requests == 2)
entering.advance(0.021)
assert(entering.camera.CameraType == "Scriptable" and entering.covered() == 1)
local previewFrame = entering.camera.CFrame
entering.requests[2](loading)
entering.advance(0.101)
entering.tap()
assert(entering.covered() == 1 and entering.camera.CameraType == "Scriptable" and not entering.root.Anchored,
	"Keep the fishing camera completely hidden until server confirmation")
assert(not entering.fishingAudio.active, "Wait to prepare the fishing scene until the server confirms")
assert(not entering.baitVisible() and entering.pickerShows() == 0 and #entering.selections == 0 and #entering.notices == 0)
assert(#entering.requests == 3, "Retry when the profile is still loading")
entering.requests[3]({ ok = true, token = "confirmed", rodId = "Rod_101" })
assert(entering.root.Anchored and entering.locked() and entering.camera.CFrame == previewFrame)
assert(entering.covered() == 1 and entering.fishingAudio.active and not entering.baitVisible(),
	"Prepare the confirmed scene behind the opaque cover")
entering.advance(0.016)
entering.advance(0.05)
assert(entering.covered() > 0 and entering.covered() < 1 and not entering.baitVisible(),
	"Keep bait unavailable throughout the reveal")
entering.advance(0.051)
assert(entering.baitVisible() and entering.pickerShows() == 1 and #entering.requests == 3,
	"Show the confirmed picker once after the reveal")
entering.advance(0.25)
assert(entering.pickerShows() == 1)

local earlyReply = fixture(true)
earlyReply.requests[1]({ ok = true, token = "early", rodId = "Rod_101" })
assert(earlyReply.root.Anchored and not earlyReply.baitVisible())
revealPicker(earlyReply)
assert(earlyReply.baitVisible() and earlyReply.pickerShows() == 1)

local rejected = fixture(true)
revealPicker(rejected)
rejected.requests[1]({ ok = false, message = "Fishing rod unavailable" })
assert(rejected.camera.CameraType == "Custom" and rejected.covered() == 1 and not rejected.root.Anchored,
	"Restore the world camera before fading out of a rejection")
assert(rejected.camera.CFrame.Position.Magnitude == 0 and rejected.camera.FieldOfView == 70)
assert(rejected.notices[1] == "Fishing rod unavailable" and rejected.pickerShows() == 0)
rejected.advance(0.05)
assert(rejected.covered() > 0 and rejected.covered() < 1 and not rejected.baitVisible())
rejected.advance(0.051)
assert(rejected.covered() == 0 and not rejected.locked())
assert(#rejected.requests == 1, "A rejected entry requires leaving the spot before retrying")
rejected.leave()
rejected.move(0)
assert(#rejected.requests == 2)

local earlyRejection = fixture(true)
earlyRejection.advance(0.04)
local partialCover = earlyRejection.covered()
earlyRejection.requests[1]({ ok = false, message = "Fishing rod unavailable" })
assert(earlyRejection.camera.CameraType == "Custom" and earlyRejection.covered() == partialCover,
	"Reverse an incomplete fade without flashing to full black")
earlyRejection.advance(0.101)
assert(earlyRejection.covered() == 0 and not earlyRejection.locked())

for _, invalidate in ipairs({ "leave", "die", "abort" }) do
	local abandoned = fixture(true)
	revealPicker(abandoned)
	abandoned[invalidate]()
	assert(abandoned.camera.CameraType == "Custom")
	abandoned.advance(0.2)
	assert(not abandoned.locked())
	abandoned.requests[1]({ ok = true, token = "stale" })
	assert(abandoned.cancellations[1] == "stale" and #abandoned.cancellations == 1)
	assert(not abandoned.root.Anchored and not abandoned.baitVisible() and #abandoned.notices == 0)
end

local missingDuringPreview = fixture(true)
revealPicker(missingDuringPreview)
missingDuringPreview.plot.children.FishingStartPart = nil
missingDuringPreview.advance(0.02)
missingDuringPreview.requests[1]({ ok = true, token = "removed-spot", rodId = "Rod_101" })
assert(missingDuringPreview.camera.CameraType == "Custom" and missingDuringPreview.covered() == 1)
missingDuringPreview.advance(0.101)
assert(not missingDuringPreview.locked())
assert(missingDuringPreview.cancellations[1] == "removed-spot" and missingDuringPreview.pickerShows() == 0)

local timedOut = fixture(true)
revealPicker(timedOut)
timedOut.advance(1.01)
assert(timedOut.camera.CameraType == "Custom" and timedOut.covered() == 1 and not timedOut.baitVisible(),
	"Restore the world camera while fully covered on timeout")
timedOut.advance(0.05)
assert(timedOut.covered() > 0 and timedOut.covered() < 1)
timedOut.advance(0.051)
assert(#timedOut.requests == 1 and #timedOut.notices == 1 and not timedOut.root.Anchored and not timedOut.locked())
assert(timedOut.camera.CameraType == "Custom" and not timedOut.baitVisible())
timedOut.requests[1]({ ok = true, token = "late" })
timedOut.advance(0.5)
assert(timedOut.cancellations[1] == "late" and #timedOut.notices == 1)

local event = fixture(true, true)
local eventJoined
local function onEventComplete(joined)
	eventJoined = joined
end
assert(event.controller:JoinEvent(-7, onEventComplete), "Start an event entry from outside the trigger")
assert(not event.controller:JoinEvent(-7, onEventComplete), "Ignore another click while the join is pending")
assert(#event.eventRequests == 1 and event.eventRequests[1].slotId == -7, "Send the requested slot once")
event.eventRequests[1].resolve({ ok = true, token = "event", rodId = "Rod_101" })
assert(eventJoined == nil and not event.locked(), "Wait for the teleport when the response arrives first")
event.move(0)
revealPicker(event)
assert(eventJoined and event.baitVisible() and #event.requests == 0, "Open the picker without sending a second Begin")

local replaced = fixture(true, true)
assert(replaced.controller:JoinEvent(-7, onEventComplete), "Start a join before the character changes")
replaced.abort()
replaced.eventRequests[1].resolve({ ok = true, token = "departed", rodId = "Rod_101" })
assert(eventJoined == false and replaced.cancellations[1] == "departed" and not replaced.locked(),
	"Cancel a late token for a character that has left")

local lostSpot = fixture(true, true)
assert(lostSpot.controller:JoinEvent(-7, onEventComplete), "Start a join while the spot exists")
lostSpot.plot.children.FishingStartPart = nil
lostSpot.advance(0.1)
lostSpot.eventRequests[1].resolve({ ok = true, token = "lost-spot", rodId = "Rod_101" })
assert(lostSpot.notices[1] == "Your fishing spot is unavailable." and lostSpot.cancellations[1] == "lost-spot",
	"Report a spot lost during a join and cancel the late token")

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

do
	local fishing = fixture()
	revealPicker(fishing)
	fishing.choose("Premium")
	assert(#fishing.purchaseRequests == 1 and fishing.pickerBusy())
	fishing.purchaseFinished(false, 9876)
	assert(fishing.pickerBusy(), "Unrelated prompts must not unlock the bait picker")
	fishing.purchaseFinished(false)
	assert(fishing.baitVisible() and not fishing.pickerBusy(), "Cancel restores the picker")
	fishing.showPromptError("Unavailable")
	fishing.choose("Premium")
	assert(fishing.notices[1] == "Unavailable" and not fishing.pickerBusy())
	fishing.showPromptError(nil)
	fishing.choose("Premium")
	fishing.purchaseFinished(true)
	assert(fishing.baitVisible() and not fishing.sequence() and #fishing.purchaseRequests == 3)
	fishing.advance(0.51)
	assert(fishing.pickerBusy() and not fishing.sequence() and #fishing.purchaseRequests == 3)
	fishing.receiveBaitReceipt()
	fishing.advance(0.51)
	assert(fishing.sequence() and not fishing.baitVisible() and #fishing.purchaseRequests == 3)
end
