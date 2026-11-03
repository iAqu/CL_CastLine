-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "Crimson Retribution",
	AttachLimb = "Torso",
	DefaultAnimation = "Crimson Wings Idle",
	AccessoryModel = script:WaitForChild("AccessoryModel"),
	Animations = {
		["Crimson Wings Idle"] = {
			AnimationId = "rbxassetid://95519937180169",
			Looped = true
		}
	},
	C0 = CFrame.new(Vector3.new(0, 0, -0.2)),
	C1 = CFrame.identity
}