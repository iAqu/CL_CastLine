-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	IsSkin = true,
	OverrideC0 = Vector3.new(0, 1, 0.7),
	UseNewRodGrip = true,
	Data = {
		Id = 806,
		Type = "Fishing Rods",
		Name = "Serpent\'s Trident",
		Description = "",
		Icon = "rbxassetid://102435019304495",
		NewIcon = true,
		Tier = 7
	},
	OverrideROT = CFrame.fromOrientation(0, math.pi, 0.7853981633974483),
	GripC0 = CFrame.new(Vector3.new(0, -0.969, 0)) * CFrame.fromOrientation(0, 1.5707963267948966, -1.5707963267948966),
	GripC1 = CFrame.fromOrientation(0, 0, 0),
	_moduleScript = script
}