local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local service = read("src/ServerScriptService/Services/DigItemService.lua")
local controller = read("src/StarterPlayer/StarterPlayerScripts/Controllers/DigController.lua")

assert(
	service:find("OtherPlayerDigRevealed = Knit.CreateSignal()", 1, true),
	"DigItemService must expose an observer-only reveal signal"
)
assert(
	service:find("local groundPosition = getSurfacePosition(model)", 1, true)
		and service:find("local revealCFrame = model:GetPivot()", 1, true)
		and service:find("self.Client.OtherPlayerDigRevealed:FireAll({", 1, true),
	"A completed dig must broadcast independent reveal position data"
)
local grant = assert(service:find("local grant = ItemGrantUtil.Grant", 1, true))
local broadcast = assert(service:find("self.Client.OtherPlayerDigRevealed:FireAll({", 1, true))
assert(grant < broadcast, "Observers must only be notified after a successful item grant")
assert(
	service:find("GroundPosition = groundPosition", broadcast, true)
		and service:find("RevealCFrame = revealCFrame", broadcast, true),
	"Observer payload must not depend on the soon-destroyed dig-site instance"
)

assert(
	controller:find("local function getOtherPlayerDigRevealPayload", 1, true)
		and controller:find("local function playOtherPlayerDigReveal", 1, true),
	"DigController must validate and play observer reveal payloads"
)
assert(
	controller:find("if not reveal or reveal.Player == LOCAL_PLAYER then", 1, true),
	"The owner must retain the existing local showcase instead of receiving a duplicate"
)
assert(
	controller:find("dropVFX = if item and item.IsRareReward == 1 then DropVFXUtil.Play", 1, true),
	"Only IsRareReward items may create observer Light and advanced Beam VFX"
)
assert(
	controller:find("digItemService.OtherPlayerDigRevealed:Connect(playOtherPlayerDigReveal)", 1, true),
	"DigController must subscribe to server reveal broadcasts"
)

print("OtherPlayerDigReveal.test.lua passed")
