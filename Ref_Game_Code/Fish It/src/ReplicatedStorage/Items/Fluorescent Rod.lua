-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	ClickPower = 0.14,
	Resilience = 4.2,
	Price = 715000,
	MaxWeight = 160000,
	OverrideC0 = Vector3.new(0, 2, -0.6),
	UseNewRodGrip = true,
	Hidden = true,
	Data = {
		Id = 255,
		Type = "Fishing Rods",
		Name = "Fluorescent Rod",
		Description = "",
		Icon = "rbxassetid://83998636831250",
		Tier = 5
	},
	Windup = NumberRange.new(3.6, 5.37),
	RollData = {
		BaseLuck = 3,
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