-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	IsSkin = true,
	OverrideC0 = Vector3.new(0, 2.5, 0.6),
	UseNewRodGrip = true,
	Data = {
		Id = 580,
		Type = "Fishing Rods",
		Name = "Kraken Anchor",
		Description = "",
		Icon = "rbxassetid://70707450813216",
		NewIcon = true,
		Tier = 7
	},
	OverrideROT = CFrame.fromOrientation(0, math.pi, -0.7853981633974483),
	GripC0 = CFrame.new(Vector3.new(0, -1, 0)) * CFrame.fromOrientation(1.5707963267948966, 2.792526803190927, 0),
	GripC1 = CFrame.fromOrientation(0, -3.141592653589793, 0),
	_moduleScript = script
}