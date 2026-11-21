local mt = {}
local function vector(x, y, z)
	return setmetatable({ X = x, Y = y, Z = z }, mt)
end
mt.__add = function(a, b)
	return vector(a.X + b.X, a.Y + b.Y, a.Z + b.Z)
end
mt.__sub = function(a, b)
	return vector(a.X - b.X, a.Y - b.Y, a.Z - b.Z)
end
mt.__unm = function(a)
	return vector(-a.X, -a.Y, -a.Z)
end
mt.__mul = function(a, b)
	return vector(a.X * b, a.Y * b, a.Z * b)
end
mt.__index = function(a, key)
	local length = math.sqrt(a.X * a.X + a.Y * a.Y + a.Z * a.Z)
	if key == "Magnitude" then
		return length
	end
	if key == "Unit" then
		return vector(a.X / length, a.Y / length, a.Z / length)
	end
end
local zero = vector(0, 0, 0)
local anchor = {
	Position = zero,
	Size = vector(0.05, 10.9, 7.5),
	IsA = function()
		return true
	end,
}
anchor.CFrame = {
	Position = zero,
	LookVector = vector(0, 0, 1),
	UpVector = vector(1, 0, 0),
	VectorToObjectSpace = function(_, v)
		return vector(v.Y, v.X, -v.Z)
	end,
	PointToObjectSpace = function(_, v)
		return vector(v.Y, v.X, -v.Z)
	end,
}
local spawn = {
	CFrame = { spawn = true },
	IsA = function()
		return true
	end,
}
local ground = { Position = vector(20, 0, 0) }
local plot = {
	TrainingAnchor = anchor,
	Ground = ground,
	AreaSpawnPoint = spawn,
	FindFirstChild = function(self, name)
		return self[name]
	end,
}
local humanoid = {}
local root = { Position = vector(0, 3.1, 0), Size = vector(2, 2, 1) }
local character = {
	FindFirstChild = function()
		return root
	end,
	FindFirstChildOfClass = function()
		return humanoid
	end,
}
root.Parent = character
local noFloor, blocked, steep, high = false, false, false, false
local world = {
	Raycast = function(_, origin)
		if noFloor then
			return nil
		end
		return { Position = vector(origin.X, if high then 4 else 0, origin.Z), Normal = vector(
			0,
			if steep then 0.5 else 1,
			0
		) }
	end,
	GetPartBoundsInBox = function()
		return if blocked then { true } else {}
	end,
}
local parent =
	{ FishingSpotUtil = {
		GetFootHeight = function()
			return 3
		end,
	}, TrainingConfig = { FootTolerance = 2.5 }, PlotWorkspaceUtil = {
		getPlotBySlot = function(slotId)
			assert(slotId == 1, "Plot_1 supplies the exit anchor template")
			return plot
		end,
	} }
local env = setmetatable({
	script = { Parent = parent },
	require = function(m)
		return m
	end,
	workspace = world,
	Vector3 = { new = vector, yAxis = vector(0, 1, 0), zAxis = vector(0, 0, 1) },
	CFrame = {
		new = function(p)
			return { Position = p }
		end,
		lookAt = function(p, target)
			return { Position = p, LookVector = (target - p).Unit }
		end,
	},
	RaycastParams = {
		new = function()
			return {}
		end,
	},
	OverlapParams = {
		new = function()
			return {}
		end,
	},
	Enum = { RaycastFilterType = { Exclude = "Exclude" } },
}, { __index = getfenv() })
local source = assert(io.open("src/ReplicatedStorage/Modules/TrainingSpotUtil.lua"))
local chunk = assert(loadstring(source:read("*a"), "TrainingSpot"), "TrainingSpotUtil compiles")
local Spot = setfenv(chunk, env)()
assert(Spot.Contains(anchor, root, humanoid), "Rotated thin marker checks feet")
local start = Spot.SpawnCFrame(plot, character)
assert(start.Position.Y == 3.1, "Training spawn keeps its foot clearance")
assert(math.abs(Spot.MarkerCFrame(plot).Position.Y - 0.075) < 1e-9, "Idle model rests on marker surface")

local function assertFacing(testPlot, expected)
	local spawnFrame = Spot.SpawnCFrame(testPlot, character)
	local markerFrame = Spot.MarkerCFrame(testPlot)
	assert((spawnFrame.LookVector - expected).Magnitude < 1e-9, "Training spawn faces the anchor's horizontal front")
	assert((markerFrame.LookVector - expected).Magnitude < 1e-9, "Idle display aligns with the training spawn")
end

assertFacing(plot, vector(0, 0, 1))
local rotatedPlot = table.clone(plot)
rotatedPlot.TrainingAnchor = table.clone(anchor)
rotatedPlot.TrainingAnchor.CFrame = { Position = zero, LookVector = vector(-0.8, 0.6, 0) }
assertFacing(rotatedPlot, vector(-1, 0, 0))
rotatedPlot.TrainingAnchor.CFrame.LookVector = vector(0, 1, 0)
assertFacing(rotatedPlot, vector(1, 0, 0))

local exit = Spot.ExitCFrame(plot, character)
assert(math.abs(exit.Position.X + 7.95) < 1e-9 and exit.LookVector.X == -1, "Missing exit anchor uses the marker edge")
assert(
	not Spot.Contains(anchor, { Position = exit.Position, Size = root.Size, Parent = character }, humanoid),
	"Exit lands outside the marker"
)
blocked = true
assert(Spot.ExitCFrame(plot, character) == spawn.CFrame, "Blocked body space uses home spawn")
blocked = false
noFloor = true
assert(Spot.ExitCFrame(plot, character) == spawn.CFrame, "Missing ground uses home spawn")
noFloor = false
steep = true
assert(Spot.ExitCFrame(plot, character) == spawn.CFrame, "Steep ground is rejected")
steep = false
high = true
assert(Spot.ExitCFrame(plot, character) == spawn.CFrame, "Fence tops are rejected")
high = false

plot.TrainingExitAnchor = {
	CFrame = { Position = vector(18, 0.25, 1), LookVector = vector(0, 0.6, 0.8) },
	IsA = function()
		return true
	end,
}
local function assertExit(testPlot, expectedPosition, expectedFacing)
	local frame = Spot.ExitCFrame(testPlot, character)
	assert((frame.Position - expectedPosition).Magnitude < 1e-9, "Exit keeps foot clearance above its anchor")
	assert((frame.LookVector - expectedFacing).Magnitude < 1e-9, "Exit uses the anchor's horizontal facing")
end

assertExit(plot, vector(18, 3.35, 1), vector(0, 0, 1))

local relativeFrame = {}
anchor.CFrame.ToObjectSpace = function(_, frame)
	assert(frame == plot.TrainingExitAnchor.CFrame, "Exit offset uses Plot_1's authored anchor")
	return relativeFrame
end
rotatedPlot.TrainingAnchor.CFrame.ToWorldSpace = function(_, frame)
	assert(frame == relativeFrame, "Destination plot receives the offset from Plot_1's training anchor")
	return { Position = vector(99, 0.25, 18), LookVector = vector(-0.8, 0.6, 0) }
end
assertExit(rotatedPlot, vector(99, 3.35, 18), vector(-1, 0, 0))

plot.TrainingExitAnchor.IsA = function()
	return false
end
assertExit(plot, exit.Position, exit.LookVector)
