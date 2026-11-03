local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local clientBootstrap = read("src/StarterPlayer/StarterPlayerScripts/KnitClient.client.lua")
local farmSignController = read("src/StarterPlayer/StarterPlayerScripts/Controllers/FarmSignController.lua")
local thumbnailUtil = read("src/ReplicatedStorage/Modules/PlayerThumbnailUtil.lua")

local earlyFarmSignRequire = assert(
	clientBootstrap:find('require(controllersFolder:WaitForChild("FarmSignController"))', 1, true),
	"client bootstrap must require FarmSignController explicitly"
)
local genericClientRequire = assert(
	clientBootstrap:find("controllersFolder:GetDescendants()", 1, true),
	"client bootstrap must still discover controllers"
)
assert(earlyFarmSignRequire < genericClientRequire, "farm owner UI must start before generic controllers")
assert(
	clientBootstrap:find("FarmSignController:BeginEarlyUi()", 1, true),
	"client bootstrap must start farm owner UI immediately"
)

assert(
	farmSignController:find("PlayerThumbnailUtil.GetHeadshot", 1, true),
	"farm signs must assign a non-blocking Roblox thumbnail URL immediately"
)
assert(
	not farmSignController:find("GetUserThumbnailAsync", 1, true),
	"farm sign updates must not block on thumbnail HTTP readiness"
)
assert(
	not farmSignController:find("CashLabel", 1, true),
	"farm signs must not manage an unused cash-rate label"
)
assert(
	not farmSignController:find("FarmCashRate", 1, true),
	"farm signs must not subscribe to unused cash-rate updates"
)
assert(
	not farmSignController:find("formatCashRate", 1, true),
	"farm signs must not format an unused cash rate"
)
assert(
	farmSignController:find("farmSign.Enabled = hasOwner", 1, true),
	"empty farm signs must be hidden entirely"
)
assert(
	farmSignController:find("otherPlayersSign.Enabled = hasOwner", 1, true),
	"empty other-player signs must be hidden entirely"
)
assert(
	not farmSignController:find('title.Text = "EMPTY"', 1, true),
	"farm signs must not render an empty-state title"
)
assert(
	not farmSignController:find('emptyText.Text = "Empty"', 1, true),
	"other-player signs must not render an empty-state label"
)
assert(
	farmSignController:find("function FarmSignController:BeginEarlyUi()", 1, true),
	"FarmSignController must expose idempotent early UI startup"
)
assert(
	thumbnailUtil:find("rbxthumb://type=AvatarHeadShot", 1, true),
	"thumbnail utility must use Roblox's non-blocking image content URL"
)

local avatarControllers = {
	"src/StarterPlayer/StarterPlayerScripts/Controllers/PlayerController.lua",
	"src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/InviteGuiController.lua",
	"src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/TradeGuiController.lua",
	"src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/TradeRequestGuiController.lua",
	"src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/TradeMenuGuiController.lua",
	"src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/StoreGiftMenuGuiController.lua",
}
for _, path in ipairs(avatarControllers) do
	local source = read(path)
	assert(
		not source:find("GetUserThumbnailAsync", 1, true),
		path .. " must not synchronously block UI updates on thumbnail readiness"
	)
end

local nonBlockingControllerModules = {
	"src/StarterPlayer/StarterPlayerScripts/Controllers/AtmosphereController.lua",
	"src/StarterPlayer/StarterPlayerScripts/Controllers/GiftBoxController.lua",
	"src/StarterPlayer/StarterPlayerScripts/Controllers/LightingController.lua",
	"src/StarterPlayer/StarterPlayerScripts/Controllers/PlayerStateGuiController.lua",
	"src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/LimitedAdvancedPackGuiController.lua",
	"src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/LimitedChristmasPackGuiController.lua",
	"src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/LimitedPackDetailGuiController.lua",
	"src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/LimitedSquidPackGuiController.lua",
	"src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/LimitedStarterPackGuiController.lua",
	"src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/RandomPotionGuiController.lua",
	"src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/RebirthUpgradeGuiController.lua",
	"src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/SeasonGuiController.lua",
	"src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/SpinningWheelController.lua",
	"src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/StoreGiftMenuGuiController.lua",
	"src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/TouchGuiController.lua",
	"src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/TradeMenuGuiController.lua",
	"src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/TradeRequestGuiController.lua",
}
for _, path in ipairs(nonBlockingControllerModules) do
	local source = read(path)
	assert(
		not source:find("local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()", 1, true)
			and not source:find("local localCharacter = localPlayer.Character or localPlayer.CharacterAdded:Wait()", 1, true),
		path .. " must not block the entire controller bootstrap while waiting for a character"
	)
end

print("StartupUiStateLatency.test.lua passed")
