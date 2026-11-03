-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	AnimationId = "rbxassetid://101700790116508",
	PlaybackSpeed = 1,
	Looped = false,
	TargetAnimationId = "rbxassetid://101700790116508",
	TargetPlaybackSpeed = 1,
	TargetLooped = false,
	SwapHumanoidDescriptions = true,
	MovementCancelDuration = 4,
	DescriptionSwapDelay = 3.8,
	DescriptionSwapDuration = 10,
	AutoStopDuration = 11.25,
	RequiresTarget = true,
	MaxDistance = 15,
	EventTag = "CLASSIC26",
	Data = {
		Id = 20,
		Type = "Emotes",
		Name = "Body Swap",
		Description = "Swap appearances with another player.",
		Icon = "rbxassetid://136673791643457",
		Tier = 5
	},
	AnimationPriority = Enum.AnimationPriority.Action2,
	TargetAnimationPriority = Enum.AnimationPriority.Action2,
	SyncRequesterOffset = CFrame.new(0, 0, 2),
	SyncReceiverOffset = CFrame.new(0, 0, -2) * CFrame.Angles(0, math.pi, 0),
	VFXStages = {
		Stage1 = 3.5,
		Stage2 = 3.8
	},
	_moduleScript = script
}