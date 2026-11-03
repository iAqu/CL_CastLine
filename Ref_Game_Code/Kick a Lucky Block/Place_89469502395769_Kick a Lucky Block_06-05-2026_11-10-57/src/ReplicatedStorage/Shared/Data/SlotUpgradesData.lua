-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InfiniteMath = require(ReplicatedStorage.Shared.Utility.InfiniteMath)
return {
	CachedPrices = {
		InfiniteMath.new(5000000),
		InfiniteMath.new(25000000),
		InfiniteMath.new(75000000),
		InfiniteMath.new(100000000),
		InfiniteMath.new(250000000),
		InfiniteMath.new(750000000),
		InfiniteMath.new(1000000000),
		InfiniteMath.new(2000000000),
		InfiniteMath.new(5000000000),
		InfiniteMath.new(10000000000),
		InfiniteMath.new(25000000000),
		InfiniteMath.new(50000000000),
		InfiniteMath.new(100000000000),
		InfiniteMath.new(200000000000),
		InfiniteMath.new(500000000000),
		InfiniteMath.new(1000000000000),
		InfiniteMath.new(5000000000000),
		InfiniteMath.new(10000000000000),
		InfiniteMath.new(25000000000000),
		InfiniteMath.new(50000000000000)
	},
	GetPrice = function(p1, p2) --[[ GetPrice | Line: 30 ]]
		return p1.CachedPrices[p2]
	end
}