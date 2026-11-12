local file = assert(io.open("src/StarterPlayer/StarterPlayerScripts/Controllers/EggPlacementController.lua", "r"))
local source = file:read("*a")
file:close()
local direction = setmetatable({}, {
	__mul = function(self)
		return self
	end,
})
local world = { CurrentCamera = {
	ScreenPointToRay = function()
		return { Origin = {}, Direction = direction }
	end,
} }
local raycasts = 0
function world:Raycast()
	raycasts += 1
	return nil
end
local character = {
	FindFirstChildOfClass = function()
		return {}
	end,
}
local player = {
	Character = character,
	GetAttribute = function()
		return 1
	end,
}
local modules = {
	EggToolUtil = {
		GetInstanceId = function()
			return "egg-1"
		end,
		GetTemplate = function()
			return {}
		end,
	},
	EggPlacementUtil = {},
	GameplayInputGate = {},
	EggInventory = {},
	ItemBoundsUtil = {},
	NotificationClient = {},
	PlotWorkspaceUtil = {
		getPlotBySlot = function()
			return {
				FindFirstChild = function()
					return {}
				end,
			}
		end,
	},
}
local services = {
	Players = { LocalPlayer = player },
	Workspace = world,
	RunService = {},
	UserInputService = {},
	ReplicatedFirst = { Data = { EggsData = { Draw001 = { Model = "Draw001" } } } },
	ReplicatedStorage = {
		Modules = modules,
		Packages = { Knit = {
			CreateController = function(spec)
				return spec
			end,
		} },
	},
}
local env = setmetatable({
	game = {
		GetService = function(_, name)
			return assert(services[name], name)
		end,
	},
	require = function(value)
		return value
	end,
	RaycastParams = {
		new = function()
			return {}
		end,
	},
	Enum = { RaycastFilterType = { Include = "Include" } },
}, { __index = getfenv() })
local chunk = assert(loadstring(source))
setfenv(chunk, env)
local controller = chunk()
local preview = {
	Parent = world,
	Destroy = function(self)
		self.destroyed = true
	end,
}
controller._preview, controller._uuid = preview, "egg-1"
controller._eggs = { ["egg-1"] = { EggId = "Draw001" } }
controller._valid, controller._position = true, {}
controller:_updatePreview({ X = -10000, Y = -10000 })
assert(raycasts == 1 and preview.Parent == nil, "A missed ray must hide the old placement preview")
assert(not controller._valid and controller._position == nil, "A missed ray cannot reuse a valid old location")
world.CurrentCamera = nil
preview.Parent = world
controller._valid, controller._position = true, {}
controller:_updatePreview({ X = 0, Y = 0 })
assert(
	preview.Parent == nil and not controller._valid and controller._position == nil,
	"Camera replacement must invalidate the previous location before accepting another placement"
)
controller._valid = true
controller:_clearPreview()
assert(
	preview.destroyed and not controller._valid and controller._uuid == nil,
	"Unequipping must clear placement validity"
)
