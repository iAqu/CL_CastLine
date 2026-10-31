local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local function exists(path)
	local file = io.open(path, "r")
	if not file then
		return false
	end
	file:close()
	return true
end

local randomPotion = read("src/ServerScriptService/Services/RandomPotionService.lua")
local rebirth = read("src/ServerScriptService/Services/RebirthService.lua")
local debugRebirth = read("src/ServerScriptService/Cmdr/Commands/DebugRebirth.lua")
local debugRebirthServer = read("src/ServerScriptService/Cmdr/Commands/DebugRebirthServer.lua")
local codes = read("src/ServerScriptService/Services/CodesService.lua")
local soundHelper = read("src/ReplicatedStorage/Modules/SoundHelper.lua")
local gameOperation = read("src/ServerScriptService/Services/GameOperationService.lua")

local validationStart = assert(randomPotion:find("local function isValidPurchaseCount", 1, true))
local chargeStart = assert(randomPotion:find("local totalPrice", validationStart, true))
assert(validationStart < chargeStart, "Random Potion must validate quantity before calculating or charging its price")
assert(randomPotion:find("buyNum > 0", validationStart, true), "Random Potion must reject non-positive quantities")
assert(randomPotion:find("buyNum % 1 == 0", validationStart, true), "Random Potion must require whole purchase quantities")
assert(randomPotion:find("buyNum ~= math.huge", validationStart, true), "Random Potion must reject non-finite quantities")
assert(randomPotion:find("buyNum > remainingPurchaseCount", 1, true), "Random Potion must enforce the remaining purchase limit")

assert(rebirth:find("function RebirthService.Client:Rebirth(player: Player): string", 1, true), "Rebirth client API must not accept an amount")
assert(rebirth:find("return self.Server:Rebirth(player)", 1, true), "Rebirth client API must ignore forged quantity arguments")
assert(rebirth:find("local nextRebirth = currentRebirth + 1", 1, true), "Rebirth price must always target the next level")
assert(rebirth:find("GetRebirthCost(nextRebirth)", 1, true), "Rebirth cost must use the next level")
assert(debugRebirth:find("Args = {}", 1, true), "debugRebirth must not accept a quantity")
assert(debugRebirthServer:find("return RebirthService:Rebirth(player)", 1, true), "debugRebirth must execute one normal rebirth")

assert(codes:find("_RedeemingPlayers", 1, true), "Codes must lock concurrent redemption attempts per player")
assert(codes:find("DataStore_Game_Operation:UpdateAsync(\"Codes\"", 1, true), "Codes inventory must be updated atomically")
assert(not codes:find("DataStore_Game_Operation:SetAsync(\"Codes\"", 1, true), "Codes inventory must not use non-atomic SetAsync")

assert(not exists("src/ServerScriptService/AgentDebugLogRelay_45893b.server.lua"), "First agent debug relay must be removed")
assert(not exists("src/ServerScriptService/AgentDebugLogRelay_f4635c.server.lua"), "Second agent debug relay must be removed")
assert(not soundHelper:find("AgentDebugLogRelay", 1, true), "SoundHelper must not send agent debug events")
assert(not gameOperation:find("agentDebugLog", 1, true), "GameOperationService must not retain agent debug logging")
assert(not gameOperation:find("127.0.0.1:7665", 1, true), "GameOperationService must not retain the local debug endpoint")

print("SecurityHardening.test.lua passed")
