-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	IsSkin = true,
	OverrideC0 = Vector3.new(0, 3, 0.75),
	UseNewRodGrip = true,
	Data = {
		Id = 331,
		Type = "Fishing Rods",
		Name = "Heartfelt Blade",
		Description = "",
		Icon = "rbxassetid://80750484599128",
		NewIcon = true,
		Tier = 7
	},
	OverrideROT = CFrame.fromOrientation(0, math.pi, -2.356194490192345),
	GripC0 = CFrame.new(Vector3.new(0, -1, -0.24)) * CFrame.fromOrientation(-1.5707963267948966, 0, 0),
	GripC1 = CFrame.identity,
	_moduleScript = script
}