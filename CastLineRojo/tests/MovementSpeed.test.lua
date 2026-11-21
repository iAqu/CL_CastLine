local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

for _, path in {
	"src/ReplicatedStorage/Modules/MovementSpeedUtil.lua",
	"src/ServerScriptService/Services/MovementSpeedService.lua",
} do
	assert(io.open(path, "r") == nil, path .. " must be removed so Roblox initializes the configured speed")
end

local characterController = read("src/StarterPlayer/StarterPlayerScripts/Controllers/CharacterController.lua")
for _, removed in { "MovementSpeedUtil", "updateMovementSpeed", "UpdateMoveSpeed", "ZoneWalkSpeedPercent", ".WalkSpeed" } do
	assert(not characterController:find(removed, 1, true), "Character initialization must not override StarterPlayer speed: " .. removed)
end

local zonesData = assert(loadstring(read("src/ReplicatedFirst/Data/ZonesData.lua")))()
for _, zone in zonesData do
	assert(zone.RequiredWalkSpeed == nil and zone.WalkSpeedPercent == nil, "Zone data must no longer configure movement speed")
end

for _, path in {
	"src/ServerScriptService/Services/EventFishService.lua",
	"src/StarterPlayer/StarterPlayerScripts/Controllers/EventFishController.lua",
} do
	assert(not read(path):find("GetMoveSpeedMultiplier", 1, true), "Events must not expose movement speed multipliers")
end

print("MovementSpeed.test.lua passed")
