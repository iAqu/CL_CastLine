local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local digItemService = read("src/ServerScriptService/Services/DigItemService.lua")
local plotPedestalService = read("src/ServerScriptService/Services/PlotPedestalService.lua")
local shovelService = read("src/ServerScriptService/Services/ShovelService.lua")
local indexService = read("src/ServerScriptService/Services/IndexService.lua")
local gamePassService = read("src/ServerScriptService/Services/GamePassService.lua")
local homeGuiController = read("src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/HomeGuiController.lua")

assert(digItemService:find("LuckChanged = Knit.CreateSignal()", 1, true), "Luck changes need a targeted client signal")
assert(digItemService:find("function DigItemService.Client:GetPlayerRollLuck", 1, true), "Clients need an authoritative Luck query")
assert(digItemService:find("return getPlayerRollLuck(player)", 1, true), "The client query must reuse the dig-roll calculation")
assert(digItemService:find("self._PlayerLuck[player] == luck", 1, true), "Unchanged Luck must not fire redundant updates")
assert(digItemService:find("self.Client.LuckChanged:Fire(player, luck)", 1, true), "Changed Luck must reach the owning client")

for _, source in ipairs({ plotPedestalService, shovelService, indexService }) do
	assert(source:find('Knit.GetService("DigItemService"):RefreshPlayerLuck(player)', 1, true), "Luck sources must refresh the displayed total")
end
assert(gamePassService:find("Constants.GAMEPASS.SUPER_LUCK", 1, true), "Super Luck must refresh the total")
assert(gamePassService:find("Constants.GAMEPASS.MEGA_LUCK", 1, true), "Ultra Luck must refresh the total")

assert(homeGuiController:find('CurrencyFrame:FindFirstChild("Luck")', 1, true), "Home GUI must bind the Luck frame")
assert(homeGuiController:find('LuckFrame:FindFirstChild("LuckShadowLabel")', 1, true), "Home GUI must bind the Luck shadow label")
assert(homeGuiController:find('LuckShadowLabel:FindFirstChild("LuckLabel")', 1, true), "Home GUI must bind the Luck foreground label")
assert(homeGuiController:find('"Luck: " .. ItemStatUtil.FormatLuckPercent(luck)', 1, true), "Luck text must reuse the shared percentage formatter")
assert(homeGuiController:find("digItemService.LuckChanged:Connect(setLuckAmountText)", 1, true), "Home GUI must react to server Luck updates")
assert(homeGuiController:find("digItemService:GetPlayerRollLuck()", 1, true), "Home GUI must request initial Luck")

print("HomeLuckDisplay.test.lua passed")
