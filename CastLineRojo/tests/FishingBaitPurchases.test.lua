local new = require("./helpers/FishingHarness")
local h = new()
local config, progression = h.baitConfig, h.progression
config.ProductIds.Rod_101 = 1234
local player = {}
local persisted, revision, now, active, saveEnabled = nil, nil, 0, true, true
local profile = { Data = {}, MetaData = { MetaTags = {}, MetaTagsLatest = {} } }
function profile:IsActive()
	return active
end
function profile:SetMetaTag(key, value)
	self.MetaData.MetaTags[key] = value
end
function profile:Save()
	revision = self.MetaData.MetaTags.FishingBaitReceiptRevision
	if saveEnabled then
		local p = progression.Ensure(self.Data)
		persisted = { credits = table.clone(p.Credits), receipts = table.clone(p.Receipts) }
		self.MetaData.MetaTagsLatest.FishingBaitReceiptRevision = revision
	end
end
local file = assert(io.open("src/ServerScriptService/Services/FishingBaitPurchases.lua"))
local source = file:read("*a")
file:close()
local module = assert(load(
	source,
	"FishingBaitPurchases",
	"t",
	setmetatable({
		game = {
			GetService = function()
				return { Modules = { FishingBaitConfig = config, FishingProgression = progression } }
			end,
		},
		script = { Parent = { PlayerDataService = {
			GetProfile = function()
				return profile
			end,
		} } },
		require = function(v)
			return v
		end,
		os = {
			clock = function()
				return now
			end,
		},
		task = {
			wait = function(t)
				now += t
			end,
		},
	}, { __index = getfenv() })
))()
assert(not module.Process(nil, { ProductId = 1234, PurchaseId = "missing-player" }))
assert(not module.Process(player, { ProductId = 9999, PurchaseId = "unknown" }))
local granted, added = module.Process(player, { ProductId = 1234, PurchaseId = "one" })
assert(granted and added and persisted.credits.Rod_101 == 1 and persisted.receipts.one)
local p = progression.Ensure(profile.Data)
p.Credits.Rod_101 = 0 -- A player used the bait before a repeated receipt callback.
granted, added = module.Process(player, { ProductId = 1234, PurchaseId = "one" })
assert(granted and not added and p.Credits.Rod_101 == 0, "Repeated receipt cannot restore spent bait")
saveEnabled = false
assert(not module.Process(player, { ProductId = 1234, PurchaseId = "two" }), "Do not acknowledge an unsaved credit")
assert(p.Credits.Rod_101 == 1 and persisted.receipts.two == nil)
saveEnabled = true
assert(module.Process(player, { ProductId = 1234, PurchaseId = "two" }))
assert(p.Credits.Rod_101 == 1 and persisted.receipts.two, "Retry saves without granting twice")
active = false
assert(not module.Process(player, { ProductId = 1234, PurchaseId = "three" }))
assert(not p.Receipts.three)
config.ProductIds.Rod_102 = 1234
assert(
	config.GetProductId("Rod_101") == nil and config.GetProductRod(1234) == nil,
	"Ambiguous product mappings cannot be sold"
)
assert(progression.Ensure({}, true).NewbieComplete, "Existing zero-catch accounts are still veterans")
