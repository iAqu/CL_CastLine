local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local AreasWorkspace = require(script.Parent.AreasWorkspace)

local LOCAL_PLAYER = Players.LocalPlayer
local DEFAULT_AREA_NAME = "Area_1"
local FARM_SLOT_WAIT_TIMEOUT = 30

local FarmLocalUtil = {}

function FarmLocalUtil.waitForFarmSlotId(timeout: number): number?
	local slotId = LOCAL_PLAYER:GetAttribute("FarmSlotId")
	if type(slotId) == "number" then
		return slotId
	end

	local elapsed = 0
	while elapsed < timeout do
		elapsed += RunService.Heartbeat:Wait()
		slotId = LOCAL_PLAYER:GetAttribute("FarmSlotId")
		if type(slotId) == "number" then
			return slotId
		end
	end

	return nil
end

function FarmLocalUtil.getSortedFarmsForHomeArea(): { Instance }
	return AreasWorkspace.getSortedFarmsForAreaContext(DEFAULT_AREA_NAME)
end

function FarmLocalUtil.resolveLocalFarm(): Instance?
	local slotId = FarmLocalUtil.waitForFarmSlotId(FARM_SLOT_WAIT_TIMEOUT)
	local farms = FarmLocalUtil.getSortedFarmsForHomeArea()
	if #farms == 0 then
		return nil
	end

	for _, farm in ipairs(farms) do
		if farm:GetAttribute("OwnerUserId") == LOCAL_PLAYER.UserId then
			return farm
		end
	end

	if slotId and farms[slotId] then
		return farms[slotId]
	end

	return nil
end

function FarmLocalUtil.isLocalFarm(farm: Instance?): boolean
	if not farm then
		return false
	end

	local ownerUserId = farm:GetAttribute("OwnerUserId")
	if ownerUserId == LOCAL_PLAYER.UserId then
		return true
	end

	local slotId = LOCAL_PLAYER:GetAttribute("FarmSlotId")
	if type(slotId) ~= "number" then
		return false
	end

	local farms = FarmLocalUtil.getSortedFarmsForHomeArea()
	return farms[slotId] == farm
end

return FarmLocalUtil
