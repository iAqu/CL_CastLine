-- Edit-only installation; runtime scripts and animation logic stay in Rojo.
-- Layout/palette: ThrowFood TrainingGui, TrainingController, PlotController and UITheme.
assert(game.PlaceId == 84106335829275, "Expected #CL_DEV")
assert(not game:GetService("RunService"):IsRunning(), "Training prefabs require Edit mode")
local StarterGui = game:GetService("StarterGui")
local titles = StarterGui:FindFirstChild("TitleGui")
assert(titles and titles:IsA("ScreenGui"), "Missing TitleGui")
local plots = workspace.Areas.Plot
local sourcePlot = plots.Plot_1
local old = StarterGui:FindFirstChild("TrainingGui")
local oldTitle = titles:FindFirstChild("TrainingUpgradeTemplate")
assert(
	not old or old:GetAttribute("TrainingPrefabVersion") == 1 or old:GetAttribute("TrainingPrefabVersion") == 2,
	"TrainingGui is not managed by this installer"
)
assert(not oldTitle or oldTitle:GetAttribute("TrainingPrefabVersion") == 2, "Unmanaged TrainingUpgradeTemplate")
for _, name in ipairs({ "TrainingAnchor", "TrainingUpgradeAnchor" }) do
	assert(sourcePlot:FindFirstChild(name) and sourcePlot[name]:IsA("BasePart"), "Missing Plot_1 training anchor")
end
for _, plot in ipairs(plots:GetChildren()) do
	assert(plot:FindFirstChild("Ground") and plot.Ground:IsA("BasePart"), "Missing plot Ground")
end
local function make(class, parent, name, properties)
	local o = Instance.new(class)
	o.Name = name
	for key, value in pairs(properties or {}) do
		o[key] = value
	end
	o.Parent = parent
	return o
end
local function corner(o, radius)
	make("UICorner", o, "Corner", { CornerRadius = UDim.new(0, radius) })
end
local function stroke(o, thickness, contextual)
	return make("UIStroke", o, "Stroke", {
		Thickness = thickness,
		Color = Color3.new(),
		ApplyStrokeMode = if contextual then Enum.ApplyStrokeMode.Contextual else Enum.ApplyStrokeMode.Border,
	})
end
local function gradient(o, a, b)
	return make(
		"UIGradient",
		o,
		"Gradient",
		{ Color = ColorSequence.new(Color3.fromRGB(unpack(a)), Color3.fromRGB(unpack(b))), Rotation = 90 }
	)
end
local function text(parent, name, value, size, pos, anchor, color, thickness)
	local o = make("TextLabel", parent, name, {
		Text = value,
		Font = Enum.Font.FredokaOne,
		TextScaled = true,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = size or UDim2.fromScale(1, 1),
		Position = pos or UDim2.new(),
		AnchorPoint = anchor or Vector2.zero,
		TextColor3 = color or Color3.new(1, 1, 1),
		ZIndex = 10,
	})
	stroke(o, thickness or 3, true)
	return o
end
local blue, yellow = Color3.fromRGB(96, 205, 255), Color3.fromRGB(255, 220, 90)
local gui = make("ScreenGui", nil, "TrainingGui", {
	Enabled = false,
	ResetOnSpawn = false,
	IgnoreGuiInset = false,
	DisplayOrder = 30,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})
gui:SetAttribute("TrainingPrefabVersion", 2)
local bar = make("Frame", gui, "XPBar", {
	Size = UDim2.new(0.46, 0, 0, 44),
	Position = UDim2.fromScale(0.5, 0.965),
	AnchorPoint = Vector2.new(0.5, 1),
	BackgroundColor3 = Color3.fromRGB(42, 82, 18),
	BorderSizePixel = 0,
})
corner(bar, 12)
stroke(bar, 2)
make("UIScale", bar, "PulseScale", { Scale = 1 })
local track = make("Frame", bar, "Track", {
	Size = UDim2.new(1, -10, 1, -10),
	Position = UDim2.fromOffset(5, 5),
	BackgroundColor3 = Color3.fromRGB(66, 118, 28),
	BorderSizePixel = 0,
	ZIndex = 2,
})
corner(track, 9)
gradient(track, { 76, 134, 32 }, { 54, 100, 22 })
make("UIScale", track, "PulseScale", { Scale = 1 })
local stripes = make("Frame", track, "Stripes", {
	Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = Color3.new(1, 1, 1),
	BackgroundTransparency = 0.94,
	BorderSizePixel = 0,
	ZIndex = 3,
})
corner(stripes, 9)
local keys = {}
for i = 0, 9 do
	local value = if i % 2 == 0 then 1 else 0
	table.insert(keys, NumberSequenceKeypoint.new(i / 10, value))
	table.insert(keys, NumberSequenceKeypoint.new((i + 1) / 10 - 0.001, value))
end
keys[#keys] = NumberSequenceKeypoint.new(1, 0)
make("UIGradient", stripes, "Gradient", { Rotation = 30, Transparency = NumberSequence.new(keys) })
local fill = make("Frame", track, "Fill", {
	Size = UDim2.fromScale(0, 1),
	BackgroundColor3 = Color3.fromRGB(60, 170, 255),
	BorderSizePixel = 0,
	ZIndex = 4,
	ClipsDescendants = true,
})
corner(fill, 9)
stroke(fill, 3)
gradient(fill, { 96, 205, 255 }, { 28, 132, 235 })
local shine = make("Frame", fill, "Shine", {
	Size = UDim2.fromScale(1, 0.45),
	BackgroundColor3 = Color3.new(1, 1, 1),
	BackgroundTransparency = 0.75,
	BorderSizePixel = 0,
	ZIndex = 5,
})
corner(shine, 9)
make("UIGradient", shine, "Gradient", { Rotation = 90, Transparency = NumberSequence.new(0.2, 1) })
local level =
	text(bar, "LevelLabel", "Level 1", UDim2.fromScale(0.4, 0.66), UDim2.fromScale(0.022, 0.5), Vector2.new(0, 0.5))
level.TextXAlignment = Enum.TextXAlignment.Left
local xp = text(bar, "XPLabel", "0/20", UDim2.fromScale(0.5, 0.66), UDim2.fromScale(0.982, 0.5), Vector2.new(1, 0.5))
xp.TextXAlignment = Enum.TextXAlignment.Right
local stop = make("TextButton", gui, "StopButton", {
	Visible = true,
	Active = true,
	Interactable = true,
	Selectable = true,
	Text = "STOP",
	Size = UDim2.fromScale(0.11, 0.065),
	Position = UDim2.fromScale(0.5, 0.86),
	AnchorPoint = Vector2.new(0.5, 1),
	BackgroundColor3 = Color3.new(1, 1, 1),
	BorderSizePixel = 0,
	Font = Enum.Font.FredokaOne,
	TextScaled = true,
	TextColor3 = Color3.new(1, 1, 1),
	ZIndex = 10,
})
corner(stop, 8)
stroke(stop, 3)
-- Separate text preserves the reference button's padding.
stop.Text = ""
text(stop, "Label", "STOP", UDim2.fromScale(0.86, 0.7), UDim2.fromScale(0.5, 0.5), Vector2.new(0.5, 0.5))
gradient(stop, { 250, 75, 75 }, { 195, 22, 22 })
local info = make("Frame", gui, "Info", {
	Visible = false,
	BackgroundTransparency = 1,
	Size = UDim2.fromOffset(620, 88),
	Position = UDim2.new(0.5, 0, 0.86, -60),
	AnchorPoint = Vector2.new(0.5, 1),
})
text(info, "WeightLabel", "Max Catch: 10kg  ·  Next: 11.5kg", UDim2.new(1, 0, 0, 26), nil, nil, blue)
text(info, "RateLabel", "Barbell 01 · +2 XP / sec", UDim2.new(1, 0, 0, 22), UDim2.fromOffset(0, 28))
local rule = text(
	info,
	"RuleLabel",
	"Fish grow in steps up to your limit.\nOverweight fish shrink to the limit.",
	UDim2.new(1, 0, 0, 34),
	UDim2.fromOffset(0, 54),
	nil,
	Color3.fromRGB(210, 235, 255),
	2
)
rule.TextWrapped = true
make("Frame", gui, "Effects", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 60 })
local templates = make("Folder", gui, "Templates")
make("Attachment", templates, "UpgradeTitleAnchor")
local function popup(name, value, width, height, color)
	local board = make("BillboardGui", templates, name, {
		Enabled = false,
		Size = UDim2.fromScale(width, height),
		LightInfluence = 0,
		MaxDistance = 400,
		AlwaysOnTop = false,
	})
	local label = text(board, "Text", value, nil, nil, nil, color)
	make("UIScale", label, "PulseScale", { Scale = 1 })
	return label
end
popup("XpPopup", "+1 XP", 3.2, 0.85, blue)
local levelPopup = popup("LevelPopup", "LEVEL UP!", 6.8, 1.7, Color3.new(1, 1, 1))
gradient(levelPopup, { 255, 220, 90 }, { 240, 160, 20 })
popup("WeightPopup", "Max Catch +1.5kg", 5.2, 0.9, blue)
local confetti = make("Frame", templates, "ConfettiPiece", {
	Visible = false,
	Size = UDim2.fromOffset(10, 10),
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = yellow,
	BorderSizePixel = 0,
	ZIndex = 60,
})
corner(confetti, 3)
make("ProximityPrompt", templates, "UpgradePrompt", {
	ActionText = "Upgrade",
	ObjectText = "Training",
	Style = Enum.ProximityPromptStyle.Custom,
	HoldDuration = 0,
	MaxActivationDistance = 9,
	RequiresLineOfSight = false,
	Enabled = false,
	Exclusivity = Enum.ProximityPromptExclusivity.OnePerButton,
})

local title = make("BillboardGui", nil, "TrainingUpgradeTemplate", {
	Enabled = false,
	Size = UDim2.fromScale(7.5, 3.4),
	StudsOffsetWorldSpace = Vector3.new(0, 5.2, 0),
	MaxDistance = 90,
	LightInfluence = 0,
	AlwaysOnTop = false,
	ResetOnSpawn = false,
})
title:SetAttribute("TrainingPrefabVersion", 2)
local holder = make("Frame", title, "Holder", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) })
local priceHolder = make("Frame", holder, "PriceHolder", {
	BackgroundTransparency = 1,
	Size = UDim2.fromScale(1, 0.46),
	Position = UDim2.fromScale(0.5, 0.42),
	AnchorPoint = Vector2.new(0.5, 0.5),
	ZIndex = 2,
})
make("UIScale", priceHolder, "BreathScale", { Scale = 1 })
local price = text(priceHolder, "Price", "$1K", nil, nil, nil, nil, 4)
gradient(price, { 152, 246, 72 }, { 98, 204, 34 })
make("UIScale", price, "PulseScale", { Scale = 1 })
local rate =
	text(holder, "Xp", "+2 XP / rep", UDim2.fromScale(1, 0.22), UDim2.fromScale(0.5, 0.79), Vector2.new(0.5, 0.5), blue)
rate.RichText = true
text(holder, "Arrow", "▼", UDim2.fromScale(0.18, 0.2), UDim2.fromScale(0.5, 1.02), Vector2.new(0.5, 0.5), yellow)
if old then
	old:Destroy()
end
if oldTitle then
	oldTitle:Destroy()
end
gui.Parent, title.Parent = StarterGui, titles
local installed = {}
for _, plot in ipairs(plots:GetChildren()) do
	for _, name in ipairs({ "TrainingAnchor", "TrainingUpgradeAnchor" }) do
		if not plot:FindFirstChild(name) then
			local source = sourcePlot[name]
			local clone = source:Clone()
			clone.CFrame = plot.Ground.CFrame * sourcePlot.Ground.CFrame:ToObjectSpace(source.CFrame)
			clone.Parent = plot
			table.insert(installed, clone:GetFullName())
		end
	end
end
return { prefab = gui:GetFullName(), upgrade = title:GetFullName(), version = 2, anchors = installed }
