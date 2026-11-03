-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Name = "Draconic Soul",
	AttachLimb = "Torso",
	DefaultAnimation = "Darkness Dragon Idle",
	AccessoryModel = script:WaitForChild("AccessoryModel"),
	Animations = {
		["Darkness Dragon Idle"] = {
			AnimationId = "rbxassetid://88474713161141",
			Looped = true
		}
	},
	C0 = CFrame.new(Vector3.new(0, 2.49, 0)),
	C1 = CFrame.identity * CFrame.fromOrientation(0, math.pi, 0)
}