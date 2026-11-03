-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
RunService:IsServer()
RunService:IsClient()
require(ReplicatedStorage.Packages.Replion)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local t = {
	DATA_VERSION = 24,
	DATA_TEMPLATE = "Data",
	MOCK_DATA = false,
	ClickDelay = 0.14,
	CooldownTime = 1,
	FishingRange = 80,
	AutoFishingLevel = 0,
	MaxInventorySize = 4500,
	MaxItemSize = 400,
	RodSize = 800,
	EnchantingLevel = 10,
	SecondEnchantingLevel = 200,
	TradingLevel = 20,
	AquariumLevel = 50,
	FishingDistance = 125,
	GameVersion = 44,
	StoreNotification = 44,
	AutoSellTiers = { 5, 6, 7 },
	Flags = {
		NewYears = 1767204600,
		NewYearsPad = 1767330000,
		EidMubarak = 1774137600,
		EidMubarakPad = 1774656000,
		EasterEndTime = 1777161600,
		RetroEndTime = 1779580800,
		WeeklyLimitedEndTime = 1780790400,
		OldWeeklyLimitedEndTime = 1780185600,
		ValentineEndTime = 1772323200
	},
	GetClickTiming = function(p1, p2, p3) --[[ GetClickTiming | Line: 65 ]]
		local _ = p3 and p3.ClickPowerMultiplier
		return 0.19
	end,
	CountRodSize = function(p1, p2) --[[ CountRodSize | Line: 89 ]]
		if p2 and not p2.Destroyed then
			return #p2:GetExpect({ "Inventory", "Fishing Rods" })
		else
			return 0
		end
	end,
	CountInventorySize = function(p1, p2) --[[ CountInventorySize | Line: 100 | Upvalues: ItemUtility (copy) ]]
		if not p2 or p2.Destroyed then
			return 0, 0
		end
		local v1 = p2:GetExpect("Inventory")
		local t = { "Gears", "Enchant Stones", "Trophies" }
		local count = 0
		local count_2 = 0
		for i, v in ipairs(v1.Items) do
			local v2 = ItemUtility:GetItemData(v.Id)
			if v2 then
				local Type = v2.Data.Type
				if Type == "Fish" then
					count_2 = count_2 + 1
					continue
				end
				if table.find(t, Type) then
					count = count + 1
				end
			end
		end
		return count_2, count + #v1.Totems + #v1.Potions
	end,
	GetPower = function(p1, p2) --[[ GetPower | Line: 138 ]]
		local v1 = Random.new(p2):NextInteger(4, 10)
		return (1 - math.sin(1.5707963267948966 + (workspace:GetServerTimeNow() - p2) * v1)) / 2
	end
}
if game.GameId == 6902403037 then
	local ClickDelay = t.ClickDelay
	local CooldownTime = t.CooldownTime
	local function updateTestServerMode() --[[ updateTestServerMode | Line: 155 | Upvalues: t (copy), ClickDelay (copy), CooldownTime (copy) ]]
		local v2 = if workspace:GetAttribute("__GOD_MODE") and game.GameId == 6902403037 then 0.2 else 1
		t.ClickDelay = ClickDelay * v2
		t.CooldownTime = CooldownTime * v2
	end
	local v2 = if workspace:GetAttribute("__GOD_MODE") and game.GameId == 6902403037 then 0.2 else 1
	t.ClickDelay = ClickDelay * v2
	t.CooldownTime = CooldownTime * v2
	workspace:GetAttributeChangedSignal("__GOD_MODE"):Connect(function() --[[ Line: 164 | Upvalues: t (copy), ClickDelay (copy), CooldownTime (copy) ]]
		local v2 = if workspace:GetAttribute("__GOD_MODE") and game.GameId == 6902403037 then 0.2 else 1
		t.ClickDelay = ClickDelay * v2
		t.CooldownTime = CooldownTime * v2
	end)
end
return t