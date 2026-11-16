-- Exercise the production capture functions with slots reparented between views.
local f = assert(io.open("src/StarterPlayer/StarterPlayerScripts/Controllers/HotbarLayoutController.lua", "r"))
local source = f:read("*a")
f:close()
local start = assert(source:find("local function getHotbarSlots()", 1, true))
local finish = assert(source:find("local function requestSave()", start, true))
local captureSource = source:sub(start, finish - 1):gsub(": {%s*%[[^%]]+%]: %w+ }", "")
local descendants = {}
local gui = {
	GetDescendants = function()
		return descendants
	end,
}
local playerGui = {
	FindFirstChild = function(_, name)
		if name == "BackpackGui" then
			return gui
		end
	end,
}
local player = {
	FindFirstChildOfClass = function()
		return playerGui
	end,
}
local env = setmetatable({
	LOCAL_PLAYER = player,
	FIRST_ITEM_SLOT = 1,
	LAST_ITEM_SLOT = 10,
	getDescriptor = function(tool)
		return tool and { Kind = tool.Kind, Id = tool.Id }
	end,
}, { __index = _G })
local chunk = assert(load(captureSource .. "\nreturn captureLayout", "HotbarLayoutController capture", "t", env))
local capture = chunk()
local function slot(index, id, parent)
	local reference = { Value = { Kind = "Item", Id = id } }
	local result = {
		Name = tostring(index),
		Parent = parent,
		IsA = function(_, class)
			return class == "TextButton"
		end,
		GetAttribute = function(_, name)
			if name == "HotbarSlotIndex" then
				return index
			end
		end,
		FindFirstChild = function(_, name)
			if name == "ToolReference" then
				return reference
			end
		end,
	}
	reference.IsA = function(_, class)
		return class == "ObjectValue"
	end
	table.insert(descendants, result)
	return result, reference
end
local frames, references = {}, {}
for i = 1, 10 do
	frames[i], references[i] = slot(i, "fish" .. i, "Hotbar")
end
local original = capture()
for i = 8, 10 do
	frames[i].Parent = "UIGridFrame"
end
local mobile = capture()
for i = 1, 10 do
	assert(mobile[tostring(i)].Id == original[tostring(i)].Id)
end
-- A visual ghost may contain labels, but cannot masquerade as a saved slot.
local ghost = slot(11, "ghost", "DragLayer")
ghost.Name = "DragPreview"
ghost.GetAttribute = function()
	return nil
end
assert(capture()["11"] == nil)
-- Moving a reserved fish to a visible slot clears its reservation once.
references[1].Value = references[8].Value
references[8].Value = nil
local changed = capture()
assert(changed["1"].Id == "fish8" and changed["8"] == nil)
assert(changed["9"].Id == "fish9" and changed["10"].Id == "fish10")
for i = 8, 10 do
	frames[i].Parent = "Hotbar"
end
local desktop = capture()
for key, descriptor in pairs(changed) do
	assert(desktop[key].Id == descriptor.Id)
end

-- Run the production presentation and drop callbacks, not a second implementation.
local coreFile = assert(io.open("src/StarterPlayer/StarterPlayerScripts/Purse/init.luau", "r"))
local core = coreFile:read("*a")
coreFile:close()
local layoutStart = assert(core:find("local function AdjustHotbarFrames()", 1, true))
local layoutEnd = assert(core:find("local function Clamp(", layoutStart, true))
local dropStart = assert(core:find("drop = function(source, point)", 1, true)) + #"drop = "
local dropEnd = assert(core:find("\n\tend,\n})", dropStart, true)) + #"\n\tend" - 1
local policy = dofile("src/ReplicatedStorage/Modules/BackpackLayout.lua")
local grid = { AbsoluteSize = { X = 500 } }
local hotbar = {}
local slots = {}
local function fillSlot(s, tool)
	s.Tool = tool
	s.Frame.reference.Value = tool
end
local function makeSlot(parent)
	local s = { Index = #slots + 1, Frame = { Parent = parent, Visible = true } }
	s.Frame.reference = {
		IsA = function()
			return true
		end,
	}
	s.Frame.IsA = function(_, class)
		return class == "GuiObject" or class == "TextButton"
	end
	s.Frame.FindFirstChild = function(_, name)
		if name == "ToolReference" then
			return s.Frame.reference
		end
	end
	s.Frame.GetAttribute = function(_, name)
		if name == "HotbarSlotIndex" and s.Index <= 10 then
			return s.Index
		end
	end
	s.Fill = fillSlot
	s.Clear = function(self)
		fillSlot(self, nil)
	end
	s.Readjust = function() end
	s.TurnNumber = function(self, on)
		self.numberVisible = on
	end
	s.Delete = function(self)
		self.Frame.Parent = nil
	end
	s.MoveToInventory = function(self)
		local tool = self.Tool
		self:Clear()
		makeSlot(grid):Fill(tool)
	end
	s.Swap = function(self, target)
		local tool = self.Tool
		self:Fill(target.Tool)
		target:Fill(tool)
	end
	table.insert(slots, s)
	return s
end
for i = 1, 10 do
	makeSlot(hotbar):Fill({ Kind = "Item", Id = "saved" .. i })
end
makeSlot(grid):Fill({ Kind = "Item", Id = "loose" })
grid.GetChildren = function()
	local result = {}
	for _, s in ipairs(slots) do
		if s.Frame.Parent == grid then
			table.insert(result, s.Frame)
		end
	end
	return result
end
local inventory = { Visible = true }
local scroll = {}
local hitTarget
local hitInventory = false
local coreEnv = setmetatable({
	Slots = slots,
	NumberOfHotbarSlots = 10,
	VisibleHotbarSlots = 10,
	Layout = policy.Compute(1280, 662, false),
	ICON_SIZE = 53,
	ICON_BUFFER = 4,
	InventoryFrame = inventory,
	HotbarFrame = hotbar,
	UIGridFrame = grid,
	UIGridLayout = {},
	ScrollingFrame = scroll,
	INVENTORY_HEADER_SIZE = 56,
	UserInputService = { KeyboardEnabled = true },
	OpenInventoryButton = {},
	BackpackScript = {},
	UDim2 = {
		new = function(...)
			return { ... }
		end,
		fromOffset = function(x, y)
			return { X = x, Y = y }
		end,
	},
	BackpackLayout = policy,
	MakeSlot = makeSlot,
	CheckBounds = function(frame)
		return frame == hitTarget or (frame == scroll and hitInventory)
	end,
	IsEquipped = function()
		return false
	end,
}, { __index = _G })
local callbacks = assert(
	load(
		core:sub(layoutStart, layoutEnd - 1)
			.. "\nlocal drop = "
			.. core:sub(dropStart, dropEnd)
			.. "\nreturn { layout = UpdateBackpackLayout, canvas = UpdateScrollingFrameCanvasSize, drop = drop }",
		"Purse presentation callbacks",
		"t",
		coreEnv
	)
)()
callbacks.layout()
assert(coreEnv.UIGridLayout.FillDirectionMaxCells == 10)
assert(grid.Size.X == coreEnv.Layout.GridWidth and grid.Position.X == 18)
assert(scroll.CanvasSize.Y == policy.CanvasHeight(1, coreEnv.Layout))
for i = 1, 10 do
	assert(slots[i].Frame.Parent == hotbar)
end
coreEnv.VisibleHotbarSlots = 7
coreEnv.Layout = policy.Compute(402, 816, true)
callbacks.layout()
assert(coreEnv.UIGridLayout.FillDirectionMaxCells == 7)
assert(grid.Size.X == coreEnv.Layout.GridWidth and grid.Position.X == 18)
assert(scroll.CanvasSize.Y == policy.CanvasHeight(4, coreEnv.Layout), "Reserved positions count toward the same grid")
local getActualChildren = grid.GetChildren
for _, count in ipairs({ 0, 1, 7, 8, 29 }) do
	grid.GetChildren = function()
		local children = {}
		for _ = 1, count do
			table.insert(children, {
				Visible = true,
				IsA = function()
					return true
				end,
			})
		end
		table.insert(children, {
			Visible = false,
			IsA = function()
				return true
			end,
		})
		return children
	end
	callbacks.canvas()
	assert(
		scroll.CanvasSize.Y == policy.CanvasHeight(count, coreEnv.Layout),
		"Production canvas sizing counts visible cells and handles row boundaries"
	)
	assert(grid.Size.Y == scroll.CanvasSize.Y)
end
grid.GetChildren = getActualChildren
callbacks.canvas()
for i = 1, 7 do
	assert(slots[i].Frame.Parent == hotbar)
end
for i = 8, 10 do
	assert(slots[i].Frame.Parent == grid and slots[i].Tool.Id == "saved" .. i)
	assert(not slots[i].numberVisible)
end
-- Capture all ten logical slots from the real reparented presentation.
descendants = {}
for _, s in ipairs(slots) do
	table.insert(descendants, s.Frame)
end
local mobileCapture = capture()
assert(mobileCapture["8"].Id == "saved8" and mobileCapture["10"].Id == "saved10")
hitTarget = slots[1].Frame
callbacks.drop(slots[8], { X = 0, Y = 0 })
assert(slots[1].Tool.Id == "saved8" and slots[8].Tool == nil)
assert(slots[#slots].Tool.Id == "saved1" and slots[#slots].Frame.Parent == grid)
local count, seen = 0, {}
for _, s in ipairs(slots) do
	if s.Tool then
		assert(not seen[s.Tool.Id])
		seen[s.Tool.Id] = true
		count = count + 1
	end
end
assert(count == 11, "Reserved-slot move must neither lose nor duplicate an item")
local afterDrop = capture()
assert(afterDrop["1"].Id == "saved8" and afterDrop["8"] == nil and afterDrop["10"].Id == "saved10")
hitTarget = nil
callbacks.drop(slots[1], { X = 0, Y = 0 })
assert(slots[1].Tool.Id == "saved8", "Dropping outside both regions cancels")
coreEnv.VisibleHotbarSlots = 10
coreEnv.Layout = policy.Compute(1280, 662, false)
callbacks.layout()
assert(slots[10].Frame.Parent == hotbar and slots[10].Tool.Id == "saved10")
assert(slots[8].Tool == nil and capture()["8"] == nil)

local closeStart = assert(core:find("\tlocal function setOpen(open)", 1, true))
local closeEnd = assert(core:find("\t-- HotkeyFns[ARROW_HOTKEY]", closeStart, true))
local gate, fishing, cancelled, stateEvents = false, false, 0, 0
coreEnv.GameplayInputGate = {
	IsActive = function()
		return fishing
	end,
	SetActive = function(_, _, active)
		gate = active
	end,
}
coreEnv.DragController = {
	Cancel = function()
		cancelled = cancelled + 1
	end,
}
coreEnv.BackpackScript.StateChanged = {
	Fire = function()
		stateEvents = stateEvents + 1
	end,
}
coreEnv.MainFrame = {}
coreEnv.AdjustHotbarFrames = callbacks.layout
coreEnv.UpdateScrollingFrameCanvasSize = function() end
for _, s in ipairs(slots) do
	s.SetClickability = function() end
end
coreEnv.ContextActionService = { BindAction = function() end, UnbindAction = function() end }
coreEnv.Enum = { KeyCode = { ButtonX = 1 } }
coreEnv.gamepadHintsFrame = {}
coreEnv.disableGamepadInventoryControl = function() end
local closeCallbacks = assert(
	load(
		core:sub(closeStart, closeEnd - 1) .. "\nreturn { close = BackpackScript.Close, toggle = openClose }",
		"Purse open and close",
		"t",
		coreEnv
	)
)()
closeCallbacks.close()
assert(not inventory.Visible and not gate and coreEnv.BackpackScript.IsOpen == false)
local closedEventCount = stateEvents
closeCallbacks.close()
assert(stateEvents == closedEventCount, "Close must be idempotent")
closeCallbacks.toggle()
assert(inventory.Visible and gate and coreEnv.BackpackScript.IsOpen)
fishing = true
closeCallbacks.close()
assert(not inventory.Visible and not gate, "Closing must still release input while fishing is active")
closeCallbacks.toggle()
assert(not inventory.Visible, "Opening remains blocked during fishing")
assert(cancelled >= 3, "Close must cancel pending pointer interactions")
