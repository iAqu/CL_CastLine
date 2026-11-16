local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Inventory = require(ReplicatedStorage.Modules.PetInventory)
local PetFeatureConfig = require(ReplicatedStorage.Modules.PetFeatureConfig)
local PetsData = require(ReplicatedFirst.Data.PetsData)
local PlayerDataService = require(script.Parent.PlayerDataService)

local PetService = Knit.CreateService({
	Name = "PetService",
	Client = {
		InventoryChanged = Knit.CreateSignal(),
		EquippedChanged = Knit.CreateSignal(),
	},
})

local function copyRecords(records)
	local result = {}
	for key, record in pairs(records) do
		result[key] = if type(record) == "table" then table.clone(record) else record
	end
	return result
end

function PetService:GetState(player)
	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		return nil
	end
	return {
		Pets = copyRecords(profile.Data.Pets),
		PetIndex = table.clone(profile.Data.PetIndex),
		LuckMultiplier = self:GetLuckMultiplier(player),
		MaxEquipped = Inventory.MAX_EQUIPPED,
		MaxStored = Inventory.MAX_STORED,
	}
end

function PetService:_changed(player)
	if not PetFeatureConfig.Enabled then return end
	local state = self:GetState(player)
	if not state then
		return
	end
	self.Client.InventoryChanged:Fire(player, state)
	self.Client.EquippedChanged:FireAll(player.UserId, Inventory.GetEquipped(state))
end

function PetService:GivePet(player, petId)
	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		return nil, "Your data is still loading"
	end
	local pet, err = Inventory.Give(profile.Data, PetsData, petId, HttpService:GenerateGUID(false))
	if pet then
		self:_changed(player)
	end
	return pet, err
end

function PetService:GetLuckMultiplier(player)
	if not PetFeatureConfig.Enabled then return 1 end
	local profile = PlayerDataService:GetProfile(player)
	return if profile then Inventory.GetLuckMultiplier(profile.Data, PetsData) else 1
end

function PetService.Client:GetState(player)
	if not PetFeatureConfig.Enabled then
		return { Pets = {}, PetIndex = {}, LuckMultiplier = 1, MaxEquipped = Inventory.MAX_EQUIPPED, MaxStored = Inventory.MAX_STORED }
	end
	return self.Server:GetState(player)
end

function PetService.Client:GetAllPlayersEquippedPets(_player)
	if not PetFeatureConfig.Enabled then return {} end
	local result = {}
	for _, player in ipairs(Players:GetPlayers()) do
		local state = self.Server:GetState(player)
		if state then
			result[tostring(player.UserId)] = Inventory.GetEquipped(state)
		end
	end
	return result
end

function PetService.Client:EquipPet(player, uuid, equipped)
	if not PetFeatureConfig.Enabled then return { ok = false, message = PetFeatureConfig.DisabledMessage } end
	if typeof(uuid) ~= "string" or typeof(equipped) ~= "boolean" then
		return { ok = false, message = "Invalid request" }
	end
	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		return { ok = false, message = "Your data is still loading" }
	end
	local ok, message = Inventory.Equip(profile.Data, uuid, equipped)
	if ok then
		self.Server:_changed(player)
	end
	return { ok = ok, message = message }
end

function PetService.Client:EquipBest(player)
	if not PetFeatureConfig.Enabled then return false end
	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		return false
	end
	Inventory.EquipBest(profile.Data, PetsData)
	self.Server:_changed(player)
	return true
end

function PetService.Client:UnequipAll(player)
	if not PetFeatureConfig.Enabled then return false end
	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		return false
	end
	for _, pet in pairs(profile.Data.Pets) do
		pet.Equipped = false
	end
	self.Server:_changed(player)
	return true
end

function PetService.Client:LockPet(player, uuid, locked)
	if not PetFeatureConfig.Enabled then return false end
	if typeof(uuid) ~= "string" or typeof(locked) ~= "boolean" then
		return false
	end
	local profile = PlayerDataService:GetProfile(player)
	local pet = profile and profile.Data.Pets[uuid]
	if not pet then
		return false
	end
	pet.Locked = locked
	self.Server:_changed(player)
	return true
end

function PetService.Client:LockPets(player, uuids)
	if not PetFeatureConfig.Enabled then return { ok = false, message = PetFeatureConfig.DisabledMessage } end
	if typeof(uuids) ~= "table" then
		return { ok = false, message = "Invalid lock request" }
	end
	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		return { ok = false, message = "Your data is still loading" }
	end
	local selected, count = {}, 0
	-- Validate the complete array before changing any lock, including unlocks.
	for index, uuid in pairs(uuids) do
		count += 1
		if
			type(index) ~= "number"
			or index % 1 ~= 0
			or index < 1
			or index > #uuids
			or count > Inventory.MAX_STORED
			or typeof(uuid) ~= "string"
			or not profile.Data.Pets[uuid]
		then
			return { ok = false, message = "Pet selection changed; try again" }
		end
		selected[uuid] = true
	end
	if count ~= #uuids then
		return { ok = false, message = "Invalid lock request" }
	end
	for uuid, pet in pairs(profile.Data.Pets) do
		pet.Locked = selected[uuid] == true
	end
	self.Server:_changed(player)
	return { ok = true }
end

function PetService.Client:DeletePets(player, uuids)
	if not PetFeatureConfig.Enabled then return { ok = false, message = PetFeatureConfig.DisabledMessage, deleted = 0 } end
	if typeof(uuids) ~= "table" or #uuids > Inventory.MAX_STORED then
		return { ok = false, message = "Invalid request" }
	end
	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		return { ok = false, message = "Your data is still loading" }
	end
	local deleted = 0
	for _, uuid in ipairs(uuids) do
		local pet = if typeof(uuid) == "string" then profile.Data.Pets[uuid] else nil
		if pet and not pet.Equipped and not pet.Locked and Inventory.Delete(profile.Data, uuid) then
			deleted += 1
		end
	end
	if deleted > 0 then
		self.Server:_changed(player)
	end
	return {
		ok = deleted > 0,
		message = if deleted == 0 then "No unequipped, unlocked pets selected" else nil,
		deleted = deleted,
	}
end

function PetService.Client:CraftPet(player, uuid, expectedSize)
	if not PetFeatureConfig.Enabled then return { ok = false, message = PetFeatureConfig.DisabledMessage, craftedCount = 0 } end
	if typeof(uuid) ~= "string" or (expectedSize ~= 0 and expectedSize ~= 1) then
		return { ok = false, message = "Invalid craft request", craftedCount = 0 }
	end
	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		return { ok = false, message = "Your data is still loading", craftedCount = 0 }
	end
	local ok, message = Inventory.Craft(profile.Data, uuid, expectedSize)
	if ok then
		self.Server:_changed(player)
	end
	return { ok = ok, message = message, craftedCount = if ok then 1 else 0 }
end

function PetService.Client:CraftAllPets(player)
	if not PetFeatureConfig.Enabled then return { ok = false, message = PetFeatureConfig.DisabledMessage, craftedCount = 0 } end
	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		return { ok = false, message = "Your data is still loading", craftedCount = 0 }
	end
	local count = Inventory.CraftAll(profile.Data)
	if count > 0 then
		self.Server:_changed(player)
	end
	return { ok = count > 0, craftedCount = count, message = if count == 0 then "Not enough pets to craft" else nil }
end

function PetService:KnitStart()
	if not PetFeatureConfig.Enabled then return end
	PlayerDataService.ProfileLoaded:Connect(function(player)
		self:_changed(player)
	end)
	Players.PlayerRemoving:Connect(function(player)
		self.Client.EquippedChanged:FireAll(player.UserId, {})
	end)
	for _, player in ipairs(Players:GetPlayers()) do
		self:_changed(player)
	end
end

return PetService
