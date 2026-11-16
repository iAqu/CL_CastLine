-- Run in Studio Edit mode; preserve the artist-authored slot layout.
local templates = assert(game:GetService("StarterGui"):FindFirstChild("_GuiTemplates"), "GUI templates missing")
local slot = assert(templates:FindFirstChild("BackpackSlot"), "BackpackSlot missing")
for _, label in ipairs(slot:GetDescendants()) do
	if label:IsA("TextLabel") then
		label.Visible = label == slot:FindFirstChild("CpsLabel") or label == slot:FindFirstChild("Number")
	end
end
local toolName = slot:FindFirstChild("ToolName")
if not toolName then
	toolName = Instance.new("TextLabel")
	toolName.Name = "ToolName"
	toolName.BackgroundTransparency = 1
	toolName.Size = UDim2.fromScale(1, 1)
	toolName.Text = ""
	toolName.Parent = slot
end
toolName.Visible = false
slot:SetAttribute("MinimalSlotLabels", true)
slot.Icon.ImageColor3 = Color3.new(1, 1, 1)
local gradient = slot.Icon:FindFirstChild("BackpackMutationRainbowGradient")
if gradient then
	gradient:Destroy()
end
