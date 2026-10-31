local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)
local Constants = require(ReplicatedStorage.Modules.Constants)
local UpgradeShopConfig = require(ReplicatedStorage.Modules.UpgradeShopConfig)

local UpgradeService = Knit.CreateService {
    Name = "UpgradeService",
    Client = {
        Upgrade = Knit.CreateSignal(),
    },
	_Purchasing = {} :: { [Player]: boolean },
}

local function result(ok: boolean, message: string, newLevel: number?, price: number?)
	return {
		ok = ok,
		message = message,
		newLevel = newLevel,
		price = price,
	}
end

local function isValidLevel(level: unknown): boolean
	return typeof(level) == "number"
		and level == level
		and level ~= math.huge
		and level ~= -math.huge
		and level >= 0
		and level % 1 == 0
end

function UpgradeService:_applyUpgradeLevel(
	player: Player,
	profile,
	upgradeId: string,
	newLevel: number,
	message: string,
	price: number?
)
	if typeof(profile.Data.Upgrades) ~= "table" then
		profile.Data.Upgrades = {}
	end
	profile.Data.Upgrades[upgradeId] = newLevel

	if upgradeId == Constants.UPGRADE_ID.MOVE_SPEED then
		Knit.GetService("MovementSpeedService"):RefreshPlayer(player)
	elseif upgradeId == Constants.UPGRADE_ID.CARRY_WEIGHT then
		Knit.GetService("CarryCapacityService"):RefreshPlayer(player)
	end

	self.Client.Upgrade:Fire(player, upgradeId, true, message, newLevel)
	return result(true, message, newLevel, price)
end

function UpgradeService:SetUpgradeLevel(player: Player, upgradeId: unknown, level: unknown)
	if not UpgradeShopConfig.IsValidUpgradeId(upgradeId) then
		return result(false, "Invalid upgrade")
	end
	if not isValidLevel(level) then
		return result(false, "Level must be a non-negative whole number")
	end
	if self._Purchasing[player] then
		return result(false, "Purchase already in progress")
	end

	local profile = PlayerDataService:GetProfile(player)
	if not profile then
		return result(false, "Player data is unavailable")
	end

	local typedUpgradeId = upgradeId :: string
	local typedLevel = level :: number
	return self:_applyUpgradeLevel(
		player,
		profile,
		typedUpgradeId,
		typedLevel,
		`Set {typedUpgradeId} to level {typedLevel}`,
		0
	)
end

function UpgradeService:PurchaseUpgrade(player: Player, upgradeId: unknown, amount: unknown)
	if not UpgradeShopConfig.IsValidUpgradeId(upgradeId)
		or not UpgradeShopConfig.IsValidBundleAmount(amount)
	then
		return result(false, "Invalid upgrade")
	end
	if self._Purchasing[player] then
		return result(false, "Purchase already in progress")
	end
	self._Purchasing[player] = true

    local profile = PlayerDataService:GetProfile(player)
    if not profile then
		self._Purchasing[player] = nil
		return result(false, "Player data is unavailable")
	end
	if typeof(profile.Data.Upgrades) ~= "table" then
		profile.Data.Upgrades = {}
	end

	local typedUpgradeId = upgradeId :: string
	local typedAmount = amount :: number
	local currentUpgradeLevel = UpgradeShopConfig.GetLevel(profile.Data, typedUpgradeId)
	local price = UpgradeShopConfig.GetBundlePrice(typedUpgradeId, currentUpgradeLevel, typedAmount)
    if price > 0 then
        local canSpend, message = Knit.GetService("TutorialService"):CanSpendWins(player)
        if not canSpend then
			self._Purchasing[player] = nil
			return result(false, message)
        end
    end
    if profile.Data.Wins < price then
		self._Purchasing[player] = nil
		return result(false, Constants.NOTIFICATION_NO_ENOUGH_WIN)
	end

	local newUpgradeLevel = currentUpgradeLevel + typedAmount
    PlayerDataService:AdjustWins(player, -price)

	local message = `Upgraded +{typedAmount}`
	local purchaseResult = self:_applyUpgradeLevel(player, profile, typedUpgradeId, newUpgradeLevel, message, price)
	if typedUpgradeId == Constants.UPGRADE_ID.CARRY_WEIGHT then
		Knit.GetService("TutorialService"):OnBackpackUpgraded(player)
	end
	self._Purchasing[player] = nil
	return purchaseResult
end

function UpgradeService.Client:PurchaseUpgrade(player: Player, upgradeId: string, amount: number)
	return self.Server:PurchaseUpgrade(player, upgradeId, amount)
end

function UpgradeService:KnitStart()
	-- 兼容旧客户端的一档升级请求；新商店使用 PurchaseUpgrade RemoteFunction。
    self.Client.Upgrade:Connect(function(player: Player, upgradeId: string)
        self:PurchaseUpgrade(player, upgradeId, 1)
    end)
end


return UpgradeService
