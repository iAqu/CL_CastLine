local vectorMeta = {}
local function vec(x, y, z)
	return setmetatable({ X = x, Y = y, Z = z }, vectorMeta)
end
vectorMeta.__add = function(a, b)
	return vec(a.X + b.X, a.Y + b.Y, a.Z + b.Z)
end
vectorMeta.__sub = function(a, b)
	return vec(a.X - b.X, a.Y - b.Y, a.Z - b.Z)
end
vectorMeta.__unm = function(a)
	return vec(-a.X, -a.Y, -a.Z)
end
vectorMeta.__mul = function(a, b)
	if type(b) == "number" then
		return vec(a.X * b, a.Y * b, a.Z * b)
	end
	return vec(a.X * b.X, a.Y * b.Y, a.Z * b.Z)
end
vectorMeta.__index = function(a, key)
	if key == "Cross" then
		return function(v, w)
			return vec(v.Y * w.Z - v.Z * w.Y, v.Z * w.X - v.X * w.Z, v.X * w.Y - v.Y * w.X)
		end
	end
	local length = math.sqrt(a.X ^ 2 + a.Y ^ 2 + a.Z ^ 2)
	if key == "Magnitude" then
		return length
	elseif key == "Unit" then
		return a * (1 / length)
	end
end

local yAxis, front = vec(0, 1, 0), vec(0, 0, -1)
local frameMeta = {
	__mul = function(a, modelOffset)
		return { Position = a.Position, LookVector = a.LookVector, ModelOffset = modelOffset }
	end,
}
local modelOffset = {}
local function signal()
	local event = {}
	function event:Connect(callback)
		self.fire = callback
	end
	return event
end

local function loadSource(path, environment)
	local file = assert(io.open(path, "r"))
	local chunk = assert(loadstring(file:read("*a"), path))
	file:close()
	return setfenv(chunk, setmetatable(environment, { __index = getfenv() }))()
end

local promptDistance = 9
local function click(candidates, lookVector)
	local messages, destinations, rays = {}, {}, {}
	local anchor = {
		Position = vec(0, 0, 0),
		CFrame = { LookVector = lookVector or front, RightVector = front },
		IsA = function() return true end,
	}
	local root = {
		Size = vec(2, 2, 1),
		IsA = function() return true end,
		CFrame = { ToObjectSpace = function() return modelOffset end },
	}
	local character = {
		FindFirstChild = function() return root end,
		FindFirstChildOfClass = function() return { Health = 100 } end,
		GetPivot = function() return {} end,
	}
	local plot = {
		GetAttribute = function() return 17 end,
		FindFirstChild = function(_, name)
			return if name == "TrainingUpgradeAnchor" then anchor else nil
		end,
	}
	local button = { Activated = signal() }
	local popup = {
		MainFrame = { ShopButton = button, MouseEnter = signal(), MouseLeave = signal() },
		CloseButton = { Activated = signal() },
		IsA = function() return true end,
	}
	local gui = {
		GetChildren = function() return { popup } end,
		FindFirstChild = function(_, name) return if name == "BarbellPopup" then popup else nil end,
	}
	local player = {
		UserId = 17,
		Character = character,
		GetAttribute = function() return 1 end,
		WaitForChild = function() return { WaitForChild = function() return gui end } end,
	}
	local function candidateAt(position)
		return candidates[string.format("%g,%g", position.X, position.Z)]
	end
	local world = { CurrentCamera = {} }
	function world:Raycast(origin, _, params)
		assert(params.RespectCanCollide and params.IgnoreWater and params.FilterDescendantsInstances[2] == anchor)
		table.insert(rays, string.format("%g,%g", origin.X, origin.Z))
		local candidate = candidateAt(origin)
		if not candidate then
			return nil
		end
		return {
			Position = vec(origin.X, candidate.height or 0, origin.Z),
			Normal = candidate.normal or yAxis,
		}
	end
	function world:GetPartBoundsInBox(frame, _, params)
		assert(params.RespectCanCollide and params.FilterDescendantsInstances[1] == character)
		local candidate = candidateAt(frame.Position)
		return if candidate.blocked or candidate.boundsOnly then { {} } else {}
	end
	function world:GetPartsInPart(probe, params)
		assert(probe.Parent == self and probe.Anchored and probe.Transparency == 1)
		assert(not probe.CanCollide and not probe.CanTouch and not probe.CanQuery)
		assert(params.RespectCanCollide and params.FilterDescendantsInstances[1] == character)
		return if candidateAt(probe.CFrame.Position).blocked then { {} } else {}
	end
	local liveProbes = 0
	local policy = {
		active = { kind = "Barbell", id = "Training_102", trainingId = "Training_101" },
		Close = function(self) self.active = nil end,
	}
	local modules = {
		ButtonAnimation = { SetUp = function() end },
		CharacterUtil = { TeleportTo = function(_, destination) table.insert(destinations, destination) end },
		FishingSpotUtil = { GetFootHeight = function() return candidates.footHeight or 3 end },
		GameplayInputGate = { IsWorldActionAllowed = function() return true end },
		GuiAnimation = { IsAllPopupGuisClosed = function() return true end },
		NotificationClient = { RedNotify = function(message) table.insert(messages, message) end },
		PlotWorkspaceUtil = { getPlotBySlot = function() return plot end },
		RodPopupView = { new = function() return { Hide = function() end } end },
		RodShopClientState = { new = function() return {} end },
		RodUpgradePromptPolicy = { new = function() return policy end },
		TrainingConfig = { PromptDistance = promptDistance },
		TrainingProgress = { GetNextEquipment = function() return { TrainingID = "Training_102", Price = 100 } end },
	}
	local knit = {
		CreateController = function(controller) return controller end,
		GetService = function(name)
			return if name == "RodShopService" then { InventoryChanged = signal() } else { WinsChanged = signal() }
		end,
		GetController = function(name)
			if name == "PlayerDataController" then
				return { GetData = function() return { Wins = 100 } end }
			elseif name == "TrainingController" then
				return { GetSnapshot = function() return { trainingId = "Training_101" } end }
			end
			return {}
		end,
	}
	local services = {
		Players = { LocalPlayer = player },
		ReplicatedFirst = { WaitForChild = function() return { WaitForChild = function() return {} end } end },
		ReplicatedStorage = { Modules = modules, Packages = { Knit = knit } },
		RunService = { Heartbeat = signal() },
		Workspace = world,
	}
	local controller = loadSource("src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/RodPopupController.lua", {
		game = { GetService = function(_, name) return services[name] end },
		Enum = { RaycastFilterType = { Exclude = "Exclude" } },
		Vector3 = { new = vec, yAxis = yAxis },
		CFrame = {
			new = function(position) return { Position = position } end,
			lookAt = function(position, target)
				return setmetatable({ Position = position, LookVector = (target - position).Unit }, frameMeta)
			end,
		},
		RaycastParams = { new = function() return {} end },
		OverlapParams = { new = function() return {} end },
		Instance = { new = function(class)
			assert(class == "Part")
			liveProbes += 1
			return { Destroy = function() liveProbes -= 1 end }
		end },
		require = function(module) return module end,
		task = { spawn = function(callback) callback() end },
		warn = function() end,
	})
	controller:KnitStart()
	button.Activated.fire()
	assert(policy.active == nil, "Clicking the training upgrade popup consumes the recommendation")
	assert(liveProbes == 0, "The collision query must clean up its probe")
	return messages, destinations, table.concat(rays, " ")
end

local function assertLanding(candidates, attempts, x, z, description, lookVector)
	local messages, destinations, rays = click(candidates, lookVector)
	assert(#messages == 0 and #destinations == 1, description .. " should teleport exactly once")
	local frame = destinations[1]
	assert(rays == attempts, description .. " should use the first valid candidate")
	assert((frame.Position - vec(x, 3.1, z)).Magnitude < 1e-6, description .. " should land at standing height")
	assert((frame.LookVector - vec(-x, 0, -z).Unit).Magnitude < 1e-6, "The character faces the upgrade anchor")
	assert(frame.ModelOffset == modelOffset, "Teleport retains the offset from the root to the model pivot")
end

assertLanding({ ["-3,0"] = {}, ["0,-3"] = {} }, "-3,0", -3, 0, "Clear preferred side")
assertLanding({ ["-3,0"] = { boundsOnly = true } }, "-3,0", -3, 0, "Mesh bounds without a solid overlap")
assertLanding({ ["-3,0"] = { blocked = true }, ["0,-3"] = {} }, "-3,0 0,-3", 0, -3, "Blocked preferred side")
assertLanding({ ["0,3"] = {} }, "-3,0 0,-3 0,3", 0, 3, "Missing floor at the first two spots")
assertLanding({ ["-3,0"] = {} }, "-3,0", -3, 0, "Vertical anchor", yAxis)

local innerSpots = "-3,0 0,-3 0,3 3,0"
assertLanding(
	{ ["-3,0"] = { normal = vec(1, 0, 0) }, ["0,-3"] = { height = 4 }, ["-5,0"] = {} },
	innerSpots .. " -5,0",
	-5,
	0,
	"Outer ring when the inner ring has no suitable floor"
)

local messages, destinations, rays = click({ ["-3,0"] = {}, footHeight = promptDistance })
assert(#destinations == 0, "The character stays put when every candidate fails, including a floor outside prompt range")
assert(rays == innerSpots .. " -5,0 0,-5 0,5 5,0", "All eight candidates are checked before reporting failure")
assert(
	#messages == 1 and messages[1] == "Could not reach the training upgrade. Walk to the upgrade point to continue.",
	"Keep the existing message when there is no safe destination"
)
