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
local placements = loadSource(modules .. "PlotPlacementUtil.lua")
local inventory = {
	Small = { ItemID = "Small", CpsPrice = 4 },
	Large = { ItemID = "Large", CpsPrice = 20 },
}
local mutations = {
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
		Parent = { FishInventoryData = inventory, MutationDataUtil = mutations, PlotPlacementUtil = placements },
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
local createCount, failOnCreate = 0, nil
local services = {
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
	ServerScriptService = { Services = { PlayerDataService = dataService } },
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
			FishInventoryData = inventory,
			MutationDataUtil = mutations,
			PlotPlacementUtil = placements,
			PlotFishIncome = income,
			ItemStatUtil = {},
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
				GetGeometry = function()
					return { footprint = 3 }
				end,
				Start = function(_, entry, startedAt, _, _, radius)
					assert(radius == 3, "Start new and restored fish with their scaled footprint")
					return { from = entry, startedAt = startedAt, swimming = true }
				end,
				Advance = function(_, move, time, _, radius)
					assert(radius == 3, "Keep the same footprint on later moves")
					if time >= move.startedAt + 1 then
						return { from = move.from, startedAt = time, swimming = not move.swimming }
					end
					return nil
				end,
				Encode = function(move)
					return move
				end,
				GetSurfacePoint = function(_, point, radius)
					assert(radius == 3, "Use the fish footprint at the placement point")
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
plot:SetAttribute("OwnerUserId", 43)
assert(not plotService:RequestPlace(player, "first").ok, "Do not place fish in another player's plot")
plot:SetAttribute("OwnerUserId", 42)
root.Position = position(23)
assert(not plotService:RequestPlace(player, "first").ok and first.Parent == player.Character)
root.Position = position(0)
assert(not plotService:RequestPlace(player, "forged").ok, "The requested fish must be the held tool")
local response = plotService:RequestPlace(player, "first")
assert(response.ok and response.position.X == 5 and response.rate == 8 and not first.Parent)
assert(not plotService:RequestPlace(player, "first").ok)
assert(placements.GetItemUid(data.PlotPlacements, 1) == "first")
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

print("PlotFishService.test.lua passed")
