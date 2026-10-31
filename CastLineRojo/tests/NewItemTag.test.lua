local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local template = read("src/ReplicatedStorage/PlayerData/Template.lua")
local playerDataService = read("src/ServerScriptService/Services/PlayerDataService.lua")
local itemGrantUtil = read("src/ServerScriptService/Services/ItemGrantUtil.lua")
local digItemService = read("src/ServerScriptService/Services/DigItemService.lua")
local digController = read("src/StarterPlayer/StarterPlayerScripts/Controllers/DigController.lua")

assert(template:find("NewItemTagSeenLog = {}", 1, true), "Profiles must start the NEW tag log empty")
assert(
	playerDataService:find("local function sanitizeNewItemTagSeenLog", 1, true),
	"Profiles must sanitize the NEW tag log"
)
assert(
	playerDataService:find("sanitizeNewItemTagSeenLog(profile.Data)", 1, true),
	"Profile loading must sanitize the NEW tag log"
)
assert(
	itemGrantUtil:find("local isFirstItemAcquisition = profile.Data.NewItemTagSeenLog[itemId] ~= true", 1, true),
	"Item grants must determine first acquisition before marking the item as seen"
)
assert(
	itemGrantUtil:find("IsFirstItemAcquisition = isFirstItemAcquisition", 1, true),
	"Item grants must expose first-acquisition status"
)
assert(
	digItemService:find("IsFirstItemAcquisition = grant.IsFirstItemAcquisition == true", 1, true),
	"Dig results must forward first-acquisition status to the owner"
)
assert(
	digController:find("newTag.Visible = false", 1, true),
	"Dig title templates must hide NEW before the item is obtained"
)
assert(
	digController:find("newTag.Visible = typeof(result) == \"table\" and result.IsFirstItemAcquisition == true", 1, true),
	"Dig titles must show NEW only for the first acquisition result"
)

print("NewItemTag.test.lua passed")
