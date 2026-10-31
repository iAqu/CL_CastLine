local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local BackpacksData = require(ReplicatedFirst.Data.BackpacksData)
local CarryCapacityUtil = require(ReplicatedStorage.Modules.CarryCapacityUtil)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)

local BACKPACKS_FOLDER_NAME = "Backpacks"
local AUTO_EQUIPPED_ATTRIBUTE = "AutoEquippedBackpack"
local AUTO_EQUIPPED_MODEL_ATTRIBUTE = "AutoEquippedBackpackModel"
local LEGACY_TEST_BACKPACK_NAME = "TestBackpack"

local BackpackVisualService = Knit.CreateService({
	Name = "BackpackVisualService",
	Client = {},
})

local function getConfigForCapacity(capacity: number)
	local selectedConfig = nil
	local selectedCarryWeight = -math.huge

	for _, config in pairs(BackpacksData) do
		local carryWeight = tonumber(config.CarryWeight)
		if carryWeight and carryWeight <= capacity and carryWeight > selectedCarryWeight then
			selectedConfig = config
			selectedCarryWeight = carryWeight
		end
	end

	return selectedConfig
end

local function getBackpackTemplate(modelName: string): Accessory?
	local models = ReplicatedStorage:FindFirstChild("Models")
	local backpacks = models and models:FindFirstChild(BACKPACKS_FOLDER_NAME)
	local backpack = backpacks and backpacks:FindFirstChild(modelName)
	if not backpack or not backpack:IsA("Accessory") then
		warn(`BackpackVisualService: ReplicatedStorage.Models.Backpacks.{modelName} is missing or not an Accessory`)
		return nil
	end

	return backpack
end

local function unanchorBackpackParts(backpack: Accessory)
	for _, descendant in ipairs(backpack:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.Anchored = false
		end
	end
end

local function removeAutoEquippedBackpacks(character: Model)
	for _, child in ipairs(character:GetChildren()) do
		if child:IsA("Accessory")
			and (child:GetAttribute(AUTO_EQUIPPED_ATTRIBUTE) == true or child.Name == LEGACY_TEST_BACKPACK_NAME)
		then
			child:Destroy()
		end
	end
end

local function hasSelectedBackpack(character: Model, modelName: string): boolean
	for _, child in ipairs(character:GetChildren()) do
		if child:IsA("Accessory")
			and child:GetAttribute(AUTO_EQUIPPED_ATTRIBUTE) == true
			and child:GetAttribute(AUTO_EQUIPPED_MODEL_ATTRIBUTE) == modelName
		then
			return true
		end
	end

	return false
end

function BackpackVisualService:RefreshPlayer(player: Player)
	local profile = PlayerDataService:GetProfile(player)
	local character = player.Character
	if not profile or not character then
		return
	end

	local capacity = CarryCapacityUtil.GetCapacity(profile.Data)
	local config = getConfigForCapacity(capacity)
	if not config then
		removeAutoEquippedBackpacks(character)
		return
	end

	local modelName = config.Model
	if typeof(modelName) ~= "string" or modelName == "" then
		warn(`BackpackVisualService: Backpack config for {config.BackpackID or "unknown"} has no Model name`)
		return
	end

	if hasSelectedBackpack(character, modelName) then
		return
	end

	local template = getBackpackTemplate(modelName)
	if not template then
		return
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5)
	if not humanoid or not humanoid:IsA("Humanoid") then
		warn("BackpackVisualService: Humanoid missing for " .. character:GetFullName())
		return
	end

	removeAutoEquippedBackpacks(character)
	local backpack = template:Clone()
	backpack:SetAttribute(AUTO_EQUIPPED_ATTRIBUTE, true)
	backpack:SetAttribute(AUTO_EQUIPPED_MODEL_ATTRIBUTE, modelName)
	unanchorBackpackParts(backpack)

	local success, err = pcall(function()
		humanoid:AddAccessory(backpack)
	end)
	if not success then
		backpack:Destroy()
		warn("BackpackVisualService: Failed to attach " .. modelName .. " to " .. character:GetFullName() .. ": " .. tostring(err))
	end
end

local function bindPlayer(player: Player)
	player.CharacterAdded:Connect(function()
		BackpackVisualService:RefreshPlayer(player)
	end)
	if player.Character then
		task.spawn(function()
			BackpackVisualService:RefreshPlayer(player)
		end)
	end
end

function BackpackVisualService:KnitStart()
	Players.PlayerAdded:Connect(bindPlayer)
	for _, player in ipairs(Players:GetPlayers()) do
		bindPlayer(player)
	end
end

return BackpackVisualService
