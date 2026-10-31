-- 客户端/服务端共用的 Farm 槽位识别与排序（须与 FarmSlotService 槽位逻辑一致）

local FarmWorkspaceUtil = {}

function FarmWorkspaceUtil.resolvePlate(farm: Instance): PVInstance?
	local plate = farm:FindFirstChild("Plate")
	if plate and plate:IsA("PVInstance") then
		return plate
	end
	return nil
end

function FarmWorkspaceUtil.getPlatePivot(farm: Instance): CFrame?
	local plate = FarmWorkspaceUtil.resolvePlate(farm)
	if plate then
		return plate:GetPivot()
	end
	return nil
end

function FarmWorkspaceUtil.resolvePlateRootPart(farm: Instance): BasePart?
	local plate = FarmWorkspaceUtil.resolvePlate(farm)
	if not plate then
		return nil
	end

	local rootPart = plate:FindFirstChild("RootPart")
	if rootPart and rootPart:IsA("BasePart") then
		return rootPart
	end
	return nil
end

-- 家园放置总边界只检查 Plate.RootPart 的局部 XZ；Y 高度不参与判断。
function FarmWorkspaceUtil.isPointInsidePlateXZ(farm: Instance, worldPosition: Vector3): boolean
	local rootPart = FarmWorkspaceUtil.resolvePlateRootPart(farm)
	if not rootPart then
		return false
	end

	local localPosition = rootPart.CFrame:PointToObjectSpace(worldPosition)
	return math.abs(localPosition.X) <= rootPart.Size.X * 0.5 and math.abs(localPosition.Z) <= rootPart.Size.Z * 0.5
end

function FarmWorkspaceUtil.isValidFarmContainer(instance: Instance): boolean
	if not instance.Name:match("^Farm_%d+$") then
		return false
	end
	if not (instance:IsA("Folder") or instance:IsA("Model")) then
		return false
	end
	return FarmWorkspaceUtil.resolvePlate(instance) ~= nil
end

local function getFarmAnchorPosition(farm: Instance): Vector3
	local platePivot = FarmWorkspaceUtil.getPlatePivot(farm)
	if platePivot then
		return platePivot.Position
	end
	return Vector3.zero
end

local function getFarmSlotIndex(farm: Instance): number?
	return tonumber(farm.Name:match("^Farm_(%d+)$"))
end

local function sortFarmsByAnchor(a: Instance, b: Instance): boolean
	local posA = getFarmAnchorPosition(a)
	local posB = getFarmAnchorPosition(b)
	if math.abs(posA.X - posB.X) > 0.001 then
		return posA.X < posB.X
	end
	if math.abs(posA.Z - posB.Z) > 0.001 then
		return posA.Z < posB.Z
	end
	return posA.Y < posB.Y
end

function FarmWorkspaceUtil.sortFarmsBySlotOrder(a: Instance, b: Instance): boolean
	local slotA = getFarmSlotIndex(a)
	local slotB = getFarmSlotIndex(b)
	if slotA and slotB then
		return slotA < slotB
	end
	if slotA then
		return true
	end
	if slotB then
		return false
	end
	return sortFarmsByAnchor(a, b)
end

-- 在 parent 下递归查找合法 Farm；遇到合法 Farm 不再向下钻（避免误扫子级）
local MAX_DEPTH_DEFAULT = 12

local function collectValidFarmsRecursive(parent: Instance, depth: number, maxDepth: number): { Instance }
	if depth > maxDepth then
		return {}
	end
	local out = {}
	for _, child in ipairs(parent:GetChildren()) do
		if FarmWorkspaceUtil.isValidFarmContainer(child) then
			table.insert(out, child)
		elseif child:IsA("Folder") or child:IsA("Model") then
			local sub = collectValidFarmsRecursive(child, depth + 1, maxDepth)
			for _, f in ipairs(sub) do
				table.insert(out, f)
			end
		end
	end
	return out
end

function FarmWorkspaceUtil.collectSortedValidFarmsUnderParent(parent: Instance, maxDepth: number?): { Instance }
	local depthLimit = maxDepth or MAX_DEPTH_DEFAULT
	local farms = collectValidFarmsRecursive(parent, 0, depthLimit)
	table.sort(farms, FarmWorkspaceUtil.sortFarmsBySlotOrder)
	return farms
end

return FarmWorkspaceUtil
