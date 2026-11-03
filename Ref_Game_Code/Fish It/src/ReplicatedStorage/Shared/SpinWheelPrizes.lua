-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
return {
	Products = {
		[1] = 3378204619,
		[5] = 3378204784,
		[10] = 3378205021
	},
	RegularBag = {
		{
			SpotIndex = 4,
			Chance = 0.01,
			IsTopPrize = true,
			RewardData = {
				Currency = "ItemReward",
				NotificationMessage = "You got the Galactic Skin!",
				DisplayName = "Galactic Skin",
				CurrencyRewardInfo = RewardInfo.fishingRodReward("Galactic")
			}
		},
		{
			SpotIndex = 6,
			Chance = 0.13,
			RewardData = {
				Currency = "ItemReward",
				NotificationMessage = "You got x4 Luck I Potions!",
				DisplayName = "Luck I Potions",
				CurrencyRewardInfo = RewardInfo.potionReward("Luck I Potion", 4)
			}
		},
		{
			SpotIndex = 0,
			Chance = 0.33,
			RewardData = {
				Currency = "Coins",
				NotificationMessage = "You got 500 Coins!",
				DisplayName = "Small Coins",
				CurrencyRewardInfo = table.pack(500)
			}
		},
		{
			SpotIndex = 1,
			Chance = 0.22,
			RewardData = {
				Currency = "Coins",
				NotificationMessage = "You got 1,000 Coins!",
				DisplayName = "Medium Coins",
				CurrencyRewardInfo = table.pack(1000)
			}
		},
		{
			SpotIndex = 3,
			Chance = 0.1,
			RewardData = {
				Currency = "ItemReward",
				NotificationMessage = "You got x2 Enchant Stones!",
				DisplayName = "Enchant Stones",
				CurrencyRewardInfo = RewardInfo.enchantStoneReward("Enchant Stone", 2)
			}
		},
		{
			SpotIndex = 5,
			Chance = 0.13,
			RewardData = {
				Currency = "ItemReward",
				NotificationMessage = "You got x4 Mutation I Potions!",
				DisplayName = "Mutation I Potions",
				CurrencyRewardInfo = RewardInfo.potionReward("Mutation I Potion", 4)
			}
		},
		{
			SpotIndex = 7,
			Chance = 0.06,
			RewardData = {
				Currency = "LuckReward",
				NotificationMessage = "The server received x2 Luck!",
				DisplayName = "x2 Server Luck",
				Icon = "rbxassetid://72017551982890",
				CurrencyRewardInfo = table.pack(2, 60)
			}
		},
		{
			SpotIndex = 2,
			Chance = 0.02,
			RewardData = {
				Currency = "LuckReward",
				NotificationMessage = "The server received x4 Luck!",
				DisplayName = "x4 Server Luck",
				Icon = "rbxassetid://110372719378532",
				CurrencyRewardInfo = table.pack(4, 60)
			}
		}
	},
	TopPrizes = {
		{
			Currency = "ItemReward",
			NotificationMessage = "You got the Galactic Skin!",
			DisplayName = "Galactic Skin",
			PityCount = 65,
			Icon = "rbxassetid://127771159160485",
			CurrencyRewardInfo = RewardInfo.fishingRodReward("Galactic")
		},
		{
			Currency = "ItemReward",
			NotificationMessage = "You got the Enlightened Skin!",
			DisplayName = "Enlightened Skin",
			PityCount = 85,
			Icon = "rbxassetid://135282537420782",
			CurrencyRewardInfo = RewardInfo.fishingRodReward("Enlightened")
		}
	},
	GetRandomOutcome = function(p1, p2) --[[ GetRandomOutcome | Line: 154 ]]
		assert(p2, "No bag to choose item from")
		local sum = 0
		for i, v in ipairs(p2) do
			sum = sum + v.Chance * 100
		end
		local v1 = math.random(1, sum)
		local sum_2 = 0
		for i, v in ipairs(p2) do
			sum_2 = sum_2 + v.Chance * 100
			if v1 <= sum_2 then
				return v
			end
		end
	end
}