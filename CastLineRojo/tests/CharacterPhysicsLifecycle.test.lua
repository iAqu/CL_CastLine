local function read(path)
	local file = assert(io.open(path, "r"))
	local content = file:read("*a")
	file:close()
	return content
end

local characterController = read("src/StarterPlayer/StarterPlayerScripts/Controllers/CharacterController.lua")
local characterUtil = read("src/ReplicatedStorage/Modules/CharacterUtil.lua")
local constants = read("src/ReplicatedStorage/Modules/Constants.lua")

assert(constants:find("HRP_DENSITY = 2", 1, true), "Character weight must keep AF's HRP density")
assert(
	characterController:find("local function makeCharacterBodyPartsMassless(character: Model)", 1, true),
	"Character physics must centralize body mass configuration"
)
assert(
	characterController:find('child:IsA("BasePart") and child.Name ~= "HumanoidRootPart"', 1, true),
	"Only non-HRP body parts must become massless"
)
assert(characterController:find("child.Massless = true", 1, true), "Non-HRP body parts must be massless")
assert(
	characterController:find("local function configureCharacterPhysics(character: Model)", 1, true),
	"Character physics needs a shared lifecycle initializer"
)
assert(
	characterController:find("monitorCharacterDensity(character)", 1, true),
	"Character physics must maintain HRP density"
)
assert(
	characterController:find("CharacterUtil.MakeCharacterStable(character)", 1, true),
	"Character physics must reuse the shared stability helper"
)
assert(
	characterController:find("localPlayer.CharacterAdded:Connect(function(character: Model)", 1, true)
		and characterController:find("task.spawn(configureCharacterPhysics, character)", 1, true),
	"CharacterAdded must configure the newly spawned character"
)
assert(
	characterController:find("localPlayer.CharacterAppearanceLoaded:Connect(function(character: Model)", 1, true)
		and characterController:find("task.defer(configureCharacterPhysics, character)", 1, true),
	"CharacterAppearanceLoaded must refresh character physics"
)
assert(
	characterController:find("task.spawn(configureCharacterPhysics, localPlayer.Character)", 1, true),
	"An already spawned character must be configured"
)
assert(
	characterUtil:find("humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)", 1, true)
		and characterUtil:find("humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)", 1, true),
	"The stability helper must disable normal ragdoll and falling states"
)
assert(characterUtil:find('bodyGyro.Name = "StableBodyGyro"', 1, true), "The stability helper must maintain an upright gyro")

print("CharacterPhysicsLifecycle.test.lua passed")
