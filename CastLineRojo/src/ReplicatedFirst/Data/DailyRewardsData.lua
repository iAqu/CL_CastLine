export type DailyRewardConfig = {
	RewardID: string,
	Type: string,
	ItemId: string,
	Count: number,
	Name: string,
	IconId: number,
}

local data: {[string]: DailyRewardConfig} = {
	Daily_Reward_1 = {
		RewardID = "Daily_Reward_1",
		Type = "Wins",
		ItemId = "nil",
		Count = 200,
		Name = "30 Wins",
		IconId = 0,
	},
	Daily_Reward_2 = {
		RewardID = "Daily_Reward_2",
		Type = "Wins",
		ItemId = "nil",
		Count = 5000,
		Name = "5K Wins",
		IconId = 0,
	},
	Daily_Reward_3 = {
		RewardID = "Daily_Reward_3",
		Type = "Wins",
		ItemId = "nil",
		Count = 50000,
		Name = "5K Wins",
		IconId = 0,
	},
	Daily_Reward_4 = {
		RewardID = "Daily_Reward_4",
		Type = "Potion",
		ItemId = "Potion_Mutation",
		Count = 1,
		Name = "Golden Potion",
		IconId = 0,
	},
	Daily_Reward_5 = {
		RewardID = "Daily_Reward_5",
		Type = "Wins",
		ItemId = "nil",
		Count = 2000000,
		Name = "20K Wins",
		IconId = 0,
	},
	Daily_Reward_6 = {
		RewardID = "Daily_Reward_6",
		Type = "Potion",
		ItemId = "Potion_Mutation",
		Count = 1,
		Name = "Rainbow Potion",
		IconId = 0,
	},
	Daily_Reward_7 = {
		RewardID = "Daily_Reward_7",
		Type = "Wins",
		ItemId = "nil",
		Count = 5000000,
		Name = "50K Wins",
		IconId = 0,
	},
}

return data