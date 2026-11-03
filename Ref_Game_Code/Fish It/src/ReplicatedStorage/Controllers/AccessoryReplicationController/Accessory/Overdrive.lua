-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "Overdrive",
	AttachLimb = "Torso",
	DefaultAnimation = "Voltage Idle",
	AccessoryModel = script:WaitForChild("AccessoryModel"),
	Animations = {
		["Voltage Idle"] = {
			AnimationId = "rbxassetid://79279532631194",
			Looped = true
		}
	},
	C0 = CFrame.new(Vector3.new(0, 1, 0)),
	C1 = CFrame.fromOrientation(0, math.pi, 0)
}