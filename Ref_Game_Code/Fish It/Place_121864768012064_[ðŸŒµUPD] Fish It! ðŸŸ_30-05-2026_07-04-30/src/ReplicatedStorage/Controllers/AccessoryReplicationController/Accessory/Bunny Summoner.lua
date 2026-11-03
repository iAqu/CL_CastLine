-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "Bunny Summoner",
	AttachLimb = "Torso",
	DefaultAnimation = "Bunny Idle",
	FishingAnimation = "Bunny Action",
	AccessoryModel = script:WaitForChild("AccessoryModel"),
	Animations = {
		["Bunny Idle"] = {
			AnimationId = "rbxassetid://74908255627568",
			Looped = true
		},
		["Bunny Action"] = {
			AnimationId = "rbxassetid://100953194964003",
			Looped = false
		}
	},
	C0 = CFrame.new(Vector3.new(-1.3, -2.14, 0)),
	C1 = CFrame.identity * CFrame.fromOrientation(0, math.pi, 0)
}