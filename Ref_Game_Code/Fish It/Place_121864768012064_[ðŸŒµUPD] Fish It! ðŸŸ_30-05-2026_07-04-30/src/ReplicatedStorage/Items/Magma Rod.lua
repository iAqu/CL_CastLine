-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	TradeLocked = true,
	ClickPower = 0.05,
	Resilience = 7.8,
	HiddenInShop = true,
	Price = 1000000,
	MaxWeight = 50000,
	OverrideC0 = Vector3.new(0, 2, 0.95),
	UseNewRodGrip = true,
	Data = {
		Id = 3,
		Type = "Fishing Rods",
		Name = "Magma Rod",
		Description = "",
		Icon = "rbxassetid://130960889779123",
		Tier = 5
	},
	Windup = NumberRange.new(3.5, 4.1),
	RollData = {
		BaseLuck = 4.7,
		Frequency = {
			Golden = 0,
			Rainbow = 0
		}
	},
	OverrideROT = CFrame.fromOrientation(0, math.pi, -0.7853981633974483),
	GripC0 = CFrame.new(Vector3.new(0, -1, 0)) * CFrame.fromOrientation(1.5707963267948966, 2.792526803190927, 0),
	GripC1 = CFrame.fromOrientation(0, -3.141592653589793, 0),
	_moduleScript = script
}