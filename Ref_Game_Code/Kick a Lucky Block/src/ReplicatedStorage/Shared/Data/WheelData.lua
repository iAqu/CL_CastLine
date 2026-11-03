-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {
	Rewards = {
		{
			Name = "Rainbow Lucky Block",
			Type = "Entity",
			Value = "Rainbow",
			Chance = 0.5
		},
		{
			Name = "+5 Speed [Perm]",
			Type = "Speed",
			Value = 5,
			Chance = 0.5
		},
		{
			Name = "x2 Mutation Luck",
			Type = "Upgrade",
			Subtype = "kick_speed",
			Value = 2,
			Duration = 600,
			Chance = 5
		},
		{
			Name = "x1.5 Kick Speed",
			Type = "Upgrade",
			Subtype = "kick_speed",
			Value = 1.5,
			Duration = 300,
			Chance = 7
		},
		{
			Name = "Cash Product",
			Type = "Cash",
			Value = 200000,
			Chance = 31
		},
		{
			Name = "Cash Product",
			Type = "Cash",
			Value = 50000,
			Chance = 56
		}
	}
}
table.sort(t.Rewards, function(p1, p2) --[[ Line: 45 ]]
	return p1.Chance < p2.Chance
end)
t.WheelOrder = {
	1,
	2,
	3,
	4,
	5,
	6
}
return t