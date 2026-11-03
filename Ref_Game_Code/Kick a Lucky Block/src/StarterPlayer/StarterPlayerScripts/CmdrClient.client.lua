-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
if ({
	[646338867] = true,
	[341835893] = true,
	[550065203] = true
})[game:GetService("Players").LocalPlayer.UserId] then
	require(ReplicatedStorage:WaitForChild("CmdrClient")):SetActivationKeys({ Enum.KeyCode.F2 })
end