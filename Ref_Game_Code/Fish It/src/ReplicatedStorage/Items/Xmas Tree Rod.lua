-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	IsSkin = true,
	OverrideC0 = Vector3.new(0, 2, 1),
	UseNewRodGrip = true,
	Data = {
		Id = 524,
		Type = "Fishing Rods",
		Name = "Xmas Tree Rod",
		Description = "",
		Icon = "rbxassetid://84640208915058",
		NewIcon = true,
		Tier = 5
	},
	OverrideROT = CFrame.fromOrientation(0, math.pi, 0.7853981633974483),
	GripC0 = CFrame.new(Vector3.new(0.025, -1, -0.03)) * CFrame.fromOrientation(-1.5707963267948966, 0, 0),
	GripC1 = CFrame.identity,
	_moduleScript = script
}