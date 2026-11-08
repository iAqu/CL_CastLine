-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMXCUNoYXJhY3RlcghIdW1hbm9pZA5GaW5kRmlyc3RDaGlsZARFbnVtEUh1bWFub2lkU3RhdGVUeXBlB0p1bXBpbmcPU2V0U3RhdGVFbmFibGVkCkdldFNlcnZpY2UUQ2hhcmFjdGVyU3RhdE1hbmFnZXIOU2V0SnVtcEVuYWJsZWQHQ29ubmVjdAlLbml0U3RhcnQEZ2FtZRFSZXBsaWNhdGVkU3RvcmFnZQdQbGF5ZXJzB3JlcXVpcmUIUGFja2FnZXMES25pdAZTaWduYWwLTG9jYWxQbGF5ZXIQQ3JlYXRlQ29udHJvbGxlcgROYW1lGkNoYXJhY3RlclN0YXRNYW5hZ2VyQ2xpZW50AAMHAQEAAAYDAAAFAQES+wEAAE0BAWkAAAAAKwEBAIIAAQBvBAEAvAIBAwIAAACfAgMCKwIBAIIAAQCkBQYABRAwwFIGAAC8AwLoBwAAAJ8DBAGCAAEACAMBAwIDAwMEAwUDBgQFEDDAAwcAEQABGAAAAAEAAgAAAAEAAgAAAAAAARIAAAAABQECAAAADfsBAABNAQEWAAAAAG8CAQCfAQICTQIBCwIAAADABAMAEgIBALwCAscEAAAAnwIDAYIAAQAFAwgDCQMKBgADCwEADgwBGAAAAAAAAgAAAAAAAAkPAAAAAAcAAAECACejAAAApAABAAAAAEBvAgIAvAAAFgMAAACfAAMCpAEBAAAAAEBvAwQAvAEBFgMAAACfAQMCpAIGAAAAUEBNAwDmBwAAAE0DA3EIAAAAnwICAqQDBgAAAFBATQQA5gcAAABNBAQfCQAAAJ8DAgJNBAExCgAAAE0FAg8LAAAA4gYOAJ8FAgLABg8AEgACABIABAAwBgWZEAAAAIIFAgARAw0EAAAAQAMOAwgDDwMQBAAAUEADEQMSAxMDFAMVAxYDFwgBDA0AAAAGAQMMAQEBAAEYAAAAAAAAAAEAAAAAAAIAAAAAAAABAAAAAAAAAgACAAAABQAAAAAOAQAAAAACKrpKjxZfxlpgTV8WbszsdFqiXfsYfiCO

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Knit = require(ReplicatedStorage.Packages.Knit)

require(ReplicatedStorage.Packages.Signal)

local LocalPlayer = Players.LocalPlayer
local v1 = Knit.CreateController({
	Name = "CharacterStatManagerClient"
})

function v1.KnitStart(p1) --[[ KnitStart | Line: 14 | Upvalues: Knit (copy), LocalPlayer (copy) ]]
	Knit.GetService("CharacterStatManager").SetJumpEnabled:Connect(function(p1) --[[ Line: 17 | Upvalues: LocalPlayer (ref) ]]
		local Character = LocalPlayer.Character

		if not Character then
			return
		end

		local Humanoid = Character:FindFirstChild("Humanoid")

		if Humanoid then
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, p1)
		end
	end)
end

return v1