local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local template = read("src/ReplicatedStorage/PlayerData/Template.lua")
local playerDataService = read("src/ServerScriptService/Services/PlayerDataService.lua")
local itemGrantUtil = read("src/ServerScriptService/Services/ItemGrantUtil.lua")

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

print("NewItemTag.test.lua passed")
