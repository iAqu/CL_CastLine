local function loadSource(path, globals)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return assert(load(source, path, "t", setmetatable(globals or {}, { __index = getfenv() })))()
end

local function instance(class)
	local attributes, children = {}, {}
	local object = { Name = class }
	function object:IsA(kind)
		return class == kind
	end
	function object:SetAttribute(key, value)
		attributes[key] = value
	end
	function object:GetAttribute(key)
		return attributes[key]
	end
	function object:FindFirstChild(name)
		return children[name]
	end
	function object:GetChildren()
		local list = {}
		for _, child in pairs(children) do
			table.insert(list, child)
		end
		return list
	end
	function object:FindFirstChildOfClass(kind)
		for _, child in pairs(children) do
			if child:IsA(kind) then
				return child
			end
		end
		return nil
	end
	local parent
	function object:Destroy()
		if parent then
			parent._children[self.Name] = nil
		end
		parent = nil
	end
	object._children = children
	return setmetatable(object, {
		__newindex = function(self, key, value)
			if key == "Parent" then
				parent = value
				value._children[self.Name] = self
			else
				rawset(self, key, value)
			end
		end,
		__index = function(_, key)
			if key == "Parent" then
				return parent
			end
			return nil
		end,
	})
end

local function position(x)
	return setmetatable({ X = x }, {
		__sub = function(left, right)
			return { Magnitude = math.abs(left.X - right.X) }
		end,
	})
end

local modules = "src/ReplicatedStorage/Modules/"
local upgrades = require("./helpers/PlotUpgrades")
local placements = loadSource(modules .. "PlotPlacementUtil.lua", upgrades.environment)
local stats = require("./helpers/ItemStats")
local inventory = {
	Small = { ItemID = "Small", CpsPrice = 4 },
	Large = { ItemID = "Large", CpsPrice = 20 },
}
local mutations = {
	GetPriceRate = function() return 1 end,
	NormalizeMutationId = function(id)
		return id
	end,
	GetEarnCashRate = function(id)
		return if id == "Golden" then 2 else 1
	end,
}
local income = loadSource(modules .. "PlotFishIncome.lua", {
	require = function(value)
		return value
	end,
	script = {
		Parent = { FishInventoryData = inventory, ItemStatUtil = stats, MutationDataUtil = mutations, PlotPlacementUtil = placements },
	},
})

local data = { PlotPlacements = {}, Items = {}, Wins = 0, PendingPlotOfflineCash = 0 }
local player, plot, boundary = instance("Player"), instance("Model"), instance("BasePart")
player.UserId = 42
boundary.Parent = plot
plot:SetAttribute("OwnerUserId", 42)
player.Character = instance("Model")
instance("Backpack").Parent = player
local root, humanoid = instance("BasePart"), instance("Humanoid")
root.Name, root.Position, root.Parent = "HumanoidRootPart", position(0), player.Character
humanoid.Health, humanoid.Parent = 100, player.Character

local function hold(uid, container, itemId, mutation)
	data.Items[uid] = {
		ItemId = itemId or "Small",
		Weight = 50,
		ConditionId = "Codition_1",
		Price = 9,
		MutationId = mutation or "Golden",
	}
	local tool = instance("Tool")
	tool.Name, tool.uid, tool.Parent = uid, uid, container or player.Character
	return tool
end

local now, payoutAvailable, onPay = 100, true, nil
local dataService = {
	GetProfile = function()
		return { Data = data }
	end,
	AdjustWins = function(_, who, amount, progress)
		assert(who == player and progress == false, "Household income must not advance TotalWins")
		if not payoutAvailable then
			return false
		end
		if onPay then
			onPay()
		end
		data.Wins += amount
		return true
	end,
}
local benefits = { luck = 0 }
local signals = {}
local onboardingSteps = {}
local createCount, failOnCreate = 0, nil
local services = {
	PlotUpgradeService = { ApplyForPlayer = function() end, ResetPlot = function() end },
	PlotSlotService = {
		GetPlayerPlot = function()
			return plot
		end,
	},
	PlayerLuckService = {
		RefreshPlayerLuck = function()
			benefits.luck += 1
		end,
	},
	Workspace = {
		GetServerTimeNow = function()
			return now
		end,
	},
	Players = {},
	ReplicatedFirst = { Data = { ConditionsData = { Codition_1 = {} } } },
	ServerScriptService = { Services = {
		PlayerDataService = dataService,
		OnboardingAnalyticsService = { Step = function(_, _, step) table.insert(onboardingSteps, step) end },
	} },
	ReplicatedStorage = {
		Packages = { Knit = {
			CreateService = function(value)
				return value
			end,
			CreateSignal = function()
				return {
					Fire = function(_, recipient, payload)
						assert(recipient == player)
						table.insert(signals, payload)
					end,
				}
			end,
		} },
		Modules = {
			FishingOnboarding = loadSource(modules .. "FishingOnboarding.lua"),
			FishInventoryData = inventory,
			MutationDataUtil = mutations,
			PlotPlacementUtil = placements,
			PlotUpgradeData = upgrades.data,
			PlotFishIncome = income,
			ItemStatUtil = stats,
			ItemToolUtil = {
				GetInstanceId = function(tool)
					return tool.uid
				end,
				Create = function(uid)
					createCount += 1
					if createCount == failOnCreate then
						return nil
					end
					local tool = instance("Tool")
					tool.Name, tool.uid = uid, uid
					return tool
				end,
			},
			PlotFishMotion = {
				CAPACITY = 10,
				FOLDER_NAME = "PlacedFish",
				MOVE_ATTRIBUTE = "MoveState",
				GetBoundary = function()
					return boundary
				end,
				GetEntry = function(_, characterRoot)
					return if math.abs(characterRoot.Position.X) <= 22.5 then position(5) else nil
				end,
				GetGeometry = function(item)
					return if item.ModelUnavailable then nil else {}
				end,
				Start = function(_, entry, startedAt, _, ...)
					assert(select("#", ...) == 0, "New and restored fish use the same center boundary")
					return { from = entry, startedAt = startedAt, swimming = true }
				end,
				Advance = function(_, move, time, _, ...)
					assert(select("#", ...) == 0, "Later moves must not depend on fish size")
					if time >= move.startedAt + 1 then
						return { from = move.from, startedAt = time, swimming = not move.swimming }
					end
					return nil
				end,
				Encode = function(move)
					return move
				end,
				GetSurfacePoint = function(_, point, ...)
					assert(select("#", ...) == 0, "Placement uses the same center boundary")
					return point
				end,
			},
		},
	},
}
-- Bind after the table is initialized so the Knit mock closes over the local service map.
services.ReplicatedStorage.Packages.Knit.GetService = function(name)
	return services[name]
end
local plotService = loadSource("src/ServerScriptService/Services/PlotFishService.lua", {
	game = {
		GetService = function(_, name)
			return services[name]
		end,
	},
	require = function(value)
		return value
	end,
	Instance = { new = instance },
	Random = { new = function() return {} end },
	Vector3 = { new = position },
})

local first = hold("first")
data.FishingOnboarding = { Stage = "PlaceFish", FishUid = "first" }
plot:SetAttribute("OwnerUserId", 43)
assert(not plotService:RequestPlace(player, "first").ok, "Do not place fish in another player's plot")
plot:SetAttribute("OwnerUserId", 42)
root.Position = position(23)
assert(not plotService:RequestPlace(player, "first").ok and first.Parent == player.Character)
root.Position = position(0)
assert(not plotService:RequestPlace(player, "forged").ok, "The requested fish must be the held tool")
assert(data.FishingOnboarding.Stage == "PlaceFish" and #onboardingSteps == 0)
local response = plotService:RequestPlace(player, "first")
assert(response.ok and response.position.X == 5 and response.rate == 8 and not first.Parent)
assert(not plotService:RequestPlace(player, "first").ok)
assert(placements.GetItemUid(data.PlotPlacements, 1) == "first")
assert(data.FishingOnboarding.Stage == "Train" and data.FishingOnboarding.FishUid == nil)
assert(#onboardingSteps == 1 and onboardingSteps[1] == "FishPlaced", "Successful placement advances the guide exactly once")
assert(benefits.luck == 1)
assert(plotService.RequestPickup == nil and plotService.Client.RequestPickup == nil, "World pickup must be disabled")
local firstDisplay = plot:FindFirstChild("PlacedFish"):FindFirstChild("first")
local firstMove = firstDisplay:GetAttribute("MoveState")
assert(firstMove.swimming and firstMove.from.X == response.position.X, "Publish the first move at the placement point")
plotService:_stepMotion(now)
assert(firstDisplay:GetAttribute("MoveState") == firstMove, "Publish only when motion changes")
plotService:_stepMotion(now + 1)
assert(not firstDisplay:GetAttribute("MoveState").swimming, "Publish the rest after a swim")

now += 3
local second = hold("second")
assert(plotService:RequestPlace(player, "second").ok and not second.Parent)
assert(data.Wins == 24, "Settle the previous 8/s before the second fish increases the rate")
root.Position = position(-25)
now += 2
assert(plotService:RequestUnequip(player, "first").ok and not plotService:RequestUnequip(player, "first").ok)
assert(data.Wins == 56, "Settle the previous 16/s before menu unequip lowers the rate")
local lastMove = firstDisplay:GetAttribute("MoveState")
plotService:_stepMotion(now)
assert(firstDisplay:GetAttribute("MoveState") == lastMove, "Unequipped fish must stop receiving movement updates")
root.Position = position(0)
assert(player:FindFirstChildOfClass("Backpack"):FindFirstChild("first"))
assert(benefits.luck == 3)

for index = 1, 9 do
	local uid = tostring(index)
	hold(uid)
	assert(plotService:RequestPlace(player, uid).ok)
end
local overflow = hold("overflow")
assert(not plotService:RequestPlace(player, "overflow").ok and overflow.Parent == player.Character)
overflow:Destroy()

plot:FindFirstChild("PlacedFish"):Destroy()
plotService:_restore(player)
plotService:_restore(player)
assert(#plot:FindFirstChild("PlacedFish"):GetChildren() == 10, "Restore must recreate each fish exactly once")
assert(plot:FindFirstChild("PlacedFish"):FindFirstChild("second"):GetAttribute("MutationId") == "Golden")

data.LastOnlineTime = 100
data.PendingPlotOfflineCash = 17
local session = income.PrepareOffline(data, 100 + 9 * 3600)
assert(session.away == 9 * 3600 and session.counted == 8 * 3600)
assert(data.PendingPlotOfflineCash == 17 + 80 * 8 * 3600 * 0.5)
local pending = data.PendingPlotOfflineCash
assert(income.PrepareOffline(data, data.LastOnlineTime).away == 0 and data.PendingPlotOfflineCash == pending)
local client = plotService.Client
payoutAvailable = false
assert(not client:ClaimOfflineReward(player).ok and data.PendingPlotOfflineCash == pending)
payoutAvailable = true
onPay = function()
	assert(not client:ClaimOfflineReward(player).ok, "Overlapping claims must not double-pay")
end
local previousCash = data.Wins
assert(client:ClaimOfflineReward(player).ok and data.Wins == previousCash + pending)
assert(not client:ClaimOfflineReward(player).ok and data.PendingPlotOfflineCash == 0)

-- Exercise the menu from outside the plot while holding a fish.
onPay = nil
local backpack = player:FindFirstChildOfClass("Backpack")
local firstTool = backpack:FindFirstChild("first")
local golden = hold("golden-large", nil, "Large")
local other = hold("other-large", backpack, "Large", "Normal")
local folder = plot:FindFirstChild("PlacedFish")
local retained = folder:FindFirstChild("1")
root.Position = position(300)
assert(not plotService:RequestUnequip(player, "forged").ok)
plot:SetAttribute("OwnerUserId", 99)
assert(not plotService:RequestEquipBest(player).ok)
assert(not plotService:RequestUnequip(player, "1").ok)
plot:SetAttribute("OwnerUserId", 42)

local before = client:GetEquippedFish(player)
local balance = data.Wins
now += 1.5
failOnCreate = createCount + 2
assert(not plotService:RequestEquipBest(player).ok)
assert(client:GetEquippedFish(player).revision == before.revision and data.Wins == balance)
assert(golden.Parent == player.Character and other.Parent == backpack)
assert(folder:FindFirstChild("second") and not backpack:FindFirstChild("second") and not backpack:FindFirstChild("9"))

failOnCreate = nil
payoutAvailable = false
assert(not plotService:RequestEquipBest(player).ok)
assert(client:GetEquippedFish(player).revision == before.revision and data.Wins == balance)
assert(golden.Parent == player.Character and other.Parent == backpack)
assert(not backpack:FindFirstChild("second") and not backpack:FindFirstChild("9"))
payoutAvailable = true
assert(plotService:RequestEquipBest(player).ok)
local equipped = client:GetEquippedFish(player)
assert(#equipped.fish == 10 and equipped.fish[1].uid == "golden-large" and equipped.fish[1].income == 40)
assert(equipped.fish[2].uid == "other-large" and equipped.fish[2].income == 20)
assert(equipped.revision == before.revision + 1 and signals[#signals].revision == equipped.revision)
assert(data.Wins == balance + 120, "Settle 1.5 seconds at the old 80/s before swapping")
assert(not golden.Parent and not other.Parent and backpack:FindFirstChild("second") and backpack:FindFirstChild("9"))
assert(folder:FindFirstChild("1") == retained and backpack:FindFirstChild("first") == firstTool,
	"Keep the original slot and display for a retained fish, and prefer it over an equal carried fish")
local current = folder:FindFirstChild("golden-large")
local previousCreateCount = createCount
assert(plotService:RequestEquipBest(player).ok and folder:FindFirstChild("golden-large") == current)
assert(createCount == previousCreateCount and client:GetEquippedFish(player).revision == equipped.revision)

now += 0.5
assert(plotService:RequestUnequip(player, "golden-large").ok)
assert(data.Wins == balance + 182, "Settle the new 124/s until remote unequip")
assert(#client:GetEquippedFish(player).fish == 9 and not folder:FindFirstChild("golden-large"))
assert(backpack:FindFirstChild("golden-large") and not plotService:RequestUnequip(player, "golden-large").ok)

-- Event production must settle the old rate before a carried baseline changes.
inventory.Event = { ItemID = "Event", Rarity = "Event", CpsPrice = 1.5 }
inventory.Fish_101 = { ItemID = "Fish_101", Rarity = "Common", CpsPrice = 1 }
root.Position = position(0)
data.Items, data.PlotPlacements = {}, {}
plot:FindFirstChild("PlacedFish"):Destroy()
plotService:RefreshInventoryIncome(player)
hold("event", nil, "Event", "Normal")
hold("base", backpack, "Small", "Golden")
plotService:RefreshInventoryIncome(player)
assert(player:GetAttribute("BestOwnedFishBaseCps") == 4, "Use base CPS, not the strongest fish's mutation")
assert(plotService:RequestPlace(player, "event").rate == 6)
assert(player:GetAttribute("PlotFishBaseCashPerSecond") == 6)
local eventBalance = data.Wins
now += 2
local stronger = hold("new-best", backpack, "Large", "Normal")
plotService:RefreshInventoryIncome(player)
assert(data.Wins == eventBalance + 12 and player:GetAttribute("BestOwnedFishBaseCps") == 20)
assert(client:GetEquippedFish(player).fish[1].income == 30)
assert(player:GetAttribute("PlotFishBaseCashPerSecond") == 30)
now += 1
data.Items["new-best"] = nil
stronger:Destroy()
plotService:RefreshInventoryIncome(player)
assert(data.Wins == eventBalance + 42 and client:GetEquippedFish(player).fish[1].income == 6)
assert(player:GetAttribute("PlotFishBaseCashPerSecond") == 6)
-- A failed payout must retain the old credit while switching to the new rate.
now += 1
payoutAvailable = false
data.Items.base = nil
plotService:RefreshInventoryIncome(player)
assert(player:GetAttribute("BestOwnedFishBaseCps") == 1 and client:GetEquippedFish(player).fish[1].income == 1)
payoutAvailable = true
plotService:RefreshInventoryIncome(player)
assert(data.Wins == eventBalance + 48, "Retry unpaid credit even if no additional time has elapsed")
-- Equip-best ranking must use the same dynamic rate as real production.
hold("best-again", backpack, "Large", "Normal")
plotService:RefreshInventoryIncome(player)
assert(plotService:RequestEquipBest(player).ok)
local eventRoster = client:GetEquippedFish(player).fish
assert(eventRoster[1].uid == "event" and eventRoster[1].income == 30 and eventRoster[2].income == 20)

-- Upgraded capacity must reach placement, best-equip, snapshots and income.
data.PlotUpgradeLevel = 10
for index = 1, 20 do hold("upgraded-" .. index, backpack, "Large", "Normal") end
assert(plotService:RequestEquipBest(player).ok)
local upgradedRoster = client:GetEquippedFish(player)
assert(upgradedRoster.capacity == 20 and #upgradedRoster.fish == 20)
local expectedRate = 0
for _, fish in upgradedRoster.fish do expectedRate += fish.income end
assert(income.GetRate(data) == expectedRate)
data.LastOnlineTime, data.PendingPlotOfflineCash = 100, 0
income.PrepareOffline(data, 110)
assert(data.PendingPlotOfflineCash == expectedRate * 5)
assert(plotService:RequestUnequip(player, upgradedRoster.fish[20].uid).ok)
assert(#client:GetEquippedFish(player).fish == 19)

-- A paid fish can have a backpack tool before its pond model is available.
assert(plotService:RequestEquipBest(player).ok, "Refill the pond before testing upgrades")
local fullRoster = client:GetEquippedFish(player)
assert(#fullRoster.fish == fullRoster.capacity, "The regression requires a full pond")
local weakestUid = fullRoster.fish[fullRoster.capacity].uid
local weakestSlot = plot:FindFirstChild("PlacedFish"):FindFirstChild(weakestUid):GetAttribute("Slot")
inventory.MissingModel = { ItemID = "MissingModel", Rarity = "Exclusive", CpsPrice = 5, ModelUnavailable = true }
local unavailable = hold("missing-model", backpack, "MissingModel", "Normal")
data.Items["missing-model"].PaidOrigin = "test-order"
local upgrade = hold("valid-upgrade", backpack, "Large", "Golden")
assert(plotService:RequestEquipBest(player).ok, "An unavailable fish must not block a placeable upgrade")
local updated = client:GetEquippedFish(player)
assert(updated.fish[1].uid == "valid-upgrade" and updated.fish[1].income == 40, "Equip the best placeable fish")
assert(#updated.fish == fullRoster.capacity and updated.revision == fullRoster.revision + 1, "Commit one full roster")
assert(placements.GetItemUid(data.PlotPlacements, weakestSlot) == "valid-upgrade", "Replace the weakest slot")
assert(not upgrade.Parent and unavailable.Parent == backpack and backpack:FindFirstChild(weakestUid),
	"Consume the selected tool and keep the returned and unavailable fish in the backpack")

assert(plotService:RequestEquipBest(player).ok, "Succeed when no further upgrade is available")
assert(client:GetEquippedFish(player).revision == updated.revision and unavailable.Parent == backpack,
	"Leave the roster and backpack alone when only an unavailable upgrade remains")

inventory.MissingModel.ModelUnavailable = false
assert(plotService:RequestEquipBest(player).ok, "Recheck model availability on the next request")
local restored = client:GetEquippedFish(player)
assert(restored.fish[1].uid == "missing-model" and restored.revision == updated.revision + 1,
	"Equip the previously skipped fish once its model is available")
assert(not unavailable.Parent and data.Items["missing-model"].PaidOrigin == "test-order",
	"Consume the tool and preserve the equipped fish's paid origin")

-- The real grant path must settle the old rate and immediately refresh online income.
local cashPass = "DoubleWins"
data.GamePasses = {}
services.ReplicatedStorage.Modules.Constants = { GAMEPASS = {
	DOUBLE_WINS = cashPass, SUPER_LUCK = "SuperLuck", MEGA_LUCK = "MegaLuck",
} }
services.ReplicatedFirst.DataHelpers = { PurchaseDataHelper = {
	GetData = function() return { Type = "GamePass" } end,
	IsRetired = function() return false end,
} }
services.PlotFishService = plotService
local gamePassService = loadSource("src/ServerScriptService/Services/GamePassService.lua", {
	game = { GetService = function(_, name) return services[name] end },
	require = function(value) return value end,
})
local baseRate = income.GetRate(data)
local cashBeforeGrant = data.Wins
now += 1
gamePassService:GiveGamePass(player, cashPass)
assert(data.Wins == cashBeforeGrant + baseRate, "Settle pre-grant time at the old rate")
assert(income.GetRate(data) == baseRate * 2 and player:GetAttribute(income.MULTIPLIER_ATTRIBUTE) == 2)
local boosted = client:GetEquippedFish(player)
assert(boosted.revision == restored.revision + 1 and boosted.fish[1].income == restored.fish[1].income * 2)
gamePassService:GiveGamePass(player, cashPass)
assert(client:GetEquippedFish(player).revision == boosted.revision, "A repeated grant must not reapply the effect")
now += 1
plotService:RefreshInventoryIncome(player)
assert(data.Wins == cashBeforeGrant + baseRate * 3, "Online payout uses the boosted rate after the grant")

data.LastOnlineTime, data.PendingPlotOfflineCash = 100, 17
income.PrepareOffline(data, 109)
assert(data.PendingPlotOfflineCash == 17 + income.ComputeOfflineCash(baseRate, 9) * 2,
	"Double only newly earned offline cash after applying the existing rounding rule")

-- The full-plot offer previews the gain without consuming the held fish or changing the pond.
root.Position = position(0)
local incoming = hold("full-plot-incoming", nil, "Large", "Golden")
local beforeSwap = client:GetEquippedFish(player)
local beforeSwapRate = income.GetRate(data)
local quoted = plotService:RequestPlace(player, "full-plot-incoming")
assert(not quoted.ok and quoted.full.capacity == beforeSwap.capacity and quoted.full.level == data.PlotUpgradeLevel)
local offer = quoted.full.swap
local swapFolder = plot:FindFirstChild("PlacedFish")
local oldDisplay = assert(swapFolder:FindFirstChild(offer.uid))
assert(offer.rate > 0 and incoming.Parent == player.Character)
assert(client:GetEquippedFish(player).revision == beforeSwap.revision)
local function confirmSwap(target, rate)
	return plotService:RequestSwap(player, "full-plot-incoming", target, rate)
end
assert(not confirmSwap("other-large", offer.rate).ok and not confirmSwap(offer.uid, offer.rate + 1).ok)
root.Position = position(300)
assert(not confirmSwap(offer.uid, offer.rate).ok, "Confirm from inside the owned plot")
root.Position = position(0)
failOnCreate = createCount + 1
assert(not confirmSwap(offer.uid, offer.rate).ok and oldDisplay.Parent == swapFolder and incoming.Parent == player.Character)
failOnCreate = nil
local swapped = confirmSwap(offer.uid, offer.rate)
assert(swapped.ok and swapped.position.X == 5 and not incoming.Parent)
assert(not oldDisplay.Parent and backpack:FindFirstChild(offer.uid))
assert(placements.GetItemUid(data.PlotPlacements, offer.slot) == "full-plot-incoming")
assert(income.GetRate(data) - beforeSwapRate == offer.rate and #swapFolder:GetChildren() == beforeSwap.capacity)
assert(not confirmSwap(offer.uid, offer.rate).ok, "Retrying a successful swap cannot return a second tool")

local remaining = client:GetEquippedFish(player).fish
local weakest = remaining[#remaining]
for _, fish in {
	{ uid = "full-plot-even", itemId = weakest.itemId, mutationId = weakest.mutationId },
	{ uid = "full-plot-weaker", itemId = "Small", mutationId = "Normal" },
} do
	local held = hold(fish.uid, nil, fish.itemId, fish.mutationId)
	local noGain = plotService:RequestPlace(player, fish.uid)
	assert(noGain.full and not noGain.full.swap, "Only offer a swap when it increases income")
	assert(not plotService:RequestSwap(player, fish.uid, weakest.uid, 0).ok)
	assert(held.Parent == player.Character, "The held fish stays equipped when no swap is offered")
	held:Destroy()
end
print("PlotFishService.test.lua passed")
