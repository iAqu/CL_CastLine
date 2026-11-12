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

-- Exercise real granting and discovery together: the fishing badge follows the
-- index unlock, even when the independent acquisition-tag log disagrees.
local profile = { Data = { NewItemTagSeenLog = { Fish_A = true } } }
local player = {}
local backpack = { Parent = player, IsA = function(_, class) return class == "Backpack" end }
function player:FindFirstChildOfClass() return backpack end
function player:WaitForChild() return backpack end
local createSucceeds = true
local discoveryEvents = 0
local guid = 0
local index
local playerData = { GetProfile = function() return profile end }
local condition = { ValueMult = 1 }
local item = { Model = "TestFish", LayoutOrder = 1 }
local modules = {
	FishInventoryData = { Fish_A = item, Fish_B = item, Fish_C = item },
	GamePassEffectUtil = { GetItemLuckMultiplier = function() return 1 end },
	ItemRollUtil = { RollCondition = function() return "Normal", condition end },
	ItemStatUtil = {
		CalculateLuck = function() return 1 end,
		CalculatePrice = function() return 10 end,
		RollWeight = function() return 1 end,
	},
	ItemToolUtil = {
		INSTANCE_ID_ATTRIBUTE = "InstanceId",
		Create = function()
			return if createSucceeds then { SetAttribute = function() end } else nil
		end,
	},
	MutationDataUtil = {
		NormalizeMutationId = function(value) return value end,
		GetPriceRate = function() return 1 end,
	},
}
local knit = {
	CreateService = function(service) return service end,
	CreateSignal = function()
		return { Fire = function() discoveryEvents += 1 end }
	end,
	GetService = function(name)
		if name == "IndexService" then return index end
		if name == "PlotFishService" then return { RefreshInventoryIncome = function() end } end
		assert(name == "PlayerLuckService")
		return { RefreshPlayerLuck = function() end }
	end,
}
local services = {
	HttpService = { GenerateGUID = function() guid += 1; return tostring(guid) end },
	ReplicatedFirst = {
		Data = { ConditionsData = {}, IndexRewardsData = {} },
		DataHelpers = { IndexRewardsDataHelper = {
			GetProgress = function() return { UnlockedLuck = 0 } end,
		} },
	},
	ReplicatedStorage = { Modules = modules, Packages = { Knit = knit } },
	ServerScriptService = { Services = { PlayerDataService = playerData } },
}
local environment = setmetatable({
	game = { GetService = function(_, name) return assert(services[name]) end },
	require = function(value) return value end,
}, { __index = getfenv() })
index = assert(load(read("src/ServerScriptService/Services/IndexService.lua"), "IndexService", "t", environment))()
local grant = assert(load(itemGrantUtil, "ItemGrantUtil", "t", environment))()

local first = assert(grant.Grant(player, "Fish_A"))
assert(first.IsNewDiscovery == true and first.IsFirstItemAcquisition == false,
	"NEW on the fishing reveal must follow index discovery, not the acquisition-tag log")
assert(profile.Data.IndexDiscoveryLog.Fish_A == true and discoveryEvents == 1,
	"The first granted fish must unlock its index entry exactly once")
local repeated = assert(grant.Grant(player, "Fish_A", { MutationId = "Golden" }))
assert(repeated.IsNewDiscovery == false and discoveryEvents == 1,
	"Catching the same fish with a different mutation must not be a new index discovery")

profile.Data.IndexDiscoveryLog.Fish_B = true
local known = assert(grant.Grant(player, "Fish_B"))
assert(known.IsNewDiscovery == false and known.IsFirstItemAcquisition == true,
	"An unlocked index entry must stay known even if its acquisition-tag log is empty")

createSucceeds = false
assert(grant.Grant(player, "Fish_C") == nil, "Unavailable models must fail the grant")
assert(profile.Data.IndexDiscoveryLog.Fish_C == nil and discoveryEvents == 1,
	"Failed catches must not unlock entries or consume first discovery")
createSucceeds = true
assert(grant.Grant(player, "Fish_C").IsNewDiscovery == true and discoveryEvents == 2,
	"The next successful catch must still count as the first discovery")
