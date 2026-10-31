local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)
local Constants = require(ReplicatedStorage.Modules.Constants)
local PotionFeatureHelper = require(ReplicatedStorage.Modules.PotionFeatureHelper)
local PotionToolUtil = require(ReplicatedStorage.Modules.PotionToolUtil)

local PotionService = Knit.CreateService({
	Name = "PotionService",
	Client = {
		UpdatePotionCount = Knit.CreateSignal(),
		UsePotion = Knit.CreateSignal(),
		EquipPotion = Knit.CreateSignal(),
		PotionApplied = Knit.CreateSignal(),
		UsePotionFailed = Knit.CreateSignal(),
	},
})

local REMOVED_POTION_IDS = {
	"Potion_Golden", "Potion_Rainbow", "Potion_SuperLucky", "Potion_DoubleStrength", "Potion_DoubleDamage",
}
local REMOVED_POTION_REPLACEMENTS = {
	Potion_Golden = Constants.POTION_ID.MUTATION,
	Potion_Rainbow = Constants.POTION_ID.MUTATION,
	Potion_SuperLucky = Constants.POTION_ID.MUTATION,
	Potion_DoubleStrength = Constants.POTION_ID.MUTATION,
	Potion_DoubleDamage = Constants.POTION_ID.MUTATION,
}
local SUPPORTED_POTIONS = {
	[Constants.POTION_ID.DOUBLE_WINS] = true,
	[Constants.POTION_ID.DOUBLE_WINS_SPEED] = true,
	[Constants.POTION_ID.DOUBLE_EXP] = true,
	[Constants.POTION_ID.MUTATION] = true,
}

local function failUse(service, player: Player, message: string)
	service.Client.UsePotionFailed:Fire(player, message)
end

local function getPotionData(playerData, potionId: string)
	if not SUPPORTED_POTIONS[potionId] then
		return nil
	end
	if not playerData.Potions[potionId] then
		playerData.Potions[potionId] = { Count = 0, LastTime = 0 }
	end
	return playerData.Potions[potionId]
end

local function findPotionTool(container: Instance?, potionId: string): Tool?
	if not container then return nil end
	for _, child in ipairs(container:GetChildren()) do
		if PotionToolUtil.IsPotionTool(child) and PotionToolUtil.GetPotionId(child) == potionId then
			return child
		end
	end
	return nil
end

local function syncPotionTool(player: Player, potionId: string, count: number)
	local backpack = player:FindFirstChildOfClass("Backpack") or player:WaitForChild("Backpack", 5)
	local existing = findPotionTool(backpack, potionId) or findPotionTool(player.Character, potionId)
	if count <= 0 then
		if existing then existing:Destroy() end
		return
	end
	if not existing then
		if not backpack or not backpack:IsA("Backpack") then
			warn("PotionService: Backpack missing, cannot create potion tool", potionId)
			return
		end
		existing = PotionToolUtil.CreateTool(potionId, count)
		if not existing then return end
		existing.Parent = backpack
	end
	PotionToolUtil.SetCount(existing, count)
end

local function syncAllPotionTools(player: Player, data)
	for potionId, potion in pairs(data.Potions or {}) do
		syncPotionTool(player, potionId, potion.Count or 0)
	end
end

function PotionService:AdjustPotionCount(player: Player, potionId: string, amount: number, allowDisabledPotionGrant: boolean?): boolean
	if amount > 0 and not allowDisabledPotionGrant and not PotionFeatureHelper.IsAcquisitionEnabled() then
		return false
	end
	potionId = REMOVED_POTION_REPLACEMENTS[potionId] or potionId
	local profile = PlayerDataService:GetProfile(player)
	if not profile then return false end
	local potionData = getPotionData(profile.Data, potionId)
	if not potionData then return false end
	potionData.Count = math.max(0, potionData.Count + amount)
	syncPotionTool(player, potionId, potionData.Count)
	self.Client.UpdatePotionCount:Fire(player, potionId, potionData.Count)
	return true
end

function PotionService:UsePotion(player: Player, _potionId: string, _targetUuid: string?)
	failUse(self, player, "This potion is unavailable.")
end

function PotionService:EquipPotion(player: Player, potionId: string)
	local profile = PlayerDataService:GetProfile(player)
	local potion = profile and getPotionData(profile.Data, potionId)
	if not potion or potion.Count <= 0 then
		failUse(self, player, "You don't have this potion.")
		return
	end
	local tool = findPotionTool(player:FindFirstChildOfClass("Backpack"), potionId)
	if tool and player.Character then
		tool.Parent = player.Character
	end
end

function PotionService:KnitStart()
	self.Client.UsePotion:Connect(function(player: Player, potionId: string, targetUuid: string?)
		self:UsePotion(player, potionId, targetUuid)
	end)
	self.Client.EquipPotion:Connect(function(player: Player, potionId: string)
		self:EquipPotion(player, potionId)
	end)
	PlayerDataService.ProfileLoaded:Connect(function(player, data)
		for _, potionId in ipairs(REMOVED_POTION_IDS) do
			data.Potions[potionId] = nil
		end
		for potionId, potion in pairs(data.Potions) do
			if SUPPORTED_POTIONS[potionId] and typeof(potion) == "table" then
				potion.LastTime = 0
			end
		end
		task.spawn(syncAllPotionTools, player, data)
		player.CharacterAdded:Connect(function()
			task.spawn(syncAllPotionTools, player, data)
		end)
	end)
end

return PotionService
