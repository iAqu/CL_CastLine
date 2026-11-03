-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RewardInfo = require(ReplicatedStorage.Shared.RewardInfo)
return {
	{
		Price = 500000,
		SinglePurchase = true,
		RewardInfo = RewardInfo.boothReward(4)
	},
	{
		ProductId = 3592930102,
		Price = 199,
		SinglePurchase = true,
		RewardInfo = RewardInfo.boothReward(2),
		BGColor = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(89, 227, 255)),
			ColorSequenceKeypoint.new(0.256, Color3.fromRGB(165, 30, 230)),
			ColorSequenceKeypoint.new(0.694, Color3.fromRGB(62, 206, 233)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(232, 201, 80))
		})
	}
}