local FishingSpotUtil = require(script.Parent.FishingSpotUtil)
local PlotWorkspaceUtil = require(script.Parent.PlotWorkspaceUtil)
local Config = require(script.Parent.TrainingConfig)
local Spot = {}

local function towardGround(plot, position)
	local ground = plot:FindFirstChild("Ground")
	local direction = if ground then ground.Position - position else Vector3.zAxis
	direction = Vector3.new(direction.X, 0, direction.Z)
	return if direction.Magnitude < 0.01 then Vector3.zAxis else direction.Unit
end

local function horizontalForward(plot, frame)
	local forward = frame.LookVector
	local direction = Vector3.new(forward.X, 0, forward.Z)
	return if direction.Magnitude < 0.01 then towardGround(plot, frame.Position) else direction.Unit
end

function Spot.MarkerCFrame(plot)
	local anchor = plot.TrainingAnchor
	local height = math.min(anchor.Size.X, anchor.Size.Y, anchor.Size.Z) / 2 + 0.05
	local position = anchor.Position + Vector3.yAxis * height
	return CFrame.lookAt(position, position + horizontalForward(plot, anchor.CFrame))
end

function Spot.Contains(anchor, root, humanoid)
	if not anchor or not anchor:IsA("BasePart") then
		return false
	end
	local feet = root.Position - Vector3.yAxis * FishingSpotUtil.GetFootHeight(root, humanoid)
	local point = anchor.CFrame:PointToObjectSpace(feet)
	local size = anchor.Size
	-- The supplied markers have local X as their thin, vertical dimension.
	local thin = math.min(size.X, size.Y, size.Z)
	for _, axis in ipairs({ "X", "Y", "Z" }) do
		local limit = if size[axis] == thin then Config.FootTolerance else size[axis] * 0.5 + 0.35
		if math.abs(point[axis]) > limit then
			return false
		end
	end
	return true
end

function Spot.SpawnCFrame(plot, character)
	local anchor = plot and plot:FindFirstChild("TrainingAnchor")
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not anchor or not anchor:IsA("BasePart") or not root or not humanoid then
		return nil
	end
	local position = anchor.Position + Vector3.yAxis * (FishingSpotUtil.GetFootHeight(root, humanoid) + 0.1)
	local direction = horizontalForward(plot, anchor.CFrame)
	return CFrame.lookAt(position, position + direction)
end

local function getExitAnchorFrame(plot, trainingAnchor)
	local templatePlot = PlotWorkspaceUtil.getPlotBySlot(1)
	local exitAnchor = templatePlot and templatePlot:FindFirstChild("TrainingExitAnchor")
	if not exitAnchor or not exitAnchor:IsA("BasePart") then
		return nil
	end
	if plot == templatePlot then
		return exitAnchor.CFrame
	end
	local templateTraining = templatePlot:FindFirstChild("TrainingAnchor")
	if not templateTraining or not templateTraining:IsA("BasePart") then
		return nil
	end
	local offset = templateTraining.CFrame:ToObjectSpace(exitAnchor.CFrame)
	return trainingAnchor.CFrame:ToWorldSpace(offset)
end

function Spot.ExitCFrame(plot, character)
	local anchor = plot and plot:FindFirstChild("TrainingAnchor")
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not anchor or not anchor:IsA("BasePart") or not root or not humanoid then
		return nil
	end
	local footHeight = FishingSpotUtil.GetFootHeight(root, humanoid)
	local exitFrame = getExitAnchorFrame(plot, anchor)
	if exitFrame then
		local position = exitFrame.Position + Vector3.yAxis * (footHeight + 0.1)
		return CFrame.lookAt(position, position + horizontalForward(plot, exitFrame))
	end
	local outward = -towardGround(plot, anchor.Position)
	local localDirection = anchor.CFrame:VectorToObjectSpace(outward)
	local size = anchor.Size
	local extent = math.abs(localDirection.X) * size.X / 2
		+ math.abs(localDirection.Y) * size.Y / 2
		+ math.abs(localDirection.Z) * size.Z / 2
	local candidate = anchor.Position + outward * (extent + 2.5)
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = { character }
	params.IgnoreWater, params.RespectCanCollide = true, true
	local hit = workspace:Raycast(candidate + Vector3.yAxis * 8, -Vector3.yAxis * 24, params)
	if hit and hit.Normal.Y >= 0.7 and math.abs(hit.Position.Y - anchor.Position.Y) <= 3 then
		local height = footHeight + root.Size.Y / 2 + 1
		local overlap = OverlapParams.new()
		overlap.FilterType, overlap.FilterDescendantsInstances = Enum.RaycastFilterType.Exclude, { character }
		overlap.RespectCanCollide = true
		local space = workspace:GetPartBoundsInBox(
			CFrame.new(hit.Position + Vector3.yAxis * (height / 2 + 0.2)),
			Vector3.new(math.max(2, root.Size.X), height - 0.2, math.max(2, root.Size.Z)),
			overlap
		)
		local position = hit.Position + Vector3.yAxis * (footHeight + 0.1)
		local probe = { Position = position, Size = root.Size, Parent = root.Parent }
		if #space == 0 and not Spot.Contains(anchor, probe, humanoid) then
			return CFrame.lookAt(position, position + outward)
		end
	end
	local spawn = plot:FindFirstChild("AreaSpawnPoint")
	return if spawn and spawn:IsA("BasePart") then spawn.CFrame else nil
end

return Spot
