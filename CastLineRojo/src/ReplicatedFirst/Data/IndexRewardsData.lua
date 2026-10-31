export type IndexRewardConfig = {
	RewardID: string,
	RequiredCount: number,
	LuckIncrease: number,
}

local data: {[string]: IndexRewardConfig} = {
	Reward_1 = {
		RewardID = "Reward_1",
		RequiredCount = 20,
		LuckIncrease = 0.1,
	},
	Reward_2 = {
		RewardID = "Reward_2",
		RequiredCount = 40,
		LuckIncrease = 0.1,
	},
	Reward_3 = {
		RewardID = "Reward_3",
		RequiredCount = 60,
		LuckIncrease = 0.1,
	},
	Reward_4 = {
		RewardID = "Reward_4",
		RequiredCount = 80,
		LuckIncrease = 0.1,
	},
	Reward_5 = {
		RewardID = "Reward_5",
		RequiredCount = 100,
		LuckIncrease = 0.1,
	},
}

return data