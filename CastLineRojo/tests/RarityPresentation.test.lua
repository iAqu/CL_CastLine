local createHarness = require("./helpers/RarityHarness")
local sources = {}
for _, name in ipairs({ "RarityConfig", "RarityPresentation", "GuiUtil" }) do
	local file = assert(io.open("src/ReplicatedStorage/Modules/" .. name .. ".lua", "r"))
	sources[name] = file:read("*a")
	file:close()
end
local h = createHarness(sources)
local config = h.load("RarityConfig")
assert(config.Get("Secret").Color == nil and config.Get("Secret").Gradient == nil,
	"Gameplay metadata must not keep a second palette")
local presentation = h.load("RarityPresentation")
local gui = h.load("GuiUtil")
local gradients = h.addRarityTemplates()
for _, entry in ipairs(config.List) do
	local template = assert(presentation.GetTemplate(entry.Name))
	assert(presentation.GetColor(entry.Name) == template.Color.Keypoints[2].Value)
end
assert(presentation.GetTemplate("Mythic") == presentation.GetTemplate("Mythical"))
assert(presentation.GetTemplate("Mythic").Name == "UIGradient_Mythical")

local secret = presentation.GetTemplate("Secret")
secret.Offset, secret.Transparency = "authored offset", "authored transparency"
-- Non-uniform times ensure the midpoint interpolates the enclosing points, not endpoints.
secret.Color = h.sequence({ { Time = 0, Value = h.colors.new(0, 0, 0) },
	{ Time = 0.2, Value = h.colors.new(1, 0, 0) },
	{ Time = 0.6, Value = h.colors.new(0, 0, 1) },
	{ Time = 1, Value = h.colors.new(0, 1, 0) } })
assert(presentation.GetColor("Secret") == h.colors.new(0.25, 0, 0.75))
assert(gui.GetRarityGradientColor("Secret") == presentation.GetColor("Secret"))
local button = h.newInstance("TextButton")
local child = h.newInstance("TextLabel")
child.Parent = button
local priceGradient = h.newInstance("UIGradient")
priceGradient.Parent = child
for _ = 1, 3 do
	gui.SetRarityGradient(button, "Secret")
	assert(#button:GetChildren() == 2, "Reapplying must replace the previous gradient")
	local applied = assert(button:FindFirstChild("UIGradient_Secret"))
	assert(applied ~= secret and applied.Enabled and not secret.Enabled)
	assert(applied.Color == secret.Color and applied.Rotation == secret.Rotation)
	assert(applied.Offset == secret.Offset and applied.Transparency == secret.Transparency)
	assert(priceGradient.Parent == child, "Do not clear child-label gradients")
end
secret.Color = h.sequence({ { Time = 0, Value = h.colors.new(0, 1, 0) },
	{ Time = 1, Value = h.colors.new(0, 1, 0) } })
assert(presentation.GetColor("Secret") == h.colors.new(0, 1, 0), "Do not cache stale template colors")
gui.SetRarityGradient(button, "Secret")
assert(button:FindFirstChild("UIGradient_Secret").Color == secret.Color)
assert(#h.warnings == 0)

local common = assert(presentation.GetTemplate("Common"))
assert(presentation.GetTemplate("missing") == common)
assert(presentation.GetTemplate("missing") == common and #h.warnings == 1)
secret:Destroy()
assert(presentation.GetTemplate("Secret") == common)
assert(presentation.GetTemplate("Secret") == common and #h.warnings == 2)
local invalid = h.newInstance("Folder")
invalid.Name, invalid.Parent = "UIGradient_Secret", gradients
assert(presentation.GetTemplate("Secret") == common and #h.warnings == 2)
common:Destroy()
assert(presentation.GetTemplate("Common") == nil)
assert(presentation.GetColor("Common") == h.colors.new(1, 1, 1))
assert(#h.warnings == 3)
gui.SetRarityGradient(button, "Common")
assert(button:FindFirstChild("UIGradient_Secret") == nil and #button:GetChildren() == 1)
assert(gui.GetRarityGradientColor(nil) == nil)
gui.SetRarityGradient(button, nil)
assert(#button:GetChildren() == 1 and #h.warnings == 3)
gradients.Parent:Destroy()
assert(presentation.GetColor("Common") == h.colors.new(1, 1, 1))
