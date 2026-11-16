-- Shared inventory rules. All mutation is performed by the server.
local PetInventory = { MAX_EQUIPPED = 3, MAX_STORED = 100 }
local LUCK_MULTIPLIERS = { [0] = 1, [1] = 1.5, [2] = 2 }
local MODEL_SCALES = { [0] = 1, [1] = 1.5, [2] = 2.2 }
PetInventory.SIZE_ICONS = { [0] = "", [1] = "rbxassetid://16787482519", [2] = "rbxassetid://16787524702" }

function PetInventory.GetSize(pet)
	local size = pet.Size
	if type(size) ~= "number" or size ~= size or math.abs(size) == math.huge then
		return 0
	end
	return math.clamp(math.floor(size), 0, 2)
end

function PetInventory.GetModelScale(pet)
	return MODEL_SCALES[PetInventory.GetSize(pet)]
end

function PetInventory.GetLuckBoost(pet, configs)
	local config = configs[pet.PetID]
	return if config
		then math.max(0, tonumber(config.LuckBoost) or 0) * LUCK_MULTIPLIERS[PetInventory.GetSize(pet)]
		else 0
end

function PetInventory.Reconcile(data, configs)
	data.Pets = if type(data.Pets) == "table" then data.Pets else {}
	data.PetIndex = if type(data.PetIndex) == "table" then data.PetIndex else {}
	local ids = {}
	for uuid, pet in pairs(data.Pets) do
		if type(uuid) ~= "string" or type(pet) ~= "table" or not configs[pet.PetID] then
			data.Pets[uuid] = nil
		else
			pet.UUID, pet.Equipped, pet.Locked = uuid, pet.Equipped == true, pet.Locked == true
			pet.Size = PetInventory.GetSize(pet)
			data.PetIndex[pet.PetID] = true
			table.insert(ids, uuid)
		end
	end
	table.sort(ids)
	local equipped = 0
	for _, uuid in ipairs(ids) do
		local pet = data.Pets[uuid]
		if pet.Equipped then
			equipped += 1
			pet.Equipped = equipped <= PetInventory.MAX_EQUIPPED
		end
	end
end

function PetInventory.Count(pets)
	local count = 0
	for _ in pairs(pets or {}) do
		count += 1
	end
	return count
end

function PetInventory.GetEquipped(data)
	local pets = {}
	for _, pet in pairs(data.Pets or {}) do
		if pet.Equipped then
			table.insert(pets, pet)
		end
	end
	table.sort(pets, function(a, b)
		return a.UUID < b.UUID
	end)
	return pets
end

function PetInventory.GetLuckMultiplier(data, configs)
	local multiplier = 1
	for _, pet in ipairs(PetInventory.GetEquipped(data)) do
		multiplier += PetInventory.GetLuckBoost(pet, configs)
	end
	return multiplier
end

function PetInventory.Give(data, configs, petId, uuid)
	if not configs[petId] then
		return nil, "Unknown pet"
	end
	if PetInventory.Count(data.Pets) >= PetInventory.MAX_STORED then
		return nil, "Pet storage is full"
	end
	if data.Pets[uuid] then
		return nil, "Pet already exists"
	end
	local pet = { UUID = uuid, PetID = petId, Equipped = next(data.Pets) == nil, Locked = false, Size = 0 }
	data.Pets[uuid] = pet
	data.PetIndex[petId] = true
	return pet
end

function PetInventory.Equip(data, uuid, equipped)
	local pet = data.Pets[uuid]
	if not pet then
		return false, "Pet not found"
	end
	if equipped and not pet.Equipped and #PetInventory.GetEquipped(data) >= PetInventory.MAX_EQUIPPED then
		return false, "You can equip 3 pets"
	end
	pet.Equipped = equipped
	return true
end

function PetInventory.EquipBest(data, configs)
	local pets = {}
	for _, pet in pairs(data.Pets) do
		table.insert(pets, pet)
	end
	table.sort(pets, function(a, b)
		local left, right = PetInventory.GetLuckBoost(a, configs), PetInventory.GetLuckBoost(b, configs)
		if left ~= right then
			return left > right
		end
		if a.Equipped ~= b.Equipped then
			return a.Equipped
		end
		return a.UUID < b.UUID
	end)
	for index, pet in ipairs(pets) do
		pet.Equipped = index <= PetInventory.MAX_EQUIPPED
	end
end

function PetInventory.Delete(data, uuid)
	local pet = data.Pets[uuid]
	if not pet then
		return false, "Pet not found"
	end
	if pet.Locked then
		return false, "Unlock this pet before deleting it"
	end
	data.Pets[uuid] = nil
	return true
end

local function candidates(data, pet)
	local result = {}
	if pet.Locked then
		return result
	end
	for _, other in pairs(data.Pets) do
		if
			not other.Locked
			and other.PetID == pet.PetID
			and PetInventory.GetSize(other) == PetInventory.GetSize(pet)
		then
			table.insert(result, other)
		end
	end
	return result
end

function PetInventory.GetCraftCount(data, pet)
	return #candidates(data, pet)
end

function PetInventory.Craft(data, uuid, expectedSize)
	local pet = data.Pets[uuid]
	if not pet then
		return false, "Pet not found"
	end
	if pet.Locked then
		return false, "Unlock this pet before crafting it"
	end
	local size = PetInventory.GetSize(pet)
	if size >= 2 then
		return false, "Max Size reached!"
	end
	if expectedSize ~= size then
		return false, "Pet size changed; select it again"
	end
	local materials = {}
	for _, other in ipairs(candidates(data, pet)) do
		if other.UUID ~= uuid then
			table.insert(materials, other)
		end
	end
	if #materials < 2 then
		return false, "Not enough pets!"
	end
	table.sort(materials, function(a, b)
		if a.Equipped ~= b.Equipped then
			return not a.Equipped
		end
		return a.UUID < b.UUID
	end)
	-- Validate first, then commit without yielding. Keep the surviving identity and equipment.
	data.Pets[materials[1].UUID], data.Pets[materials[2].UUID] = nil, nil
	pet.Size = size + 1
	return true
end

function PetInventory.CraftAll(data)
	local crafted = 0
	for size = 0, 1 do
		local ids, seen = {}, {}
		for _, pet in pairs(data.Pets) do
			if not seen[pet.PetID] then
				seen[pet.PetID] = true
				table.insert(ids, pet.PetID)
			end
		end
		table.sort(ids)
		for _, id in ipairs(ids) do
			while true do
				local group = {}
				for _, pet in pairs(data.Pets) do
					if pet.PetID == id and not pet.Locked and PetInventory.GetSize(pet) == size then
						table.insert(group, pet)
					end
				end
				if #group < 3 then
					break
				end
				table.sort(group, function(a, b)
					if a.Equipped ~= b.Equipped then
						return a.Equipped
					end
					return a.UUID < b.UUID
				end)
				local ok = PetInventory.Craft(data, group[1].UUID, size)
				if not ok then
					break
				end
				crafted += 1
			end
		end
	end
	return crafted
end

return PetInventory
