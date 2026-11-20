local function read(path)
	local f = assert(io.open(path, "r"))
	local source = f:read("*a")
	f:close()
	return source
end
local function signal()
	local callbacks = {}
	return {
		Connect = function(_, callback) table.insert(callbacks, callback) end,
		Emit = function(_, ...) for _, callback in callbacks do callback(...) end end,
		Fire = function(self, ...) self.last = { ... } end,
		FireAll = function() end,
	}
end
local function instance(class, name)
	local object = { Class = class, Name = name or class, children = {} }
	function object:IsA(kind) return self.Class == kind end
	function object:GetChildren() return table.clone(self.children) end
	function object:FindFirstChildOfClass(kind)
		for _, child in self.children do if child.Class == kind then return child end end
	end
	function object:FindFirstChild(childName)
		for _, child in self.children do if child.Name == childName then return child end end
	end
	function object:WaitForChild(childName) return self:FindFirstChild(childName) end
	function object:SetAttribute(key, value) self[key] = value end
	function object:Destroy() self.Parent = nil end
	return setmetatable(object, {
		__index = function(self, key) if key == "Parent" then return rawget(self, "_parent") end end,
		__newindex = function(self, key, value)
			if key ~= "Parent" then rawset(self, key, value); return end
			local previous = rawget(self, "_parent")
			if previous then
				local index = table.find(previous.children, self)
				if index then table.remove(previous.children, index) end
			end
			rawset(self, "_parent", value)
			if value then table.insert(value.children, self) end
		end,
	})
end
local players, profiles, published = { PlayerRemoving = signal() }, {}, {}
local function player(id)
	local p = instance("Player")
	p.UserId, p.DisplayName, p.Character = id, "Player" .. id, instance("Model")
	instance("Backpack").Parent = p
	local humanoid, root = instance("Humanoid"), instance("BasePart", "HumanoidRootPart")
	humanoid.Health, humanoid.Parent, root.Parent = 100, p.Character, p.Character
	root.Position = setmetatable({}, { __sub = function() return { Magnitude = 1 } end })
	profiles[p] = { Data = { Items = {}, PlotPlacements = {}, Wins = 0 } }
	return p
end
local sender, recipient = player(1), player(2)
function players:GetPlayerByUserId(id) return if id == 1 then sender else recipient end
local fish = {
	Fish_101 = { ItemID = "Fish_101", DisplayName = "Starter", Rarity = "Common", CpsPrice = 1 },
	Best = { ItemID = "Best", DisplayName = "Best", Rarity = "Secret", CpsPrice = 100 },
	Event = { ItemID = "Event", DisplayName = "Event", Rarity = "Event", CpsPrice = 2 },
}
local modules = {
	HeldGiftFeatureConfig = assert(loadstring(read("src/ReplicatedStorage/Modules/HeldGiftFeatureConfig.lua")))(),
	SellShopZone = { CanSell = function() return true end },
	FishInventoryData = fish,
	MutationDataUtil = {
		NormalizeMutationId = function(id) return id end,
		GetPriceRate = function() return 1 end, GetEarnCashRate = function() return 1 end,
	},
	ItemStatUtil = { RollWeight = function() return 1 end, CalculateLuck = function() return 0 end,
		CalculatePrice = function() return 10 end },
	ItemRollUtil = { RollCondition = function() return "Codition_1", { ValueMult = 1 } end },
	GamePassEffectUtil = { GetItemLuckMultiplier = function() return 1 end, GetSaleMultiplier = function() return 1 end },
}
local income = assert(load(read("src/ReplicatedStorage/Modules/PlotFishIncome.lua"), "Income", "t", setmetatable({
	script = { Parent = { FishInventoryData = fish, ItemStatUtil = require("./helpers/ItemStats"), MutationDataUtil = modules.MutationDataUtil, PlotPlacementUtil = {} } },
	require = function(value) return value end,
}, { __index = getfenv() })))()
local guid, failRecipient = 0, false
modules.ItemToolUtil = {
	INSTANCE_ID_ATTRIBUTE = "uid",
	IsItemTool = function(tool) return tool.Class == "Tool" end,
	GetInstanceId = function(tool) return tool.uid end,
	Create = function(uid, _, _, owner)
		if failRecipient and owner == recipient then return nil end
		local tool = instance("Tool")
		tool.uid = uid
		return tool
	end,
}
local refreshes = 0
local hotbarRemovals = 0
local otherServices = {
	PlotFishService = { RefreshInventoryIncome = function(_, who)
		refreshes += 1
		published[who] = income.GetBestOwnedBaseCps(profiles[who].Data)
	end },
	HotbarLayoutService = {
		RemoveItemDescriptors = function()
			hotbarRemovals += 1
		end,
	},
	IndexService = { GetDiscoveryLuck = function() return 0 end, DiscoverItem = function() return false end },
}
local knit = { CreateService = function(service) return service end, CreateSignal = signal,
	GetService = function(name) return assert(otherServices[name], name) end }
local services = {
	Players = players,
	HttpService = { GenerateGUID = function() guid += 1; return tostring(guid) end },
	ReplicatedFirst = { Data = { ConditionsData = { Codition_1 = { ValueMult = 1 } } } },
	ReplicatedStorage = { Modules = modules, Packages = { Knit = knit } },
	ServerScriptService = { Services = { PlayerDataService = {
		GetProfile = function(_, who) return profiles[who] end,
		AdjustWins = function(_, who, amount) profiles[who].Data.Wins += amount; return true end,
	} } },
}
local function loadService(name)
	return assert(load(read("src/ServerScriptService/Services/" .. name .. ".lua"), name, "t", setmetatable({
		game = { GetService = function(_, service) return assert(services[service], service) end },
		require = function(value) return value end,
		script = { Parent = { PaidItemPolicy = { CanTransfer = function() return true end } } },
		task = { delay = function() end },
	}, { __index = getfenv() })))()
end
local grant = loadService("ItemGrantUtil")
local granted = assert(grant.Grant(sender, "Best"))
assert(published[sender] == 100, "Successful grants must immediately publish the new baseline")
local tool = sender:FindFirstChildOfClass("Backpack"):GetChildren()[1]
tool.Parent = sender.Character

assert(modules.HeldGiftFeatureConfig.Enabled == false, "Held fish gifts must start disabled")
local disabledGifts = loadService("GiftService")
disabledGifts:KnitInit()
local originalRecord = profiles[sender].Data.Items[granted.InstanceId]
local senderBackpack = sender:FindFirstChildOfClass("Backpack")
local recipientBackpack = recipient:FindFirstChildOfClass("Backpack")

disabledGifts.Client.SetHeldItem:Emit(sender, "item", granted.InstanceId)
disabledGifts.Client.RequestGift:Emit(sender, recipient.UserId)
disabledGifts.Client.RespondGift:Emit(recipient, 1, true)

local refusal = assert(disabledGifts.Client.GiftResult.last)
assert(refusal[1] == sender and refusal[2] == false and refusal[3] == "Fish gifting is temporarily disabled.")
assert(#disabledGifts.Client:GetHeldItems(sender) == 0)
assert(not disabledGifts.Client.GiftRequestReceived.last and not disabledGifts.Client.GiftReceived.last)
assert(profiles[sender].Data.Items[granted.InstanceId] == originalRecord and not next(profiles[recipient].Data.Items))
assert(tool.Parent == sender.Character and #senderBackpack:GetChildren() == 0 and #recipientBackpack:GetChildren() == 0)
assert(hotbarRemovals == 0 and refreshes == 1)

modules.HeldGiftFeatureConfig = { Enabled = true }
local gifts = loadService("GiftService")
gifts:KnitInit()
local function gift()
	gifts.Client.SetHeldItem:Emit(sender, "item", granted.InstanceId)
	gifts.Client.RequestGift:Emit(sender, recipient.UserId)
	local request = assert(gifts.Client.GiftRequestReceived.last)
	gifts.Client.RespondGift:Emit(recipient, request[2], true)
end
failRecipient = true
gift()
assert(profiles[sender].Data.Items[granted.InstanceId] and not profiles[recipient].Data.Items[granted.InstanceId])
assert(published[sender] == 100 and published[recipient] == 1,
	"Failed gifts must restore ownership before refreshing both baselines")
assert(refreshes == 3)
failRecipient = false
sender:FindFirstChildOfClass("Backpack"):GetChildren()[1].Parent = sender.Character
gift()
assert(not profiles[sender].Data.Items[granted.InstanceId] and profiles[recipient].Data.Items[granted.InstanceId])
assert(published[sender] == 1 and published[recipient] == 100,
	"Successful gifts must lower the sender baseline and raise the recipient baseline")

recipient:FindFirstChildOfClass("Backpack"):GetChildren()[1].Parent = recipient.Character
local sale = loadService("SellService"):SellHeldItem(recipient)
assert(sale.success and published[recipient] == 1 and profiles[recipient].Data.Wins == 10,
	"Sales refresh the Event baseline without changing the fixed sale price")
