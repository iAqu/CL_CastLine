-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "Empyrean Staff",
	AttachLimb = "Torso",
	DefaultAnimation = "Empyrean Wings Idle",
	AccessoryModel = script:WaitForChild("AccessoryModel"),
	Animations = {
		["Empyrean Wings Idle"] = {
			AnimationId = "rbxassetid://102153183939732",
			Looped = true
		}
	},
	C0 = CFrame.new(Vector3.new(0, 0, -0.05)),
	C1 = CFrame.identity
}