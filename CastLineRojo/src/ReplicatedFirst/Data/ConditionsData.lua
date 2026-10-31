export type ConditionConfig = {
	CoditionID: string,
	DisplayName: string,
	LayoutOrder: number,
	ChanceWeight: number,
	ValueMult: number,
	LuckMult: number,
}

local data: {[string]: ConditionConfig} = {
	Codition_1 = {
		CoditionID = "Codition_1",
		DisplayName = "Normal",
		LayoutOrder = 1,
		ChanceWeight = 38,
		ValueMult = 1,
		LuckMult = 1,
	},
	Codition_2 = {
		CoditionID = "Codition_2",
		DisplayName = "Good",
		LayoutOrder = 2,
		ChanceWeight = 28,
		ValueMult = 1.3,
		LuckMult = 1.3,
	},
	Codition_3 = {
		CoditionID = "Codition_3",
		DisplayName = "Great",
		LayoutOrder = 3,
		ChanceWeight = 20,
		ValueMult = 2.2,
		LuckMult = 2.2,
	},
	Codition_4 = {
		CoditionID = "Codition_4",
		DisplayName = "Perfect",
		LayoutOrder = 4,
		ChanceWeight = 10,
		ValueMult = 4.4,
		LuckMult = 4.4,
	},
	Codition_5 = {
		CoditionID = "Codition_5",
		DisplayName = "Mint",
		LayoutOrder = 5,
		ChanceWeight = 4,
		ValueMult = 9.5,
		LuckMult = 9.5,
	},
}

return data