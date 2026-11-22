local file = assert(io.open("src/ReplicatedStorage/Modules/RodPopupView.lua", "r"), "Read the popup view source")
local source = file:read("*a")
file:close()
local colors = { Common = {}, Rare = {}, Epic = {} }
local modules = {
	NumberUtil = { FormatItemPriceCompact = tostring },
	RarityPresentation = {
		GetColor = function(rarity)
			return assert(colors[rarity], "Expected a test rarity color")
		end,
	},
}
local services = {
	ReplicatedStorage = { Modules = modules },
	GuiService = {},
	TweenService = { Create = function() return { Play = function() end, Cancel = function() end } end },
	UserInputService = { PreferredInput = "Gamepad" },
}
local environment = setmetatable({
	game = { GetService = function(_, name) return services[name] end },
	require = function(value) return value end,
	Enum = { PreferredInput = { Gamepad = "Gamepad" }, EasingStyle = {}, EasingDirection = {}, SizeConstraint = {} },
	UDim2 = {
		fromScale = function() return {} end,
		new = function() return {} end,
	},
	TweenInfo = { new = function() return {} end },
}, { __index = getfenv() })
local chunk = assert(loadstring(source, "RodPopupView"), "Compile the popup view")
local View = setfenv(chunk, environment)()
local image = { Image = "rbxassetid://1", Visible = true }
local main = {
	PreviewFrame = { RodImage = image },
	Top = { Title = {} },
	NameLabel = {},
	PriceLabel = {},
	ShopButton = { NameLabel = { Text = "SHOP" } },
	ProgressFrame = { ProgressBar = {} },
}
local attributes = {}
local popup = {
	MainFrame = main,
	FindFirstChildOfClass = function() return nil end,
	IsA = function() return true end,
	SetAttribute = function(_, name, value) attributes[name] = value end,
	Visible = true,
	Position = { X = { Scale = 0.5, Offset = 0 } },
	Size = { X = { Scale = 0.5, Offset = 0 } },
}
local gui = { Enabled = false, AbsoluteSize = { X = 1920, Y = 1080 } }
local view = View.new(gui, popup, "Rod")

local rod = { RodID = "Rod_102", DisplayName = "Park Rod", Rarity = "Common", Price = 500, Icon = "rbxassetid://2" }
view:SetItem(rod)
assert(image.Image == rod.Icon and image.Visible, "The recommended rod replaces the Studio preview image")
assert(main.NameLabel.Text == "Park Rod" and main.NameLabel.TextColor3 == colors.Common, "Use the rod name and color")
rod = { RodID = "Rod_103", DisplayName = "Forest Warden", Rarity = "Rare", Price = 1000, Icon = "rbxassetid://3" }
view:SetItem(rod)
assert(image.Image == rod.Icon and image.Visible, "A new recommendation replaces the previous rod image")

for _, missingIcon in ipairs({ "", "nil" }) do
	rod.Icon = missingIcon
	view:SetItem(rod)
	assert(image.Image == "" and not image.Visible, "A missing icon clears and hides the preview")
	assert(main.Top.Title.Text == "NEW ROD UNLOCKED!" and main.NameLabel.Text == "Forest Warden", "Show the rod title and name")
	assert(main.NameLabel.TextColor3 == colors.Rare and main.ShopButton.NameLabel.Text == "SHOP", "Update the name color")
	assert(main.PriceLabel.Text == '<font color="#00F900">$1000</font>' and attributes.RodID == rod.RodID, "Use the rod price and ID")

	rod.Icon = "rbxassetid://3"
	view:SetItem(rod)
	assert(image.Image == rod.Icon and image.Visible, "The next valid icon restores the preview")
end

assert(not view:Paused(), "An idle pointer must not pause the countdown")
view.hovered = true
assert(view:Paused(), "Hover pauses the countdown")
view.hovered = false
view:Show()
assert(gui.Enabled and popup.Visible, "Show the upgrade prompt for gamepad users")
assert(services.GuiService.SelectedObject == nil, "A passive upgrade prompt must leave the left stick with native character movement")
services.GuiService.SelectedObject = {
	IsDescendantOf = function(_, parent)
		return parent == view.popup
	end,
}
assert(view:Paused(), "Gamepad focus on the banner pauses the countdown")
services.GuiService.SelectedObject = { IsDescendantOf = function()
	return false
end }
assert(not view:Paused(), "Focus on another screen must not pause the banner")
local otherSelection = services.GuiService.SelectedObject
view:Show()
assert(services.GuiService.SelectedObject == otherSelection, "Showing an upgrade prompt preserves the active UI selection")
view:Hide(true)
assert(services.GuiService.SelectedObject == otherSelection, "Closing an upgrade prompt preserves focus owned by another UI")
services.GuiService.SelectedObject = {
	IsDescendantOf = function(_, parent)
		return parent == popup
	end,
}
view:Hide(true)
assert(services.GuiService.SelectedObject == nil, "Closing the focused upgrade prompt hands the stick back to native movement")

local barbellView = View.new(gui, popup, "Barbell")
main.ShopButton.NameLabel.Text = "UPGRADE"
for i, name in ipairs({ "Barbell 04", "Barbell 05" }) do
	local id = "Training_" .. (103 + i)
	barbellView:SetItem({ TrainingID = id, DisplayName = name, Rarity = "Epic", Price = 2000 })
	assert(main.NameLabel.Text == name and main.NameLabel.TextColor3 == colors.Epic, "Same-rarity barbells retain distinct names")
	assert(main.Top.Title.Text == "NEW BARBELL UNLOCKED!", "Use the barbell title")
	assert(main.ShopButton.NameLabel.Text == "UPGRADE", "Keep the button text from the barbell template")
	assert(main.PriceLabel.Text == '<font color="#00F900">$2000</font>' and attributes.TrainingID == id, "Use barbell price and ID")
	assert(not main.PreviewFrame.Visible and image.Image == "" and not image.Visible, "Hide the barbell preview without an icon")
end
barbellView:SetItem({ TrainingID = "Training_105", DisplayName = "Barbell 05", Rarity = "Epic", Price = 2000, Icon = "rbxassetid://4" })
assert(main.PreviewFrame.Visible and image.Visible and image.Image == "rbxassetid://4", "Restore the preview with a valid icon")
