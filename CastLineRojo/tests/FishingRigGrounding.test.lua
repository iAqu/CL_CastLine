local sourceFile = assert(io.open("src/ReplicatedStorage/Modules/FishingRigUtil.lua"))
local source = sourceFile:read("*a")
sourceFile:close()

local function vector(x, y, z)
	return setmetatable({ X = x, Y = y, Z = z }, {
		__add = function(a, b) return vector(a.X + b.X, a.Y + b.Y, a.Z + b.Z) end,
		__div = function(a, divisor) return vector(a.X / divisor, a.Y / divisor, a.Z / divisor) end,
		__mul = function(a, b)
			return if type(b) == "number" then vector(a.X * b, a.Y * b, a.Z * b)
				else vector(a.X * b.X, a.Y * b.Y, a.Z * b.Z)
		end,
		__index = function(a, key)
			local magnitude = math.sqrt(a.X ^ 2 + a.Y ^ 2 + a.Z ^ 2)
			return if key == "Magnitude" then magnitude else vector(a.X / magnitude, a.Y / magnitude, a.Z / magnitude)
		end,
	})
end

local marker = {
	Position = vector(12, 8, 24),
	Size = vector(8, 4, 8),
	CFrame = { UpVector = vector(0, 1, 0), LookVector = vector(0, 0, -1) },
}
local floor = { Position = vector(12, 5, 24) }
local nearbyCharacter = {}
local workspace = {
	Raycast = function(_, origin, direction, params)
		assert(origin.X == 12 and origin.Z == 24 and origin.Y > 10)
		assert(direction.Y < 0 and origin.Y + direction.Y < 5)
		assert(params.RespectCanCollide and params.IgnoreWater)
		assert(table.find(params.FilterDescendantsInstances, nearbyCharacter))
		return floor
	end,
}
local players = { GetPlayers = function() return { { Character = nearbyCharacter } } end }
local environment = setmetatable({
	game = { GetService = function(_, name) return if name == "Workspace" then workspace else players end },
	Vector3 = { new = vector, yAxis = vector(0, 1, 0) },
	CFrame = { lookAt = function(position, target)
		assert(target.X == position.X and target.Y == position.Y and target.Z < position.Z)
		return { Position = position }
	end },
	Enum = { RaycastFilterType = { Exclude = "Exclude" } },
	RaycastParams = { new = function() return {} end },
}, { __index = getfenv() })
local rigUtil = assert(load(source, "FishingRigUtil", "t", environment))()

local function foot(centerY, rightY, upY)
	return {
		Size = vector(2, 0.5, 1),
		CFrame = {
			Position = vector(0, centerY, 0),
			RightVector = vector(0, rightY, 0),
			UpVector = vector(0, upY, 0),
			LookVector = vector(0, 0, -1),
		},
		IsA = function(_, class) return class == "BasePart" end,
	}
end

local feet = { LeftFoot = foot(-2.5, 0, 1), RightFoot = foot(-2.5, 1, 0) }
local rig = { FindFirstChild = function(_, name) return feet[name] end }
local root = {
	Parent = rig,
	Size = vector(2, 2, 1),
	CFrame = { ToObjectSpace = function(_, frame) return frame end },
}
local humanoid = { HipHeight = 3 }

local target, forward, groundY = rigUtil.GetSpotRootCFrame(marker, root, humanoid)
assert(groundY == 5, "Use the real ground instead of the elevated trigger")
assert(target.Position.Y == 8.5, "Use the lowest point of the rotated foot rather than HipHeight")
assert(target.Position.X == 12 and target.Position.Z == 24 and forward.Z == -1)

feet.RightFoot = nil
target = rigUtil.GetSpotRootCFrame(marker, root, humanoid)
assert(target.Position.Y == 7.75, "Use the remaining foot on an incomplete rig")

feet.LeftFoot = nil
target = rigUtil.GetSpotRootCFrame(marker, root, humanoid)
assert(target.Position.Y == 9, "Fall back to HipHeight when neither foot is available")

floor = nil
target, _, groundY = rigUtil.GetSpotRootCFrame(marker, root, humanoid)
assert(groundY == 10 and target.Position.Y == 14, "Fall back to the marker when collision geometry is missing")
