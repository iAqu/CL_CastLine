-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	ClickPower = 0.16,
	Resilience = 9,
	MaxWeight = 300000,
	OverrideC0 = Vector3.new(0, 2, -0.6),
	UseNewRodGrip = true,
	Hidden = true,
	Data = {
		Id = 256,
		Type = "Fishing Rods",
		Name = "Hazmat Rod",
		Description = "",
		Icon = "rbxassetid://125567152580809",
		Tier = 5
	},
	Windup = NumberRange.new(3.5, 4.47),
	RollData = {
		BaseLuck = 3.8,
		Frequency = {
			Golden = 0,
			Rainbow = 0
		}
	},
	OverrideROT = CFrame.fromOrientation(0, 0, -0.7853981633974483),
	GripC0 = CFrame.new(Vector3.new(0, -1, 0)) * CFrame.Angles(-1.5707963267948966, math.pi, 0),
	GripC1 = CFrame.identity,
	_moduleScript = script
}