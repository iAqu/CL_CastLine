local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Constants = require(ReplicatedStorage.Modules.Constants)
local FarmWorkspaceUtil = require(script.Parent.FarmWorkspaceUtil)
local PlotWorkspaceUtil = require(script.Parent.PlotWorkspaceUtil)

local HOME_AREA_ID = Constants.AREA_NAME.Area_1

local AreasWorkspace = {}

function AreasWorkspace.root(): Instance
	return Workspace:WaitForChild("Areas")
end

function AreasWorkspace.isHomeAreaId(areaId: string?): boolean
	return areaId == HOME_AREA_ID
end

function AreasWorkspace.getAreaRoot(areaId: string?): Instance?
	if not areaId or areaId == "" then
		return nil
	end

	local root = AreasWorkspace.root()
	if AreasWorkspace.isHomeAreaId(areaId) then
		return root
	end

	return root:FindFirstChild(areaId)
end

function AreasWorkspace.findChildForArea(areaId: string?, childName: string): Instance?
	local areaRoot = AreasWorkspace.getAreaRoot(areaId)
	if not areaRoot then
		return nil
	end
	return areaRoot:FindFirstChild(childName)
end

function AreasWorkspace.forEachAreaContext(callback: (areaRoot: Instance, areaId: string) -> ())
	local root = AreasWorkspace.root()
	callback(root, HOME_AREA_ID)

	for _, child in root:GetChildren() do
		if child.Name:match("^Area_") and (child:IsA("Folder") or child:IsA("Model")) then
			callback(child, child.Name)
		end
	end
end

local CACHE_TTL_SEC = 1.0
local farmListCache: { key: string, list: { Instance }, t: number }? = nil

local function getCachedOrCompute(cacheKey: string, compute: () -> { Instance }): { Instance }
	local now = tick()
	if farmListCache and farmListCache.key == cacheKey and farmListCache.list and (now - farmListCache.t) < CACHE_TTL_SEC then
		return farmListCache.list
	end
	local list = compute()
	farmListCache = { key = cacheKey, list = list, t = now }
	return list
end

-- areaId：如 "Area_1"。Home 区域内容在 Areas 根下；其他区域在 Areas[areaId] 动态 Model 下。
function AreasWorkspace.getSortedFarmsForAreaContext(areaId: string?): { Instance }
	local root = AreasWorkspace.root()
	local cacheKey = (areaId and areaId ~= "") and ("af:" .. areaId) or "af:root"
	return getCachedOrCompute(cacheKey, function()
		if areaId and areaId ~= "" then
			local areaRoot = AreasWorkspace.getAreaRoot(areaId)
			if areaRoot then
				local nested = FarmWorkspaceUtil.collectSortedValidFarmsUnderParent(areaRoot)
				if #nested > 0 then
					return nested
				end
			end
		end
		return FarmWorkspaceUtil.collectSortedValidFarmsUnderParent(root)
	end)
end

function AreasWorkspace.getSortedPlots(): { Instance }
	return PlotWorkspaceUtil.getSortedPlots()
end

return AreasWorkspace
