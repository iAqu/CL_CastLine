local files = {
	"src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/EggHatchGuiController.lua",
	"src/StarterPlayer/StarterPlayerScripts/Controllers/GiftBoxController.lua",
	"src/StarterPlayer/StarterPlayerScripts/Controllers/PlayerAnimController.lua",
	"src/StarterPlayer/StarterPlayerScripts/Controllers/PetFollowController.lua",
}

for _, path in ipairs(files) do
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()

	local waitForAnimation = source:find(":WaitForChild%([\"']Animation[\"']%)")
	local directAnimation = source:find("ReplicatedStorage%.Animation%.")
	assert(waitForAnimation and (not directAnimation or waitForAnimation < directAnimation), path .. " should wait for ReplicatedStorage.Animation before top-level animation references")
end

print("StarterPlayerAnimationLoadOrder.test.lua passed")
