-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	IsSkin = true,
	OverrideC0 = Vector3.new(0.8, 3, 0.7),
	BobberAnimationDelay = 0.1,
	catchAnimationDelay = 0.1,
	UseNewRodGrip = true,
	Data = {
		Id = 659,
		Type = "Fishing Rods",
		Name = "Chromatic Katana",
		Description = "",
		Icon = "rbxassetid://79085997543052",
		NewIcon = true,
		Tier = 7
	},
	OverrideROT = CFrame.fromOrientation(0, -3.141592653589793, 1.7453292519943295),
	GripC0 = CFrame.new(Vector3.new(0, -1.05, -0.3)) * CFrame.fromOrientation(0, 1.5707963267948966, -1.5707963267948966),
	GripC1 = CFrame.identity,
	_moduleScript = script
}