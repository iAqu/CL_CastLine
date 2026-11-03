-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Golden = {
		Icon = "rbxassetid://135712314641037",
		Description = "Gold luck boost",
		Requirement = 10,
		Color = ColorSequence.new(Color3.fromRGB(255, 211, 33)),
		Modifiers = {
			BaseLuck = 5
		}
	},
	Rainbow = {
		Icon = "rbxassetid://140607580139637",
		Description = "Rainbow luck boost",
		Requirement = 40,
		RequiredTier = 5,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHex("#ffc773")),
			ColorSequenceKeypoint.new(0.1, Color3.fromHex("#e3ff73")),
			ColorSequenceKeypoint.new(0.2, Color3.fromHex("#8fff73")),
			ColorSequenceKeypoint.new(0.3, Color3.fromHex("#73ffab")),
			ColorSequenceKeypoint.new(0.4, Color3.fromHex("#73ffff")),
			ColorSequenceKeypoint.new(0.5, Color3.fromHex("#73abff")),
			ColorSequenceKeypoint.new(0.6, Color3.fromHex("#8f73ff")),
			ColorSequenceKeypoint.new(0.7, Color3.fromHex("#e373ff")),
			ColorSequenceKeypoint.new(0.8, Color3.fromHex("#ff73c7")),
			ColorSequenceKeypoint.new(0.9, Color3.fromHex("#ff7373")),
			ColorSequenceKeypoint.new(1, Color3.fromHex("#ffdb4a"))
		}),
		Modifiers = {
			BaseLuck = 30
		}
	}
}