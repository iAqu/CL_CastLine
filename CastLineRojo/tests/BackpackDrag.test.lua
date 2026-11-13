local function signal()
	local handlers = {}
	return {
		Connect = function(_, fn)
			local entry = { fn = fn, connected = true }
			table.insert(handlers, entry)
			return {
				Disconnect = function()
					entry.connected = false
				end,
			}
		end,
		Fire = function(_, ...)
			for _, entry in ipairs(handlers) do
				if entry.connected then
					entry.fn(...)
				end
			end
		end,
	}
end
local vector = {}
local function v(x, y)
	return setmetatable({ X = x, Y = y }, vector)
end
vector.__sub = function(a, b)
	return v(a.X - b.X, a.Y - b.Y)
end
vector.__index = function(a, key)
	if key == "Magnitude" then
		return math.sqrt(a.X * a.X + a.Y * a.Y)
	end
end
local types = { MouseButton1 = "mouse", MouseMovement = "move", Touch = "touch", Gamepad1 = "gamepad" }
local inputService = { InputChanged = signal(), InputEnded = signal(), WindowFocusReleased = signal() }
local delayed = {}
local function instance(class)
	return {
		ClassName = class,
		FindFirstChildOfClass = function()
			return nil
		end,
		Destroy = function(self)
			self.destroyed = true
		end,
		SetAttribute = function(self, name, value)
			self[name] = value
		end,
	}
end
local icon = {
	Name = "Icon",
	ZIndex = 1,
	IsA = function(_, class)
		return class == "GuiObject"
	end,
}
local frame = {
	InputBegan = signal(),
	Activated = signal(),
	Destroying = signal(),
	Parent = {},
	AbsolutePosition = v(10, 10),
	AbsoluteSize = v(56, 56),
	ZIndex = 1,
	Clone = function()
		local ghost = instance("TextButton")
		ghost.GetDescendants = function()
			return { icon }
		end
		ghost.FindFirstChild = function()
			return nil
		end
		return ghost
	end,
}
local env = setmetatable({
	game = {
		GetService = function()
			return inputService
		end,
	},
	Enum = { UserInputType = types, ApplyStrokeMode = { Border = "border" } },
	Vector2 = { new = v },
	UDim2 = {
		fromOffset = function(x, y)
			return v(x, y)
		end,
	},
	Color3 = {
		new = function()
			return {}
		end,
	},
	Instance = { new = instance },
	task = {
		delay = function(_, fn)
			table.insert(delayed, fn)
		end,
	},
}, { __index = _G })
local file = assert(io.open("src/ReplicatedStorage/Modules/BackpackDragController.lua", "r"))
local Controller = assert(load(file:read("*a"), "BackpackDragController", "t", env))()
file:close()
local slot = { Tool = {} }
local clicks, drops, starts, finishes = 0, 0, 0, 0
local scrolling = { ScrollingEnabled = true }
local canDrag = true
local c = Controller.new({
	layer = { AbsolutePosition = v(2, 3) },
	scrolling = scrolling,
	canInteract = function()
		return true
	end,
	canDrag = function()
		return canDrag
	end,
	click = function()
		clicks = clicks + 1
	end,
	drop = function(s, point)
		assert(s == slot and point.X == 40)
		drops = drops + 1
	end,
	started = function()
		starts = starts + 1
	end,
	finished = function()
		finishes = finishes + 1
	end,
})
c:Bind(frame, slot)
local function input(kind, x, y)
	return { UserInputType = kind, Position = v(x, y) }
end
local down = input(types.MouseButton1, 20, 20)
frame.InputBegan:Fire(down)
inputService.InputChanged:Fire(input(types.MouseMovement, 24, 20))
assert(c.pending and not c.pending.active, "Mouse deadzone must preserve click")
inputService.InputEnded:Fire(input(types.MouseButton1, 24, 20))
frame.Activated:Fire(down)
assert(clicks == 1 and drops == 0, "A mouse click must equip exactly once")
frame.InputBegan:Fire(down)
inputService.InputChanged:Fire(input(types.MouseMovement, 40, 30))
local ghost = c.pending.ghost
assert(ghost and icon.ZIndex >= ghost.ZIndex and not scrolling.ScrollingEnabled)
assert(ghost.Position.X == 38 and ghost.Position.Y == 27, "Ghost must follow pointer without easing")
inputService.InputEnded:Fire(input(types.MouseButton1, 40, 30))
frame.Activated:Fire(down)
assert(clicks == 1 and drops == 1 and scrolling.ScrollingEnabled and ghost.destroyed)
local touch = input(types.Touch, 20, 20)
frame.InputBegan:Fire(touch)
touch.Position = v(20, 40)
inputService.InputChanged:Fire(touch)
for _, fn in ipairs(delayed) do
	fn()
end
assert(c.pending == nil and scrolling.ScrollingEnabled, "A swipe must scroll instead of dragging")
inputService.InputEnded:Fire(touch)
assert(clicks == 1 and drops == 1)
frame.InputBegan:Fire(input(types.Touch, 20, 20))
delayed[#delayed]()
assert(c.pending.active and not scrolling.ScrollingEnabled, "Long press must begin touch drag")
inputService.InputChanged:Fire(input(types.Touch, 100, 100))
assert(c.pending.position.X == 20, "Other fingers must not move the drag")
inputService.WindowFocusReleased:Fire()
assert(c.pending == nil and scrolling.ScrollingEnabled and drops == 1)
frame.InputBegan:Fire(down)
inputService.InputChanged:Fire(input(types.MouseMovement, 40, 30))
c:CancelSlot(slot)
assert(c.pending == nil and starts == finishes and scrolling.ScrollingEnabled)
canDrag = false
frame.InputBegan:Fire(down)
inputService.InputChanged:Fire(input(types.MouseMovement, 40, 30))
assert(not c.pending.active, "Closed inventory cannot start a drag")
c:Cancel()
frame.Activated:Fire(input(types.Gamepad1, 0, 0))
assert(clicks == 2, "Controller activation remains supported")
frame.Destroying:Fire()
assert(c.bindings[frame] == nil)
