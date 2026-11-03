-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	IsSkin = true,
	OverrideC0 = Vector3.new(-1.25, 2.5, 0),
	BobberAnimationDelay = 0.22,
	UseNewRodGrip = true,
	Data = {
		Id = 928,
		Type = "Fishing Rods",
		Name = "Cloud Weaver",
		Description = "",
		Icon = "rbxassetid://115523529105445",
		NewIcon = true,
		Tier = 7
	},
	OverrideROT = CFrame.fromOrientation(0, 1.5707963267948966, math.pi),
	GripC0 = CFrame.new(Vector3.new(0, -1.02, 0)) * CFrame.fromOrientation(-1.5707963267948966, 0, 0),
	GripC1 = CFrame.fromOrientation(0, 0, 0),
	_moduleScript = script
}