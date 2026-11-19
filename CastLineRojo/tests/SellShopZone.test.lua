local function loadSource(path, globals)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return assert(load(source, path, "t", setmetatable(globals or {}, { __index = getfenv() })))()
end
local vector
vector = function(x, y, z)
	return setmetatable({ X = x, Y = y, Z = z }, {
		__sub = function(a, b)
			return vector(a.X - b.X, a.Y - b.Y, a.Z - b.Z)
		end,
		__mul = function(a, scalar)
			return vector(a.X * scalar, a.Y * scalar, a.Z * scalar)
		end,
	})
end
local root = {
	Position = vector(0, 3, 0),
	Size = { Y = 2 },
	IsA = function(_, kind)
		return kind == "BasePart"
	end,
}
local humanoid = { Health = 100, HipHeight = 2, RigType = "R15" }
local character = {
	FindFirstChild = function(_, name)
		return if name == "HumanoidRootPart" then root else nil
	end,
	FindFirstChildOfClass = function()
		return humanoid
	end,
}
local anchor = {
	Position = vector(0, 0, 0),
	Size = { Y = 6.3, Z = 8.25 },
	IsA = root.IsA,
	CFrame = {
		PointToObjectSpace = function(_, point)
			return { X = point.Y, Y = point.X, Z = point.Z }
		end,
	},
}
local slot, owner = 1, 42
local plot = {
	GetAttribute = function()
		return owner
	end,
	FindFirstChild = function()
		return anchor
	end,
}
local player = {
	UserId = 42,
	Character = character,
	GetAttribute = function()
		return slot
	end,
}
local geometry = loadSource("src/ReplicatedStorage/Modules/RodShopZone.lua", {
	Vector3 = { yAxis = vector(0, 1, 0) },
	Enum = { HumanoidRigType = { R6 = "R6" } },
})
local zone = loadSource("src/ReplicatedStorage/Modules/SellShopZone.lua", {
	script = { Parent = { RodShopZone = geometry, PlotWorkspaceUtil = {
		getPlotBySlot = function()
			return plot
		end,
	} } },
	require = function(value)
		return value
	end,
})
assert(zone.CanSell(player) and zone.CanSell(player, true))
-- The client can still be inside its exit zone while the server sees a nearby,
-- slightly older/newer position. A request must not fail over that small offset.
root.Position = vector(4.8, 3, 0)
assert(zone.CanSell(player), "The shop stays open at the client's exit boundary")
root.Position = vector(6, 3, 0)
assert(not zone.CanSell(player), "Client closing must keep its existing precise boundary")
assert(
	zone.CanSell(player, true),
	"Nearby server positions must tolerate replication drift instead of Visit the sell shop on your plot"
)
root.Position = vector(0, 9, 0)
assert(not zone.CanSell(player) and zone.CanSell(player, true), "Jumping must have server-side height tolerance")
root.Position = vector(13, 3, 0)
assert(zone.CanSell(player, true), "Allow a generous horizontal buffer near the shop")
root.Position = vector(30, 3, 0)
assert(not zone.CanSell(player, true), "The buffer must not allow remote selling")
root.Position = vector(0, 20, 0)
assert(not zone.CanSell(player, true), "Reject characters far above the shop")
root.Position = vector(0, 3, 0)
humanoid.Health = 0
assert(not zone.CanSell(player, true))
humanoid.Health = 100
owner = 99
assert(not zone.CanSell(player, true), "Keep ownership checks")
owner, slot = 42, nil
assert(not zone.CanSell(player, true), "Missing plot assignment must not bypass ownership")
