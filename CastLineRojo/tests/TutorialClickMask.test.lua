local vector = {}
vector.__index = vector
local function vec(x, y)
	return setmetatable({ X = x, Y = y }, vector)
end
function vector.__add(a, b) return vec(a.X + b.X, a.Y + b.Y) end
function vector.__sub(a, b) return vec(a.X - b.X, a.Y - b.Y) end
function vector.__mul(a, n) return vec(a.X * n, a.Y * n) end

local function instance(class)
	return {
		IsA = function(_, name)
			return name == class or (name == "GuiObject" and (class == "Frame" or class == "ScrollingFrame"))
		end,
	}
end
local modulePath = "src/ReplicatedStorage/Modules/TutorialClickMask.lua"
local maskModule = assert(load(assert(io.open(modulePath)):read("*a"), modulePath, "t", setmetatable({
	Vector2 = { new = vec },
	UDim2 = { fromOffset = function(x, y) return vec(math.floor(x), math.floor(y)) end },
	Instance = { new = instance },
	Color3 = { new = function() end },
	Enum = { ApplyStrokeMode = { Border = "Border" } },
}, { __index = getfenv() })))()

local screen = instance("ScreenGui")
screen.AbsolutePosition, screen.AbsoluteSize, screen.Enabled = vec(19, 27), vec(641, 361), true
local scroll = instance("ScrollingFrame")
scroll.AbsolutePosition, scroll.AbsoluteWindowSize = vec(103, 70), vec(500, 250)
scroll.Parent, scroll.Visible, scroll.ClipsDescendants = screen, true, true
local target = instance("Frame")
target.AbsolutePosition, target.AbsoluteSize, target.Visible, target.Parent = vec(108, 130), vec(95, 27), true, scroll

local mask = maskModule.new(screen)
local function assertJoined()
	local low, high = mask:Update(target)
	assert(low and high)
	local top, bottom, left, right = unpack(mask.panels)
	assert(top.Size.Y == left.Position.Y and top.Size.Y == right.Position.Y)
	assert(left.Position.Y + left.Size.Y == bottom.Position.Y, "Left panel must meet the bottom panel")
	assert(right.Position.Y + right.Size.Y == bottom.Position.Y, "Right panel must meet the bottom panel")
	assert(bottom.Position.Y + bottom.Size.Y == screen.AbsoluteSize.Y)
	assert(right.Position.X + right.Size.X == screen.AbsoluteSize.X)
	assert(left.Size.X == low.X and right.Position.X == high.X)
	assert(mask.border.Position.Y == low.Y and mask.border.Size.Y == high.Y - low.Y)
end

assertJoined()
assert(mask.border.Position.X == scroll.AbsolutePosition.X - screen.AbsolutePosition.X, "Keep the opening within the scroll window")
screen.AbsoluteSize = vec(200, 151)
assertJoined()
target.Visible = false
assert(mask:Update(target) == nil and not mask.border.Visible)
target.Visible = true
target.AbsolutePosition = vec(30, 55)
assert(mask:Update(target) ~= nil, "A partially clipped target retains its opening")
target.AbsolutePosition = vec(0, 0)
assert(mask:Update(target) == nil and not mask.border.Visible)
for _, panel in ipairs(mask.panels) do
	assert(not panel.Visible)
end
