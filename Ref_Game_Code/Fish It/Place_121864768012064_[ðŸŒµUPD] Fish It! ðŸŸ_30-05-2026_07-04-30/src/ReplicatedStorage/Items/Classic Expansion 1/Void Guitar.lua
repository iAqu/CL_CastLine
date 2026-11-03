-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	IsSkin = true,
	OverrideC0 = Vector3.new(0, -0.55, 1.5),
	UseNewRodGrip = true,
	EventTag = "CLASSIC26",
	Data = {
		Id = 926,
		Type = "Fishing Rods",
		Name = "Void Guitar",
		Description = "",
		Icon = "rbxassetid://137349028167558",
		NewIcon = true,
		Tier = 7
	},
	OverrideROT = CFrame.fromOrientation(0, math.pi, 0),
	GripC0 = CFrame.new(Vector3.new(-0.1, -1.1, 0)) * CFrame.fromOrientation(0, -1.5707963267948966, 1.5707963267948966),
	GripC1 = CFrame.identity,
	_moduleScript = script
}