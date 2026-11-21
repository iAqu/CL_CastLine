export type MutationConfig = {
	MutationId: string,
	Index: number,
	DisplayName: string,
	PriceRate: number,
	EarnCashRate: number,
	Chance: number,
	LabelColor: string,
	Icon: string,
	backup: string,
}

local data: {[string]: MutationConfig} = {
	Golden = {
		MutationId = "Golden",
		Index = 1,
		DisplayName = "Golden",
		PriceRate = 2,
		EarnCashRate = 2,
		Chance = 0.1,
		LabelColor = "255, 170, 0",
		Icon = "rbxassetid://128821997192741",
		backup = "0.1",
	},
	Diamond = {
		MutationId = "Diamond",
		Index = 2,
		DisplayName = "Diamond",
		PriceRate = 5,
		EarnCashRate = 5,
		Chance = 0.05,
		LabelColor = "37, 204, 255",
		Icon = "rbxassetid://132091174151109",
		backup = "0.05",
	},
	Rainbow = {
		MutationId = "Rainbow",
		Index = 3,
		DisplayName = "Rainbow",
		PriceRate = 10,
		EarnCashRate = 10,
		Chance = 0.02,
		LabelColor = "255, 255, 255",
		Icon = "rbxassetid://159696879",
		backup = "0.02",
	},
}

return data