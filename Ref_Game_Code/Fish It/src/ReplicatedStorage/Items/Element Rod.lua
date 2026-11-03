-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	ClickPower = 0.28,
	Resilience = 5.4,
	MaxWeight = 800000,
	OverrideC0 = Vector3.new(0.7, 2.5, -0.25),
	UseNewRodGrip = true,
	Data = {
		Id = 257,
		Type = "Fishing Rods",
		Name = "Element Rod",
		Description = "",
		Icon = "rbxassetid://99867965187788",
		Tier = 7
	},
	Windup = NumberRange.new(2.6, 2.9),
	RollData = {
		BaseLuck = 11.11,
		MutationMultiplier = 0.1,
		Frequency = {
			Golden = 0,
			Rainbow = 0
		}
	},
	OverrideROT = CFrame.fromOrientation(0, -1.5707963267948966, -0.7853981633974483),
	GripC0 = CFrame.new(Vector3.new(0, -1, 0)) * CFrame.fromOrientation(1.5707963267948966, 2.792526803190927, 0),
	GripC1 = CFrame.fromOrientation(0, -3.141592653589793, 0),
	_moduleScript = script
}