-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InfiniteMath = require(ReplicatedStorage.Shared.Utility.InfiniteMath)
local FormatInfNumber = require(ReplicatedStorage.Functional.FormatInfNumber)
local t = {}
local t2 = {
	Infinite = function(p1) --[[ Infinite | Line: 9 | Upvalues: InfiniteMath (copy), FormatInfNumber (copy) ]]
		return FormatInfNumber((InfiniteMath:ConvertFromLeaderboards(p1)))
	end
}
t.DataStores = { "Crystals", "Coins", "Slaps" }
t.Settings = {
	Crystals = {
		Title = "Most Rebirth Crystals",
		Icon = "rbxassetid://109177177506386",
		ValueColor = Color3.fromRGB(67, 239, 255)
	},
	Coins = {
		Title = "Most Coins",
		Icon = "rbxassetid://89161135701071",
		ValueColor = Color3.fromRGB(255, 201, 8)
	},
	Slaps = {
		Title = "Most Slaps",
		Icon = "rbxassetid://73060953251723",
		ValueColor = Color3.fromRGB(255, 201, 8)
	}
}
t.ValueConvertions = {
	Coins = t2.Infinite,
	Crystals = t2.Infinite,
	Slap = t2.Format
}
return t