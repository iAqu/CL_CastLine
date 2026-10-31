local function read(path: string): string
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local farmWorkspaceUtil = read("src/ReplicatedStorage/Modules/FarmWorkspaceUtil.lua")
assert(
	farmWorkspaceUtil:find("function FarmWorkspaceUtil.resolvePlate", 1, true),
	"FarmWorkspaceUtil must expose the Plate resolver"
)
assert(
	farmWorkspaceUtil:find("function FarmWorkspaceUtil.getPlatePivot", 1, true),
	"FarmWorkspaceUtil must expose the Plate Pivot resolver"
)
assert(
	not farmWorkspaceUtil:find("AreaSpawnPoint", 1, true),
	"Farm slot discovery must not depend on AreaSpawnPoint"
)

local farmSlotService = read("src/ServerScriptService/Services/FarmSlotService.lua")
assert(
	farmSlotService:find('local FARM_INITIALIZED_ATTRIBUTE = "FarmInitialized"', 1, true),
	"FarmSlotService must publish the FarmInitialized lifecycle attribute"
)
assert(
	farmSlotService:find("sourcePlate:GetPivot():ToObjectSpace(clone:GetPivot())", 1, true),
	"FarmTemplate placement must preserve the template-root transform relative to its Plate"
)
assert(
	farmSlotService:find("sourcePlate:Destroy()", 1, true),
	"FarmTemplate's cloned Plate must be removed before unpacking"
)
assert(
	farmSlotService:find("self:_resetFarmContent(farm)", 1, true),
	"Released farms must return to Plate-only state"
)

local farmGateController = read("src/StarterPlayer/StarterPlayerScripts/Controllers/FarmGateController.lua")
assert(
	farmGateController:find("farm.ChildAdded:Connect", 1, true),
	"FarmGateController must bind Zones added by dynamic farm initialization"
)
assert(
	farmGateController:find("unbindZonesForFarm", 1, true),
	"FarmGateController must clean up dynamic Zones bindings"
)

for _, path in ipairs({
	"src/ReplicatedStorage/Modules/FarmWorkspaceUtil.lua",
	"src/ReplicatedStorage/Modules/FriendVisitorPathUtil.lua",
	"src/ReplicatedStorage/Modules/PropPlacementConfig.lua",
	"src/ReplicatedStorage/Modules/PropPlacementUtil.lua",
	"src/ServerScriptService/Services/FarmSlotService.lua",
	"src/StarterPlayer/StarterPlayerScripts/Controllers/AnimalRollerController.lua",
	"src/StarterPlayer/StarterPlayerScripts/Controllers/AreaController.lua",
}) do
	assert(not read(path):find("BuildCenterPart", 1, true), path .. " must not use the retired farm anchor")
end

print("FarmPlateLifecycle.test.lua passed")
