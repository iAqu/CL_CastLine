local function read(path: string): string
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local permissions = read("src/ServerScriptService/Cmdr/Hooks/Permission.lua")

assert(not io.open("src/ServerScriptService/Cmdr/Commands/SetMoveSpeedLevel.lua", "r"), "Do not register the retired speed command")
assert(not io.open("src/ServerScriptService/Cmdr/Commands/SetMoveSpeedLevelServer.lua", "r"), "Remove the retired speed command handler")
assert(not permissions:find('"setMoveSpeedLevel"', 1, true), "Remove the retired command permission")
assert(not io.open("src/ServerScriptService/Cmdr/Commands/SetBackpackLevel.lua", "r"), "Do not register the retired backpack command")
print("CmdrUpgradeLevel.test.lua passed")
