local PlotAppearance = {}
local GROUPS = { "Entrance", "FrontLeft", "FrontRight", "Back", "Left", "Right" }

function PlotAppearance.Preflight(plot: Instance, config)
	local ground = plot:FindFirstChild("Ground")
	local fence = plot:FindFirstChild("Fence")
	if not ground or not ground:IsA("BasePart") or not ground:GetAttribute("PlotBaseSize") or not fence then
		return false, "Your plot is not ready for upgrades."
	end
	for _, name in GROUPS do
		local group = fence:FindFirstChild(name)
		if not group or not group:FindFirstChild("Posts") or not group:FindFirstChild("Rails") then
			return false, "Your fence is not ready for upgrades."
		end
	end
	for _, part in fence:GetDescendants() do
		if part:IsA("BasePart") and not part:GetAttribute("ExtensionPost") then
			if
				typeof(part:GetAttribute("BaseLocalCFrame")) ~= "CFrame"
				or typeof(part:GetAttribute("BaseSize")) ~= "Vector3"
			then
				return false, "Fence layout data is missing."
			end
		end
	end
	if not config.PostColor:match("^#%x%x%x%x%x%x$") or not config.RailColor:match("^#%x%x%x%x%x%x$") then
		return false, "Fence colors are invalid."
	end
	return true
end

local function clearSparkles(part)
	local emitter = part:FindFirstChild("FenceSparkles")
	if emitter then
		emitter:Destroy()
	end
end

function PlotAppearance.ApplyLayout(plot: Instance, config)
	local ground = plot.Ground
	local baseSize = ground:GetAttribute("PlotBaseSize")
	local growth = (config.Width - baseSize.X) * 0.5
	local fence = plot.Fence
	for _, part in fence:GetDescendants() do
		if part:IsA("BasePart") and part:GetAttribute("ExtensionPost") then
			part:Destroy()
		end
	end
	local corners = {}
	for _, part in fence:GetDescendants() do
		if not part:IsA("BasePart") then
			continue
		end
		local base = part:GetAttribute("BaseLocalCFrame")
		local size = part:GetAttribute("BaseSize")
		local mode = part:GetAttribute("LayoutMode")
		local dx, extra = 0, 0
		if mode == "MoveLeft" then
			dx = -growth
		elseif mode == "MoveRight" then
			dx = growth
		elseif mode == "FrontLeftRail" then
			dx, extra = -growth * 0.5, growth
		elseif mode == "FrontRightRail" then
			dx, extra = growth * 0.5, growth
		elseif mode == "BackRail" then
			extra = growth * 2
		end
		part.CFrame = ground.CFrame * CFrame.new(dx, 0, 0) * base
		part.Size = size + Vector3.new(extra, 0, 0)
		if part:GetAttribute("FenceCorner") then
			table.insert(corners, part)
		end
	end
	for _, corner in corners do
		local sign = if corner:GetAttribute("LayoutMode") == "MoveLeft" then -1 else 1
		for index = 0, math.ceil(growth / 10) - 1 do
			local added = corner:Clone()
			added.Name = "ExtensionPost_" .. (if sign < 0 then "Left_" else "Right_") .. index
			added:SetAttribute("ExtensionPost", true)
			added:SetAttribute("FenceCorner", nil)
			clearSparkles(added)
			added.CFrame = ground.CFrame * CFrame.new(sign * index * 10, 0, 0) * corner:GetAttribute("BaseLocalCFrame")
			added.Parent = corner.Parent
		end
	end
	ground.Size = Vector3.new(config.Width, baseSize.Y, config.Depth)
	local plate = plot:FindFirstChild("3")
	if plate and plate:IsA("BasePart") then
		local plateSize = plate:GetAttribute("PlotBaseSize")
		if plateSize then
			plate.Size = Vector3.new(config.Depth, plateSize.Y, config.Width)
		end
	end
	local decorations = plot:FindFirstChild("Model")
	if decorations then
		for _, model in decorations:GetDescendants() do
			local base = model:GetAttribute("BaseLocalPivot")
			local side = model:GetAttribute("BoundarySide")
			if model:IsA("Model") and base and side then
				model:PivotTo(ground.CFrame * CFrame.new(side * growth, 0, 0) * base)
			end
		end
	end
end

function PlotAppearance.ApplyStyle(plot: Instance, config)
	for _, part in plot.Fence:GetDescendants() do
		if not part:IsA("BasePart") then
			continue
		end
		part.Color =
			Color3.fromHex(if part:GetAttribute("FenceRole") == "Rail" then config.RailColor else config.PostColor)
		part.Reflectance = config.Reflectance
		clearSparkles(part)
		if part:GetAttribute("FenceCorner") and config.SparkleColorA and config.SparkleColorB then
			local emitter = Instance.new("ParticleEmitter")
			emitter.Name = "FenceSparkles"
			emitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
			emitter.Color =
				ColorSequence.new(Color3.fromHex(config.SparkleColorA), Color3.fromHex(config.SparkleColorB))
			emitter.LightEmission = 1
			emitter.Size = NumberSequence.new(0.3)
			emitter.Lifetime = NumberRange.new(0.6, 1.1)
			emitter.Speed = NumberRange.new(0.5, 1.5)
			emitter.Rate = 2
			emitter.Parent = part
		end
	end
end

function PlotAppearance.Apply(plot: Instance, config)
	local ok, message = PlotAppearance.Preflight(plot, config)
	assert(ok, message)
	-- Changing only the skin must not rebuild posts or touch fish boundaries.
	if plot:GetAttribute("PlotWidth") ~= config.Width or plot:GetAttribute("PlotDepth") ~= config.Depth then
		PlotAppearance.ApplyLayout(plot, config)
	end
	PlotAppearance.ApplyStyle(plot, config)
	plot:SetAttribute("PlotWidth", config.Width)
	plot:SetAttribute("PlotDepth", config.Depth)
	plot:SetAttribute("PlotUpgradeLevel", config.Level)
	plot:SetAttribute("PlotCapacity", config.Capacity)
end

return PlotAppearance
