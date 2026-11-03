-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	IsSkin = true,
	OverrideC0 = Vector3.new(1, 3, -0.9),
	BobberAnimationDelay = 0.3,
	catchAnimationDelay = 0.2,
	UseNewRodGrip = true,
	Data = {
		Id = 452,
		Type = "Fishing Rods",
		Name = "The Vanquisher",
		Description = "",
		Icon = "rbxassetid://88866168139822",
		NewIcon = true,
		Tier = 7
	},
	OverrideROT = CFrame.fromOrientation(0, 0, -1.5707963267948966),
	GripC0 = CFrame.new(Vector3.new(-0.026, -1.1, -0.165)) * CFrame.fromOrientation(1.5707963267948966, math.pi, 0),
	GripC1 = CFrame.identity,
	_moduleScript = script
}