local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local core = read("src/StarterPlayer/StarterPlayerScripts/Purse/init.luau")
local visual = read("src/StarterPlayer/StarterPlayerScripts/PurseBackpack.client.lua")
local appearance = dofile("src/ReplicatedStorage/Modules/BackpackConfig.lua").Appearance
local first = assert(core:find("local function createCloseButton()", 1, true))
local last = assert(core:find("local closeButton = createCloseButton()", first, true))
local factorySource = core:sub(first, last - 1) .. "\nreturn createCloseButton"
local label = { Font = "AuthoredHeavyFont", ZIndex = 101, attributes = {} }
function label:IsA(class)
	return class == "TextLabel" or class == "GuiObject"
end
function label:SetAttribute(name, value)
	self.attributes[name] = value
end
function label:GetAttribute(name)
	return self.attributes[name]
end
local function button()
	return {
		ZIndex = 100,
		GetDescendants = function()
			return { label }
		end,
		FindFirstChildOfClass = function()
			return nil
		end,
	}
end
local template = {
	IsA = function(_, class)
		return class == "GuiButton"
	end,
	Clone = button,
}
local frame = {
	FindFirstChild = function()
		return template
	end,
}
local index = {
	FindFirstChild = function()
		return frame
	end,
}
local warnings, registrations, scale = 0, 0, nil
local env = setmetatable({
	StarterGui = {
		FindFirstChild = function()
			return index
		end,
	},
	NewGui = button,
	Instance = {
		new = function(class)
			local object = {}
			if class == "UIScale" then
				scale = object
			end
			return object
		end,
	},
	Color3 = {
		fromRGB = function(...)
			return { ... }
		end,
	},
	UDim = {
		new = function(...)
			return { ... }
		end,
	},
	UDim2 = {
		new = function(...)
			return { ... }
		end,
		fromOffset = function(x, y)
			return { X = x, Y = y }
		end,
	},
	Vector2 = {
		new = function(...)
			return { ... }
		end,
	},
	ButtonAnimation = {
		SetUp = function(b)
			assert(
				scale and scale.Parent == b and scale.Scale == 1,
				"Add UIScale before binding fixed-size button animation"
			)
			assert(b.Size.X == 44 and b.Size.Y == 44, "Configure button size before registering it")
			registrations = registrations + 1
		end,
	},
	warn = function()
		warnings = warnings + 1
	end,
}, { __index = _G })
local create = assert(load(factorySource, "Purse close button factory", "t", env))()
local cloned = create()
assert(cloned.Name == "CloseButton" and registrations == 1 and warnings == 0)
assert(label:GetAttribute("PreserveBackpackFont") and label.ZIndex == 6)
local fontStart = assert(visual:find("local function applyBackpackFont(", 1, true))
local fontEnd = assert(visual:find("local function applyBackpackFonts(", fontStart, true))
local applyFont = assert(
	load(
		visual:sub(fontStart, fontEnd - 1) .. "\nreturn applyBackpackFont",
		"font",
		"t",
		setmetatable({ BACKPACK_FONT = "BackpackFont" }, { __index = _G })
	)
)()
applyFont(label)
assert(label.Font == "AuthoredHeavyFont", "Preserve the cloned X label's authored font and weight")
index = nil
local fallback = create()
assert(
	fallback.Text == "X" and warnings == 1 and registrations == 2,
	"Missing template must keep a working generated button"
)

-- Execute the real fading callback across drag, equipment and accessibility changes.
local fadeStart = assert(core:find("\tlocal function UpdateSlotFading()", 1, true))
local fadeEnd = assert(core:find("\tfunction slot:Readjust(", fadeStart, true))
local canDrag = false
local slotFrame = {
	GetAttribute = function()
		return canDrag
	end,
}
local slot = {}
local gui = { PreferredTransparency = 1 }
local fadeEnv = setmetatable({
	slot = slot,
	SlotFrame = slotFrame,
	Appearance = appearance,
	GuiService = gui,
	BACKGROUND_COLOR = "normal",
	SLOT_DRAGGABLE_COLOR = "draggable",
}, { __index = _G })
assert(load(core:sub(fadeStart, fadeEnd - 1), "slot fading", "t", fadeEnv))()
slot:UpdateFading()
assert(slotFrame.BackgroundTransparency == appearance.SlotTransparency)
canDrag = true
slot:UpdateFading()
assert(
	slotFrame.BackgroundTransparency == appearance.SlotTransparency,
	"Opening or dragging must not force opaque cells"
)
fadeEnv.HighlightFrame = { Parent = slotFrame }
slot:UpdateFading()
assert(slotFrame.BackgroundTransparency == appearance.EquippedSlotTransparency)
local prefStart = assert(core:find("local function OnPreferredTransparencyChanged()", 1, true))
local prefEnd = assert(core:find('GuiService:GetPropertyChangedSignal("PreferredTransparency")', prefStart, true))
fadeEnv.Slots, fadeEnv.InventoryFrame = { slot }, {}
fadeEnv.BACKGROUND_FADE_DEFAULT = appearance.PanelTransparency
fadeEnv.SEARCH_BACKGROUND_FADE_DEFAULT = 0.15
local refresh = assert(
	load(core:sub(prefStart, prefEnd - 1) .. "\nreturn OnPreferredTransparencyChanged", "preference", "t", fadeEnv)
)()
for _, value in ipairs({ 0, 0.5, 1 }) do
	gui.PreferredTransparency = value
	refresh() -- Search has not been created.
	assert(slotFrame.BackgroundTransparency == appearance.EquippedSlotTransparency * value)
	assert(fadeEnv.InventoryFrame.BackgroundTransparency == appearance.PanelTransparency * value)
end
fadeEnv.HighlightFrame.Parent = nil
refresh()
assert(slotFrame.BackgroundTransparency == appearance.SlotTransparency)
