-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	ClickPower = 0.25,
	Resilience = 6.5,
	MaxWeight = 500000,
	OverrideC0 = Vector3.new(0, 2, -0.6),
	UseNewRodGrip = true,
	Price = 12000000,
	HiddenInShop = true,
	Data = {
		Id = 258,
		Type = "Fishing Rods",
		Name = "Bamboo Rod",
		Description = "",
		Icon = "rbxassetid://95236691549566",
		Tier = 6
	},
	Windup = NumberRange.new(2.9, 3.4),
	RollData = {
		BaseLuck = 7.6,
		SizeMultiplier = 0.1,
		Frequency = {
			Golden = 0,
			Rainbow = 0
		}
	},
	OverrideROT = CFrame.fromOrientation(0, 0, -0.7853981633974483),
	GripC0 = CFrame.new(Vector3.new(0, -1, 0)) * CFrame.Angles(-1.5707963267948966, math.pi, 0),
	GripC1 = CFrame.identity,
	EligiblePath = { "UnlockedTemple" },
	_moduleScript = script
}