-- Run in Studio Edit mode. GUI instances belong to Studio; Rojo supplies only scripts.
local starterGui = game:GetService("StarterGui")
local gui = assert(starterGui:FindFirstChild("IndexGui_New"), "IndexGui_New is missing")
local petButton = gui.Frame.MainFrame.PetsFrame.PetTemplate.PetButton
local scale = petButton:FindFirstChildOfClass("UIScale")
if not scale then
	scale = Instance.new("UIScale")
	scale.Parent = petButton
end
scale.Scale = 1
local background = gui.Frame.MainFrame.DetailFrame.ClaimButton.BG
for _, child in ipairs(background:GetChildren()) do
	if child:IsA("UIGradient") then
		local color = child.Color.Keypoints[1].Value
		local grey = math.abs(color.R - color.G) < 0.01 and math.abs(color.G - color.B) < 0.01
		child.Name = if grey then "DisabledGradient" else "ClaimableGradient"
		child.Enabled = not grey
	end
end
assert(background:FindFirstChild("ClaimableGradient"), "Gold claim gradient is missing")
assert(background:FindFirstChild("DisabledGradient"), "Grey claim gradient is missing")
gui.Enabled = false
gui.Frame.MainFrame.PetsFrame.PetTemplate.Visible = false
local oldGui = starterGui:FindFirstChild("IndexGui")
if oldGui then
	oldGui.Enabled = false
end
