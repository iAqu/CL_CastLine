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
t.DataStores = { "Cash" }
t.Settings = {
	Cash = {
		Title = "Most Cash",
		Icon = "rbxassetid://106254793390209",
		ValueColor = Color3.fromRGB(117, 255, 12)
	}
}
t.ValueConvertions = {
	Cash = t2.Infinite
}
return t