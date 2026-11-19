-- One-time Edit-mode installation recipe; runtime colors are read only from Studio templates.
assert(game.PlaceId == 84106335829275, "Expected #CL_DEV")
assert(not game:GetService("RunService"):IsRunning(), "Install rarity templates in Edit mode")
local folder = game:GetService("ReplicatedStorage"):FindFirstChild("Gui")
folder = folder and folder:FindFirstChild("UIGradient")
assert(folder, "Missing ReplicatedStorage.Gui.UIGradient")

local palette = {
	{ "Common", { "D7D7DE", "9696A0" } },
	{ "Uncommon", { "96FF78", "32B432" } },
	{ "Rare", { "78BEFF", "1E5AE6" } },
	{ "Epic", { "D782FF", "7828DC" } },
	{ "Legendary", { "FFD25A", "FF7800" } },
	{ "Mythical", { "FF6E96", "C8003C" } },
	{ "Secret", { "140838", "4B1CA0", "D73AFF", "4B1CA0", "140838" }, { 0, 0.3, 0.5, 0.7, 1 } },
	{ "Divine", { "FFFAC8", "FFD700" } },
	{ "Celestial", { "78F5FF", "BE82FF", "FF96DC" } },
	{ "Eternal", { "FFEBFF", "BE46FF", "3C0096" } },
	{ "Cosmic", { "78FFFA", "3C5AFF", "14005A" } },
	{ "Exclusive", { "FFDB89", "FF67B7", "8646FF" } },
	{ "Event", { "B4FFE1", "24CFB2", "087F8C" } },
}

-- Preflight every target before changing any template.
for _, entry in ipairs(palette) do
	local name = "UIGradient_" .. entry[1]
	local found = folder:FindFirstChild(name)
	assert(not found or found:IsA("UIGradient"), "Unexpected instance class at " .. name)
	local count = 0
	for _, child in ipairs(folder:GetChildren()) do
		if child.Name == name then
			count += 1
		end
	end
	assert(count <= 1, "Duplicate template: " .. name)
end

local installed = {}
for _, entry in ipairs(palette) do
	local name, hexColors, times = entry[1], entry[2], entry[3]
	local templateName = "UIGradient_" .. name
	local gradient = folder:FindFirstChild(templateName) or Instance.new("UIGradient")
	local points = {}
	for index, hex in ipairs(hexColors) do
		table.insert(points, ColorSequenceKeypoint.new(
			if times then times[index] else (index - 1) / (#hexColors - 1), Color3.fromHex(hex)
		))
	end
	gradient.Name = templateName
	gradient.Color = ColorSequence.new(points)
	gradient.Rotation = if name == "Secret" or name == "Exclusive" then 20 else 90
	gradient.Offset = Vector2.zero
	gradient.Transparency = NumberSequence.new(0)
	gradient.Enabled = false
	gradient.Parent = folder
	table.insert(installed, templateName)
end
return installed
