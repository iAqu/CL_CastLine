-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	ClickPower = 0.31,
	Resilience = 5,
	MaxWeight = 1100000,
	OverrideC0 = Vector3.new(0, 2, 0.82),
	UseNewRodGrip = true,
	Data = {
		Id = 559,
		Type = "Fishing Rods",
		Name = "Diamond Rod",
		Description = "",
		Icon = "rbxassetid://136272135400881",
		NewIcon = true,
		Tier = 7
	},
	Windup = NumberRange.new(2.5, 2.6),
	RollData = {
		BaseLuck = 13,
		MutationMultiplier = 0.1,
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