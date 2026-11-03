local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local serverBootstrap = read("src/ServerScriptService/KnitServer.server.lua")
local playerDataService = read("src/ServerScriptService/Services/PlayerDataService.lua")
local clientBootstrap = read("src/StarterPlayer/StarterPlayerScripts/KnitClient.client.lua")
local playerDataController = read("src/StarterPlayer/StarterPlayerScripts/Controllers/PlayerDataController.lua")

local auxiliaryVisibilitySetup = assert(
	serverBootstrap:find("local function hideAuxiliaryPart", 1, true),
	"server bootstrap must centralize world auxiliary-part visibility setup"
)
local earlyServerRequire = assert(
	serverBootstrap:find("require(ServerScriptService.Services.PlayerDataService)", 1, true),
	"server bootstrap must require PlayerDataService explicitly"
)
assert(auxiliaryVisibilitySetup < earlyServerRequire, "world auxiliary parts must be hidden before services start")
assert(
	serverBootstrap:find('hideAuxiliaryPart(areas and areas:FindFirstChild("ResetPlayerBox"), "Workspace.Areas.ResetPlayerBox")', 1, true),
	"server bootstrap must hide the reset volume"
)
assert(
	serverBootstrap:find('hideAuxiliaryPart(water and water:FindFirstChild("Surface"), "Workspace.Areas.Water.Surface")', 1, true),
	"server bootstrap must hide the water surface helper"
)
assert(
	serverBootstrap:find("instance.Transparency = 1", auxiliaryVisibilitySetup, true),
	"hiding world auxiliary parts must use transparency only"
)

local genericServerRequire = assert(
	serverBootstrap:find("ServerScriptService.Services:GetDescendants()", 1, true),
	"server bootstrap must still discover services"
)
assert(earlyServerRequire < genericServerRequire, "player profile loading must be registered before generic services")
assert(
	serverBootstrap:find("PlayerDataService:BeginEarlyLoading()", 1, true),
	"server bootstrap must start profile loading before Knit"
)
assert(
	serverBootstrap:find("PlayerDataService:MarkFrameworkReady()", 1, true),
	"profile publication must wait until service listeners are ready"
)

assert(
	playerDataService:find("function PlayerDataService:BeginEarlyLoading()", 1, true),
	"PlayerDataService must expose idempotent early loading"
)
assert(
	playerDataService:find('Instance.new("RemoteFunction")', 1, true),
	"early data transport must use a waiting RemoteFunction like the reference game"
)
assert(
	playerDataService:find("self._PendingProfiles[player]", 1, true),
	"loaded profiles must remain available to the early client request before Knit publication"
)

local earlyClientRequire = assert(
	clientBootstrap:find('require(controllersFolder:WaitForChild("PlayerDataController"))', 1, true),
	"client bootstrap must require PlayerDataController explicitly"
)
local genericClientRequire = assert(
	clientBootstrap:find("controllersFolder:GetDescendants()", 1, true),
	"client bootstrap must still discover controllers"
)
assert(earlyClientRequire < genericClientRequire, "client data fetch must start before generic controllers")
assert(
	clientBootstrap:find("PlayerDataController:BeginEarlyFetch()", 1, true),
	"client bootstrap must begin fetching data immediately"
)

assert(
	playerDataController:find("function PlayerDataController:BeginEarlyFetch()", 1, true),
	"PlayerDataController must expose idempotent early fetch"
)
assert(
	playerDataController:find("InvokeServer", 1, true),
	"early client fetch must wait on the server data response"
)
assert(
	playerDataController:find("applyEarlyHomeCurrency", 1, true),
	"the early snapshot must update HomeGui currency without waiting for HomeGuiController.KnitStart"
)
assert(
	not playerDataController:find("task.wait(0.25)", 1, true),
	"player data readiness must not be quantized by a 0.25 second polling loop"
)
assert(
	not playerDataController:find("task.wait(0.1)", 1, true),
	"controllers waiting for the first snapshot must resume on the next scheduler cycle"
)

print("PlayerDataStartupLatency.test.lua passed")
