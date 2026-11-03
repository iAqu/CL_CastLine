-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	IsSkin = true,
	OverrideC0 = Vector3.new(0.7, 2, -0.5),
	UseNewRodGrip = true,
	Data = {
		Id = 456,
		Type = "Fishing Rods",
		Name = "Sarcophagus",
		Description = "",
		Icon = "rbxassetid://79721302439816",
		NewIcon = true,
		Tier = 5
	},
	OverrideROT = CFrame.fromOrientation(0, -1.5707963267948966, -0.5235987755982988),
	GripC0 = CFrame.new(Vector3.new(0, -1, 0)) * CFrame.fromOrientation(1.5707963267948966, 2.792526803190927, 0),
	GripC1 = CFrame.fromOrientation(0, -3.141592653589793, 0),
	_moduleScript = script
}