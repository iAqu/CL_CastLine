-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {}
local InfiniteMath = require(script.Parent.Parent.Utility.InfiniteMath)
t.Weights = {
	["Wooden Stick"] = {
		PPS = 2,
		Rarity = "Common",
		Weight = 5,
		Image = "rbxassetid://93026554403002",
		Cost = InfiniteMath.new(0)
	},
	["Bone Barbell"] = {
		PPS = 5,
		Rarity = "Rare",
		Weight = 10,
		Product = 3572000164,
		Image = "rbxassetid://126331976759800",
		Cost = InfiniteMath.new(7500)
	},
	["Stone Block"] = {
		PPS = 10,
		Rarity = "Epic",
		Weight = 45,
		Product = 3572000339,
		Image = "rbxassetid://90647205545226",
		Cost = InfiniteMath.new(75000)
	},
	["Copper Plate"] = {
		PPS = 50,
		Rarity = "Legendary",
		Weight = 135,
		Product = 3572000431,
		Image = "rbxassetid://116050030239698",
		Cost = InfiniteMath.new(500000)
	},
	["Iron Plate"] = {
		PPS = 150,
		Rarity = "Mythic",
		Weight = 225,
		Product = 3572000515,
		Image = "rbxassetid://136247807607088",
		Cost = InfiniteMath.new(7250000)
	},
	["Ice Barbell"] = {
		PPS = 400,
		Rarity = "Godly",
		Weight = 450,
		Product = 3572000611,
		Image = "rbxassetid://99724381915162",
		Cost = InfiniteMath.new(350000000)
	},
	["Donut Barbell"] = {
		PPS = 1000,
		Rarity = "Secret",
		Weight = 900,
		Product = 3572000753,
		Image = "rbxassetid://108720951519836",
		Cost = InfiniteMath.new(6250000000)
	},
	["Golden Barbell"] = {
		PPS = 2500,
		Rarity = "Divine",
		Weight = 1800,
		Product = 3572000871,
		Image = "rbxassetid://116328669812442",
		Cost = InfiniteMath.new(85000000000)
	},
	["Heaven Plate"] = {
		PPS = 6250,
		Rarity = "Rainbow",
		Weight = 4500,
		Product = 3572001040,
		Image = "rbxassetid://129255792866023",
		Cost = InfiniteMath.new(1200000000000)
	},
	["Mega Golden Barbell"] = {
		PPS = 15000,
		Rarity = "Hacked",
		Weight = 9000,
		Product = 3572001119,
		Image = "rbxassetid://115807794882155",
		Cost = InfiniteMath.new(18000000000000)
	},
	["Neon Pulse"] = {
		PPS = 40000,
		Rarity = "Demon",
		Weight = 22500,
		Product = 3572001257,
		Image = "rbxassetid://97519333822789",
		Cost = InfiniteMath.new(500000000000000)
	},
	["Giant Gold Star Barbell"] = {
		PPS = 100000,
		Rarity = "OG",
		Weight = 99999,
		Product = 3572001425,
		Image = "rbxassetid://137920295864847",
		Cost = InfiniteMath.new(2e16)
	}
}
t.Animations = {
	Default = "SquatBarbell",
	["Iron Plate"] = "SquatHold",
	["Copper Plate"] = "SquatHold",
	["Stone Block"] = "SquatHold"
}
return t