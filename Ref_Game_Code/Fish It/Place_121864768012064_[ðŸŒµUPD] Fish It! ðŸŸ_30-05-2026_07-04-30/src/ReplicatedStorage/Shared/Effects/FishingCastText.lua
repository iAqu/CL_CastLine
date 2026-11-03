-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
require(script.Parent.Types)
return {
	{
		Text = "OK",
		TextColor = ColorSequence.new(Color3.fromRGB(255, 255, 255))
	},
	{
		Text = "GOOD",
		TextColor = ColorSequence.new(Color3.fromRGB(241, 224, 42))
	},
	{
		Text = "GREAT",
		TextColor = ColorSequence.new(Color3.fromRGB(248, 156, 7))
	},
	{
		Text = "AMAZING",
		TextColor = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(233, 111, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(164, 53, 255)) })
	},
	{
		Text = "PERFECT!",
		TextColor = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 255, 148)), ColorSequenceKeypoint.new(1, Color3.fromRGB(3, 255, 66)) })
	},
	{
		Text = "PERFECTION!",
		TextColor = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(64, 255, 118)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(64, 255, 118)) })
	}
}