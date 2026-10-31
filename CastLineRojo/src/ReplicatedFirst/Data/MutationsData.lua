export type MutationConfig = {
	MutationId: string,
	Index: number,
	DisplayName: string,
	PriceRate: number,
	EarnCashRate: number,
	LabelColor: string,
	PullChance: number,
	backup: string,
	Icon: string,
}

local data: {[string]: MutationConfig} = {
	Golden = {
		MutationId = "Golden",
		Index = 1,
		DisplayName = "Golden",
		PriceRate = 1.5,
		EarnCashRate = 1.5,
		LabelColor = "255, 170, 0",
		PullChance = 0.1,
		backup = "0.02",
		Icon = "rbxassetid://128821997192741",
	},
	Diamond = {
		MutationId = "Diamond",
		Index = 2,
		DisplayName = "Diamond",
		PriceRate = 2,
		EarnCashRate = 2,
		LabelColor = "37, 204, 255",
		PullChance = 0.05,
		backup = "0.001",
		Icon = "rbxassetid://132091174151109",
	},
	Rainbow = {
		MutationId = "Rainbow",
		Index = 3,
		DisplayName = "Rainbow",
		PriceRate = 2.5,
		EarnCashRate = 2.5,
		LabelColor = "255, 255, 255",
		PullChance = 0.02,
		backup = "0.0005",
		Icon = "rbxassetid://159696879",
	},
}

return data