-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	IsSkin = true,
	OverrideC0 = Vector3.new(0, -1, 0.6),
	UseNewRodGrip = true,
	Data = {
		Id = 581,
		Type = "Fishing Rods",
		Name = "Pirate Banjo",
		Description = "",
		Icon = "rbxassetid://79587169947941",
		NewIcon = true,
		Tier = 6
	},
	OverrideROT = CFrame.fromOrientation(0, math.pi, -0.7853981633974483),
	GripC0 = CFrame.new(Vector3.new(0, -1, 0)) * CFrame.fromOrientation(-1.5707963267948966, 0, 0),
	GripC1 = CFrame.identity,
	_moduleScript = script
}