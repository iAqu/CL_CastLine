local function loadSource(path, environment)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return assert(load(source, path, "t", environment or getfenv()))()
end

local modulesPath = "src/ReplicatedStorage/Modules/"
local config = loadSource(modulesPath .. "FishingConfig.lua")
local rods = loadSource("src/ReplicatedFirst/Data/RodsData.lua")
local vector = setmetatable({}, {
	__mul = function(a) return a end,
	__sub = function(a) return a end,
})
local modules = {
	FishingConfig = config,
	FishingAssets = { GetRod = function(name) return name ~= rods.Rod_104.Model end },
	Constants = { NOTIFICATION_NO_ENOUGH_WIN = "Not enough cash" },
}
local services = {
	ReplicatedFirst = { WaitForChild = function()
		return { WaitForChild = function() return rods end }
	end },
	ReplicatedStorage = { Modules = modules, Packages = {} },
}
local environment = setmetatable({
	game = { GetService = function(_, name) return services[name] end },
	require = function(value) return value end,
	script = { Parent = modules },
	Enum = { HumanoidRigType = { R6 = "R6" } },
	Vector3 = { yAxis = vector },
}, { __index = getfenv() })
local inventory = loadSource(modulesPath .. "RodInventory.lua", environment)
local zone = loadSource(modulesPath .. "RodShopZone.lua", environment)
modules.RodInventory = inventory
modules.RodShopZone = zone
modules.FishingOnboarding = loadSource(modulesPath .. "FishingOnboarding.lua")

local data = { Wins = rods.Rod_102.Price + 1, EquippedRodId = "Rod_103", OwnedRods = "invalid" }
inventory.Reconcile(data)
assert(data.EquippedRodId == "Rod_101" and data.OwnedRods.Rod_101)
data.OwnedRods.Rod_104 = true
data.EquippedRodId = "Rod_104"
inventory.Reconcile(data)
assert(data.EquippedRodId == "Rod_101", "An unavailable equipped model must fall back to the starter")

local foot = { X = 0, Y = 0, Z = 0 }
local circle = {
	IsA = function(_, kind) return kind == "BasePart" end,
	Size = { Y = 6.3, Z = 8.25 },
	CFrame = { PointToObjectSpace = function() return foot end },
}
local humanoid = { Health = 100, HipHeight = 2, RigType = "R15" }
local root = { IsA = circle.IsA, Position = vector, Size = { Y = 2 } }
local character = {
	FindFirstChild = function(_, name) return if name == "HumanoidRootPart" then root else nil end,
	FindFirstChildOfClass = function() return humanoid end,
}
foot.Z = 5
assert(not zone.Contains(circle, character, 0) and zone.Contains(circle, character, zone.ExitMargin))

-- The shop service only needs the player profile, even without a plot or character.
local attribute
local player = {
	UserId = 42,
	SetAttribute = function(_, name, value)
		if name == "EquippedRodId" then
			attribute = value
		end
	end,
}
local inventoryEvents = {}
services.ReplicatedStorage.Packages.Knit = {
	CreateService = function(service) return service end,
	CreateSignal = function()
		return { Fire = function(_, eventPlayer, snapshot)
			assert(eventPlayer == player and snapshot.ok)
			table.insert(inventoryEvents, snapshot)
		end }
	end,
}
local client
local charges, ready, allowCharge = 0, true, true
local steps, growth, details = {}, {}, {}
environment.script = { Parent = {
	OnboardingAnalyticsService = {
		Step = function(_, _, step)
			table.insert(steps, step)
		end,
		Detail = function(_, _, group, detail)
			assert(group == "Guide")
			table.insert(details, detail)
		end,
		Growth = function(_, _, event, amount, id, source)
			table.insert(growth, { event, amount, id, source })
		end,
	},
	PlayerDataService = {
	GetProfile = function() return if ready then { Data = data } else nil end,
	AdjustWins = function(_, _, amount)
		if not allowCharge then
			return false
		end
		data.Wins += amount
		charges += 1
		assert(not client:BuyRod(player, "Rod_102").ok, "Reentrant purchase must be rejected")
		return true
	end,
} } }
client = loadSource("src/ServerScriptService/Services/RodShopService.lua", environment).Client
assert(client:GetState(player).equippedRodId == "Rod_101")
assert(not client:BuyRod(player, {}).ok and not client:BuyRod(player, "Rod_104").ok)
assert(client:EquipRod(player, "Rod_102").message == "You do not own this fishing rod")
assert(client:BuyRod(player, "Rod_103").message == modules.Constants.NOTIFICATION_NO_ENOUGH_WIN)
assert(charges == 0 and data.Wins == rods.Rod_102.Price + 1 and data.EquippedRodId == "Rod_101")

ready = false
assert(not client:GetState(player).ok and not client:BuyRod(player, "Rod_102").ok)
assert(not client:EquipRod(player, "Rod_101").ok and charges == 0)
ready = true
allowCharge = false
assert(not client:BuyRod(player, "Rod_102").ok and not data.OwnedRods.Rod_102)
allowCharge = true
local purchase = client:BuyRod(player, "Rod_102")
assert(purchase.ok and purchase.ownedRods.Rod_102 and purchase.equippedRodId == "Rod_102")
assert(#inventoryEvents == 1 and inventoryEvents[1] == purchase, "Successful purchase must publish its authoritative snapshot")
assert(data.OwnedRods.Rod_102 and data.EquippedRodId == "Rod_102" and attribute == "Rod_102")
assert(data.Wins == 1 and charges == 1)
assert(not client:BuyRod(player, "Rod_102").ok and charges == 1)
assert(client:EquipRod(player, "Rod_101").ok and attribute == "Rod_101" and charges == 1)
assert(client:EquipRod(player, "Rod_102").ok and attribute == "Rod_102" and charges == 1)
assert(#inventoryEvents == 3, "Only successful purchase/equip operations publish inventory events")
data.OwnedRods.Rod_103 = true
assert(not inventoryEvents[1].ownedRods.Rod_103, "Published snapshots must not alias the stored inventory")
inventory.Reconcile(data)
assert(data.EquippedRodId == "Rod_102", "A valid saved equipment choice must survive load")

data.OwnedRods.Rod_102 = nil
data.EquippedRodId = "Rod_101"
data.Wins = 300
data.FishingOnboarding = { Stage = "Train" }
assert(not client:BuyRod(player, "Rod_102").ok and charges == 1, "Park Rod is locked before training ends")
data.FishingOnboarding.Stage = "RodReward"
services.ReplicatedStorage.Packages.Knit.GetService = function()
	return {
		GetPlayerPlot = function()
			return { FindFirstChild = function() return circle end }
		end,
	}
end
assert(not client:BuyRod(player, "Rod_102").ok, "An absent character cannot make the guided purchase")
player.Character = character
foot.Z = 50
assert(not client:BuyRod(player, "Rod_102").ok, "Guided purchase requires visiting the player's shop")
foot.Z = 0
data.Wins = rods.Rod_102.Price - 1
local insufficient = client:BuyRod(player, "Rod_102")
assert(not insufficient.ok and insufficient.message == modules.Constants.NOTIFICATION_NO_ENOUGH_WIN,
	"The guided purchase must report insufficient cash")
assert(data.Wins == rods.Rod_102.Price - 1 and not data.OwnedRods.Rod_102,
	"An unaffordable purchase must preserve the player's cash and inventory")
assert(data.FishingOnboarding.Stage == "RodReward" and charges == 1 and #inventoryEvents == 3,
	"Rejected purchases must preserve progress and leave inventory events unchanged")
assert(#steps == 0 and #details == 1 and details[1] == "RodPurchaseInsufficientCash")

data.Wins = 300
allowCharge = false
assert(not client:BuyRod(player, "Rod_102").ok and #steps == 0 and #details == 1)
allowCharge = true
local guidedPurchase = client:BuyRod(player, "Rod_102")
assert(guidedPurchase.ok and data.OwnedRods.Rod_102 and attribute == "Rod_102",
	"Buying Park Rod must grant and equip it")
assert(data.FishingOnboarding.Stage == "FinalCatch" and data.Wins == 300 - rods.Rod_102.Price and charges == 2,
	"A guided purchase must charge the configured price once and advance to the final catch")
assert(#steps == 1 and steps[1] == "RodReady" and inventoryEvents[4] == guidedPurchase,
	"The guided purchase must record RodReady and publish its inventory snapshot")
assert(#details == 2 and details[2] == "RodPurchased")
local guidedGrowth = growth[#growth]
assert(guidedGrowth[1] == "CL_RodChange_v1" and guidedGrowth[2] == rods.Rod_102.Price,
	"The growth event must record the configured price")
assert(guidedGrowth[3] == "Rod_102" and guidedGrowth[4] == "Purchase", "The growth event must record a Park Rod purchase")
assert(not client:BuyRod(player, "Rod_102").ok and charges == 2, "Duplicate attempts must not deduct cash")
assert(#steps == 1 and #details == 2, "Duplicate purchases must not report onboarding progress")

assert(client:EquipRod(player, "Rod_101").ok and data.FishingOnboarding.Stage == "RodReward",
	"Equipping the starter rod must return to the rod step")
assert(client:EquipRod(player, "Rod_102").ok and data.FishingOnboarding.Stage == "FinalCatch",
	"An owned Park Rod must still advance the guide when equipped")
assert(client:EquipRod(player, "Rod_102").ok and #details == 3 and details[3] == "OwnedRodEquipped")
assert(data.Wins == 300 - rods.Rod_102.Price and charges == 2, "Equipping an owned Park Rod is free")
assert(client.ClaimTrainingRod == nil, "The old free-claim endpoint must be absent")
