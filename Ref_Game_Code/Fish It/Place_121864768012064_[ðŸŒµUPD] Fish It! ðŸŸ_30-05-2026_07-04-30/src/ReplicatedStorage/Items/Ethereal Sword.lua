-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	IsSkin = true,
	OverrideC0 = Vector3.new(0.8, 3, 0.7),
	BobberAnimationDelay = 0.06,
	catchAnimationDelay = 0.1,
	UseNewRodGrip = true,
	Data = {
		Id = 658,
		Type = "Fishing Rods",
		Name = "Ethereal Sword",
		Description = "",
		Icon = "rbxassetid://73644740219544",
		NewIcon = true,
		Tier = 7
	},
	OverrideROT = CFrame.fromOrientation(0, -3.141592653589793, 1.7453292519943295),
	GripC0 = CFrame.new(Vector3.new(0, -1.2, 0)) * CFrame.fromOrientation(0, 1.5707963267948966, -1.5707963267948966),
	GripC1 = CFrame.identity,
	_moduleScript = script
}