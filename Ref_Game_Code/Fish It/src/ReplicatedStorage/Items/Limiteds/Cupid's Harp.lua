-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	IsSkin = true,
	OverrideC0 = Vector3.new(0, 1, -1),
	UseNewRodGrip = true,
	Data = {
		Id = 749,
		Type = "Fishing Rods",
		Name = "Cupid\'s Harp",
		Description = "",
		Icon = "rbxassetid://106908035114843",
		NewIcon = true,
		Tier = 7
	},
	ModelAttachment = game.ReplicatedStorage.Assets.RodAttachments["Mball.004"],
	OverrideROT = CFrame.fromOrientation(0, 0, 0),
	GripC0 = CFrame.new(Vector3.new(1, -1, -0.75)) * CFrame.Angles(0, -1.5707963267948966, 0),
	GripC1 = CFrame.identity,
	_moduleScript = script
}