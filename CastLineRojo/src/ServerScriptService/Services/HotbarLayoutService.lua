local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)

local FIRST_ITEM_SLOT = 1
local LAST_ITEM_SLOT = 10
local HOTBAR_SLOT_COUNT = 10

local HotbarLayoutService = Knit.CreateService({
	Name = "HotbarLayoutService",
	Client = {
		HotbarLayoutChanged = Knit.CreateSignal(),
	},
})

local VALID_KINDS = { Potion = true, Item = true }

local function cloneLayout(layout)
	local clone = {}
	for slot, descriptor in pairs(layout) do
		clone[slot] = { Kind = descriptor.Kind, Id = descriptor.Id }
	end
	return clone
end

local function isOwnedDescriptor(data, descriptor, usages)
	if descriptor.Kind == "Potion" then
		if usages.Potion[descriptor.Id] then return false end
		local potion = data.Potions and data.Potions[descriptor.Id]
		if potion and typeof(potion.Count) == "number" and potion.Count > 0 then
			usages.Potion[descriptor.Id] = true
			return true
		end
		return false
	end
	if descriptor.Kind == "Item" then
		if usages.Item[descriptor.Id] then return false end
		if data.Items and typeof(data.Items[descriptor.Id]) == "table" then
			usages.Item[descriptor.Id] = true
			return true
		end
	end
	return false
end

local function normalizeLayout(data, layout)
	local ordered = {}
	for rawSlot, descriptor in pairs(layout) do
		local slot = tonumber(rawSlot)
		if slot and slot % 1 == 0 and slot >= 1 and slot <= HOTBAR_SLOT_COUNT
			and typeof(descriptor) == "table" and VALID_KINDS[descriptor.Kind] and typeof(descriptor.Id) == "string"
		then
			table.insert(ordered, { Slot = slot, Descriptor = { Kind = descriptor.Kind, Id = descriptor.Id } })
		end
	end
	table.sort(ordered, function(left, right)
		local leftPriority = if left.Slot >= FIRST_ITEM_SLOT and left.Slot <= LAST_ITEM_SLOT then left.Slot else 100 + left.Slot
		local rightPriority = if right.Slot >= FIRST_ITEM_SLOT and right.Slot <= LAST_ITEM_SLOT then right.Slot else 100 + right.Slot
		return leftPriority < rightPriority
	end)

	local result = {}
	local usages = { Potion = {}, Item = {} }
	local function firstFree()
		for slot = FIRST_ITEM_SLOT, LAST_ITEM_SLOT do
			if not result[tostring(slot)] then return slot end
		end
		return nil
	end

	for _, entry in ipairs(ordered) do
		if isOwnedDescriptor(data, entry.Descriptor, usages) then
			local target = entry.Slot
			if target < FIRST_ITEM_SLOT or target > LAST_ITEM_SLOT or result[tostring(target)] then
				target = firstFree()
			end
			if target then result[tostring(target)] = entry.Descriptor end
		end
	end
	return result
end

function HotbarLayoutService:NormalizeStoredLayout(player: Player)
	local profile = PlayerDataService:GetProfile(player)
	if not profile then return {} end
	local stored = if typeof(profile.Data.HotbarLayout) == "table" then profile.Data.HotbarLayout else {}
	local normalized = normalizeLayout(profile.Data, stored)
	profile.Data.HotbarLayout = normalized
	return normalized
end

function HotbarLayoutService:SaveHotbarLayout(player: Player, requestedLayout, visibleSlotCount: number): boolean
	if visibleSlotCount ~= HOTBAR_SLOT_COUNT or typeof(requestedLayout) ~= "table" then return false end
	local profile = PlayerDataService:GetProfile(player)
	if not profile then return false end
	local normalized = normalizeLayout(profile.Data, requestedLayout)
	profile.Data.HotbarLayout = normalized
	self.Client.HotbarLayoutChanged:Fire(player, cloneLayout(normalized))
	return true
end

function HotbarLayoutService:RemoveItemDescriptors(player: Player, itemIds: { string })
	local profile = PlayerDataService:GetProfile(player)
	if not profile or typeof(profile.Data.HotbarLayout) ~= "table" then return end
	local removed = {}
	for _, itemId in ipairs(itemIds) do removed[itemId] = true end
	if next(removed) == nil then return end

	local updated, changed = {}, false
	for slot, descriptor in pairs(profile.Data.HotbarLayout) do
		if typeof(descriptor) == "table" and descriptor.Kind == "Item" and removed[descriptor.Id] then
			changed = true
		else
			updated[slot] = descriptor
		end
	end
	if changed then
		profile.Data.HotbarLayout = updated
		self.Client.HotbarLayoutChanged:Fire(player, cloneLayout(updated))
	end
end

function HotbarLayoutService.Client:SaveHotbarLayout(player: Player, layout, visibleSlotCount: number): boolean
	return self.Server:SaveHotbarLayout(player, layout, visibleSlotCount)
end

return HotbarLayoutService
