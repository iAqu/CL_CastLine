export type BackpackConfig = {
	BackpackID: string,
	DisplayName: string,
	LayoutOrder: number,
	Model: string,
	CarryWeight: number,
}

local data: {[string]: BackpackConfig} = {
	Backpack_101 = {
		BackpackID = "Backpack_101",
		DisplayName = "Red Backpack",
		LayoutOrder = 1,
		Model = "Red Backpack",
		CarryWeight = 20,
	},
	Backpack_102 = {
		BackpackID = "Backpack_102",
		DisplayName = "Cartoon Frog Backpack",
		LayoutOrder = 2,
		Model = "Cartoon Frog Backpack",
		CarryWeight = 45,
	},
	Backpack_103 = {
		BackpackID = "Backpack_103",
		DisplayName = "Blue Camo Backpack",
		LayoutOrder = 3,
		Model = "Blue Camo Backpack",
		CarryWeight = 75,
	},
	Backpack_104 = {
		BackpackID = "Backpack_104",
		DisplayName = "Traveler Backpack",
		LayoutOrder = 4,
		Model = "Traveler Backpack",
		CarryWeight = 120,
	},
	Backpack_105 = {
		BackpackID = "Backpack_105",
		DisplayName = "Heavy-Duty Backpack",
		LayoutOrder = 5,
		Model = "Heavy-Duty Backpack",
		CarryWeight = 170,
	},
	Backpack_106 = {
		BackpackID = "Backpack_106",
		DisplayName = "Rescue Backpack",
		LayoutOrder = 6,
		Model = "Rescue Backpack",
		CarryWeight = 230,
	},
	Backpack_107 = {
		BackpackID = "Backpack_107",
		DisplayName = "Nordic Leather Backpack",
		LayoutOrder = 7,
		Model = "Nordic Leather Backpack",
		CarryWeight = 290,
	},
	Backpack_108 = {
		BackpackID = "Backpack_108",
		DisplayName = "Traffic Light Backpack",
		LayoutOrder = 8,
		Model = "Traffic Light Backpack",
		CarryWeight = 360,
	},
	Backpack_109 = {
		BackpackID = "Backpack_109",
		DisplayName = "Merchant Backpack",
		LayoutOrder = 9,
		Model = "Merchant Backpack",
		CarryWeight = 440,
	},
	Backpack_110 = {
		BackpackID = "Backpack_110",
		DisplayName = "Survivor Backpack",
		LayoutOrder = 10,
		Model = "Survivor Backpack",
		CarryWeight = 530,
	},
	Backpack_111 = {
		BackpackID = "Backpack_111",
		DisplayName = "Mountaineering Backpack",
		LayoutOrder = 11,
		Model = "Mountaineering Backpack",
		CarryWeight = 630,
	},
	Backpack_112 = {
		BackpackID = "Backpack_112",
		DisplayName = "Expedition Backpack",
		LayoutOrder = 12,
		Model = "Expedition Backpack",
		CarryWeight = 800,
	},
}

return data