-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	IsSkin = true,
	OverrideC0 = Vector3.new(0, 2.5, 0.7),
	BobberAnimationDelay = 0.2,
	catchAnimationDelay = 0.2,
	UseNewRodGrip = true,
	Data = {
		Id = 343,
		Type = "Fishing Rods",
		Name = "Eclipse Katana",
		Description = "",
		Icon = "rbxassetid://97801821774267",
		NewIcon = true,
		Tier = 7
	},
	OverrideROT = CFrame.fromOrientation(0, math.pi, -0.7853981633974483),
	GripC0 = CFrame.new(Vector3.new(0, -1, 0)) * CFrame.fromOrientation(0, 1.5707963267948966, -1.5707963267948966),
	GripC1 = CFrame.identity,
	_moduleScript = script
}