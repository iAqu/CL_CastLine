local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EggToolUtil = {}

function EggToolUtil.IsEggTool(tool)
	return tool ~= nil and tool:IsA("Tool") and tool:GetAttribute("InventoryKind") == "Egg"
end

function EggToolUtil.GetInstanceId(tool)
	return if EggToolUtil.IsEggTool(tool) then tool:GetAttribute("EggInstanceId") else nil
end

function EggToolUtil.GetTemplate(name)
	local models = ReplicatedStorage:FindFirstChild("Models")
	local folder = models and models:FindFirstChild("Eggs")
	local model = folder and folder:FindFirstChild(name)
	return if model and model:IsA("Model") and model.PrimaryPart then model else nil
end

function EggToolUtil.Create(uuid, config)
	local template = EggToolUtil.GetTemplate(config.Model or config.EggId)
	if not template then
		return nil
	end
	local tool = Instance.new("Tool")
	tool.Name = config.DisplayName or config.EggId
	tool.CanBeDropped = false
	tool:SetAttribute("InventoryKind", "Egg")
	tool:SetAttribute("EggInstanceId", uuid)
	tool:SetAttribute("EggId", config.EggId)
	tool:SetAttribute("DisplayName", tool.Name)
	if config.Icon and config.Icon ~= "nil" then
		tool.TextureId = config.Icon
	end
	local model = template:Clone()
	model.Name = "EggVisual"
	local size = model:GetExtentsSize()
	model:ScaleTo(model:GetScale() * math.min(1, 3 / math.max(size.X, size.Y, size.Z)))
	model:PivotTo(CFrame.new())
	local handle = Instance.new("Part")
	handle.Name, handle.Size, handle.Transparency = "Handle", Vector3.one * 0.2, 1
	handle.CanCollide, handle.CanTouch, handle.CanQuery, handle.Massless = false, false, false, true
	handle.Parent = tool
	for _, part in ipairs(model:GetDescendants()) do
		if part:IsA("BaseScript") then
			part:Destroy()
		elseif part:IsA("BasePart") then
			part.Anchored, part.CanCollide, part.CanTouch, part.CanQuery, part.Massless =
				false, false, false, false, true
			local weld = Instance.new("WeldConstraint")
			weld.Part0, weld.Part1, weld.Parent = handle, part, handle
		end
	end
	model.Parent = tool
	tool.Grip = CFrame.new(0, -0.5, -1)
	return tool
end

return EggToolUtil
