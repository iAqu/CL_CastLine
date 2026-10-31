export type UpgradeConfig = {
	UpgradeID: string,
	Name: string,
	Index: number,
	MaxLevel: number,
	InitPrice: number,
	PriceGrowth: number,
	TotalPrice: number,
	LevelBoost: number,
	BoostDisplayType: "percent"? | "count"?,
	NameColor: string,
	IconID: string,
}

local data: {[string]: UpgradeConfig} = {
	Upgrade_WinsBoost = {
		UpgradeID = "Upgrade_WinsBoost",
		Name = "More Gems",
		Index = 40,
		MaxLevel = 20,
		InitPrice = 500,
		PriceGrowth = 1.3,
		TotalPrice = 315082,
		LevelBoost = 5,
		NameColor = "255, 64, 255",
		IconID = "131781108736891",
	},
	Upgrade_MoveSpeed = {
		UpgradeID = "Upgrade_MoveSpeed",
		Name = "Gem Chance",
		Index = 50,
		MaxLevel = 20,
		InitPrice = 500,
		PriceGrowth = 1.3,
		TotalPrice = 315082,
		LevelBoost = 5,
		NameColor = "255, 64, 255",
		IconID = "77451051547283",
	},
}

return data
