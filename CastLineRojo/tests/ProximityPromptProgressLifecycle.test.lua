local function read(path)
	local file = assert(io.open(path, "r"))
	local content = file:read("*a")
	file:close()
	return content
end

local controller = read("src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/ProximityPromptController.lua")

local progressRenderer = assert(
	controller:match("local function createProgressBarGradient.-local function clearInputIcons"),
	"Prompt progress renderer section must exist"
)
local circularProgressFactory = assert(
	controller:match("local function createCircularProgressBar.-local function clearInputIcons"),
	"Circular progress factory section must exist"
)
local holdLifecycle = assert(
	controller:match("local progressValue.-local function updateUIFromPrompt"),
	"Prompt hold lifecycle section must exist"
)
local cleanupLifecycle = assert(
	controller:match("local cleanedUp = false.-local function refreshActiveInputIcons"),
	"Prompt cleanup lifecycle section must exist"
)

assert(controller:find("local function renderProgress", 1, true), "Prompt progress needs an explicit renderer")
assert(controller:find("local function resetHoldProgress", 1, true), "Prompt progress needs one reset path")
assert(controller:find("local function startHoldDriver", 1, true), "Prompt progress needs one hold driver")
assert(controller:find("RunService.Heartbeat:Connect", 1, true), "Prompt progress must advance on Heartbeat")
assert(not controller:find("holdProgressTween", 1, true), "Prompt progress must not retain competing Tween writers")

assert(
	progressRenderer:find('imageLabel.Image = "rbxasset://textures/ui/Controls/RadialFill.png"', 1, true),
	"Circular progress must retain the original smooth radial texture"
)
assert(
	progressRenderer:find('local gradient = Instance.new("UIGradient")', 1, true),
	"Circular progress must retain the original smooth gradient mask"
)
assert(
	progressRenderer:find("imageLabel.ImageTransparency = 0", 1, true),
	"Radial images must stay rendered so the gradient mask stays warm"
)
assert(
	circularProgressFactory:find("renderProgress(0)", 1, true),
	"Gradient masks must be initialized to empty before mounting"
)
assert(
	not circularProgressFactory:find("setProgressVisible", 1, true),
	"Progress must not hide the radial images after they have rendered"
)
assert(
	not circularProgressFactory:find("CanvasGroup", 1, true),
	"Billboard CanvasGroup hides do not warm the radial gradient"
)
assert(
	not controller:find("ProximityPromptWarmup", 1, true),
	"Reparenting a ScreenGui-warmed ring into a BillboardGui resets the gradient"
)
assert(
	controller:find('billboard.Name = "PromptProgress"', 1, true),
	"The radial ring must live in one persistent BillboardGui"
)
assert(
	controller:find('part.Name = "ProximityPromptProgressWarmup"', 1, true),
	"The persistent ring must stay rendered on a hidden warmup adornee"
)
assert(
	controller:find("local function attachSharedProgress", 1, true),
	"Showing a hold prompt must retarget the persistent ring instead of recreating it"
)
assert(
	controller:find('screenGui.Name = "ProximityPromptProgress"', 1, true),
	"The persistent ring must draw above the text prompt BillboardGui"
)
assert(
	controller:find("progressBar.Parent = inputFrame", 1, true),
	"The ring must sit in the same input frame as the E key"
)
assert(
	not controller:find("PROGRESS_REVEAL_RENDER_STEPS", 1, true),
	"Hidden-frame reveal delays cannot warm a UIGradient"
)
assert(
	not holdLifecycle:find("ImageTransparency", 1, true),
	"Hold lifecycle must not toggle radial image transparency"
)
assert(
	holdLifecycle:find("progress.Value = nextProgress", 1, true),
	"Heartbeat must write the current hold progress"
)

assert(
	cleanupLifecycle:find("billboard.Enabled = false", 1, true),
	"A hidden prompt must leave the render tree synchronously"
)
assert(
	cleanupLifecycle:find("billboard.Parent = nil", 1, true),
	"A hidden prompt billboard must be unparented synchronously"
)
assert(
	not cleanupLifecycle:find("task.wait(0.2)", 1, true),
	"Old and new prompt billboards must never overlap during delayed cleanup"
)

assert(controller:find("progressValue.Value = 0", 1, true), "The shared reset path must return progress to zero")
assert(
	controller:find(
		"holdEndedConn = prompt.PromptButtonHoldEnded:Connect(function()\n\t\t\tresetHoldProgress()",
		1,
		true
	),
	"Releasing a prompt must reset progress"
)
assert(
	controller:find("local triggeredConn = prompt.Triggered:Connect(function()\n\t\tresetHoldProgress()", 1, true),
	"Triggering a prompt must reset progress"
)

print("ProximityPromptProgressLifecycle.test.lua passed")
