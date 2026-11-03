local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local playerLuckService = read("src/ServerScriptService/Services/PlayerLuckService.lua")
local plotPedestalService = read("src/ServerScriptService/Services/PlotPedestalService.lua")
local indexService = read("src/ServerScriptService/Services/IndexService.lua")
local gamePassService = read("src/ServerScriptService/Services/GamePassService.lua")
local homeGuiController = read("src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/HomeGuiController.lua")


assert(playerLuckService:find("LuckChanged = Knit.CreateSignal()", 1, true))
assert(playerLuckService:find("function PlayerLuckService.Client:GetPlayerRollLuck", 1, true))
assert(playerLuckService:find("self._PlayerLuck[player] == luck", 1, true))
assert(playerLuckService:find("self.Client.LuckChanged:Fire(player, luck)", 1, true))
assert(homeGuiController:find("playerLuckService.LuckChanged:Connect(setLuckAmountText)", 1, true))
assert(homeGuiController:find("playerLuckService:GetPlayerRollLuck()", 1, true))

for _, source in ipairs({ plotPedestalService, indexService }) do
	assert(source:find('Knit.GetService("PlayerLuckService"):RefreshPlayerLuck(player)', 1, true), "Luck sources must refresh the displayed total")
end
assert(gamePassService:find("Constants.GAMEPASS.SUPER_LUCK", 1, true), "Super Luck must refresh the total")
assert(gamePassService:find("Constants.GAMEPASS.MEGA_LUCK", 1, true), "Ultra Luck must refresh the total")

assert(homeGuiController:find('CurrencyFrame:FindFirstChild("Luck")', 1, true), "Home GUI must bind the Luck frame")
assert(homeGuiController:find('LuckFrame:FindFirstChild("LuckShadowLabel")', 1, true), "Home GUI must bind the Luck shadow label")
assert(homeGuiController:find('LuckShadowLabel:FindFirstChild("LuckLabel")', 1, true), "Home GUI must bind the Luck foreground label")
assert(homeGuiController:find('"Luck: " .. ItemStatUtil.FormatLuckPercent(luck)', 1, true), "Luck text must reuse the shared percentage formatter")

print("HomeLuckDisplay.test.lua passed")
