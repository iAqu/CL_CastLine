-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	IsSkin = true,
	OverrideC0 = Vector3.new(0, 1, 0.6),
	BobberAnimationDelay = 0.22,
	catchAnimationDelay = 0.2,
	UseNewRodGrip = true,
	Data = {
		Id = 344,
		Type = "Fishing Rods",
		Name = "Princess Parasol",
		Description = "",
		Icon = "rbxassetid://132455653641238",
		NewIcon = true,
		Tier = 7
	},
	OverrideROT = CFrame.fromOrientation(0, math.pi, 0.7853981633974483),
	GripC0 = CFrame.new(Vector3.new(0, -1, 0)) * CFrame.fromOrientation(-1.5707963267948966, 0, 0),
	GripC1 = CFrame.identity,
	_moduleScript = script
}